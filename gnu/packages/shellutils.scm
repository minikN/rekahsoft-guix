;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2016 Matthew Jordan <matthewjordandevops@yandex.com>
;;; Copyright © 2016, 2017 Alex Griffin <a@ajgrf.com>
;;; Copyright © 2016 Christopher Baines <mail@cbaines.net>
;;; Copyright © 2017 Stefan Reichör <stefan@xsteve.at>
;;; Copyright © 2018, 2020 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2018 Benjamin Slade <slade@jnanam.net>
;;; Copyright © 2019 Collin J. Doering <collin@rekahsoft.ca>
;;; Copyright © 2020 Michael Rohleder <mike@rohleder.de>
;;;
;;; This file is part of GNU Guix.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (gnu packages shellutils)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system go)
  #:use-module (guix build-system python)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages base)
  #:use-module (gnu packages golang)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages readline)
  #:use-module (gnu packages ruby)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages tmux))

(define-public zsh-autosuggestions
  (package
    (name "zsh-autosuggestions")
    (version "0.6.4")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/zsh-users/zsh-autosuggestions")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0h52p2waggzfshvy1wvhj4hf06fmzd44bv6j18k3l9rcx6aixzn6"))))
    (build-system gnu-build-system)
    (native-inputs
     `(("ruby" ,ruby)
       ("ruby-byebug" ,ruby-byebug)
       ("ruby-pry" ,ruby-pry)
       ("ruby-rspec" ,ruby-rspec)
       ("ruby-rspec-wait" ,ruby-rspec-wait)
       ("tmux" ,tmux)
       ("zsh" ,zsh)))
    (arguments
     '(#:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (replace 'check ; Tests use ruby's bundler; instead execute rspec directly.
           (lambda _
             (setenv "TMUX_TMPDIR" (getenv "TMPDIR"))
             (setenv "SHELL" (which "zsh"))
             (invoke "rspec")))
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (zsh-plugins
                      (string-append out "/share/zsh/plugins/zsh-autosuggestions")))
               (invoke "make" "all")
               (install-file "zsh-autosuggestions.zsh" zsh-plugins)
               #t))))))
    (home-page "https://github.com/zsh-users/zsh-autosuggestions")
    (synopsis "Fish-like autosuggestions for zsh")
    (description
     "Fish-like fast/unobtrusive autosuggestions for zsh.  It suggests commands
as you type.")
    (license license:expat)))

(define-public sh-z
  (package
    (name "sh-z")
    (version "1.11")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/rupa/z")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "13zbgkj6y0qhvn5jpkrqbd4jjxjr789k228iwma5hjfh1nx7ghyb"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f ; No tests provided
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (delete 'build)
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (man (string-append out "/share/man/man1"))
                    (bin (string-append out "/bin")))
               (install-file "z.sh" bin)
               (chmod (string-append bin "/z.sh") #o755)
               (install-file "z.1" man)
               #t))))))
    (synopsis "Jump about directories")
    (description
     "Tracks your most used directories, based on ``frecency''.  After a short
learning phase, z will take you to the most ``frecent'' directory that matches
all of the regexes given on the command line in order.")
    (home-page "https://github.com/rupa/z")
    (license license:expat)))

(define-public fzf
  (package
    (name "fzf")
    (version "0.18.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/junegunn/fzf.git")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0pwpr4fpw56yzzkcabzzgbgwraaxmp7xzzmap7w1xsrkbj7dl2xl"))))
    (build-system go-build-system)
    (native-inputs
     `(("github.com/mattn/go-isatty" ,go-github-com-mattn-go-isatty)
       ("github.com/mattn/go-runewidth" ,go-github-com-mattn-go-runewidth)
       ("github.com/mattn/go-shellwords" ,go-github-com-mattn-go-shellwords)
       ("go-golang-org-x-crypto" ,go-golang-org-x-crypto)
       ("go-golang-org-x-sys" ,go-golang-org-x-sys)))
    (propagated-inputs
     `(("tmux" ,tmux)))
    (arguments
     '(#:import-path "github.com/junegunn/fzf"
       #:install-source? #f
       #:phases
       (modify-phases %standard-phases
         (replace 'build
           (lambda _
             (with-directory-excursion "src/github.com/junegunn/fzf"
               (invoke "make"))))
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               (mkdir-p (string-append out "/share"))
               (with-directory-excursion "src/github.com/junegunn/fzf"
                 (invoke "make" "install")
                 (copy-recursively "bin" (string-append out "/bin"))
                 (copy-recursively "man" (string-append out "/share/man"))
                 (copy-recursively "shell" (string-append out "/share/fzf")))))))))
    (synopsis "Command line fuzzy finder")
    (description
     "@command{fzf} is a general purpose command line fuzzy finder.  It's an
interactive uniz filter for command-line that can be used with any lists;
files, command history, processes, hostnames, bookmarks, git commits, etc..")
    (home-page "https://github.com/junegunn/fzf")
    (license license:expat)))

(define-public sh-z
  (package
    (name "sh-z")
    (version "1.11")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/rupa/z.git")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "13zbgkj6y0qhvn5jpkrqbd4jjxjr789k228iwma5hjfh1nx7ghyb"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f ; No tests provided
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (delete 'build)
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (man (string-append out "/share/man/man1"))
                    (bin (string-append out "/bin")))
               (install-file "z.sh" bin)
               (chmod (string-append bin "/z.sh") #o755)
               (install-file "z.1" man)))))))
    (synopsis "Jump about directories")
    (description
     "Tracks your most used directories, based on ``frecency''.  After a short
learning phase, z will take you to the most ``frecent'' directory that matches
ALL of the regexes given on the command line in order.")
    (home-page "https://github.com/rupa/z")
    (license license:expat)))

(define-public spaceship-prompt
  (package
    (name "spaceship-prompt")
    (version "3.11.1")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/denysdovhan/spaceship-prompt.git")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "171gmqnwbyan1wslbh4aky1gdqfbw3gfsfscxfnpgk0j114a6jfj"))))
    (build-system gnu-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (delete 'build)
         (delete 'check)
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (func-path (string-append out "/share/zsh/site-functions"))
                    (install-path (string-append out "/lib/spaceship-prompt")))
               (for-each mkdir-p `(,func-path ,install-path))
               (for-each (lambda (dir)
                           (copy-recursively dir (string-append install-path "/" dir)))
                         '("lib" "modules" "sections"))
               (copy-file "spaceship.zsh" (string-append install-path "/spaceship.zsh"))
               (symlink (string-append install-path "/spaceship.zsh")
                        (string-append func-path "/prompt_spaceship_setup"))))))))
    (synopsis "Zsh prompt for Astronauts")
    (description
     "Spaceship is a minimalistic, powerful and extremely customizable
Zsh prompt.  It combines everything you may need for convenient work,
without unecessary complications, like a real spaceship.")
    (home-page "https://github.com/denysdovhan/spaceship-prompt")
    (license license:expat)))

(define-public sh-z
  (package
    (name "sh-z")
    (version "1.11")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/rupa/z.git")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "13zbgkj6y0qhvn5jpkrqbd4jjxjr789k228iwma5hjfh1nx7ghyb"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f ; No tests provided
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (delete 'build)
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (man (string-append out "/share/man/man1"))
                    (bin (string-append out "/bin")))
               (install-file "z.sh" bin)
               (chmod (string-append bin "/z.sh") #o755)
               (install-file "z.1" man)))))))
    (synopsis "Jump about directories")
    (description
     "Tracks your most used directories, based on ``frecency''.  After a short
learning phase, z will take you to the most ``frecent'' directory that matches
ALL of the regexes given on the command line in order.")
    (home-page "https://github.com/rupa/z")
    (license license:expat)))

(define-public zsh-autosuggestions
  (package
    (name "zsh-autosuggestions")
    (version "0.6.3")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/zsh-users/zsh-autosuggestions.git")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1h8h2mz9wpjpymgl2p7pc146c1jgb3dggpvzwm9ln3in336wl95c"))))
    (build-system gnu-build-system)
    (native-inputs
     `(("tmux" ,tmux)
       ("zsh" ,zsh)
       ("ruby" ,ruby)
       ("ruby-rspec" ,ruby-rspec)
       ("ruby-rspec-wait" ,ruby-rspec-wait)
       ("ruby-pry" ,ruby-pry)
       ("ruby-byebug" ,ruby-byebug)))
    (arguments
     '(#:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (replace 'check ; Tests use ruby's bundler; instead execute rspec directly
           (lambda _
             (setenv "TMUX_TMPDIR" (getenv "TMPDIR"))
             (setenv "SHELL" (which "zsh"))
             (invoke "rspec")))
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (zsh-plugins (string-append out "/share/zsh/plugins/zsh-autosuggestions")))
               (invoke "make" "all")
               (install-file "zsh-autosuggestions.zsh" zsh-plugins)
               #t))))))
    (synopsis "Fish-like autosuggestions for zsh")
    (description
     "Fish-like fast/unobtrusive autosuggestions for zsh.  It suggests commands as you type.")
    (home-page "https://github.com/zsh-users/zsh-autosuggestions.git")
    (license license:expat)))

(define-public envstore
  (package
    (name "envstore")
    (version "2.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://finalrewind.org/projects/"
                           name "/" name "-" version ".tar.bz2"))
       (sha256
        (base32 "1x97lxad80m5blhdfanl5v2qzjwcgbij2i23701bn8mpyxsrqszi"))))
    (build-system gnu-build-system)
    (arguments
     `(#:test-target "test"
       #:make-flags (list "CC=gcc"
                          (string-append "PREFIX=" (assoc-ref %outputs "out")))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure))))
    (home-page "https://finalrewind.org/projects/envstore/")
    (synopsis "Save and restore environment variables")
    (description "Envstore is a program for sharing environment variables
between various shells or commands.")
    (license license:wtfpl2)))

(define-public trash-cli
  (package
    (name "trash-cli")
    (version "0.17.1.14")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "trash-cli" version))
       (sha256
        (base32
         "01q0cl04ljf214z6s3g256gsxx3pqsgaf6ac1zh0vrq5bnhnr85h"))))
    (build-system python-build-system)
    (arguments
     `(#:python ,python-2
       #:tests? #f ; no tests
       #:phases
       (modify-phases %standard-phases
         (add-before 'build 'patch-path-constants
           (lambda* (#:key inputs #:allow-other-keys)
             (let ((libc (assoc-ref inputs "libc"))
                   (coreutils (assoc-ref inputs "coreutils")))
               (substitute* "trashcli/list_mount_points.py"
                 (("\"/lib/libc.so.6\".*")
                  (string-append "\"" libc "/lib/libc.so.6\"\n"))
                 (("\"df\"")
                  (string-append "\"" coreutils "/bin/df\"")))))))))
    (inputs `(("coreutils" ,coreutils)))
    (home-page "https://github.com/andreafrancia/trash-cli")
    (synopsis "Trash can management tool")
    (description
     "trash-cli is a command line utility for interacting with the
FreeDesktop.org trash can used by GNOME, KDE, XFCE, and other common desktop
environments.  It can move files to the trash, and remove or list files that
are already there.")
    (license license:gpl2+)))

(define-public direnv
  (package
    (name "direnv")
    (version "2.15.2")
    (source
     (origin (method git-fetch)
             (uri (git-reference
                   (url "https://github.com/direnv/direnv")
                   (commit (string-append "v" version))))
             (file-name (git-file-name name version))
             (sha256
              (base32
               "1y18619pmhfl0vrf4w0h75ybkkwgi9wcb7d9kv4n8drg1xp4aw4w"))))
    (build-system go-build-system)
    (arguments
     '(#:import-path "github.com/direnv/direnv"
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'delete-vendor
           (lambda _
             ;; Using a snippet causes issues with the name of the directory,
             ;; so delete the extra source code here.
             (delete-file-recursively "src/github.com/direnv/direnv/vendor")
             #t))
         (replace 'check
           (lambda* (#:key tests? #:allow-other-keys)
             (when tests?
               (setenv "HOME" "/tmp")
               (with-directory-excursion "src/github.com/direnv/direnv"
                 ;; The following file needs to be writable so it can be
                 ;; modified by the testsuite.
                 (make-file-writable "test/scenarios/base/.envrc")
                 (invoke "make" "test")
                 ;; Clean up from the tests, especially so that the extra
                 ;; direnv executable that's generated is removed.
                 (invoke "make" "clean")))
             #t)))))
    (native-inputs
     `(("go-github-com-burntsushi-toml" ,go-github-com-burntsushi-toml)
       ("go-github-com-direnv-go-dotenv" ,go-github-com-direnv-go-dotenv)
       ("which" ,which)))
    (home-page "https://direnv.net/")
    (synopsis "Environment switcher for the shell")
    (description
     "direnv can hook into the bash, zsh, tcsh, and fish shells to load
or unload environment variables depending on the current directory.  This
allows project-specific environment variables without using @file{~/.profile}.

Before each prompt, direnv checks for the existence of a @file{.envrc} file in
the current and parent directories.  This file is then used to alter the
environment variables of the current shell.")
    (license license:expat)))

(define-public fzy
  (package
    (name "fzy")
    (version "1.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/jhawthorn/fzy")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "1gkzdvj73f71388jvym47075l9zw61v6l8wdv2lnc0mns6dxig0k"))))
    (build-system gnu-build-system)
    (arguments
     '(#:make-flags (list "CC=gcc"
                          (string-append "PREFIX=" (assoc-ref %outputs "out")))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure))))
    (home-page "https://github.com/jhawthorn/fzy")
    (synopsis "Fast fuzzy text selector for the terminal with an advanced
scoring algorithm")
    (description
     "Most other fuzzy matchers sort based on the length of a match.  fzy tries
to find the result the user intended.  It does this by favouring matches on
consecutive letters and starts of words.  This allows matching using acronyms
or different parts of the path.

fzy is designed to be used both as an editor plugin and on the command
line.  Rather than clearing the screen, fzy displays its interface directly
below the current cursor position, scrolling the screen if necessary.")
    (license license:expat)))

(define-public hstr
  (package
    (name "hstr")
    (version "2.2")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                     (url "https://github.com/dvorka/hstr")
                     (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "07fkilqlkpygvf9kvxyvl58g3lfq0bwwdp3wczy4hk8qlbhmgihn"))))
    (build-system gnu-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-before 'build 'adjust-ncurses-includes
           (lambda* (#:key make-flags outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               (substitute* "src/include/hstr_curses.h"
                 (("ncursesw\\/curses.h") "ncurses.h"))
               (substitute* "src/include/hstr.h"
                 (("ncursesw\\/curses.h") "ncurses.h")))
             #t)))))
    (native-inputs
     `(("autoconf" ,autoconf)
       ("automake" ,automake)
       ("pkg-config" ,pkg-config)))
    (inputs
     `(("ncurses" ,ncurses)
       ("readline" ,readline)))
    (synopsis "Navigate and search command history with shell history suggest box")
    (description "HSTR (HiSToRy) is a command-line utility that brings
improved Bash and Zsh command completion from the history.  It aims to make
completion easier and more efficient than with @kbd{Ctrl-R}.  It allows you to
easily view, navigate, and search your command history with suggestion boxes.
HSTR can also manage your command history (for instance you can remove
commands that are obsolete or contain a piece of sensitive information) or
bookmark your favourite commands.")
    (home-page "http://me.mindforger.com/projects/hh.html")
    (license license:asl2.0)))

(define-public shell-functools
  (package
    (name "shell-functools")
    (version "0.3.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/sharkdp/shell-functools")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0d6zzg7cxfrzwzh1wmpj7q85kz33sak6ac59ncsm6dlbin12h0hi"))))
    (build-system python-build-system)
    (home-page "https://github.com/sharkdp/shell-functools/")
    (synopsis "Functional programming tools for the shell")
    (description "This package provides higher order functions like map,
filter, foldl, sort_by and take_while as simple command-line tools. Following
the UNIX philosophy, these commands are designed to be composed via pipes. A
large collection of functions such as basename, replace, contains or is_dir
are provided as arguments to these commands.")
    (license license:expat)))
