;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2013, 2014, 2015 Andreas Enge <andreas@enge.fr>
;;; Copyright © 2015 Sou Bunnbu <iyzsong@gmail.com>
;;; Copyright © 2015, 2018, 2019, 2020 Ludovic Courtès <ludo@gnu.org>
;;; Copyright © 2015, 2016, 2017, 2018, 2019 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2016, 2017 Nikita <nikita@n0.is>
;;; Copyright © 2016 Thomas Danckaert <post@thomasdanckaert.be>
;;; Copyright © 2017, 2018, 2019 Ricardo Wurmus <rekado@elephly.net>
;;; Copyright © 2017 Quiliro <quiliro@fsfla.org>
;;; Copyright © 2017, 2018, 2020 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2018, 2020 Nicolas Goaziou <mail@nicolasgoaziou.fr>
;;; Copyright © 2018 Hartmut Goebel <h.goebel@crazy-compilers.com>
;;; Copyright © 2018 Eric Bavier <bavier@member.fsf.org>
;;; Copyright © 2019, 2020 Marius Bakke <mbakke@fastmail.com>
;;; Copyright © 2018 John Soo <jsoo1@asu.edu>
;;; Copyright © 2020 Mike Rosset <mike.rosset@gmail.com>
;;; Copyright © 2020 Jakub Kądziołka <kuba@kadziolka.net>
;;; Copyright © 2020 Kei Kebreau <kkebreau@posteo.net>
;;; Copyright © 2020 TomZ <tomz@freedommail.ch>
;;; Copyright © 2020 Jonathan Brielmaier <jonathan.brielmaier@web.de>
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

(define-module (gnu packages qt)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system trivial)
  #:use-module (guix build-system python)
  #:use-module (guix packages)
  #:use-module (guix deprecation)
  #:use-module (guix utils)
  #:use-module (gnu packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bison)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages cups)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages documentation)
  #:use-module (gnu packages enchant)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages flex)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages ghostscript)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages gperf)
  #:use-module (gnu packages gstreamer)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages icu4c)
  #:use-module (gnu packages image)
  #:use-module (gnu packages libevent)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages ninja)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages pciutils)
  #:use-module (gnu packages pcre)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages protobuf)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages regex)
  #:use-module (gnu packages ruby)
  #:use-module (gnu packages sdl)
  #:use-module (gnu packages serialization)
  #:use-module (gnu packages sqlite)
  #:use-module (gnu packages telephony)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages valgrind)
  #:use-module (gnu packages video)
  #:use-module (gnu packages vulkan)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages xiph)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages xml)
  #:use-module (srfi srfi-1))

(define-public grantlee
  (package
    (name "grantlee")
    (version "5.2.0")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
              (url "https://github.com/steveire/grantlee")
              (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
         (base32 "02dyqxjyxiqxrlz5g7v9ly8f095vs3iha39l75q6s8axs36y01lq"))))
    (native-inputs
     ;; Optional: lcov and cccc, both are for code coverage
     `(("doxygen" ,doxygen)))
    (inputs
     `(("qtbase" ,qtbase)
       ("qtdeclarative" ,qtdeclarative)
       ("qtscript" ,qtscript)))
    (build-system cmake-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-before 'check 'check-setup
           (lambda _
             ;; make Qt render "offscreen", required for tests
             (setenv "QT_QPA_PLATFORM" "offscreen")
             #t)))))
    (home-page "https://github.com/steveire/grantlee")
    (synopsis "Libraries for text templating with Qt")
    (description "Grantlee Templates can be used for theming and generation of
other text such as code.  The syntax uses the syntax of the Django template
system, and the core design of Django is reused in Grantlee.")
    (license license:lgpl2.1+)))

(define-public qt-4
  (package
    (name "qt")
    (version "4.8.7")
    (source (origin
             (method url-fetch)
             (uri (string-append "http://download.qt-project.org/archive/qt/"
                                 (string-copy version 0 (string-rindex version #\.))
                                 "/" version
                                 "/qt-everywhere-opensource-src-"
                                 version ".tar.gz"))
             (sha256
              (base32
               "183fca7n7439nlhxyg1z7aky0izgbyll3iwakw4gwivy16aj5272"))
             (patches (search-patches "qt4-ldflags.patch"))
             (modules '((guix build utils)))
             (snippet
              ;; Remove webkit module, which is not built.
              '(begin (delete-file-recursively "src/3rdparty/webkit")
                      #t))))
    (build-system gnu-build-system)
    (propagated-inputs
     `(("mesa" ,mesa)))
    (inputs
     `(("alsa-lib" ,alsa-lib)
       ("bluez" ,bluez)
       ("cups" ,cups)
       ("dbus" ,dbus)
       ("double-conversion" ,double-conversion)
       ("expat" ,expat)
       ("fontconfig" ,fontconfig)
       ("freetype" ,freetype)
       ("glib" ,glib)
       ("gstreamer" ,gstreamer)
       ("gst-plugins-base" ,gst-plugins-base)
       ("icu4c" ,icu4c)
       ("jasper" ,jasper)
       ("libinput" ,libinput-minimal)
       ("libmng" ,libmng)
       ("libpci" ,pciutils)
       ("libpng" ,libpng)
       ("libtiff" ,libtiff)
       ("libwebp" ,libwebp)
       ("libx11" ,libx11)
       ("libxcomposite" ,libxcomposite)
       ("libxcursor" ,libxcursor)
       ("libxext" ,libxext)
       ("libxfixes" ,libxfixes)
       ("libxi" ,libxi)
       ("libxinerama" ,libxinerama)
       ("libxkbcommon" ,libxkbcommon)
       ("libxml2" ,libxml2)
       ("libxrandr" ,libxrandr)
       ("libxrender" ,libxrender)
       ("libxslt" ,libxslt)
       ("libxtst" ,libxtst)
       ("mtdev" ,mtdev)
       ("mariadb" ,mariadb "lib")
       ("mariadb-dev" ,mariadb "dev")
       ("nss" ,nss)
       ("postgresql" ,postgresql)
       ("pulseaudio" ,pulseaudio)
       ("pcre2" ,pcre2)
       ("sqlite" ,sqlite)
       ("udev" ,eudev)
       ("unixodbc" ,unixodbc)
       ("wayland" ,wayland)
       ("xcb-util" ,xcb-util)
       ("xcb-util-image" ,xcb-util-image)
       ("xcb-util-keysyms" ,xcb-util-keysyms)
       ("xcb-util-renderutil" ,xcb-util-renderutil)
       ("xcb-util-wm" ,xcb-util-wm)
       ("zlib" ,zlib)
       ("libjpeg" ,libjpeg-turbo)
       ("libsm" ,libsm)
       ("openssl" ,openssl-1.0)))
    (native-inputs
     `(;; XXX: The JavaScriptCore engine does not build with the C++11 standard.
       ;; We could build it with -std=gnu++98, but then we'll get in trouble with
       ;; ICU later.  Just keep using GCC 5 for now.
       ("gcc@5" ,gcc-5)
       ("bison" ,bison)
       ("flex" ,flex)
       ("gperf" ,gperf)
       ("perl" ,perl)
       ("pkg-config" ,pkg-config)
       ("python" ,python-2)
       ("ruby" ,ruby)
       ("which" ,(@ (gnu packages base) which))))
    ;; Note: there are 37 MiB of examples and a '-exampledir' configure flags,
    ;; but we can't make them a separate output because "out" and "examples"
    ;; would refer to each other.
    (outputs '("out"                             ;112MiB core + 37MiB examples
               "doc"))                           ;280MiB of HTML + code
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'set-paths 'hide-default-gcc
           (lambda* (#:key inputs #:allow-other-keys)
             (let ((gcc (assoc-ref inputs "gcc")))
               ;; Remove the default GCC from CPLUS_INCLUDE_PATH to prevent
               ;; conflicts with the GCC 5 input.
               (setenv "CPLUS_INCLUDE_PATH"
                       (string-join
                        (delete (string-append gcc "/include/c++")
                                (string-split (getenv "CPLUS_INCLUDE_PATH") #\:))
                        ":"))
               #t)))
         (replace
          'configure
          (lambda* (#:key outputs #:allow-other-keys)
            (let ((out (assoc-ref outputs "out"))
                  (doc (assoc-ref outputs "doc")))
              (substitute* '("configure")
                (("/bin/pwd") (which "pwd")))
              (substitute* "src/corelib/global/global.pri"
                (("/bin/ls") (which "ls")))

              (invoke
                "./configure"
                "-verbose"
                "-prefix" out
                "-nomake" "examples demos"
                ;; Note: Don't pass '-docdir' since 'qmake' and
                ;; libQtCore would record its value, thereby defeating
                ;; the whole point of having a separate output.
                "-datadir" (string-append out "/share/qt-" ,version
                                          "/data")
                "-importdir" (string-append out "/lib/qt-4"
                                            "/imports")
                "-plugindir" (string-append out "/lib/qt-4"
                                            "/plugins")
                "-translationdir" (string-append out "/share/qt-" ,version
                                                 "/translations")
                "-demosdir"    (string-append out "/share/qt-" ,version
                                              "/demos")
                "-examplesdir" (string-append out "/share/qt-" ,version
                                              "/examples")
                "-opensource"
                "-confirm-license"
                ;; explicitly link with dbus instead of dlopening it
                "-dbus-linked"
                ;; Skip the webkit module; it fails to build on armhf
                ;; and, apart from that, may pose security risks.
                "-no-webkit"
                ;; don't use the precompiled headers
                "-no-pch"
                ;; drop special machine instructions not supported
                ;; on all instances of the target
                ,@(if (string-prefix? "x86_64"
                                      (or (%current-target-system)
                                          (%current-system)))
                      '()
                      '("-no-mmx"
                        "-no-3dnow"
                        "-no-sse"
                        "-no-sse2"))
                "-no-sse3"
                "-no-ssse3"
                "-no-sse4.1"
                "-no-sse4.2"
                "-no-avx"))))
         (add-after
          'install 'move-doc
          (lambda* (#:key outputs #:allow-other-keys)
            ;; Because of qt4-documentation-path.patch, documentation ends up
            ;; being installed in OUT.  Move it to the right place.
            (let* ((out    (assoc-ref outputs "out"))
                   (doc    (assoc-ref outputs "doc"))
                   (olddoc (string-append out "/doc"))
                   (docdir (string-append doc "/share/doc/qt-" ,version)))
              (mkdir-p (dirname docdir))

              ;; Note: We can't use 'rename-file' here because OUT and DOC are
              ;; different "devices" due to bind-mounts.
              (copy-recursively olddoc docdir)
              (delete-file-recursively olddoc)
              #t))))))
    (native-search-paths
     (list (search-path-specification
            (variable "QMAKEPATH")
            (files '("lib/qt5")))
           (search-path-specification
            (variable "QML2_IMPORT_PATH")
            (files '("lib/qt5/qml")))
           (search-path-specification
            (variable "QT_PLUGIN_PATH")
            (files '("lib/qt5/plugins")))
           (search-path-specification
            (variable "XDG_DATA_DIRS")
            (files '("share")))
           (search-path-specification
            (variable "XDG_CONFIG_DIRS")
            (files '("etc/xdg")))))
    (home-page "https://www.qt.io/")
    (synopsis "Cross-platform GUI library")
    (description "Qt is a cross-platform application and UI framework for
developers using C++ or QML, a CSS & JavaScript like language.")
    (license (list license:lgpl2.1 license:lgpl3))

    ;; Qt 4: 'QBasicAtomicPointer' leads to build failures on MIPS;
    ;; see <http://hydra.gnu.org/build/112828>.
    ;; Qt 5: assembler error; see <http://hydra.gnu.org/build/112526>.
    (supported-systems (delete "mips64el-linux" %supported-systems))))

(define-public qtbase
  (package
    (name "qtbase")
    ;; TODO Remove ((gnu packages kde) qtbase-for-krita) when upgrading qtbase.
    (version "5.14.2")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://download.qt.io/official_releases/qt/"
                                 (version-major+minor version) "/" version
                                 "/submodules/" name "-everywhere-src-"
                                 version ".tar.xz"))
             (sha256
              (base32
               "12mjsahlma9rw3vz9a6b5h2s6ylg8b34hxc2vnlna5ll429fgfa8"))
             ;; Use TZDIR to avoid depending on package "tzdata".
             (patches (search-patches "qtbase-use-TZDIR.patch"
                                      "qtbase-moc-ignore-gcc-macro.patch"))
             (modules '((guix build utils)))
             (snippet
               ;; corelib uses bundled harfbuzz, md4, md5, sha3
              '(begin
                (with-directory-excursion "src/3rdparty"
                  (for-each delete-file-recursively
                            (list "double-conversion" "freetype" "harfbuzz-ng"
                                  "libpng" "libjpeg" "pcre2" "sqlite" "xcb"
                                  "zlib"))
                  #t)))))
    (build-system gnu-build-system)
    (propagated-inputs
     `(("mesa" ,mesa)
       ;; Use which the package, not the function
       ("which" ,(@ (gnu packages base) which))))
    (inputs
     `(("alsa-lib" ,alsa-lib)
       ("cups" ,cups)
       ("dbus" ,dbus)
       ("double-conversion" ,double-conversion)
       ("eudev" ,eudev)
       ("expat" ,expat)
       ("fontconfig" ,fontconfig)
       ("freetype" ,freetype)
       ("glib" ,glib)
       ("harfbuzz" ,harfbuzz)
       ("icu4c" ,icu4c)
       ("libinput" ,libinput-minimal)
       ("libjpeg" ,libjpeg-turbo)
       ("libmng" ,libmng)
       ("libpng" ,libpng)
       ("libx11" ,libx11)
       ("libxcomposite" ,libxcomposite)
       ("libxcursor" ,libxcursor)
       ("libxfixes" ,libxfixes)
       ("libxi" ,libxi)
       ("libxinerama" ,libxinerama)
       ("libxkbcommon" ,libxkbcommon)
       ("libxml2" ,libxml2)
       ("libxrandr" ,libxrandr)
       ("libxrender" ,libxrender)
       ("libxslt" ,libxslt)
       ("libxtst" ,libxtst)
       ("mtdev" ,mtdev)
       ("mariadb" ,mariadb "lib")
       ("mariadb-dev" ,mariadb "dev")
       ("nss" ,nss)
       ("openssl" ,openssl)
       ("pcre2" ,pcre2)
       ("postgresql" ,postgresql)
       ("pulseaudio" ,pulseaudio)
       ("sqlite" ,sqlite)
       ("unixodbc" ,unixodbc)
       ("xcb-util" ,xcb-util)
       ("xcb-util-image" ,xcb-util-image)
       ("xcb-util-keysyms" ,xcb-util-keysyms)
       ("xcb-util-renderutil" ,xcb-util-renderutil)
       ("xcb-util-wm" ,xcb-util-wm)
       ("xdg-utils" ,xdg-utils)
       ("zlib" ,zlib)))
    (native-inputs
     `(("bison" ,bison)
       ("flex" ,flex)
       ("gperf" ,gperf)
       ("perl" ,perl)
       ("pkg-config" ,pkg-config)
       ("python" ,python)
       ("vulkan-headers" ,vulkan-headers)
       ("ruby" ,ruby)))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'configure 'patch-bin-sh
           (lambda _
             (substitute* '("config.status"
                            "configure"
                            "mkspecs/features/qt_functions.prf"
                            "qmake/library/qmakebuiltins.cpp")
                          (("/bin/sh") (which "sh")))
             #t))
         (add-after 'configure 'patch-xdg-open
           (lambda _
             (substitute* '("src/platformsupport/services/genericunix/qgenericunixservices.cpp")
                          (("^.*const char \\*browsers.*$" all)
                           (string-append "*browser = QStringLiteral(\""
                                          (which "xdg-open")
                                          "\"); return true; \n" all)))
             #t))
         (replace 'configure
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               (substitute* "configure"
                 (("/bin/pwd") (which "pwd")))
               (substitute* "src/corelib/global/global.pri"
                 (("/bin/ls") (which "ls")))
               ;; The configuration files for other Qt5 packages are searched
               ;; through a call to "find_package" in Qt5Config.cmake, which
               ;; disables the use of CMAKE_PREFIX_PATH via the parameter
               ;; "NO_DEFAULT_PATH". Re-enable it so that the different
               ;; components can be installed in different places.
               (substitute* (find-files "." ".*\\.cmake")
                 (("NO_DEFAULT_PATH") ""))
               ;; do not pass "--enable-fast-install", which makes the
               ;; configure process fail
               (invoke
                 "./configure"
                 "-verbose"
                 "-prefix" out
                 "-docdir" (string-append out "/share/doc/qt5")
                 "-headerdir" (string-append out "/include/qt5")
                 "-archdatadir" (string-append out "/lib/qt5")
                 "-datadir" (string-append out "/share/qt5")
                 "-examplesdir" (string-append
                                  out "/share/doc/qt5/examples")
                 "-opensource"
                 "-confirm-license"

                 ;; These features require higher versions of Linux than the
                 ;; minimum version of the glibc.  See
                 ;; src/corelib/global/minimum-linux_p.h.  By disabling these
                 ;; features Qt5 applications can be used on the oldest
                 ;; kernels that the glibc supports, including the RHEL6
                 ;; (2.6.32) and RHEL7 (3.10) kernels.
                 "-no-feature-getentropy"  ; requires Linux 3.17
                 "-no-feature-renameat2"   ; requires Linux 3.16

                 ;; Do not build examples; if desired, these could go
                 ;; into a separate output, but for the time being, we
                 ;; prefer to save the space and build time.
                 "-no-compile-examples"
                 ;; Most "-system-..." are automatic, but some use
                 ;; the bundled copy by default.
                 "-system-sqlite"
                 "-system-harfbuzz"
                 "-system-pcre"
                 ;; explicitly link with openssl instead of dlopening it
                 "-openssl-linked"
                 ;; explicitly link with dbus instead of dlopening it
                 "-dbus-linked"
                 ;; don't use the precompiled headers
                 "-no-pch"
                 ;; drop special machine instructions that do not have
                 ;; runtime detection
                 ,@(if (string-prefix? "x86_64"
                                       (or (%current-target-system)
                                           (%current-system)))
                     '()
                     '("-no-sse2"))
                 "-no-mips_dsp"
                 "-no-mips_dspr2"))))
         (add-after 'install 'patch-mkspecs
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (archdata (string-append out "/lib/qt5"))
                    (mkspecs (string-append archdata "/mkspecs"))
                    (qt_config.prf (string-append
                                    mkspecs "/features/qt_config.prf")))
               ;; For each Qt module, let `qmake' uses search paths in the
               ;; module directory instead of all in QT_INSTALL_PREFIX.
               (substitute* qt_config.prf
                 (("\\$\\$\\[QT_INSTALL_HEADERS\\]")
                  "$$clean_path($$replace(dir, mkspecs/modules, ../../include/qt5))")
                 (("\\$\\$\\[QT_INSTALL_LIBS\\]")
                  "$$clean_path($$replace(dir, mkspecs/modules, ../../lib))")
                 (("\\$\\$\\[QT_HOST_LIBS\\]")
                  "$$clean_path($$replace(dir, mkspecs/modules, ../../lib))")
                 (("\\$\\$\\[QT_INSTALL_BINS\\]")
                  "$$clean_path($$replace(dir, mkspecs/modules, ../../bin))"))

               ;; Searches Qt tools in the current PATH instead of QT_HOST_BINS.
               (substitute* (string-append mkspecs "/features/qt_functions.prf")
                 (("cmd = \\$\\$\\[QT_HOST_BINS\\]/\\$\\$2")
                  "cmd = $$system(which $${2}.pl 2>/dev/null || which $${2})"))

               ;; Resolve qmake spec files within qtbase by absolute paths.
               (substitute*
                   (map (lambda (file)
                          (string-append mkspecs "/features/" file))
                        '("device_config.prf" "moc.prf" "qt_build_config.prf"
                          "qt_config.prf" "winrt/package_manifest.prf"))
                 (("\\$\\$\\[QT_HOST_DATA/get\\]") archdata)
                 (("\\$\\$\\[QT_HOST_DATA/src\\]") archdata))
               #t)))
         (add-after 'patch-mkspecs 'patch-prl-files
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               ;; Insert absolute references to the qtbase libraries because
               ;; QT_INSTALL_LIBS does not always resolve correctly, depending
               ;; on context.  See <https://bugs.gnu.org/38405>
               (substitute* (find-files (string-append out "/lib") "\\.prl$")
                 (("\\$\\$\\[QT_INSTALL_LIBS\\]")
                  (string-append out "/lib")))
               #t)))
         (add-after 'unpack 'patch-paths
           ;; Use the absolute paths for dynamically loaded libs, otherwise
           ;; the lib will be searched in LD_LIBRARY_PATH which typically is
           ;; not set in guix.
           (lambda* (#:key inputs #:allow-other-keys)
             ;; libresolve
             (let ((glibc (assoc-ref inputs ,(if (%current-target-system)
                                                 "cross-libc" "libc"))))
               (substitute* '("src/network/kernel/qdnslookup_unix.cpp"
                              "src/network/kernel/qhostinfo_unix.cpp")
                 (("^\\s*(lib.setFileName\\(QLatin1String\\(\")(resolv\"\\)\\);)" _ a b)
                (string-append a glibc "/lib/lib" b))))
             ;; libGL
             (substitute* "src/plugins/platforms/xcb/gl_integrations/xcb_glx/qglxintegration.cpp"
               (("^\\s*(QLibrary lib\\(QLatin1String\\(\")(GL\"\\)\\);)" _ a b)
                (string-append a (assoc-ref inputs "mesa") "/lib/lib" b)))
             ;; libXcursor
             (substitute* "src/plugins/platforms/xcb/qxcbcursor.cpp"
               (("^\\s*(QLibrary xcursorLib\\(QLatin1String\\(\")(Xcursor\"\\), 1\\);)" _ a b)
                (string-append a (assoc-ref inputs "libxcursor") "/lib/lib" b))
               (("^\\s*(xcursorLib.setFileName\\(QLatin1String\\(\")(Xcursor\"\\)\\);)" _ a b)
                (string-append a (assoc-ref inputs "libxcursor") "/lib/lib" b)))
             #t)))))
    (native-search-paths
     (list (search-path-specification
            (variable "QMAKEPATH")
            (files '("lib/qt5")))
           (search-path-specification
            (variable "QML2_IMPORT_PATH")
            (files '("lib/qt5/qml")))
           (search-path-specification
            (variable "QT_PLUGIN_PATH")
            (files '("lib/qt5/plugins")))
           (search-path-specification
            (variable "XDG_DATA_DIRS")
            (files '("share")))
           (search-path-specification
            (variable "XDG_CONFIG_DIRS")
            (files '("etc/xdg")))))
    (home-page "https://www.qt.io/")
    (synopsis "Cross-platform GUI library")
    (description "Qt is a cross-platform application and UI framework for
developers using C++ or QML, a CSS & JavaScript like language.")
    (license (list license:lgpl2.1 license:lgpl3))))

;; qt used to refer to the monolithic Qt 5.x package
(define-deprecated qt qtbase)

;; This variable is required by 'python-pyside-2-tools', which copies some
;; qtbase executables that fail to run because RUNPATH refers to the
;; wrong $ORIGIN.  TODO: Merge with qtbase in the next rebuild cycle.
(define qtbase/next
  (package
    (inherit qtbase)
    (source
     (origin
       (inherit (package-source qtbase))
       (patches (append (origin-patches (package-source qtbase))
                        (search-patches "qtbase-absolute-runpath.patch")))))))

(define-public qtbase-for-krita
  (hidden-package
    (package
      (inherit qtbase)
      (source (origin
                (inherit (package-source qtbase))
                (patches (append (origin-patches (package-source qtbase))
                                 (search-patches "qtbase-fix-krita-deadlock.patch"))))))))

(define-public qtsvg
  (package (inherit qtbase)
    (name "qtsvg")
    (version "5.14.2")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://download.qt.io/official_releases/qt/"
                                 (version-major+minor version) "/" version
                                 "/submodules/" name "-everywhere-src-"
                                 version ".tar.xz"))
             (sha256
              (base32
               "18dmfc8s428fzbk7k5vl3212b25455ayrz7s716nwyiy3ahgmmy7"))))
    (propagated-inputs `())
    (native-inputs `(("perl" ,perl)))
    (inputs
     `(("mesa" ,mesa)
       ("qtbase" ,qtbase)
       ("zlib" ,zlib)))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-before 'configure 'configure-qmake
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (qtbase (assoc-ref inputs "qtbase"))
                    (tmpdir (string-append (getenv "TMPDIR")))
                    (qmake (string-append tmpdir "/qmake"))
                    (qt.conf (string-append tmpdir "/qt.conf")))
               ;; Use qmake with a customized qt.conf to override install
               ;; paths to $out.
               (symlink (which "qmake") qmake)
               (setenv "PATH" (string-append tmpdir ":" (getenv "PATH")))
               (with-output-to-file qt.conf
                 (lambda ()
                   (format #t "[Paths]
Prefix=~a
ArchData=lib/qt5
Data=share/qt5
Documentation=share/doc/qt5
Headers=include/qt5
Libraries=lib
LibraryExecutables=lib/qt5/libexec
Binaries=bin
Tests=tests
Plugins=lib/qt5/plugins
Imports=lib/qt5/imports
Qml2Imports=lib/qt5/qml
Translations=share/qt5/translations
Settings=etc/xdg
Examples=share/doc/qt5/examples
HostPrefix=~a
HostData=lib/qt5
HostBinaries=bin
HostLibraries=lib

[EffectiveSourcePaths]
HostPrefix=~a
HostData=lib/qt5
" out out qtbase)))
               #t)))
         (replace 'configure
           (lambda* (#:key inputs outputs #:allow-other-keys)
             ;; Valid QT_BUILD_PARTS variables are:
             ;; libs tools tests examples demos docs translations
             (invoke "qmake" "QT_BUILD_PARTS = libs tools tests")))
         (add-before 'check 'set-display
           (lambda _
             ;; make Qt render "offscreen", required for tests
             (setenv "QT_QPA_PLATFORM" "offscreen")
             #t)))))
    (synopsis "Qt module for displaying SVGs")
    (description "The QtSvg module provides classes for displaying the
 contents of SVG files.")))

(define-public qtimageformats
  (package (inherit qtsvg)
    (name "qtimageformats")
    (version "5.14.2")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://download.qt.io/official_releases/qt/"
                                 (version-major+minor version) "/" version
                                 "/submodules/" name "-everywhere-src-"
                                 version ".tar.xz"))
             (sha256
              (base32
               "132g4rlm61pdcpcrclr1rwpbrxn7va4wjfb021mh8pn1cl0wlgkk"))
             (modules '((guix build utils)))
             (snippet
              '(begin
                 (delete-file-recursively "src/3rdparty")
                 #t))))
    (arguments
     (substitute-keyword-arguments (package-arguments qtsvg)
       ((#:phases phases)
        `(modify-phases ,phases
           (add-after 'unpack 'fix-build
             (lambda _
               (substitute* "src/plugins/imageformats/jp2/qjp2handler.cpp"
                 (("^#include <jasper/jasper.h>")
                  "#include <jasper/jasper.h>\n#include <QtCore/qmath.h>"))
               #t))))))
    (native-inputs `())
    (inputs
     `(("jasper" ,jasper)
       ("libmng" ,libmng)
       ("libtiff" ,libtiff)
       ("libwebp" ,libwebp)
       ("mesa" ,mesa)
       ("qtbase" ,qtbase)
       ("zlib" ,zlib)))
    (synopsis "Additional Image Format plugins for Qt")
    (description "The QtImageFormats module contains plugins for adding
support for MNG, TGA, TIFF and WBMP image formats.")))

(define-public qtx11extras
  (package (inherit qtsvg)
    (name "qtx11extras")
    (version "5.14.2")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://download.qt.io/official_releases/qt/"
                                 (version-major+minor version) "/" version
                                 "/submodules/" name "-everywhere-src-"
                                 version ".tar.xz"))
             (sha256
              (base32
               "0njlh6d327nll7d8qaqrwr5x15m9yzgyar2j45qigs1f7ah896my"))))
    (arguments
     (substitute-keyword-arguments (package-arguments qtsvg)
       ((#:tests? _ #f) #f))) ; TODO: Enable the tests
    (native-inputs `(("perl" ,perl)))
    (inputs
     `(("mesa" ,mesa)
       ("qtbase" ,qtbase)))
    (synopsis "Qt Extras for X11")
    (description "The QtX11Extras module includes the library to access X11
from within Qt 5.")))

(define-public qtxmlpatterns
  (package (inherit qtsvg)
    (name "qtxmlpatterns")
    (version "5.14.2")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://download.qt.io/official_releases/qt/"
                                 (version-major+minor version) "/" version
                                 "/submodules/" name "-everywhere-src-"
                                 version ".tar.xz"))
             (sha256
              (base32
               "1dyg1z4349k04yyzn8xbp4f5qjgm60gz6wgzp80khpilcmk8g6i1"))))
    (arguments
     (substitute-keyword-arguments (package-arguments qtsvg)
       ((#:tests? _ #f) #f) ; TODO: Enable the tests
       ((#:phases phases)
        `(modify-phases ,phases
           (add-after 'unpack 'disable-network-tests
             (lambda _ (substitute* "tests/auto/auto.pro"
                         (("qxmlquery") "# qxmlquery")
                         (("xmlpatterns ") "# xmlpatterns"))
               #t))))))
    (native-inputs `(("perl" ,perl)
                     ("qtdeclarative" ,qtdeclarative)))
    (inputs `(("qtbase" ,qtbase)))
    (synopsis "Qt XML patterns module")
    (description "The QtXmlPatterns module is a XQuery and XPath engine for
XML and custom data models.  It contains programs such as xmlpatterns and
xmlpatternsvalidator.")))

(define-public qtdeclarative
  (package (inherit qtsvg)
    (name "qtdeclarative")
    (version "5.14.2")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://download.qt.io/official_releases/qt/"
                                 (version-major+minor version) "/" version
                                 "/submodules/" name "-everywhere-src-"
                                 version ".tar.xz"))
             (sha256
              (base32
               "0l0nhc2si6dl9r4s1bs45z90qqigs8jnrsyjjdy38q4pvix63i53"))))
    (arguments
     (substitute-keyword-arguments (package-arguments qtsvg)
       ((#:tests? _ #f) #f)             ;TODO: Enable the tests
       ((#:phases phases)
        `(modify-phases ,phases
           (add-after 'build 'fix-qt5core-install-prefix
             (lambda* (#:key outputs #:allow-other-keys)
               (let ((out (assoc-ref outputs "out")))
                 ;; The Qt5Core install prefix is set to qtbase, but qmlcachegen
                 ;; is provided by qtdeclarative.
                 (substitute*
                     "lib/cmake/Qt5QuickCompiler/Qt5QuickCompilerConfig.cmake"
                   (("\\$\\{_qt5Core_install_prefix\\}") out)))
               #t))))))
    (native-inputs
     `(("perl" ,perl)
       ("pkg-config" ,pkg-config)
       ("python" ,python)
       ("python-wrapper" ,python-wrapper)
       ("qtsvg" ,qtsvg)
       ("vulkan-headers" ,vulkan-headers)))
    (inputs
     `(("mesa" ,mesa)
       ("qtbase" ,qtbase)))
    (synopsis "Qt QML module (Quick 2)")
    (description "The Qt QML module provides a framework for developing
applications and libraries with the QML language.  It defines and implements the
language and engine infrastructure, and provides an API to enable application
developers to extend the QML language with custom types and integrate QML code
with JavaScript and C++.")))

(define-public qtconnectivity
  (package (inherit qtsvg)
    (name "qtconnectivity")
    (version "5.14.2")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://download.qt.io/official_releases/qt/"
                                 (version-major+minor version) "/" version
                                 "/submodules/" name "-everywhere-src-"
                                 version ".tar.xz"))
             (sha256
              (base32
               "0a5wzin635b926b8prdwfazgy1vhyf8m6an64wp2lpkp78z7prmb"))))
    (native-inputs
     `(("perl" ,perl)
       ("pkg-config" ,pkg-config)
       ("qtdeclarative" ,qtdeclarative)))
    (inputs
     `(("bluez" ,bluez)
       ("qtbase" ,qtbase)))
    (synopsis "Qt Connectivity module")
    (description "The Qt Connectivity modules provides modules for interacting
with Bluetooth and NFC.")))

(define-public qtwebsockets
  (package (inherit qtsvg)
    (name "qtwebsockets")
    (version "5.14.2")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://download.qt.io/official_releases/qt/"
                                 (version-major+minor version) "/" version
                                 "/submodules/" name "-everywhere-src-"
                                 version ".tar.xz"))
             (sha256
              (base32
               "116amx4mnv50k0fpswgpr5x8wjny8nbffrjmld01pzhkhfqn4vph"))))
    (arguments
     (substitute-keyword-arguments (package-arguments qtsvg)
       ((#:tests? _ #f) #f))) ; TODO: Enable the tests
    (native-inputs
     `(("perl" ,perl)
       ("qtdeclarative" ,qtdeclarative)))
    (inputs `(("qtbase" ,qtbase)))
    (synopsis "Qt Web Sockets module")
    (description "WebSocket is a web-based protocol designed to enable two-way
communication between a client application and a remote host.  The Qt
WebSockets module provides C++ and QML interfaces that enable Qt applications
to act as a server that can process WebSocket requests, or a client that can
consume data received from the server, or both.")))

(define-public qtsensors
  (package (inherit qtsvg)
    (name "qtsensors")
    (version "5.14.2")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://download.qt.io/official_releases/qt/"
                                 (version-major+minor version) "/" version
                                 "/submodules/" name "-everywhere-src-"
                                 version ".tar.xz"))
             (sha256
              (base32
               "0qccpgbhyg9k4x5nni7xm0pyvaqia3zrcd42cn7ksf5h21lwmkxw"))))
    (arguments
     (substitute-keyword-arguments (package-arguments qtsvg)
       ((#:parallel-tests? _ #f) #f) ; can lead to race condition
       ((#:phases phases)
        `(modify-phases ,phases
           (add-after 'unpack 'fix-tests
             (lambda _
               (substitute* "tests/auto/qsensorgestures_gestures/tst_sensorgestures_gestures.cpp"
                 (("2000") "5000")      ;lengthen test timeout
                 (("QTest::newRow(\"twist\") << \"twist\"") "")) ;failing test
               #t))))))
    (native-inputs
     `(("perl" ,perl)
       ("qtdeclarative" ,qtdeclarative)))
    (inputs `(("qtbase" ,qtbase)))
    (synopsis "Qt Sensors module")
    (description "The Qt Sensors API provides access to sensor hardware via QML
and C++ interfaces.  The Qt Sensors API also provides a motion gesture
recognition API for devices.")))

(define-public qtmultimedia
  (package (inherit qtsvg)
    (name "qtmultimedia")
    (version "5.14.2")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://download.qt.io/official_releases/qt/"
                                 (version-major+minor version) "/" version
                                 "/submodules/" name "-everywhere-src-"
                                 version ".tar.xz"))
             (sha256
              (base32
               "1sczzcvk3c5gczz53yvp8ma6gp8aixk5pcq7wh344c9md3g8xkbs"))
             (modules '((guix build utils)))
             (snippet
              '(begin
                 (delete-file-recursively
                   "examples/multimedia/spectrum/3rdparty")
                 ;; We also prevent the spectrum example from being built.
                 (substitute* "examples/multimedia/multimedia.pro"
                   (("spectrum") "#"))
                 #t))))
    (arguments
     (substitute-keyword-arguments (package-arguments qtsvg)
       ((#:phases phases)
        `(modify-phases ,phases
           (replace 'configure
             (lambda* (#:key outputs #:allow-other-keys)
               (let ((out (assoc-ref outputs "out")))
                 (invoke "qmake" "QT_BUILD_PARTS = libs tools tests"
                         (string-append "QMAKE_LFLAGS_RPATH=-Wl,-rpath," out "/lib -Wl,-rpath,")
                         (string-append "PREFIX=" out)))))))
       ((#:tests? _ #f) #f)))           ; TODO: Enable the tests
    (native-inputs
     `(("perl" ,perl)
       ("pkg-config" ,pkg-config)
       ("python" ,python)
       ("qtdeclarative" ,qtdeclarative)))
    (inputs
     `(("alsa-lib" ,alsa-lib)
       ("mesa" ,mesa)
       ("pulseaudio" ,pulseaudio)
       ("qtbase" ,qtbase)
       ;; Gstreamer is needed for the mediaplayer plugin
       ("gstreamer" ,gstreamer)
       ("gst-plugins-base" ,gst-plugins-base)))
    (synopsis "Qt Multimedia module")
    (description "The Qt Multimedia module provides set of APIs to play and
record media, and manage a collection of media content.  It also contains a
set of plugins for interacting with pulseaudio and GStreamer.")))

(define-public qtwayland
  (package (inherit qtsvg)
    (name "qtwayland")
    (version "5.14.2")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://download.qt.io/official_releases/qt/"
                                 (version-major+minor version) "/" version
                                 "/submodules/" name "-everywhere-src-"
                                 version ".tar.xz"))
             (sha256
              (base32
               "0al3yypy3fin62n8d1859jh0mn0fbpa161l7f37hgd4gf75365nk"))
             (modules '((guix build utils)))
             (snippet
               ;; The examples try to build and cause the build to fail
              '(begin
                 (delete-file-recursively "examples")
                 #t))))
    (arguments
     (substitute-keyword-arguments (package-arguments qtsvg)
       ((#:phases phases)
        `(modify-phases ,phases
           (add-after 'unpack 'disable-failing-tests
             (lambda _
               ;; FIXME: tst_seatv4::animatedCursor() fails for no good
               ;; reason and breaks these two tests.
               (substitute* "tests/auto/client/seatv4/tst_seatv4.cpp"
                 (((string-append "QVERIFY\\(!cursorSurface\\(\\)->"
                                  "m_waitingFrameCallbacks\\.empty\\(\\)\\);"))
                  "")
                 (("QTRY_COMPARE\\(bufferSpy\\.count\\(\\), 1\\);")
                  ""))
               #t))
           (add-before 'check 'set-test-environment
             (lambda _
               ;; Do not fail just because /etc/machine-id is missing.
               (setenv "DBUS_FATAL_WARNINGS" "0")
               #t))))))
    (native-inputs
     `(("glib" ,glib)
       ("perl" ,perl)
       ("pkg-config" ,pkg-config)
       ("qtdeclarative" ,qtdeclarative)))
    (inputs
     `(("fontconfig" ,fontconfig)
       ("freetype" ,freetype)
       ("libx11" ,libx11)
       ("libxcomposite" ,libxcomposite)
       ("libxext" ,libxext)
       ("libxkbcommon" ,libxkbcommon)
       ("libxrender" ,libxrender)
       ("mesa" ,mesa)
       ("mtdev" ,mtdev)
       ("qtbase" ,qtbase)
       ("wayland" ,wayland)))
    (synopsis "Qt Wayland module")
    (description "The Qt Wayland module provides the QtWayland client and
compositor libraries.")))

(define-public qtserialport
  (package (inherit qtsvg)
    (name "qtserialport")
    (version "5.14.2")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://download.qt.io/official_releases/qt/"
                                 (version-major+minor version) "/" version
                                 "/submodules/" name "-everywhere-src-"
                                 version ".tar.xz"))
             (sha256
              (base32
               "08ga9a1lwj83872nxablk602z1dq0la6jqsiicvd7m1sfbfpgnd6"))))
    (native-inputs `(("perl" ,perl)))
    (inputs
     `(("qtbase" ,qtbase)
       ("eudev" ,eudev)))
    (arguments
     (substitute-keyword-arguments (package-arguments qtsvg)
       ((#:phases phases)
        `(modify-phases ,phases
           (add-after 'unpack 'patch-dlopen-paths
           (lambda* (#:key inputs #:allow-other-keys)
             (substitute* "src/serialport/qtudev_p.h"
               ;; Use the absolute paths for dynamically loaded libs,
               ;; otherwise the lib will be searched in LD_LIBRARY_PATH which
               ;; typically is not set in guix.
               (("^\\s*(udevLibrary->setFileNameAndVersion\\(QStringLiteral\\(\")(udev\"\\),\\s*[0-9]+\\);)" _ a b)
                (string-append a (assoc-ref inputs "eudev") "/lib/lib" b)))
             #t))))))
    (synopsis "Qt Serial Port module")
    (description "The Qt Serial Port module provides the library for
interacting with serial ports from within Qt.")))

(define-public qtserialbus
  (package (inherit qtsvg)
    (name "qtserialbus")
    (version "5.14.2")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://download.qt.io/official_releases/qt/"
                                 (version-major+minor version) "/" version
                                 "/submodules/" name "-everywhere-src-"
                                 version ".tar.xz"))
             (sha256
              (base32
               "14bahg82jciciqkl74q9hvf3a8kp3pk5v731vp2416k4b8bn4xqb"))))
    (inputs
     `(("qtbase" ,qtbase)
       ("qtserialport" ,qtserialport)))
    (synopsis "Qt Serial Bus module")
    (description "The Qt Serial Bus API provides classes and functions to
access the various industrial serial buses and protocols, such as CAN, ModBus,
and others.")))

(define-public qtwebchannel
  (package (inherit qtsvg)
    (name "qtwebchannel")
    (version "5.14.2")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://download.qt.io/official_releases/qt/"
                                 (version-major+minor version) "/" version
                                 "/submodules/" name "-everywhere-src-"
                                 version ".tar.xz"))
             (sha256
              (base32
               "0x7q66994pw6cd0f505bmirw1sssqs740zaw8lyqqqr32m2ch7bx"))))
    (native-inputs
     `(("perl" ,perl)
       ("qtdeclarative" ,qtdeclarative)
       ("qtwebsockets" ,qtwebsockets)))
    (inputs `(("qtbase" ,qtbase)))
    (synopsis "Web communication library for Qt")
    (description "The Qt WebChannel module enables peer-to-peer communication
between the host (QML/C++ application) and the client (HTML/JavaScript
application).  The transport mechanism is supported out of the box by the two
popular web engines, Qt WebKit 2 and Qt WebEngine.")))

(define-public qtwebglplugin
  (package (inherit qtsvg)
    (name "qtwebglplugin")
    (version "5.14.2")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://download.qt.io/official_releases/qt/"
                                 (version-major+minor version) "/" version
                                 "/submodules/" name "-everywhere-src-"
                                 version ".tar.xz"))
             (sha256
              (base32
               "05rl657848fsprsnabdqb5z363c6drjc32k59223vl351f8ihhgb"))))
    (arguments
     (substitute-keyword-arguments (package-arguments qtsvg)
       ((#:phases phases)
        `(modify-phases ,phases
           (add-after 'unpack 'disable-network-tests
             (lambda _ (substitute* "tests/plugins/platforms/platforms.pro"
                         (("webgl") "# webgl"))
               #t))))))
    (native-inputs '())
    (inputs
     `(("mesa" ,mesa)
       ("qtbase" ,qtbase)
       ("qtdeclarative" ,qtdeclarative)
       ("qtwebsockets" ,qtwebsockets)
       ("zlib" ,zlib)))
    (synopsis "QPA plugin for running an application via a browser using
streamed WebGL commands")
    (description "Qt back end that uses WebGL for rendering. It allows Qt
applications (with some limitations) to run in a web browser that supports
WebGL.  WebGL is a JavaScript API for rendering 2D and 3D graphics within any
compatible web browser without the use of plug-ins.  The API is similar to
OpenGL ES 2.0 and can be used in HTML5 canvas elements")))

(define-public qtwebview
  (package (inherit qtsvg)
    (name "qtwebview")
    (version "5.14.2")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://download.qt.io/official_releases/qt/"
                                 (version-major+minor version) "/" version
                                 "/submodules/" name "-everywhere-src-"
                                 version ".tar.xz"))
             (sha256
              (base32
               "0jzzcm7z5njkddzfhmyjz4dbbzq8h93980cci4479zc4xq9r47y6"))))
    (native-inputs
     `(("perl" ,perl)))
    (inputs
     `(("qtbase" ,qtbase)
       ("qtdeclarative" ,qtdeclarative)))
    (synopsis "Display web content in a QML application")
    (description "Qt WebView provides a way to display web content in a QML
application without necessarily including a full web browser stack by using
native APIs where it makes sense.")))

(define-public qtlocation
  (package (inherit qtsvg)
    (name "qtlocation")
    (version "5.14.2")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://download.qt.io/official_releases/qt/"
                                 (version-major+minor version) "/" version
                                 "/submodules/" name "-everywhere-src-"
                                 version ".tar.xz"))
             (sha256
              (base32
               "1k3m8zhbv04yrqvj7jlnh8f9xczdsmla59j9gcwsqvbg76y0hxy3"))))
    (arguments
     (substitute-keyword-arguments (package-arguments qtsvg)
       ((#:tests? _ #f) #f))) ; TODO: Enable the tests
    (native-inputs
     `(("perl" ,perl)
       ("qtdeclarative" ,qtdeclarative)
       ("qtquickcontrols" ,qtquickcontrols)
       ("qtserialport" ,qtserialport)))
    (inputs
     `(("icu4c" ,icu4c)
       ("openssl" ,openssl)
       ("qtbase" ,qtbase)
       ("zlib" ,zlib)))
    (synopsis "Qt Location and Positioning modules")
    (description "The Qt Location module provides an interface for location,
positioning and geolocation plugins.")))

(define-public qttools
  (package (inherit qtsvg)
    (name "qttools")
    (version "5.14.2")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://download.qt.io/official_releases/qt/"
                                 (version-major+minor version) "/" version
                                 "/submodules/" name "-everywhere-src-"
                                 version ".tar.xz"))
             (sha256
              (base32
               "1iakl3hlyg51ri1czmis8mmb257b0y1zk2a2knybd3mq69wczc2v"))))
    (arguments
     (substitute-keyword-arguments (package-arguments qtsvg)
       ((#:tests? _ #f) #f))) ; TODO: Enable the tests
    (native-inputs
     `(("perl" ,perl)
       ("qtdeclarative" ,qtdeclarative)
       ("vulkan-headers" ,vulkan-headers)))
    (inputs
     `(("mesa" ,mesa)
       ("qtbase" ,qtbase)))
    (synopsis "Qt Tools and Designer modules")
    (description "The Qt Tools module provides a set of applications to browse
the documentation, translate applications, generate help files and other stuff
that helps in Qt development.")))

(define-public qtscript
  (package (inherit qtsvg)
    (name "qtscript")
    (version "5.14.2")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://download.qt.io/official_releases/qt/"
                                 (version-major+minor version) "/" version
                                 "/submodules/" name "-everywhere-src-"
                                 version ".tar.xz"))
             (sha256
              (base32
               "1zlvg3hc6h70d789g3kv6dxbwswzkskkm00bdgl01grwrdy4izg9"))
             (patches (search-patches "qtscript-disable-tests.patch"))))
    (native-inputs
     `(("perl" ,perl)
       ("qttools" ,qttools)))
    (inputs
     `(("qtbase" ,qtbase)))
    (synopsis "Qt Script module")
    (description "Qt provides support for application scripting with ECMAScript.
The following guides and references cover aspects of programming with
ECMAScript and Qt.")))

(define-public qtquickcontrols
  (package (inherit qtsvg)
    (name "qtquickcontrols")
    (version "5.14.2")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://download.qt.io/official_releases/qt/"
                                 (version-major+minor version) "/" version
                                 "/submodules/" name "-everywhere-src-"
                                 version ".tar.xz"))
             (sha256
              (base32
               "0qa4dlhn3iv9yvaic8hw86v6h8rn9sgq8xjfdaym04pfshfyypfm"))))
    (arguments
     (substitute-keyword-arguments (package-arguments qtsvg)
       ((#:tests? _ #f) #f))) ; TODO: Enable the tests
    (inputs
     `(("qtbase" ,qtbase)
       ("qtdeclarative" ,qtdeclarative)))
    (synopsis "Qt Quick Controls and other Quick modules")
    (description "The QtScript module provides classes for making Qt
applications scriptable.  This module provides a set of extra components that
can be used to build complete interfaces in Qt Quick.")))

(define-public qtquickcontrols2
  (package (inherit qtsvg)
    (name "qtquickcontrols2")
    (version "5.14.2")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://download.qt.io/official_releases/qt/"
                                 (version-major+minor version) "/" version
                                 "/submodules/" name "-everywhere-src-"
                                 version ".tar.xz"))
             (sha256
              (base32
               "0q0mk2mjlf9ll0gdrdzxy8096s6g9draaqiwrlvdpa7lv14x7xzs"))))
    (arguments
     (substitute-keyword-arguments (package-arguments qtsvg)
       ((#:tests? _ #f) #f))) ; TODO: Enable the tests
    (inputs
     `(("qtbase" ,qtbase)
       ("qtdeclarative" ,qtdeclarative)))
    (synopsis "Qt Quick Controls 2 and other Quick 2 modules")
    (description "The Qt Quick Controls 2 module contains the Qt Labs Platform
module that provides platform integration: native dialogs, menus and menu bars,
and tray icons.  It falls back to Qt Widgets when a native implementation is
not available.")))

(define-public qtgraphicaleffects
  (package (inherit qtsvg)
    (name "qtgraphicaleffects")
    (version "5.14.2")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://download.qt.io/official_releases/qt/"
                                 (version-major+minor version) "/" version
                                 "/submodules/" name "-everywhere-src-"
                                 version ".tar.xz"))
             (sha256
              (base32
               "03xmwhapv0b2qj661iaqqrvhxc7qiid0acrp6rj85824ha2pyyj8"))))
    (arguments
     (substitute-keyword-arguments (package-arguments qtsvg)
       ((#:tests? _ #f) #f))) ; TODO: Enable the tests
    (inputs
     `(("qtbase" ,qtbase)
       ("qtdeclarative" ,qtdeclarative)))
    (synopsis "Qt Graphical Effects module")
    (description "The Qt Graphical Effects module provides a set of QML types
for adding visually impressive and configurable effects to user interfaces.
Effects are visual items that can be added to Qt Quick user interface as UI
components.  The API consists of over 20 effects provided as separate QML
types.  The effects cover functional areas such as blending, masking, blurring,
coloring, and many more.")))

(define-public qtgamepad
  (package (inherit qtsvg)
    (name "qtgamepad")
    (version "5.14.2")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://download.qt.io/official_releases/qt/"
                                 (version-major+minor version) "/" version
                                 "/submodules/" name "-everywhere-src-"
                                 version ".tar.xz"))
             (sha256
              (base32
               "00wd3h465waxdghg2vdhs5pkj0xikwjn88l12477dksm8zdslzgp"))))
    (native-inputs
     `(("perl" ,perl)
       ("pkg-config" ,pkg-config)))
    (inputs
     `(("fontconfig" ,fontconfig)
       ("freetype" ,freetype)
       ("libxrender" ,libxrender)
       ("sdl2" ,sdl2)
       ("qtbase" ,qtbase)
       ("qtdeclarative" ,qtdeclarative)))
    (synopsis "Qt Gamepad module")
    (description "The Qt Gamepad module is an add-on library that enables Qt
applications to support the use of gamepad hardware and in some cases remote
control equipment.  The module provides both QML and C++ interfaces.  The
primary target audience are embedded devices with fullscreen user interfaces,
and mobile applications targeting TV-like form factors.")))

(define-public qtscxml
  (package (inherit qtsvg)
    (name "qtscxml")
    (version "5.14.2")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://download.qt.io/official_releases/qt/"
                                 (version-major+minor version) "/" version
                                 "/submodules/" name "-everywhere-src-"
                                 version ".tar.xz"))
             (sha256
              (base32
               "141pfschv6zmcvvn3pi7f5vb4nf96zpngy80f9bly1sn58syl303"))
             (modules '((guix build utils)))
             (snippet
              '(begin
                 (delete-file-recursively "tests/3rdparty")
                 ;; the scion test refers to the bundled 3rd party test code.
                 (substitute* "tests/auto/auto.pro"
                   (("scion") "#"))
                 #t))))
    (inputs
     `(("qtbase" ,qtbase)
       ("qtdeclarative" ,qtdeclarative)))
    (synopsis "Qt SCXML module")
    (description "The Qt SCXML module provides functionality to create state
machines from SCXML files.  This includes both dynamically creating state
machines (loading the SCXML file and instantiating states and transitions) and
generating a C++ file that has a class implementing the state machine.  It
also contains functionality to support data models and executable content.")))

(define-public qtpurchasing
  (package (inherit qtsvg)
    (name "qtpurchasing")
    (version "5.14.2")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://download.qt.io/official_releases/qt/"
                                 (version-major+minor version) "/" version
                                 "/submodules/" name "-everywhere-src-"
                                 version ".tar.xz"))
             (sha256
              (base32
               "0lg8x7g7dkf95xwxq8b4yw4ypdz68igkscya96xwbklg3q08gc39"))))
    (inputs
     `(("qtbase" ,qtbase)
       ("qtdeclarative" ,qtdeclarative)))
    (synopsis "Qt Purchasing module")
    (description "The Qt Purchasing module provides and in-app API for
purchasing goods and services.")))

(define-public qtcharts
  (package (inherit qtsvg)
    (name "qtcharts")
    (version "5.14.2")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://download.qt.io/official_releases/qt/"
                                 (version-major+minor version) "/" version
                                 "/submodules/" name "-everywhere-src-"
                                 version ".tar.xz"))
             (sha256
              (base32
               "1drvm15i6n10b6a1acgarig120ppvqh3r6fqqdn8i3blx81m5cmd"))))
    (arguments
     (substitute-keyword-arguments (package-arguments qtsvg)
       ((#:tests? _ #f) #f))) ; TODO: Enable the tests
    (inputs
     `(("qtbase" ,qtbase)
       ("qtdeclarative" ,qtdeclarative)))
    (synopsis "Qt Charts module")
    (description "The Qt Charts module provides a set of easy to use chart
components.  It uses the Qt Graphics View Framework, therefore charts can be
easily integrated to modern user interfaces.  Qt Charts can be used as QWidgets,
QGraphicsWidget, or QML types. Users can easily create impressive graphs by
selecting one of the charts themes.")
    (license license:gpl3)))

(define-public qtdatavis3d
  (package (inherit qtsvg)
    (name "qtdatavis3d")
    (version "5.14.2")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://download.qt.io/official_releases/qt/"
                                 (version-major+minor version) "/" version
                                 "/submodules/" name "-everywhere-src-"
                                 version ".tar.xz"))
             (sha256
              (base32
               "080fkpxg70m3c697wfnkjhca58b7r1xsqd559jzb21985pdh6g3j"))))
    (arguments
     (substitute-keyword-arguments (package-arguments qtsvg)
       ((#:tests? _ #f) #f))) ; TODO: Enable the tests
    (inputs
     `(("qtbase" ,qtbase)
       ("qtdeclarative" ,qtdeclarative)))
    (synopsis "Qt Data Visualization module")
    (description "The Qt Data Visualization module provides a way to visualize
data in 3D as bar, scatter, and surface graphs. It is especially useful for
visualizing depth maps and large quantities of rapidly changing data, such as
data received from multiple sensors. The look and feel of graphs can be
customized by using themes or by adding custom items and labels to them.")
    (license license:gpl3)))

(define-public qtnetworkauth
  (package (inherit qtsvg)
    (name "qtnetworkauth")
    (version "5.14.2")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://download.qt.io/official_releases/qt/"
                                 (version-major+minor version) "/" version
                                 "/submodules/" name "-everywhere-src-"
                                 version ".tar.xz"))
             (sha256
              (base32
               "0pi6p7bq54kzij2p69cgib7n55k69jsq0yqq09yli645s4ym202g"))))
    (arguments
     (substitute-keyword-arguments (package-arguments qtsvg)
       ((#:phases phases)
        `(modify-phases ,phases
           (add-after 'unpack 'remove-failing-test
             (lambda _
               ;; These tests can't find their test data.
               (substitute* "tests/auto/auto.pro"
                 (("oauth1 ") "# oauth1 "))
               #t))))))
    (inputs
     `(("qtbase" ,qtbase)))
    (synopsis "Qt Network Authorization module")
    (description "The Qt Network Authorization module provides an
implementation of OAuth and OAuth2 authenticathon methods for Qt.")))

(define-public qtremoteobjects
  (package (inherit qtsvg)
    (name "qtremoteobjects")
    (version "5.14.2")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://download.qt.io/official_releases/qt/"
                                 (version-major+minor version) "/" version
                                 "/submodules/" name "-everywhere-src-"
                                 version ".tar.xz"))
             (sha256
              (base32
               "1mhlws5w0igf5hw0l90p6dz6k7w16dqfbnk2li0zxdmayk2039m6"))))
    (arguments
     (substitute-keyword-arguments (package-arguments qtsvg)
       ((#:phases phases)
        `(modify-phases ,phases
           (add-after 'unpack 'remove-failing-test
             (lambda _
               ;; This test can't find its imports.
               (substitute* "tests/auto/qml/qml.pro"
                 (("integration") "# integration")
                 (("usertypes") "# usertypes"))
               ;; disable failing tests: they need network
               (substitute* "tests/auto/auto.pro"
                 (("integration_multiprocess proxy_multiprocess integration_external restart")
                   "integration_multiprocess"))
               #t))))))
    (inputs
     `(("qtbase" ,qtbase)
       ("qtdeclarative" ,qtdeclarative)))
    (synopsis "Qt Remote Objects module")
    (description "The Qt Remote Objects module is an @dfn{inter-process
communication} (IPC) module developed for Qt.  The idea is to extend existing
Qt's functionalities to enable an easy exchange of information between
processes or computers.")))

(define-public qtspeech
  (package (inherit qtsvg)
    (name "qtspeech")
    (version "5.14.2")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://download.qt.io/official_releases/qt/"
                                 (version-major+minor version) "/" version
                                 "/submodules/" name "-everywhere-src-"
                                 version ".tar.xz"))
             (sha256
              (base32
               "1nn6kspbp8hfkz1jhzc1qx1m9z7r1bgkdqgi9n4vl1q25yk8x7jy"))))

    (arguments
     (substitute-keyword-arguments (package-arguments qtsvg)
       ((#:tests? _ #f) #f))) ; TODO: Enable the tests
    (inputs
     `(("qtbase" ,qtbase)))
    (native-inputs
     `(("perl" ,perl)
       ("qtdeclarative" ,qtdeclarative)
       ("qtmultimedia" ,qtmultimedia)
       ("qtxmlpatterns" ,qtxmlpatterns)))
    (synopsis "Qt Speech module")
    (description "The Qt Speech module enables a Qt application to support
accessibility features such as text-to-speech, which is useful for end-users
who are visually challenged or cannot access the application for whatever
reason.  The most common use case where text-to-speech comes in handy is when
the end-user is driving and cannot attend the incoming messages on the phone.
In such a scenario, the messaging application can read out the incoming
message.")))

(define-public qtspell
  (package
    (name "qtspell")
    (version "0.9.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/manisandro/qtspell.git")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1081makirjxixz44ghwz362vgnk5wcks6ni6w01pl667x8wggsd2"))))
    (build-system cmake-build-system)
    (arguments
     `(#:tests? #f))                    ;no test
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("qttools" ,qttools)))
    (inputs
     `(("enchant" ,enchant)
       ("qtbase" ,qtbase)))
    (home-page "https://github.com/manisandro/qtspell")
    (synopsis "Spell checking for Qt text widgets")
    (description
     "QtSpell adds spell-checking functionality to Qt's text widgets,
using the Enchant spell-checking library.")
    ;; COPYING file specify GPL3, but source code files all refer to GPL2+.
    (license license:gpl2+)))

(define-public qtwebengine
  (package
    (inherit qtsvg)
    (name "qtwebengine")
    (version (package-version qtbase))
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://download.qt.io/official_releases/qt/"
                           (version-major+minor version) "/" version
                           "/submodules/" name "-everywhere-src-"
                           version ".tar.xz"))
       (sha256
        (base32
         "0iy9lsl6zxlkca6x2p1506hbj3wmhnaipg23z027wfccbnkxcsg1"))
       (modules '((ice-9 ftw)
                  (ice-9 match)
                  (srfi srfi-1)
                  (srfi srfi-26)
                  (guix build utils)))
       (snippet
        '(begin
           (let ((preserved-third-party-files
                  '("base/third_party/cityhash"
                    "base/third_party/dmg_fp"
                    "base/third_party/dynamic_annotations"
                    "base/third_party/icu"
                    "base/third_party/libevent"
                    "base/third_party/nspr"
                    "base/third_party/superfasthash"
                    "base/third_party/symbolize"
                    "base/third_party/xdg_mime"
                    "base/third_party/xdg_user_dirs"
                    "net/third_party/mozilla_security_manager"
                    "net/third_party/nss"
                    "net/third_party/quiche"
                    "net/third_party/uri_template"
                    "third_party/abseil-cpp"
                    "third_party/angle"
                    "third_party/angle/src/common/third_party/base"
                    "third_party/angle/src/common/third_party/smhasher"
                    "third_party/angle/src/common/third_party/xxhash"
                    "third_party/angle/src/third_party/compiler"
                    "third_party/axe-core"
                    "third_party/blink"
                    "third_party/boringssl"
                    "third_party/boringssl/src/third_party/fiat"
                    "third_party/boringssl/src/third_party/sike"
                    "third_party/boringssl/linux-x86_64/crypto/third_party/sike"
                    "third_party/boringssl/linux-aarch64/crypto/third_party/sike"
                    "third_party/breakpad"
                    "third_party/brotli"
                    "third_party/ced"
                    "third_party/cld_3"
                    "third_party/crc32c"
                    "third_party/dav1d"
                    "third_party/dawn"
                    "third_party/emoji-segmenter"
                    "third_party/ffmpeg"
                    "third_party/googletest"
                    "third_party/hunspell"
                    "third_party/iccjpeg"
                    "third_party/icu"
                    "third_party/inspector_protocol"
                    "third_party/jinja2"
                    "third_party/jsoncpp"
                    "third_party/jstemplate"
                    "third_party/khronos"
                    "third_party/leveldatabase"
                    "third_party/libaddressinput"
                    "third_party/libjingle_xmpp"
                    "third_party/libjpeg"
                    "third_party/libpng"
                    "third_party/libsrtp"
                    "third_party/libsync"
                    "third_party/libudev"
                    "third_party/libvpx"
                    "third_party/libwebm"
                    "third_party/libwebp"
                    "third_party/libxml"
                    "third_party/libxslt"
                    "third_party/libyuv"
                    "third_party/lss"
                    "third_party/markupsafe"
                    "third_party/mesa_headers"
                    "third_party/metrics_proto"
                    "third_party/modp_b64"
                    "third_party/nasm"
                    "third_party/one_euro_filter"
                    "third_party/opus"
                    "third_party/ots"
                    "third_party/perfetto"
                    "third_party/pffft"
                    "third_party/ply"
                    "third_party/polymer"
                    "third_party/protobuf"
                    "third_party/pyjson5"
                    "third_party/re2"
                    "third_party/rnnoise"
                    "third_party/skia"
                    "third_party/skia/include/third_party/skcms/skcms.h"
                    "third_party/skia/include/third_party/vulkan"
                    "third_party/skia/third_party/gif"
                    "third_party/skia/third_party/skcms"
                    "third_party/skia/third_party/vulkanmemoryallocator"
                    "third_party/smhasher"
                    "third_party/snappy"
                    "third_party/sqlite"
                    "third_party/usb_ids"
                    "third_party/usrsctp"
                    "third_party/web-animations-js"
                    "third_party/webrtc"
                    "third_party/webrtc/common_audio/third_party/fft4g"
                    "third_party/webrtc/common_audio/third_party/spl_sqrt_floor"
                    "third_party/webrtc/modules/third_party/fft"
                    "third_party/webrtc/modules/third_party/g711"
                    "third_party/webrtc/modules/third_party/g722"
                    "third_party/webrtc/rtc_base/third_party/base64"
                    "third_party/webrtc/rtc_base/third_party/sigslot"
                    "third_party/webrtc_overrides"
                    "third_party/widevine/cdm/widevine_cdm_common.h"
                    "third_party/widevine/cdm/widevine_cdm_version.h"
                    "third_party/woff2"
                    "third_party/yasm"
                    "third_party/zlib"
                    "url/third_party/mozilla"
                    "v8/src/third_party/utf8-decoder"
                    "v8/src/third_party/valgrind"
                    "v8/src/third_party/siphash"
                    "v8/third_party/v8/builtins"
                    "v8/third_party/inspector_protocol"))
                 (protected (make-regexp "\\.(gn|gyp)i?$")))
             (define preserved-club
               (map (lambda (member)
                      (string-append "./" member))
                    preserved-third-party-files))
             (define (empty? dir)
               (equal? (scandir dir) '("." "..")))
             (define (third-party? file)
               (string-contains file "third_party/"))
             (define (useless? file)
               (any (cute string-suffix? <> file)
                    '(".zip" ".so" ".dll" ".exe" ".jar")))
             (define (parents child)
               ;; Return all parent directories of CHILD up to and including
               ;; the closest "third_party".
               (let* ((dirs (match (string-split child #\/)
                              ((dirs ... last) dirs)))
                      (closest (list-index (lambda (dir)
                                             (string=? "third_party" dir))
                                           (reverse dirs)))
                      (delim (- (length dirs) closest)))
                 (fold (lambda (dir prev)
                         (cons (string-append (car prev) "/" dir)
                               prev))
                       (list (string-join (list-head dirs delim) "/"))
                       (list-tail dirs delim))))
             (define (remove-loudly file)
               (format #t "deleting ~a...~%" file)
               (force-output)
               (delete-file file))
             (define (delete-unwanted-files child stat flag base level)
               (match flag
                 ((or 'regular 'symlink 'stale-symlink)
                  (when (third-party? child)
                    (unless (or (member child preserved-club)
                                (any (cute member <> preserved-club)
                                     (parents child))
                                (regexp-exec protected child))
                      (remove-loudly child)))
                  (when (and (useless? child) (file-exists? child))
                    (remove-loudly child))
                  #t)
                 ('directory-processed
                  (when (empty? child)
                    (rmdir child))
                  #t)
                 (_ #t)))

             (with-directory-excursion "src/3rdparty"
               ;; TODO: Try removing "gn" too for future versions of qtwebengine.
               (delete-file-recursively "ninja")

               (with-directory-excursion "chromium"
                 ;; Delete bundled software and binaries that were not explicitly
                 ;; preserved above.
                 (nftw "." delete-unwanted-files 'depth 'physical)

                 ;; Assert that each preserved item is present to catch removals.
                 (for-each (lambda (third-party)
                             (unless (file-exists? third-party)
                               (error (format #f "~s does not exist!~%" third-party))))
                           preserved-club)

                 ;; Use relative header locations instead of hard coded ones.
                 (substitute*
                     "base/third_party/dynamic_annotations/dynamic_annotations.c"
                   (("base/third_party/valgrind") "valgrind"))
                 (substitute*
                     "third_party/breakpad/breakpad/src/common/linux/libcurl_wrapper.h"
                   (("third_party/curl") "curl"))
                 (substitute*
                     '("components/viz/common/gpu/vulkan_context_provider.h"
                       "components/viz/common/resources/resource_format_utils.h"
                       "gpu/config/gpu_util.cc")
                   (("third_party/vulkan/include/")
                    ""))

                 ;; Replace Google Analytics bundle with an empty file and hope
                 ;; no one notices.
                 (mkdir-p "third_party/analytics")
                 (call-with-output-file
                     "third_party/analytics/google-analytics-bundle.js"
                   (lambda (port)
                     (const #t)))))
             ;; Do not enable support for loading the Widevine DRM plugin.
             (substitute* "src/buildtools/config/common.pri"
               (("enable_widevine=true")
                "enable_widevine=false"))
             #t)))))
    (build-system gnu-build-system)
    (native-inputs
     `(("bison" ,bison)
       ("flex" ,flex)
       ("gperf" ,gperf)
       ("ninja" ,ninja)
       ("perl" ,perl)
       ("pkg-config" ,pkg-config)
       ("python-2" ,python-2)
       ("ruby" ,ruby)))
    (inputs
     `(("alsa-lib" ,alsa-lib)
       ("atk" ,atk)
       ("cups-minimal" ,cups-minimal)
       ("curl" ,curl)
       ("dbus" ,dbus)
       ("ffmpeg" ,ffmpeg)
       ("fontconfig" ,fontconfig)
       ("harbuzz" ,harfbuzz)
       ("icu4c" ,icu4c)
       ("jsoncpp" ,jsoncpp)
       ("lcms" ,lcms)
       ("libcap" ,libcap)
       ("libevent" ,libevent)
       ("libgcrypt" ,libgcrypt)
       ("libjpeg" ,libjpeg-turbo)
       ("libvpx" ,libvpx)
       ("libwebp" ,libwebp)
       ("libx11" ,libx11)
       ("libxcb" ,libxcb)
       ("libxcomposite" ,libxcomposite)
       ("libxcursor" ,libxcursor)
       ("libxi" ,libxi)
       ("libxkbcommon" ,libxkbcommon)
       ;; FIXME: libxml2 needs to built with icu support though it links to
       ;; libxml2 configure summary still states "Checking for compatible
       ;; system libxml2... no"
       ("libxml2" ,libxml2)
       ("libxrandr" ,libxrandr)
       ("libxrender" ,libxrender)
       ("libxslt" ,libxslt)
       ("libxtst" ,libxtst)
       ("mesa" ,mesa)
       ("minizip" ,minizip)
       ("nss" ,nss)
       ("opus" ,opus)
       ("pciutils" ,pciutils)
       ("protobuf" ,protobuf)
       ("pulseaudio" ,pulseaudio)
       ("qtbase" ,qtbase)
       ("qtdeclarative" ,qtdeclarative)
       ("qtmultimedia" ,qtmultimedia)
       ("qtwebchannel" ,qtwebchannel)
       ("re2" ,re2)
       ("snappy" ,snappy)
       ("udev" ,eudev)
       ("valgrind" ,valgrind)
       ("vulkan-headers" ,vulkan-headers)
       ("xcb-util" ,xcb-util)))
    (arguments
     (substitute-keyword-arguments (package-arguments qtsvg)
       ((#:phases phases)
        `(modify-phases ,phases
           (add-after 'unpack 'fix-build-with-newer-re2
             (lambda _
               ;; Adjust for API change in re2, taken from
               ;; https://chromium-review.googlesource.com/c/chromium/src/+/2145261
               (substitute* "src/3rdparty/chromium/components/autofill/core\
/browser/address_rewriter.cc"
               (("options\\.set_utf8\\(true\\)")
                "options.set_encoding(RE2::Options::EncodingUTF8)"))
               #t))
           (add-after 'unpack 'patch-ninja-version-check
             (lambda _
               ;; The build system assumes the system Ninja is too old because
               ;; it only checks for versions 1.7 through 1.9.  We have 1.10.
               (substitute* "configure.pri"
                 (("1\\.\\[7-9\\]\\.\\*")
                  "1.([7-9]|1[0-9]).*"))
               #t))
           (add-before 'configure 'substitute-source
             (lambda* (#:key inputs outputs #:allow-other-keys)
               (let ((out (assoc-ref outputs "out"))
                     (nss (assoc-ref inputs "nss"))
                     (udev (assoc-ref inputs "udev")))
                 ;; Qtwebengine is not installed into the same prefix as
                 ;; qtbase.  Some qtbase QTLibraryInfo constants will not
                 ;; work.  Replace with the full path to the qtwebengine
                 ;; translations and locales in the store.
                 (substitute* "src/core/web_engine_library_info.cpp"
                   (("QLibraryInfo::location\\(QLibraryInfo::TranslationsPath\\)")
                    (string-append "QLatin1String(\"" out "/share/qt5/translations\")"))
                   (("QLibraryInfo::location\\(QLibraryInfo::DataPath\\)")
                    (string-append "QLatin1String(\"" out "/share/qt5\")")))
                 ;; Substitute full dynamic library path for nss.
                 (substitute* "src/3rdparty/chromium/crypto/nss_util.cc"
                   (("libnssckbi.so")
                    (string-append nss "/lib/nss/libnssckbi.so")))
                 ;; Substitute full dynamic library path for udev.
                 (substitute* "src/3rdparty/chromium/device/udev_linux/udev1_loader.cc"
                   (("libudev.so.1")
                    (string-append udev "/lib/libudev.so.1")))
                 #t)))
           (add-before 'configure 'set-env
             (lambda _
               ;; Avoids potential race conditions.
               (setenv "PYTHONDONTWRITEBYTECODE" "1")
               (setenv "NINJAFLAGS"
                       (string-append "-k1" ;less verbose build output
                                      ;; Respect the '--cores' option of 'guix build'.
                                      " -j" (number->string (parallel-job-count))))
               #t))
           (replace 'configure
             (lambda _
               ;; Valid QT_BUILD_PARTS variables are:
               ;; libs tools tests examples demos docs translations
               (invoke "qmake" "QT_BUILD_PARTS = libs tools" "--"
                       "--webengine-printing-and-pdf=no"
                       "--webengine-ffmpeg=system"
                       "--webengine-icu=system"
                       "--webengine-pepper-plugins=no")))))
       ;; Tests are disabled due to "Could not find QtWebEngineProcess error"
       ;; It's possible this can be fixed by setting QTWEBENGINEPROCESS_PATH
       ;; before running tests.
       ((#:tests? _ #f) #f)))
    (native-search-paths
     (list (search-path-specification
            (file-type 'regular)
            (separator #f)
            (variable "QTWEBENGINEPROCESS_PATH")
            (files '("lib/qt5/libexec/QtWebEngineProcess")))))
    (home-page "https://wiki.qt.io/QtWebEngine")
    (synopsis "Qt WebEngine module")
    (description "The Qt5WebEngine module provides support for web applications
using the Chromium browser project.  The Chromium source code has Google services
and binaries removed, and adds modular support for using system libraries.")
    (license license:lgpl2.1+)))

(define-public python-sip
  (package
    (name "python-sip")
    (version "4.19.22")
    (source
      (origin
        (method url-fetch)
        (uri (string-append "https://www.riverbankcomputing.com/static/"
                            "Downloads/sip/" version "/sip-" version ".tar.gz"))
        (sha256
         (base32
          "0idywc326l8v1m3maprg1aq2gph67mmnnsskvlwfx8n19s16idz1"))))
    (build-system gnu-build-system)
    (native-inputs
     `(("python" ,python-wrapper)))
    (arguments
     `(#:tests? #f ; no check target
       #:imported-modules ((guix build python-build-system)
                           ,@%gnu-build-system-modules)
       #:modules ((srfi srfi-1)
                  ((guix build python-build-system) #:select (python-version))
                  ,@%gnu-build-system-modules)
       #:phases
       (modify-phases %standard-phases
         (replace 'configure
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (bin (string-append out "/bin"))
                    (include (string-append out "/include"))
                    (python (assoc-ref inputs "python"))
                    (lib (string-append out "/lib/python"
                                        (python-version python)
                                        "/site-packages")))
               (invoke "python" "configure.py"
                       "--bindir" bin
                       "--destdir" lib
                       "--incdir" include)))))))
    (home-page "https://www.riverbankcomputing.com/software/sip/intro")
    (synopsis "Python binding creator for C and C++ libraries")
    (description
     "SIP is a tool to create Python bindings for C and C++ libraries.  It
was originally developed to create PyQt, the Python bindings for the Qt
toolkit, but can be used to create bindings for any C or C++ library.

SIP comprises a code generator and a Python module.  The code generator
processes a set of specification files and generates C or C++ code, which
is then compiled to create the bindings extension module.  The SIP Python
module provides support functions to the automatically generated code.")
    ;; There is a choice between a python like license, gpl2 and gpl3.
    ;; For compatibility with pyqt, we need gpl3.
    (license license:gpl3)))

(define-public python2-sip
  (package (inherit python-sip)
    (name "python2-sip")
    (native-inputs
     `(("python" ,python-2)))))

(define-public python-pyqt
  (package
    (name "python-pyqt")
    (version "5.14.2")
    (source
      (origin
        (method url-fetch)
        ;; PyPI is the canonical distribution point of PyQt.  Older
        ;; releases are available from the web site.
        (uri (list (pypi-uri "PyQt5" version)
                   (string-append "https://www.riverbankcomputing.com/static/"
                                  "Downloads/PyQt5/" version "/PyQt5-"
                                  version ".tar.gz")))
        (file-name (string-append "PyQt5-"version ".tar.gz"))
        (sha256
         (base32
          "1c4y4qi1l540gd125ikj0al00k5pg65kmqaixcfbzslrsrphq8xx"))
       (patches (search-patches "pyqt-configure.patch"
                                "pyqt-public-sip.patch"))))
    (build-system gnu-build-system)
    (native-inputs
     `(("qtbase" ,qtbase))) ; for qmake
    (propagated-inputs
     `(("python-sip" ,python-sip)))
    (inputs
     `(("python" ,python-wrapper)
       ("qtbase" ,qtbase)
       ("qtconnectivity" ,qtconnectivity)
       ("qtdeclarative" ,qtdeclarative)
       ("qtlocation" ,qtlocation)
       ("qtmultimedia" ,qtmultimedia)
       ("qtsensors" ,qtsensors)
       ("qtserialport" ,qtserialport)
       ("qtsvg" ,qtsvg)
       ("qttools" ,qttools)
       ("qtwebchannel" ,qtwebchannel)
       ("qtwebkit" ,qtwebkit)
       ("qtwebsockets" ,qtwebsockets)
       ("qtx11extras" ,qtx11extras)
       ("qtxmlpatterns" ,qtxmlpatterns)))
    (arguments
     `(#:modules ((srfi srfi-1)
                  ((guix build python-build-system) #:select (python-version))
                  ,@%gnu-build-system-modules)
       #:imported-modules ((guix build python-build-system)
                           ,@%gnu-build-system-modules)
       #:phases
       (modify-phases %standard-phases
         ;; When building python-pyqtwebengine, <qprinter.h> can not be
         ;; included.  Here we substitute the full path to the header in the
         ;; store.
         (add-before 'configure 'substitute-source
           (lambda* (#:key inputs  #:allow-other-keys)
             (let* ((qtbase (assoc-ref inputs "qtbase"))
                    (qtprinter.h (string-append "\"" qtbase "/include/qt5/QtPrintSupport/qprinter.h\"")))
               (substitute* "sip/QtPrintSupport/qprinter.sip"
                 (("<qprinter.h>")
                  qtprinter.h))
               #t)))
         (replace 'configure
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (bin (string-append out "/bin"))
                    (sip (string-append out "/share/sip"))
                    (plugins (string-append out "/lib/qt5/plugins"))
                    (designer (string-append plugins "/designer"))
                    (qml (string-append plugins "/PyQt5"))
                    (python (assoc-ref inputs "python"))
                    (lib (string-append out "/lib/python"
                                        (python-version python)
                                        "/site-packages"))
                    (stubs (string-append lib "/PyQt5")))
               (invoke "python" "configure.py"
                       "--confirm-license"
                       "--bindir" bin
                       "--destdir" lib
                       "--designer-plugindir" designer
                       "--qml-plugindir" qml
                       ; Where to install the PEP 484 Type Hints stub
                       ; files. Without this the stubs are tried to be
                       ; installed into the python package's
                       ; site-package directory, which is read-only.
                       "--stubsdir" stubs
                       "--sipdir" sip)))))))
    (home-page "https://www.riverbankcomputing.com/software/pyqt/intro")
    (synopsis "Python bindings for Qt")
    (description
     "PyQt is a set of Python v2 and v3 bindings for the Qt application
framework.  The bindings are implemented as a set of Python modules and
contain over 620 classes.")
    (license license:gpl3)))

(define-public python-pyqtwebengine
  (package
    (name "python-pyqtwebengine")
    (version "5.14.0")
    (source
     (origin
       (method url-fetch)
       ;; The newest releases are only available on PyPI.  Older ones
       ;; are mirrored at the upstream home page.
       (uri (list (pypi-uri "PyQtWebEngine" version)
                  (string-append "https://www.riverbankcomputing.com/static"
                                 "/Downloads/PyQtWebEngine/" version
                                 "/PyQtWebEngine-" version ".tar.gz")))
       (sha256
        (base32
         "14hw49akb35n9pgiw564x8ykmsifihn9p2ax2x4zmywb3w2ra5g1"))))
    (build-system gnu-build-system)
    (native-inputs
     `(("python" ,python)
       ("python-sip" ,python-sip)
       ;; qtbase is required for qmake
       ("qtbase" ,qtbase)))
    (inputs
     `(("python" ,python-wrapper)
       ("python-sip" ,python-sip)
       ("python-pyqt" ,python-pyqt)
       ("qtbase" ,qtbase)
       ("qtsvg" ,qtsvg)
       ("qtdeclarative" ,qtdeclarative)
       ("qtwebchannel" ,qtwebchannel)
       ("qtwebengine" ,qtwebengine)))
    (arguments
     `(#:modules ((srfi srfi-1)
                  ((guix build python-build-system) #:select (python-version))
                  ,@%gnu-build-system-modules)
       #:imported-modules ((guix build python-build-system)
                           ,@%gnu-build-system-modules)
       #:phases
       (modify-phases %standard-phases
         (replace 'configure
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (sipdir (string-append out "/share/sip"))
                    (pyqt-sipdir (string-append
                                  (assoc-ref inputs "python-pyqt") "/share/sip"))
                    (python (assoc-ref inputs "python"))
                    (lib (string-append out "/lib/python"
                                        (python-version python)
                                        "/site-packages/PyQt5"))
                    (stubs (string-append lib "/PyQt5")))

               (mkdir-p sipdir)
               (invoke "python" "configure.py"
                       "-w"
                       "--no-dist-info"
                       "--destdir" lib
                       "--no-qsci-api"
                       "--stubsdir" stubs
                       "--sipdir" sipdir
                       "--pyqt-sipdir" pyqt-sipdir))))
         ;; Because this has a different prefix than python-pyqt then we need
         ;; to make this a namespace of it's own
         (add-after 'install 'make-namespace
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((__init__.py (string-append
                                  (assoc-ref outputs "out")
                                  "/lib/python"
                                  (python-version (assoc-ref inputs "python"))
                                  "/site-packages/PyQt5/__init__.py")))
               (with-output-to-file __init__.py
                 (lambda _ (display "
from pkgutil import extend_path
__path__ = extend_path(__path__, __name__)
")))
               #t))))))
    (home-page "https://www.riverbankcomputing.com/software/pyqtwebengine/intro")
    (synopsis "Python bindings for QtWebEngine")
    (description
     "PyQtWebEngine is a set of Python bindings for The Qt Company's Qt
WebEngine libraries.  The bindings sit on top of PyQt5 and are implemented as a
set of three modules.  Prior to v5.12 these bindings were part of PyQt
itself.")
    (license license:gpl3)))

;; XXX: This is useful because qtwebkit does not build reliably at this time.
;; Ultimately, it would be nicer to have a more modular set of python-pyqt-*
;; packages that could be used together.
(define-public python-pyqt-without-qtwebkit
  (package (inherit python-pyqt)
    (name "python-pyqt-without-qtwebkit")
    (inputs
     (alist-delete "qtwebkit" (package-inputs python-pyqt)))))

(define-public python2-pyqt
  (package (inherit python-pyqt)
    (name "python2-pyqt")
    (propagated-inputs
     `(("python-enum34" ,python2-enum34)
       ("python-sip" ,python2-sip)))
    (native-inputs
     `(("python-sip" ,python2-sip)
       ("qtbase" ,qtbase)))
    (inputs
     `(("python" ,python-2)
       ("python2-enum34" ,python2-enum34)
       ,@(alist-delete "python" (package-inputs python-pyqt))))))

(define-public python2-pyqtwebengine
  (package/inherit
   python-pyqtwebengine
   (name "python2-pyqtwebengine")
   (native-inputs
    `(("python" ,python-2)
      ("python-sip" ,python2-sip)
      ;; qtbase is required for qmake
      ("qtbase" ,qtbase)))
   (inputs
    `(("python" ,python-2)
      ("python-sip" ,python2-sip)
      ("python-pyqt" ,python2-pyqt)
      ("qtbase" ,qtbase)
      ("qtsvg" ,qtsvg)
      ("qtdeclarative" ,qtdeclarative)
      ("qtwebchannel" ,qtwebchannel)
      ("qtwebengine" ,qtwebengine)))))

(define-public python2-pyqt-4
  (package (inherit python-pyqt)
    (name "python2-pyqt")
    (version "4.12")
    (source
      (origin
        (method url-fetch)
        (uri
          (string-append "mirror://sourceforge/pyqt/PyQt4/"
                         "PyQt-" version "/PyQt4_gpl_x11-"
                         version ".tar.gz"))
        (sha256
         (base32
          "1nw8r88a5g2d550yvklawlvns8gd5slw53yy688kxnsa65aln79w"))))
    (native-inputs
     `(("python-sip" ,python2-sip)
       ("qt" ,qt-4)))
    (inputs `(("python" ,python-2)))
    (arguments
     `(#:tests? #f ; no check target
       #:modules ((srfi srfi-1)
                  ,@%gnu-build-system-modules)
       #:phases
       (modify-phases %standard-phases
         (replace 'configure
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (bin (string-append out "/bin"))
                    (sip (string-append out "/share/sip"))
                    (python (assoc-ref inputs "python"))
                    (python-version
                      (last (string-split python #\-)))
                    (python-major+minor
                      (string-join
                        (take (string-split python-version #\.) 2)
                        "."))
                    (lib (string-append out "/lib/python"
                                        python-major+minor
                                        "/site-packages")))
               (invoke "python" "configure.py"
                       "--confirm-license"
                       "--bindir" bin
                       "--destdir" lib
                       "--sipdir" sip)))))))
    (license (list license:gpl2 license:gpl3)))) ; choice of either license

(define-public qscintilla
  (package
    (name "qscintilla")
    (version "2.10.8")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://sourceforge/pyqt/QScintilla2/"
                                  "QScintilla-" version "/QScintilla_gpl-"
                                  version ".tar.gz"))
              (sha256
               (base32
                "1swjr786w04r514pry9pn32ivza4il1cg35s60qy39cwc175pka6"))))
    (build-system gnu-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (replace 'configure
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               (chdir "Qt4Qt5")
               (substitute* "qscintilla.pro"
                 (("\\$\\$\\[QT_INSTALL_LIBS\\]")
                  (string-append out "/lib"))
                 (("\\$\\$\\[QT_INSTALL_HEADERS\\]")
                  (string-append out "/include"))
                 (("\\$\\$\\[QT_INSTALL_TRANSLATIONS\\]")
                  (string-append out "/translations"))
                 (("\\$\\$\\[QT_INSTALL_DATA\\]")
                  (string-append out "/lib/qt$${QT_MAJOR_VERSION}"))
                 (("\\$\\$\\[QT_HOST_DATA\\]")
                 (string-append out "/lib/qt$${QT_MAJOR_VERSION}")))
               (invoke "qmake")))))))
    (native-inputs `(("qtbase" ,qtbase)))
    (home-page "https://www.riverbankcomputing.co.uk/software/qscintilla/intro")
    (synopsis "Qt port of the Scintilla C++ editor control")
    (description "QScintilla is a port to Qt of Neil Hodgson's Scintilla C++
editor control.  QScintilla includes features especially useful when editing
and debugging source code.  These include support for syntax styling, error
indicators, code completion and call tips.")
    (license license:gpl3+)))

(define-public python-qscintilla
  (package (inherit qscintilla)
    (name "python-qscintilla")
    (arguments
     `(#:configure-flags
       (list "--pyqt=PyQt5"
             (string-append "--pyqt-sipdir="
                            (assoc-ref %build-inputs "python-pyqt")
                            "/share/sip")
             (string-append "--qsci-incdir="
                            (assoc-ref %build-inputs "qscintilla")
                            "/include")
             (string-append "--qsci-libdir="
                            (assoc-ref %build-inputs "qscintilla")
                            "/lib"))
       #:phases
       (modify-phases %standard-phases
         (replace 'configure
           (lambda* (#:key inputs outputs configure-flags #:allow-other-keys)
             (let ((out    (assoc-ref outputs "out"))
                   (python (assoc-ref inputs "python")))
               (chdir "Python")
               (apply invoke "python3" "configure.py"
                      configure-flags)
               ;; Install to the right directory
               (substitute* '("Makefile"
                              "Qsci/Makefile")
                 (("\\$\\(INSTALL_ROOT\\)/gnu/store/[^/]+") out)
                 (((string-append python "/lib"))
                  (string-append out "/lib")))
               ;; And fix the installed.txt file
               (substitute* "installed.txt"
                 (("/gnu/store/[^/]+") out)))
             #t)))))
    (inputs
     `(("qscintilla" ,qscintilla)
       ("python" ,python)
       ("python-pyqt" ,python-pyqt)))
    (description "QScintilla is a port to Qt of Neil Hodgson's Scintilla C++
editor control.  QScintilla includes features especially useful when editing
and debugging source code.  These include support for syntax styling, error
indicators, code completion and call tips.

This package provides the Python bindings.")))

;; PyQt only looks for modules in its own directory.  It ignores environment
;; variables such as PYTHONPATH, so we need to build a union package to make
;; it work.
(define-public python-pyqt+qscintilla
  (package (inherit python-pyqt)
    (name "python-pyqt+qscintilla")
    (source #f)
    (build-system trivial-build-system)
    (arguments
     '(#:modules ((guix build union))
       #:builder (begin
                   (use-modules (ice-9 match)
                                (guix build union))
                   (match %build-inputs
                     (((names . directories) ...)
                      (union-build (assoc-ref %outputs "out")
                                   directories)
                      #t)))))
    (inputs
     `(("python-pyqt" ,python-pyqt)
       ("python-qscintilla" ,python-qscintilla)))
    (synopsis "Union of PyQt and the Qscintilla extension")
    (description
     "This package contains the union of PyQt and the Qscintilla extension.")))

(define-public qtkeychain
  (package
    (name "qtkeychain")
    (version "0.9.1")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/frankosterfeld/qtkeychain/")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
         (base32
          "0h4wgngn2yl35hapbjs24amkjfbzsvnna4ixfhn87snjnq5lmjbc"))))
    (build-system cmake-build-system)
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("qttools" ,qttools)))
    (inputs
     `(("qtbase" ,qtbase)))
    (arguments
     `(#:tests? #f ; No tests included
       #:phases
       (modify-phases %standard-phases
         (add-before 'configure 'set-qt-trans-dir
           (lambda _
             (substitute* "CMakeLists.txt"
              (("\\$\\{qt_translations_dir\\}")
               "${CMAKE_INSTALL_PREFIX}/share/qt5/translations"))
             #t)))))
    (home-page "https://github.com/frankosterfeld/qtkeychain")
    (synopsis "Qt API to store passwords")
    (description
      "QtKeychain is a Qt library to store passwords and other secret data
securely.  It will not store any data unencrypted unless explicitly requested.")
    (license license:bsd-3)))

(define-public qwt
  (package
    (name "qwt")
    (version "6.1.5")
    (source
      (origin
        (method url-fetch)
        (uri
         (string-append "mirror://sourceforge/qwt/qwt/"
                        version "/qwt-" version ".tar.bz2"))
        (sha256
         (base32 "0hf0mpca248xlqn7xnzkfj8drf19gdyg5syzklvq8pibxiixwxj0"))))
  (build-system gnu-build-system)
  (inputs
   `(("qtbase" ,qtbase)
     ("qtsvg" ,qtsvg)
     ("qttools" ,qttools)))
  (arguments
   `(#:phases
     (modify-phases %standard-phases
       (replace 'configure
         (lambda* (#:key outputs #:allow-other-keys)
           (let* ((out (assoc-ref outputs "out"))
                  (docdir (string-append out "/share/doc/qwt"))
                  (incdir (string-append out "/include/qwt"))
                  (pluginsdir (string-append out "/lib/qt5/plugins/designer"))
                  (featuresdir (string-append out "/lib/qt5/mkspecs/features")))
             (substitute* '("qwtconfig.pri")
               (("^(\\s*QWT_INSTALL_PREFIX)\\s*=.*" _ x)
                (format #f "~a = ~a\n" x out))
               (("^(QWT_INSTALL_DOCS)\\s*=.*" _ x)
                (format #f "~a = ~a\n" x docdir))
               (("^(QWT_INSTALL_HEADERS)\\s*=.*" _ x)
                (format #f "~a = ~a\n" x incdir))
               (("^(QWT_INSTALL_PLUGINS)\\s*=.*" _ x)
                (format #f "~a = ~a\n" x pluginsdir))
               (("^(QWT_INSTALL_FEATURES)\\s*=.*" _ x)
                (format #f "~a = ~a\n" x featuresdir)))
             (substitute* '("doc/doc.pro")
               ;; We'll install them in the 'install-man-pages' phase.
               (("^unix:doc\\.files.*") ""))
             (invoke "qmake"))))
       (add-after 'install 'install-man-pages
         (lambda* (#:key outputs #:allow-other-keys)
           (let* ((out (assoc-ref outputs "out"))
                  (man (string-append out "/share/man")))
             ;; Remove some incomplete manual pages.
             (for-each delete-file (find-files "doc/man/man3" "^_tmp.*"))
             (mkdir-p man)
             (copy-recursively "doc/man" man)
             #t))))))
  (home-page "http://qwt.sourceforge.net")
  (synopsis "Qt widgets for plots, scales, dials and other technical software
GUI components")
  (description
   "The Qwt library contains widgets and components which are primarily useful
for technical and scientific purposes.  It includes a 2-D plotting widget,
different kinds of sliders, and much more.")
  (license
   (list
    ;; The Qwt license is LGPL2.1 with some exceptions.
    (license:non-copyleft "http://qwt.sourceforge.net/qwtlicense.html")
    ;; textengines/mathml/qwt_mml_document.{cpp,h} is dual LGPL2.1/GPL3 (either).
    license:lgpl2.1 license:gpl3))))

(define-public qtwebkit
  (package
    (name "qtwebkit")
    (version "5.212.0-alpha4")
    (source
      (origin
        (method url-fetch)
        (uri (string-append "https://github.com/annulen/webkit/releases/download/"
                            "qtwebkit-" version "/qtwebkit-" version ".tar.xz"))
        (sha256
         (base32
          "1rm9sjkabxna67dl7myx9d9vpdyfxfdhrk9w7b94srkkjbd2d8cw"))
        (patches (search-patches "qtwebkit-pbutils-include.patch"))))
    (build-system cmake-build-system)
    (native-inputs
     `(("perl" ,perl)
       ("python" ,python)
       ("ruby" ,ruby)
       ("bison" ,bison)
       ("flex" ,flex)
       ("gperf" ,gperf)
       ("pkg-config" ,pkg-config)))
    (inputs
     `(("icu" ,icu4c)
       ("glib" ,glib)
       ("gst-plugins-base" ,gst-plugins-base)
       ("libjpeg" ,libjpeg-turbo)
       ("libpng" ,libpng)
       ("libwebp" ,libwebp)
       ("sqlite" ,sqlite)
       ("fontconfig" ,fontconfig)
       ("libxrender" ,libxrender)
       ("qtbase" ,qtbase)
       ("qtdeclarative" ,qtdeclarative)
       ("qtlocation" ,qtlocation)
       ("qtmultimedia" ,qtmultimedia)
       ("qtsensors" ,qtsensors)
       ("qtwebchannel" ,qtwebchannel)
       ("libxml2" ,libxml2)
       ("libxslt" ,libxslt)
       ("libx11" ,libx11)
       ("libxcomposite" ,libxcomposite)))
    (arguments
     `(#:tests? #f ; no apparent tests; it might be necessary to set
                   ; ENABLE_API_TESTS, see CMakeLists.txt

       ;; Parallel builds fail due to a race condition:
       ;; <https://bugs.gnu.org/34062>.
       #:parallel-build? #f

       #:configure-flags (list ;"-DENABLE_API_TESTS=TRUE"
                               "-DPORT=Qt"
                               "-DUSE_LIBHYPHEN=OFF"
                               "-DUSE_SYSTEM_MALLOC=ON"
                               ;; XXX: relative dir installs to build dir?
                               (string-append "-DECM_MKSPECS_INSTALL_DIR="
                                              %output "/lib/qt5/mkspecs/modules")
                               ;; Sacrifice a little speed in order to link
                               ;; libraries and test executables in a
                               ;; reasonable amount of memory.
                               "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,--no-keep-memory"
                               "-DCMAKE_EXE_LINKER_FLAGS=-Wl,--no-keep-memory")))
    (home-page "https://www.webkit.org")
    (synopsis "Web browser engine and classes to render and interact with web
content")
    (description "QtWebKit provides a Web browser engine that makes it easy to
embed content from the World Wide Web into your Qt application.  At the same
time Web content can be enhanced with native controls.")
    ;; Building QtWebKit takes around 13 hours on an AArch64 machine.  Give some
    ;; room for slower or busy hardware.
    (properties '((timeout . 64800)))   ;18 hours

    ;; XXX: This consumes too much RAM to successfully build on AArch64 (e.g.,
    ;; SoftIron OverDrive with 8 GiB of RAM), so instead of wasting resources,
    ;; disable it on non-Intel platforms.
    (supported-systems '("x86_64-linux" "i686-linux"))

    (license license:lgpl2.1+)))

(define-public dotherside
  (package
    (name "dotherside")
    (version "0.6.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
              (url "https://github.com/filcuc/DOtherSide")
              (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "09fz6v8rp28997f235yaifj8p4vvsyv45knc1iivgdvx7msgcd0m"))))
    (build-system cmake-build-system)
    (native-inputs
     `(("qttools" ,qttools)))
    (inputs
     `(("qtbase" ,qtbase)
       ("qtdeclarative" ,qtdeclarative)))
    (home-page "https://filcuc.github.io/DOtherSide/index.html")
    (synopsis "C language library for creating bindings for the Qt QML language")
    (description
     "DOtherSide is a C language library for creating bindings for the
QT QML language.  The following features are implementable from
a binding language:
@itemize
@item Creating custom QObject
@item Creating custom QAbstractListModels
@item Creating custom properties, signals and slots
@item Creating from QML QObject defined in the binded language
@item Creating from Singleton QML QObject defined in the binded language
@end itemize\n")
    (license license:lgpl3)))                    ;version 3 only (+ exception)

;; There have been no public releases yet.
(define-public qtcolorwidgets
  (let ((commit "a95f72e935fe9e046061a1d1c3930cbfbcb533e0")
        (revision "1"))
    (package
      (name "qtcolorwidgets")
      (version (git-version "0" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://gitlab.com/mattia.basaglia/Qt-Color-Widgets")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "0dkiwlqh2gwhlp78c1fmchj3shl4p9inspcl96ya5aa8mn6kydy8"))))
      (build-system cmake-build-system)
      (arguments `(#:tests? #f)) ; There are no tests
      (native-inputs
       `(("qttools" ,qttools)))
      (inputs
       `(("qtbase" ,qtbase)))
      (home-page "https://gitlab.com/mattia.basaglia/Qt-Color-Widgets")
      (synopsis "Color management widgets")
      (description "QtColorWidgets provides a Qt color dialog that is more
user-friendly than the default @code{QColorDialog} and several other
color-related widgets.")
      ;; Includes a license exception for combining with GPL2 code.
      (license license:lgpl3+))))

(define-public python-shiboken-2
  (package
    (name "python-shiboken-2")
    (version "5.14.2.3")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://download.qt.io/official_releases"
                                  "/QtForPython/pyside2/PySide2-" version
                                  "-src/pyside-setup-opensource-src-"
                                  version ".tar.xz"))
              (sha256
               (base32
                "08lhqm0n3fjqpblcx9rshsp8g3bvf7yzbai5q99bly2wa04y6b83"))))
    (build-system cmake-build-system)
    (inputs
     `(("clang-toolchain" ,clang-toolchain)
       ("libxml2" ,libxml2)
       ("libxslt" ,libxslt)
       ("python-wrapper" ,python-wrapper)
       ("qtbase" ,qtbase)
       ("qtxmlpatterns" ,qtxmlpatterns)))
    (arguments
     `(#:tests? #f
       ;; FIXME: Building tests fails
       #:configure-flags '("-DBUILD_TESTS=off")
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'use-shiboken-dir-only
           (lambda _ (chdir "sources/shiboken2") #t))
         (add-before 'configure 'make-files-writable-and-update-timestamps
           (lambda _
             ;; The build scripts need to modify some files in
             ;; the read-only source directory, and also attempts
             ;; to create Zip files which fails because the Zip
             ;; format does not support timestamps before 1980.
             (let ((circa-1980 (* 10 366 24 60 60)))
               (for-each (lambda (file)
                           (make-file-writable file)
                           (utime file circa-1980 circa-1980))
                         (find-files ".")))
             #t))
         (add-before 'configure 'set-build-env
           (lambda* (#:key inputs #:allow-other-keys)
             (let ((llvm (assoc-ref inputs "clang-toolchain")))
               (setenv "CLANG_INSTALL_DIR" llvm)
               #t))))))
    (home-page "https://wiki.qt.io/Qt_for_Python")
    (synopsis
     "Shiboken generates bindings for C++ libraries using CPython source code")
    (description
     "Shiboken generates bindings for C++ libraries using CPython source code")
    (license
     (list
      ;; The main code is GPL3 or LGPL3.
      ;; Examples are BSD-3.
      license:gpl3
      license:lgpl3
      license:bsd-3))))

(define-public python-pyside-2
  (package
    (name "python-pyside-2")
    (version (package-version python-shiboken-2))
    (source (package-source python-shiboken-2))
    (build-system cmake-build-system)
    (inputs
     `(("libxml2" ,libxml2)
       ("libxslt" ,libxslt)
       ("clang-toolchain" ,clang-toolchain)
       ("qtbase" ,qtbase)
       ("qtdatavis3d" ,qtdatavis3d)
       ("qtlocation" ,qtlocation)
       ("qtmultimedia" ,qtmultimedia)
       ("qtquickcontrols" ,qtquickcontrols)
       ("qtscript" ,qtscript)
       ("qtscxml" ,qtscxml)
       ("qtsensors" ,qtsensors)
       ("qtspeech" ,qtspeech)
       ("qtsvg" ,qtsvg)
       ("qtwebchannel" ,qtwebchannel)
       ("qtwebsockets" ,qtwebsockets)
       ("qtx11extras" ,qtx11extras)
       ("qtxmlpatterns" ,qtxmlpatterns)))
    (native-inputs
     `(("cmake" ,cmake-minimal)
       ("python-shiboken-2" ,python-shiboken-2)
       ("python" ,python-wrapper)
       ("qttools" ,qttools)
       ("which" ,which)))
    (arguments
     `(#:tests? #f
       ;; FIXME: Building tests fail.
       #:configure-flags
       (list "-DBUILD_TESTS=FALSE"
             (string-append "-DPYTHON_EXECUTABLE="
                            (assoc-ref %build-inputs "python")
                            "/bin/python"))
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'go-to-source-dir
           (lambda _ (chdir "sources/pyside2") #t))
         (add-before 'configure 'set-clang-dir
           (lambda* (#:key inputs #:allow-other-keys)
             (let ((clang (assoc-ref inputs "clang-toolchain")))
               (setenv "CLANG_INSTALL_DIR" clang)
               #t))))))
    (home-page "https://wiki.qt.io/Qt_for_Python")
    (synopsis
     "The Qt for Python product enables the use of Qt5 APIs in Python applications")
    (description
     "The Qt for Python product enables the use of Qt5 APIs in Python
applications.  It lets Python developers utilize the full potential of Qt,
using the PySide2 module.  The PySide2 module provides access to the
individual Qt modules such as QtCore, QtGui,and so on.  Qt for Python also
comes with the Shiboken2 CPython binding code generator, which can be used to
generate Python bindings for your C or C++ code.")
    (license (list
              license:lgpl3
              ;;They state that:
              ;; this file may be used under the terms of the GNU General
              ;; Public License version 2.0 or (at your option) the GNU
              ;; General Public license version 3 or any later version
              ;; approved by the KDE Free Qt Foundation.
              ;; Thus, it is currently v2 or v3, but no "+".
              license:gpl3
              license:gpl2))))

(define-public python-pyside-2-tools
  (package
    (name "python-pyside-2-tools")
    (version (package-version python-shiboken-2))
    (source (package-source python-shiboken-2))
    (build-system cmake-build-system)
    (inputs
     `(("python-pyside-2" ,python-pyside-2)
       ("python-shiboken-2" ,python-shiboken-2)
       ("qtbase" ,qtbase/next)))
    (native-inputs
     `(("python" ,python-wrapper)))
    (arguments
     `(#:tests? #f
       #:configure-flags
       (list "-DBUILD_TESTS=off"
             (string-append "-DPYTHON_EXECUTABLE="
                            (assoc-ref %build-inputs "python")
                            "/bin/python"))
       #:phases (modify-phases %standard-phases
                  (add-after 'unpack 'go-to-source-dir
                    (lambda _ (chdir "sources/pyside2-tools") #t)))))
    (home-page "https://wiki.qt.io/Qt_for_Python")
    (synopsis
     "Contains command line tools for PySide2")
    (description
     "Contains lupdate, rcc and uic tools for PySide2")
    (license license:gpl2)))

(define-public libqglviewer
  (package
    (name "libqglviewer")
    (version "2.7.2")
    (source (origin
              (method url-fetch)
              (uri
               (string-append "http://libqglviewer.com/src/libQGLViewer-"
                              version ".tar.gz"))
              (sha256
               (base32
                "023w7da1fyn2z69nbkp2rndiv886zahmc5cmira79zswxjfpklp2"))))
    (build-system gnu-build-system)
    (arguments
     '(#:tests? #f                      ; no check target
       #:make-flags
       (list (string-append "PREFIX="
                            (assoc-ref %outputs "out")))
       #:phases
       (modify-phases %standard-phases
         (replace 'configure
           (lambda* (#:key make-flags #:allow-other-keys)
             (apply invoke (cons "qmake" make-flags)))))))
    (native-inputs
     `(("qtbase" ,qtbase)
       ("qttools" ,qttools)))
    (inputs
     `(("glu" ,glu)))
    (home-page "http://libqglviewer.com")
    (synopsis "Qt-based C++ library for the creation of OpenGL 3D viewers")
    (description
     "@code{libQGLViewer} is a C++ library based on Qt that eases the creation
of OpenGL 3D viewers.

It provides some of the typical 3D viewer functionalities, such as the
possibility to move the camera using the mouse, which lacks in most of the
other APIs.  Other features include mouse manipulated frames, interpolated
keyFrames, object selection, stereo display, screenshot saving and much more.
It can be used by OpenGL beginners as well as to create complex applications,
being fully customizable and easy to extend.")
    ;; According to LICENSE, either version 2 or version 3 of the GNU GPL may
    ;; be used.
    (license (list license:gpl2 license:gpl3))))
