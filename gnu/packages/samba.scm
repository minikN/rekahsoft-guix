;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2013, 2015, 2017 Ludovic Courtès <ludo@gnu.org>
;;; Copyright © 2015 Mark H Weaver <mhw@netris.org>
;;; Copyright © 2016, 2017, 2019 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2016 Adonay "adfeno" Felipe Nogueira <https://libreplanet.org/wiki/User:Adfeno> <adfeno@openmailbox.org>
;;; Copyright © 2017 Thomas Danckaert <post@thomasdanckaert.be>
;;; Copyright © 2017, 2018, 2020 Marius Bakke <mbakke@fastmail.com>
;;; Copyright © 2018, 2019, 2020 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2018 Ricardo Wurmus <rekado@elephly.net>
;;; Copyright © 2019 Rutger Helling <rhelling@mykolab.com>
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

(define-module (gnu packages samba)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix licenses)
  #:use-module (guix utils)
  #:use-module (gnu packages acl)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages backup)
  #:use-module (gnu packages base)
  #:use-module (gnu packages check)
  #:use-module (gnu packages crypto)
  #:use-module (gnu packages cups)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages docbook)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages kerberos)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages onc-rpc)
  #:use-module (gnu packages openldap)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages popt)
  #:use-module (gnu packages python)
  #:use-module (gnu packages readline)
  #:use-module (gnu packages time)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages web)
  #:use-module (gnu packages xml))

(define-public cifs-utils
  (package
    (name "cifs-utils")
    (version "6.10")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://download.samba.org/pub/linux-cifs/"
                           "cifs-utils/cifs-utils-" version ".tar.bz2"))
       (sha256 (base32
                "19q4b5bzlxhn1hpi843xrp6f50d33w7m0rs26krkg5h3x742kz4j"))))
    (build-system gnu-build-system)
    (native-inputs
     `(("autoconf" ,autoconf)
       ("automake" ,automake)
       ("pkg-config" ,pkg-config)))
    (inputs
     `(("keytuils" ,keyutils)
       ("linux-pam" ,linux-pam)
       ("libcap-ng" ,libcap-ng)
       ("mit-krb5" ,mit-krb5)
       ("samba" ,samba)
       ("talloc" ,talloc)))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (replace 'bootstrap
           ;; Force a bootstrap to fix a ‘cannot find install-sh, install.sh,
           ;; or shtool’ error since version 6.10.
           (lambda _
             (invoke "autoreconf" "-vfi")
             #t))
         (add-before 'configure 'set-root-sbin
           (lambda* (#:key outputs #:allow-other-keys)
             ;; Don't try to install into "/sbin".
             (setenv "ROOTSBINDIR"
                     (string-append (assoc-ref outputs "out") "/sbin"))
             #t))
         (add-before 'install 'create-man8dir
           ;; Create a directory that isn't created since version 6.10.
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               (mkdir-p (string-append out "/share/man/man8"))
               #t))))))
    (synopsis "User-space utilities for Linux CIFS (Samba) mounts")
    (description "@code{cifs-utils} is a set of user-space utilities for
mounting and managing @dfn{Common Internet File System} (CIFS) shares using
the Linux kernel CIFS client.")
    (home-page "https://wiki.samba.org/index.php/LinuxCIFS_utils")
    ;; cifs-utils is licensed as GPL3 or later, but 3 files contain LGPL code.
    (license gpl3+)))

(define-public iniparser
  (package
    (name "iniparser")
    (version "4.1")
    (source (origin
             (method git-fetch)
             (uri (git-reference
                    (url "https://github.com/ndevilla/iniparser")
                    (commit (string-append "v" version))))
             (file-name (git-file-name name version))
             (sha256
              (base32
               "0dhab6pad6wh816lr7r3jb6z273njlgw2vpw8kcfnmi7ijaqhnr5"))))
    (build-system gnu-build-system)
    (arguments
     `(#:make-flags
       (list ,(string-append "CC=" (cc-for-target)))
       #:phases
       (modify-phases %standard-phases
         (replace 'configure
           (lambda* (#:key outputs #:allow-other-keys)
             (substitute* '("Makefile" "test/Makefile")
               (("/usr/lib")
                (string-append (assoc-ref outputs "out") "/lib")))
             #t))
         (replace 'build
           (lambda* (#:key make-flags #:allow-other-keys)
             (apply invoke "make" "libiniparser.so.1"
                    make-flags)))
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out  (assoc-ref outputs "out"))
                    (lib  (string-append out "/lib"))
                    (inc  (string-append out "/include"))
                    (doc  (string-append out "/share/doc/" ,name))
                    (html (string-append doc "/html")))
               (define (install dir)
                 (lambda (file)
                   (install-file file dir)))
               (for-each (install lib)
                         (find-files "." "^lib.*\\.so"))
               (with-directory-excursion lib
                 (symlink "libiniparser.so.1" "libiniparser.so"))
               (for-each (install inc)
                         (find-files "src" "\\.h$"))
               (for-each (install html)
                         (find-files "html" ".*"))
               (for-each (install doc)
                         '("AUTHORS" "INSTALL" "LICENSE" "README.md"))
               #t))))))
    (home-page "https://github.com/ndevilla/iniparser")
    (synopsis "Standalone ini file parsing library")
    (description
     "iniparser is a free stand-alone @code{ini} file parsing library (Windows
configuration files).  It is written in portable ANSI C and should compile
anywhere.")
    (license x11)))

(define-public samba
  (package
    (name "samba")
    (version "4.12.3")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://download.samba.org/pub/samba/stable/"
                           "samba-" version ".tar.gz"))
       (sha256
        (base32 "09w7aap1cjc41ayhaksm1igc7p7gl40fad4a1l6q4ds9a2jbrb9z"))
       (modules '((guix build utils)))
       (snippet
        '(begin
           ;; TODO: also remove the bundled ‘third_party/popt’.
           (delete-file-recursively "third_party/pyiso8601")
           #t))))
    (build-system gnu-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-before 'configure 'locate-docbook-stylesheets
           (lambda* (#:key inputs #:allow-other-keys)
             ;; XXX for some reason XML_CATALOG_FILES is not respected.
             (substitute* '("buildtools/wafsamba/samba_conftests.py"
                            "buildtools/wafsamba/wafsamba.py"
                            "docs-xml/xslt/man.xsl")
               (("http://docbook.sourceforge.net/release/xsl/current/")
                (string-append (assoc-ref inputs "docbook-xsl")
                               "/xml/xsl/docbook-xsl-"
                               ,(package-version docbook-xsl) "/")))
             #t))
         (replace 'configure
           ;; samba uses a custom configuration script that runs waf.
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out    (assoc-ref outputs "out"))
                    (libdir (string-append out "/lib")))
               (invoke "./configure"
                       "--enable-fhs"
                       ;; XXX: heimdal not packaged.
                       "--bundled-libraries=com_err"
                       (string-append "--prefix=" out)
                       "--sysconfdir=/etc"
                       ;; Install public and private libraries into
                       ;; a single directory to avoid RPATH issues.
                       (string-append "--libdir=" libdir)
                       (string-append "--with-privatelibdir=" libdir)))))
         (add-before 'install 'disable-etc-samba-directory-creation
           (lambda _
             (substitute* "dynconfig/wscript"
               (("bld\\.INSTALL_DIR\\(\"\\$\\{CONFIGDIR\\}\"\\)")
                ""))
             #t)))
       ;; XXX: The test infrastructure attempts to set password with
       ;; smbpasswd, which fails with "smbpasswd -L can only be used by root."
       ;; So disable tests until there's a workaround.
       #:tests? #f))
    (inputs                                   ; TODO: Add missing dependencies
     `(("acl" ,acl)
       ("cups" ,cups)
       ;; ("gamin" ,gamin)
       ("gpgme" ,gpgme)
       ("gnutls" ,gnutls)
       ("jansson" ,jansson)
       ("libarchive" ,libarchive)
       ("linux-pam" ,linux-pam)
       ("lmdb" ,lmdb)
       ("openldap" ,openldap)
       ("perl" ,perl)
       ("python" ,python)
       ("popt" ,popt)
       ("readline" ,readline)
       ("tdb" ,tdb)))
    (propagated-inputs
     ;; In Requires or Requires.private of pkg-config files.
     `(("ldb" ,ldb)
       ("talloc" ,talloc)
       ("tevent" ,tevent)))
    (native-inputs
     `(("perl-parse-yapp" ,perl-parse-yapp)
       ("pkg-config" ,pkg-config)
       ("python-iso8601" ,python-iso8601)
       ("rpcsvc-proto" ,rpcsvc-proto)   ; for 'rpcgen'

       ;; For generating man pages.
       ("docbook-xml" ,docbook-xml-4.2)
       ("docbook-xsl" ,docbook-xsl)
       ("xsltproc" ,libxslt)))
    (home-page "https://www.samba.org/")
    (synopsis
     "The standard Windows interoperability suite of programs for GNU and Unix")
    (description
     "Since 1992, Samba has provided secure, stable and fast file and print
services for all clients using the SMB/CIFS protocol, such as all versions of
DOS and Windows, OS/2, GNU/Linux and many others.

Samba is an important component to seamlessly integrate Linux/Unix Servers and
Desktops into Active Directory environments using the winbind daemon.")
    (license gpl3+)))

(define-public talloc
  (package
    (name "talloc")
    (version "2.3.1")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://www.samba.org/ftp/talloc/talloc-"
                                  version ".tar.gz"))
              (sha256
               (base32
                "0xwzgzrqamfdlklwacp9d219pqkah0yfrhxb1j7bxlmgzp924j7g"))))
    (build-system gnu-build-system)
    (arguments
     '(#:phases
       (modify-phases %standard-phases
         (replace 'configure
           (lambda* (#:key outputs #:allow-other-keys)
             ;; talloc uses a custom configuration script that runs a Python
             ;; script called 'waf', and doesn't tolerate unknown options.
             (setenv "CONFIG_SHELL" (which "sh"))
             (let ((out (assoc-ref outputs "out")))
               (invoke "./configure"
                       (string-append "--prefix=" out))))))))
    (native-inputs
     `(("which" ,which)))
    (inputs
     `(("python" ,python)))
    (home-page "https://talloc.samba.org")
    (synopsis "Hierarchical, reference counted memory pool system")
    (description
     "Talloc is a hierarchical, reference counted memory pool system with
destructors.  It is the core memory allocator used in Samba.")
    (license gpl3+))) ;; The bundled "replace" library uses LGPL3.

(define-public talloc/static
  (package
    (inherit talloc)
    (name "talloc-static")
    (synopsis
     "Hierarchical, reference counted memory pool system (static library)")
    (arguments
     (substitute-keyword-arguments (package-arguments talloc)
       ((#:phases phases)
        ;; Since Waf, the build system talloc uses, apparently does not
        ;; support building static libraries from a ./configure flag, roll our
        ;; own build process.  No need to be ashamed, we're not the only ones
        ;; doing that:
        ;; <https://github.com/proot-me/proot-static-build/blob/master/GNUmakefile>.
        ;; :-)
        `(modify-phases ,phases
           (replace 'build
             (lambda _
               (invoke "gcc" "-c" "-Ibin/default" "-I" "lib/replace"
                       "-I." "-Wall" "-g" "-D__STDC_WANT_LIB_EXT1__=1"
                       "talloc.c")
               (invoke "ar" "rc" "libtalloc.a" "talloc.o")))
           (replace 'install
             (lambda* (#:key outputs #:allow-other-keys)
               (let* ((out     (assoc-ref outputs "out"))
                      (lib     (string-append out "/lib"))
                      (include (string-append out "/include")))
                 (mkdir-p lib)
                 (install-file "libtalloc.a" lib)
                 (install-file "talloc.h" include)
                 #t)))
           (delete 'check)))))))            ;XXX: tests rely on Python modules

(define-public tevent
  (package
    (name "tevent")
    (version "0.10.2")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://www.samba.org/ftp/tevent/tevent-"
                                  version ".tar.gz"))
              (sha256
               (base32
                "15k6i8ad5lpxfjsjyq9h64zlyws8d3cm0vwdnaw8z1xjwli7hhpq"))))
    (build-system gnu-build-system)
    (arguments
     '(#:phases
       (modify-phases %standard-phases
         (replace 'configure
           ;; tevent uses a custom configuration script that runs waf.
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               (invoke "./configure"
                       (string-append "--prefix=" out)
                       "--bundled-libraries=NONE")))))))
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("python" ,python)
       ("which" ,which)))
    (propagated-inputs
     `(("talloc" ,talloc))) ; required by tevent.pc
    (synopsis "Event system library")
    (home-page "https://tevent.samba.org/")
    (description
     "Tevent is an event system based on the talloc memory management library.
It is the core event system used in Samba.  The low level tevent has support for
many event types, including timers, signals, and the classic file descriptor events.")
    (license lgpl3+)))

(define-public ldb
  (package
    (name "ldb")
    (version "1.5.6")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://www.samba.org/ftp/ldb/ldb-"
                                  version ".tar.gz"))
              (sha256
               (base32
                "0nwpkqidsna4yz3vhjzzadm4hpviwnyk80yml8ay82gi1d6lg0pz"))
              (modules '((guix build utils)))
              (snippet
               '(begin
                  (for-each (lambda (file)
                              ;; Delete everything except the build tools.
                              (unless (or (string-prefix? "third_party/waf" file)
                                          (string-suffix? "wscript" file))
                                (delete-file file)))
                            (find-files "third_party"))
                  #t))))
    (build-system gnu-build-system)
    (arguments
     '(;; LMDB is only supported on 64-bit systems, yet the test suite
       ;; requires it.
       #:tests? (assoc-ref %build-inputs "lmdb")
       #:phases
       (modify-phases %standard-phases
         (replace 'configure
           ;; ldb use a custom configuration script that runs waf.
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               (invoke "./configure"
                       (string-append "--prefix=" out)
                       (string-append "--with-modulesdir=" out
                                      "/lib/ldb/modules")
                       "--bundled-libraries=NONE")))))))
    (native-inputs
     `(("cmocka" ,cmocka)
       ("pkg-config" ,pkg-config)
       ("python" ,python)
       ("which" ,which)))
    (propagated-inputs
     ;; ldb.pc refers to all these.
     `(("talloc" ,talloc)
       ("tdb" ,tdb)))
    (inputs
     `(,@(if (target-64bit?)
             `(("lmdb" ,lmdb))
             '())
       ("popt" ,popt)
       ("tevent" ,tevent)))
    (synopsis "LDAP-like embedded database")
    (home-page "https://ldb.samba.org/")
    (description
     "Ldb is a LDAP-like embedded database built on top of TDB.  What ldb does
is provide a fast database with an LDAP-like API designed to be used within an
application.  In some ways it can be seen as a intermediate solution between
key-value pair databases and a real LDAP database.")
    (license lgpl3+)))

(define-public ppp
  ;; This git commit contains unreleased fixes for CVE-2020-8597.
  (let ((revision "1")
        (commit "8d45443bb5c9372b4c6a362ba2f443d41c5636af"))
    (package
      (name "ppp")
      (version (git-version "2.4.8" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/paulusmack/ppp")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "06cf8fb84l3h2zy5da4j7k2j1qjv2gfqn986sf43xgj75605aks2"))))
      (build-system gnu-build-system)
      (arguments
       '(#:tests? #f                    ; no check target
         #:make-flags '("CC=gcc")
         #:phases
         (modify-phases %standard-phases
           (add-before 'configure 'patch-Makefile
             (lambda* (#:key inputs #:allow-other-keys)
               (let ((libc    (assoc-ref inputs "libc"))
                     (openssl (assoc-ref inputs "openssl"))
                     (libpcap (assoc-ref inputs "libpcap")))
                 (substitute* "pppd/Makefile.linux"
                   (("/usr/include/crypt\\.h")
                    (string-append libc "/include/crypt.h"))
                   (("/usr/include/openssl")
                    (string-append openssl "/include/openssl"))
                   (("/usr/include/pcap-bpf.h")
                    (string-append libpcap "/include/pcap-bpf.h")))
                 #t))))))
      (inputs
       `(("libpcap" ,libpcap)
         ("openssl" ,(@ (gnu packages tls) openssl))))
      (synopsis "Implementation of the Point-to-Point Protocol")
      (home-page "https://ppp.samba.org/")
      (description
       "The Point-to-Point Protocol (PPP) provides a standard way to establish
a network connection over a serial link.  At present, this package supports IP
and IPV6 and the protocols layered above them, such as TCP and UDP.")
      ;; pppd, pppstats and pppdump are under BSD-style notices.
      ;; some of the pppd plugins are GPL'd.
      ;; chat is public domain.
      (license (list bsd-3 bsd-4 gpl2+ public-domain)))))

