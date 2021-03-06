;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2015, 2016 Ludovic Courtès <ludo@gnu.org>
;;; Copyright © 2015 Tomáš Čech <sleep_walker@gnu.org>
;;; Copyright © 2016, 2019 Leo Famulari <leo@famulari.name>
;;; Copyright © 2016, 2017, 2019 Ricardo Wurmus <rekado@elephly.net>
;;; Copyright © 2016, 2018 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2016 Andreas Enge <andreas@enge.fr>
;;; Copyright © 2017 Manolis Fragkiskos Ragkousis <manolis837@gmail.com>
;;; Copyright © 2017, 2018 Ben Woodcroft <donttrustben@gmail.com>
;;; Copyright © 2017, 2018, 2019, 2020 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2018 Mathieu Othacehe <m.othacehe@gmail.com>
;;; Copyright © 2018 Alex Kost <alezost@gmail.com>
;;; Copyright © 2018 Kei Kebreau <kkebreau@posteo.net>
;;; Copyright © 2019, 2020 Mark H Weaver <mhw@netris.org>
;;; Copyright © 2019 Carlo Zancanaro <carlo@zancanaro.id.au>
;;; Copyright © 2019 Steve Sprang <scs@stevesprang.com>
;;; Copyright © 2019 John Soo <jsoo1@asu.edu>
;;; Copyright © 2019 Pierre Neidhardt <mail@ambrevar.xyz>
;;; Copyright © 2019, 2020 Marius Bakke <mbakke@fastmail.com>
;;; Copyright © 2019 Tanguy Le Carrour <tanguy@bioneland.org>
;;; Copyright © 2020 Jakub Kądziołka <kuba@kadziolka.net>
;;; Copyright © 2020 Nicolas Goaziou <mail@nicolasgoaziou.fr>
;;; Copyright © 2020 Raghav Gururajan <raghavgururajan@disroot.org>
;;; Copyright © 2020 Maxim Cournoyer <maxim.cournoyer@gmail.com>
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

(define-module (gnu packages graphics)
  #:use-module (gnu packages)
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages audio)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages bison)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages check)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages datastructures)
  #:use-module (gnu packages documentation)
  #:use-module (gnu packages flex)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages ghostscript)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages graphviz)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages haskell-xyz)
  #:use-module (gnu packages image)
  #:use-module (gnu packages imagemagick)
  #:use-module (gnu packages jemalloc)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages multiprecision)
  #:use-module (gnu packages pdf)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages photo)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages plotutils)
  #:use-module (gnu packages pth)
  #:use-module (gnu packages pulseaudio)  ; libsndfile, libsamplerate
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages readline)
  #:use-module (gnu packages sdl)
  #:use-module (gnu packages swig)
  #:use-module (gnu packages tbb)
  #:use-module (gnu packages video)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages xorg)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system python)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix hg-download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix utils))

(define-public fox
  (package
    (name "fox")
    (version "1.6.57")
    (source
     (origin
       (method url-fetch)
       (uri
        (string-append "https://fox-toolkit.org/ftp/fox-" version ".tar.gz"))
       (sha256
        (base32 "08w98m6wjadraw1pi13igzagly4b2nfa57kdqdnkjfhgkvg1bvv5"))))
    (build-system gnu-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'patch
           (lambda _
             (substitute* "configure"
               (("-I/usr/include/freetype2")
                (string-append "-I"
                               (string-append
                                (assoc-ref %build-inputs "freetype")
                                "/include/freetype2"))))
             #t)))))
    (native-inputs
     `(("doxygen" ,doxygen)))
    (inputs
     `(("bzip2" ,lbzip2)
       ("freetype" ,freetype)
       ("gl" ,mesa)
       ("glu" ,glu)
       ("jpeg" ,libjpeg-turbo)
       ("png" ,libpng)
       ("tiff" ,libtiff)
       ("x11" ,libx11)
       ("xcursor" ,libxcursor)
       ("xext" ,libxext)
       ("xfixes" ,libxfixes)
       ("xft" ,libxft)
       ("xinput" ,libxi)
       ("xrandr" ,libxrandr)
       ("xrender" ,libxrender)
       ("xshm" ,libxshmfence)
       ("zlib" ,zlib)))
    (synopsis "Widget Toolkit for building GUI")
    (description"FOX (Free Objects for X) is a C++ based Toolkit for developing
Graphical User Interfaces easily and effectively.   It offers a wide, and
growing, collection of Controls, and provides state of the art facilities such
as drag and drop, selection, as well as OpenGL widgets for 3D graphical
manipulation.  FOX also implements icons, images, and user-convenience features
such as status line help, and tooltips.  Tooltips may even be used for 3D
objects!")
    (home-page "http://www.fox-toolkit.org")
    (license license:lgpl2.1+)))

(define-public autotrace
  (let ((commit "travis-20190624.59")
        (version-base "0.40.0"))
    (package
      (name "autotrace")
      (version (string-append version-base "-"
                              (if (string-prefix? "travis-" commit)
                                  (string-drop commit 7)
                                  commit)))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/autotrace/autotrace")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "0mk4yavy42dj0pszr1ggnggpvmzs4ds46caa9wr55cqsypn7bq6s"))))
      (build-system gnu-build-system)
      (arguments
       `(#:phases (modify-phases %standard-phases
                    ;; See: https://github.com/autotrace/autotrace/issues/27.
                    (add-after 'unpack 'include-spline.h-header
                      (lambda _
                        (substitute* "Makefile.am"
                          ((".*src/types.h.*" all)
                           (string-append all "\t\tsrc/spline.h \\\n")))
                        #t))
                    ;; See: https://github.com/autotrace/autotrace/issues/26.
                    (replace 'check
                      (lambda _
                        (invoke "sh" "tests/runtests.sh"))))))
      (native-inputs
       `(("which" ,which)
         ("pkg-config" ,pkg-config)
         ("autoconf" ,autoconf)
         ("automake" ,automake)
         ("intltool" ,intltool)
         ("libtool" ,libtool)
         ("gettext" ,gettext-minimal)))
      (inputs
       `(("glib" ,glib)
         ("libjpeg" ,libjpeg-turbo)
         ("libpng" ,libpng)
         ("imagemagick" ,imagemagick)
         ("pstoedit" ,pstoedit)))
      (home-page "https://github.com/autotrace/autotrace")
      (synopsis "Bitmap to vector graphics converter")
      (description "AutoTrace is a utility for converting bitmap into vector
graphics.  It can trace outlines and midlines, effect color reduction or
despeckling and has support for many input and output formats.  It can be used
with the @command{autotrace} utility or as a C library, @code{libautotrace}.")
      (license (list license:gpl2+         ;for the utility itself
                     license:lgpl2.1+))))) ;for use as a library

(define-public blender
  (package
    (name "blender")
    (version "2.83.3")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://download.blender.org/source/"
                                  "blender-" version ".tar.xz"))
              (sha256
               (base32
                "18m27abp4j3xv48dr6ddr2mqcvx2vkjffr487z90059yv9k0yh2p"))))
    (build-system cmake-build-system)
    (arguments
      (let ((python-version (version-major+minor (package-version python))))
       `(;; Test files are very large and not included in the release tarball.
         #:tests? #f
         #:configure-flags
         (list "-DWITH_CODEC_FFMPEG=ON"
               "-DWITH_CODEC_SNDFILE=ON"
               "-DWITH_CYCLES=ON"
               "-DWITH_DOC_MANPAGE=ON"
               "-DWITH_FFTW3=ON"
               "-DWITH_IMAGE_OPENJPEG=ON"
               "-DWITH_INPUT_NDOF=ON"
               "-DWITH_INSTALL_PORTABLE=OFF"
               "-DWITH_JACK=ON"
               "-DWITH_MOD_OCEANSIM=ON"
               "-DWITH_OPENSUBDIV=ON"
               "-DWITH_PYTHON_INSTALL=OFF"
               (string-append "-DPYTHON_LIBRARY=python" ,python-version)
               (string-append "-DPYTHON_LIBPATH=" (assoc-ref %build-inputs "python")
                              "/lib")
               (string-append "-DPYTHON_INCLUDE_DIR=" (assoc-ref %build-inputs "python")
                              "/include/python" ,python-version)
               (string-append "-DPYTHON_VERSION=" ,python-version)
               (string-append "-DPYTHON_NUMPY_PATH="
                              (assoc-ref %build-inputs "python-numpy")
                              "/lib/python" ,python-version "/site-packages/"))
         #:phases
         (modify-phases %standard-phases
           ;; XXX This file doesn't exist in the Git sources but will probably
           ;; exist in the eventual 2.80 source tarball.
           (add-after 'unpack 'fix-broken-import
             (lambda _
               (substitute* "release/scripts/addons/io_scene_fbx/json2fbx.py"
                 (("import encode_bin") "from . import encode_bin"))
               #t))
           (add-after 'set-paths 'add-ilmbase-include-path
             (lambda* (#:key inputs #:allow-other-keys)
               ;; OpenEXR propagates ilmbase, but its include files do not appear
               ;; in the CPATH, so we need to add "$ilmbase/include/OpenEXR/" to
               ;; the CPATH to satisfy the dependency on "half.h".
               (setenv "CPATH"
                       (string-append (assoc-ref inputs "ilmbase")
                                      "/include/OpenEXR"
                                      ":" (or (getenv "CPATH") "")))
               #t))))))
    (inputs
     `(("boost" ,boost)
       ("jemalloc" ,jemalloc)
       ("libx11" ,libx11)
       ("libxi" ,libxi)
       ("libxrender" ,libxrender)
       ("openimageio" ,openimageio)
       ("openexr" ,openexr)
       ("opensubdiv" ,opensubdiv)
       ("ilmbase" ,ilmbase)
       ("openjpeg" ,openjpeg)
       ("libjpeg" ,libjpeg-turbo)
       ("libpng" ,libpng)
       ("libtiff" ,libtiff)
       ("ffmpeg" ,ffmpeg)
       ("fftw" ,fftw)
       ("jack" ,jack-1)
       ("libsndfile" ,libsndfile)
       ("freetype" ,freetype)
       ("glew" ,glew)
       ("openal" ,openal)
       ("python" ,python)
       ("python-numpy" ,python-numpy)
       ("tbb" ,tbb)
       ("zlib" ,zlib)))
    (home-page "https://blender.org/")
    (synopsis "3D graphics creation suite")
    (description
     "Blender is a 3D graphics creation suite.  It supports the entirety of
the 3D pipeline—modeling, rigging, animation, simulation, rendering,
compositing and motion tracking, even video editing and game creation.  The
application can be customized via its API for Python scripting.")
    (license license:gpl2+)))

(define-public blender-2.79
  (package
    (name "blender")
    (version "2.79b")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://download.blender.org/source/"
                                  "blender-" version ".tar.gz"))
              (sha256
               (base32
                "1g4kcdqmf67srzhi3hkdnr4z1ph4h9sza1pahz38mrj998q4r52c"))
              (patches (search-patches "blender-2.79-newer-ffmpeg.patch"
                                       "blender-2.79-oiio2.patch"
                                       ;; The following patches may be
                                       ;; needed when the default GCC is
                                       ;; updated:
                                       ;;   "blender-2.79-gcc8.patch"
                                       ;;   "blender-2.79-gcc9.patch"
                                       "blender-2.79-python-3.7-fix.patch"
                                       "blender-2.79-python-3.8-fix.patch"))))
    (build-system cmake-build-system)
    (arguments
      (let ((python-version (version-major+minor (package-version python))))
       `(;; Test files are very large and not included in the release tarball.
         #:tests? #f
         #:configure-flags
         (list "-DWITH_CODEC_FFMPEG=ON"
               "-DWITH_CODEC_SNDFILE=ON"
               "-DWITH_CYCLES=ON"
               "-DWITH_DOC_MANPAGE=ON"
               "-DWITH_FFTW3=ON"
               "-DWITH_GAMEENGINE=ON"
               "-DWITH_IMAGE_OPENJPEG=ON"
               "-DWITH_INPUT_NDOF=ON"
               "-DWITH_INSTALL_PORTABLE=OFF"
               "-DWITH_JACK=ON"
               "-DWITH_MOD_OCEANSIM=ON"
               "-DWITH_PLAYER=ON"
               "-DWITH_PYTHON_INSTALL=OFF"
               "-DWITH_PYTHON_INSTALL=OFF"
               "-DWITH_SYSTEM_OPENJPEG=ON"
               (string-append "-DPYTHON_LIBRARY=python" ,python-version)
               (string-append "-DPYTHON_LIBPATH=" (assoc-ref %build-inputs "python")
                              "/lib")
               (string-append "-DPYTHON_INCLUDE_DIR=" (assoc-ref %build-inputs "python")
                              "/include/python" ,python-version)
               (string-append "-DPYTHON_VERSION=" ,python-version))
         #:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'fix-broken-import
             (lambda _
               (substitute* "release/scripts/addons/io_scene_fbx/json2fbx.py"
                 (("import encode_bin") "from . import encode_bin"))
               #t))
           (add-after 'set-paths 'add-ilmbase-include-path
             (lambda* (#:key inputs #:allow-other-keys)
               ;; OpenEXR propagates ilmbase, but its include files do not appear
               ;; in the CPATH, so we need to add "$ilmbase/include/OpenEXR/" to
               ;; the CPATH to satisfy the dependency on "half.h".
               (setenv "CPATH"
                       (string-append (assoc-ref inputs "ilmbase")
                                      "/include/OpenEXR"
                                      ":" (or (getenv "CPATH") "")))
               #t))))))
    (inputs
     `(("boost" ,boost)
       ("jemalloc" ,jemalloc)
       ("libx11" ,libx11)
       ("openimageio" ,openimageio)
       ("openexr" ,openexr)
       ("ilmbase" ,ilmbase)
       ("openjpeg" ,openjpeg)
       ("libjpeg" ,libjpeg-turbo)
       ("libpng" ,libpng)
       ("libtiff" ,libtiff)
       ("ffmpeg" ,ffmpeg)
       ("fftw" ,fftw)
       ("jack" ,jack-1)
       ("libsndfile" ,libsndfile)
       ("freetype" ,freetype)
       ("glew" ,glew)
       ("openal" ,openal)
       ("python" ,python)
       ("zlib" ,zlib)))
    (home-page "https://blender.org/")
    (synopsis "3D graphics creation suite")
    (description
     "Blender is a 3D graphics creation suite.  It supports the entirety of
the 3D pipeline—modeling, rigging, animation, simulation, rendering,
compositing and motion tracking, even video editing and game creation.  The
application can be customized via its API for Python scripting.

NOTE: This older version of Blender is the last release that does not require
OpenGL 3.  It is retained for use with older computers.")
    (license license:gpl2+)))

(define-public assimp
  (package
    (name "assimp")
    (version "4.1.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/assimp/assimp")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1rhyqfhzifdj7yibyanph3rh13ykw3i98dnn8mz65j780472hw28"))))
    (build-system cmake-build-system)
    (inputs
     `(("zlib" ,zlib)))
    (home-page "http://www.assimp.org/")
    (synopsis "Asset import library")
    (description
     "The Open Asset Import Library loads more than 40 3D file formats into
one unified data structure.  Additionally, assimp features various mesh post
processing tools: normals and tangent space generation, triangulation, vertex
cache locality optimization, removal of degenerate primitives and duplicate
vertices, sorting by primitive type, merging of redundant materials and many
more.")
    (license license:bsd-3)))

(define-public cgal
  (package
    (name "cgal")
    (version "4.14.2")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://github.com/CGAL/cgal/releases/download/releases/"
                    "CGAL-" version "/CGAL-" version ".tar.xz"))
              (sha256
               (base32
                "08lrp3hfwdypggz4138bnkh6bjxn441zg2y9xnq5mrjfc5ini6w1"))))
    (build-system cmake-build-system)
    (arguments
     '(#:tests? #f))                    ; no test target
    (inputs
     `(("mpfr" ,mpfr)
       ("gmp" ,gmp)
       ("boost" ,boost)))
    (home-page "https://www.cgal.org/")
    (synopsis "Computational geometry algorithms library")
    (description
     "CGAL provides easy access to efficient and reliable geometric algorithms
in the form of a C++ library.  CGAL is used in various areas needing geometric
computation, such as: computer graphics, scientific visualization, computer
aided design and modeling, geographic information systems, molecular biology,
medical imaging, robotics and motion planning, mesh generation, numerical
methods, etc.  It provides data structures and algorithms such as
triangulations, Voronoi diagrams, polygons, polyhedra, mesh generation, and
many more.")

    ;; The 'LICENSE' file explains that a subset is available under more
    ;; permissive licenses.
    (license license:gpl3+)))

(define-public ilmbase
  (package
    (name "ilmbase")
    (version "2.5.2")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/openexr/openexr")
                    (commit (string-append "v" version))))
              (file-name (git-file-name "ilmbase" version))
              (sha256
               (base32
                "1vf8bqld2bpcdi99jbr043y6vp01cp3fvbiasrn66xn91mf6imbn"))
              (patches (search-patches "ilmbase-fix-tests.patch"))))
    (build-system cmake-build-system)
    (arguments
     `(#:phases (modify-phases %standard-phases
                  (add-after 'unpack 'change-directory
                    (lambda _
                      (chdir "IlmBase")
                      #t)))))
    (home-page "https://www.openexr.com/")
    (synopsis "Utility C++ libraries for threads, maths, and exceptions")
    (description
     "IlmBase provides several utility libraries for C++.  Half is a class
that encapsulates ILM's 16-bit floating-point format.  IlmThread is a thread
abstraction.  Imath implements 2D and 3D vectors, 3x3 and 4x4 matrices,
quaternions and other useful 2D and 3D math functions.  Iex is an
exception-handling library.")
    (license license:bsd-3)))

(define-public lib2geom
  ;; Use the latest master commit, as the 1.0 release suffer build problems.
  (let ((revision "2")
        (commit "f98256d2a923955af74b8cff3d456f0df1ee4b59"))
    (package
      (name "lib2geom")
      (version (git-version "1.0" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://gitlab.com/inkscape/lib2geom.git")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "0w6ijaai8i80d0f35c0shgdspqlsdhw3cvz106k1gm7bmnz1wzpq"))
                (patches
                 ;; Patches submitted to upstream (see:
                 ;; https://gitlab.com/inkscape/lib2geom/merge_requests/17,
                 ;; https://gitlab.com/inkscape/lib2geom/-/merge_requests/32).
                 (search-patches "lib2geom-enable-assertions.patch"
                                 "lib2geom-fix-tests.patch"))
                (modules '((guix build utils)))
                (snippet
                 '(begin
                    ;; Fix py2geom module initialization (see:
                    ;; https://gitlab.com/inkscape/lib2geom/merge_requests/18).
                    (substitute* "src/py2geom/__init__.py"
                      (("_py2geom") "py2geom._py2geom"))
                    #t))))
      (build-system cmake-build-system)
      (arguments
       `(#:imported-modules ((guix build python-build-system)
                             ,@%cmake-build-system-modules)
         #:configure-flags '("-D2GEOM_BUILD_SHARED=ON"
                             "-D2GEOM_BOOST_PYTHON=ON"
                             ;; Compiling the Cython bindings fail (see:
                             ;; https://gitlab.com/inkscape/lib2geom/issues/21).
                             "-D2GEOM_CYTHON_BINDINGS=OFF")
         #:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'patch-python-lib-install-path
             (lambda* (#:key inputs outputs #:allow-other-keys)
               (let* ((python-version (@ (guix build python-build-system)
                                         python-version))
                      (python-maj-min-version (python-version
                                               (assoc-ref inputs "python")))
                      (site-package (string-append
                                     (assoc-ref outputs "out")
                                     "/lib/python" python-maj-min-version
                                     "/site-packages")))
                 (substitute* '("src/cython/CMakeLists.txt"
                                "src/py2geom/CMakeLists.txt")
                   (("PYTHON_LIB_INSTALL \"[^\"]*\"")
                    (format #f "PYTHON_LIB_INSTALL ~s" site-package))))
               #t)))))
      (native-inputs `(("python" ,python-wrapper)
                       ("googletest" ,googletest)
                       ("pkg-config" ,pkg-config)))
      (inputs `(("cairo" ,cairo)
                ("pycairo" ,python-pycairo)
                ("double-conversion" ,double-conversion)
                ("glib" ,glib)
                ("gsl" ,gsl)))
      (propagated-inputs
       `(("boost" ,boost)))             ;referred to in 2geom/pathvector.h.
      (home-page "https://gitlab.com/inkscape/lib2geom/")
      (synopsis "C++ 2D graphics library")
      (description "2geom is a C++ library of mathematics for paths, curves,
and other geometric calculations.  Designed for vector graphics, it tackles
Bézier curves, conic sections, paths, intersections, transformations, and
basic geometries.")
      ;; Because the library is linked with the GNU Scientific Library
      ;; (GPLv3+), the combined work must be licensed as GPLv3+ (see:
      ;; https://gitlab.com/inkscape/inkscape/issues/784).
      (license license:gpl3+))))

(define-public pstoedit
  (package
    (name "pstoedit")
    (version "3.75")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://sourceforge/pstoedit/pstoedit/"
                                  version "/pstoedit-" version ".tar.gz"))
              (sha256
               (base32
                "1kv46g2wsvsvcngkavxl5gnw3l6g5xqnh4kmyx4b39a01d8xiddp"))))
    (build-system gnu-build-system)
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (inputs
     `(("ghostscript" ,ghostscript)
       ("imagemagick" ,imagemagick)
       ("libplot" ,plotutils)
       ("libjpeg" ,libjpeg-turbo)
       ("zlib" ,zlib)))               ;else libp2edrvmagick++.so fails to link
    (home-page "http://www.pstoedit.net/")
    (synopsis "Converter for PostScript and PDF graphics")
    (description "The @code{pstoedit} utility allows translating graphics
in the PostScript or PDF (Portable Document Format) formats to various
other vector formats such as:
@itemize
@item Tgif (.obj)
@item gnuplot
@item xfig (.fig)
@item Flattened PostScript
@item DXF, a CAD (Computed-Aided Design) exchange format
@item PIC (for troff/groff)
@item MetaPost (for usage with TeX/LaTeX)
@item LaTeX2e picture
@item GNU Metafile (for use with plotutils/libplot)
@item Any format supported by ImageMagick
@end itemize")
    (license license:gpl2+)))

(define-public ogre
  (package
    (name "ogre")
    (version "1.12.5")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/OGRECave/ogre")
             (commit (string-append "v" version))
             (recursive? #t)))          ;for Dear ImGui submodule
       (file-name (git-file-name name version))
       (sha256
        (base32 "1sx0jsw4kmb4ycf62bgx3ygwv8k1cgjx52y47d7dk07z6gk6wpyj"))))
    (build-system cmake-build-system)
    (arguments
     '(#:phases
       (modify-phases %standard-phases
         (add-before 'configure 'pre-configure
           ;; CMakeLists.txt forces CMAKE_INSTALL_RPATH value.  As
           ;; a consequence, we cannot suggest ours in configure flags.  Fix
           ;; it.
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (substitute* "CMakeLists.txt"
               (("set\\(CMAKE_INSTALL_RPATH .*") ""))
             #t)))
       #:configure-flags
       (let* ((out (assoc-ref %outputs "out"))
              (runpath
               (string-join (list (string-append out "/lib")
                                  (string-append out "/lib/OGRE"))
                            ";")))
         (list (string-append "-DCMAKE_INSTALL_RPATH=" runpath)
               "-DOGRE_BUILD_DEPENDENCIES=OFF"
               "-DOGRE_BUILD_TESTS=TRUE"
               "-DOGRE_INSTALL_DOCS=TRUE"
               "-DOGRE_INSTALL_SAMPLES=TRUE"
               "-DOGRE_INSTALL_SAMPLES_SOURCE=TRUE"))))
    (native-inputs
     `(("boost" ,boost)
       ("doxygen" ,doxygen)
       ("googletest" ,googletest-1.8)
       ("pkg-config" ,pkg-config)))
    (inputs
     `(("font-dejavu" ,font-dejavu)
       ("freeimage" ,freeimage)
       ("freetype" ,freetype)
       ("glu" ,glu)
       ("libxaw" ,libxaw)
       ("libxrandr" ,libxrandr)
       ("pugixml" ,pugixml)
       ("sdl2" ,sdl2)
       ("tinyxml" ,tinyxml)
       ("zziplib" ,zziplib)))
    (synopsis "Scene-oriented, flexible 3D engine written in C++")
    (description
     "OGRE (Object-Oriented Graphics Rendering Engine) is a scene-oriented,
flexible 3D engine written in C++ designed to make it easier and more intuitive
for developers to produce applications utilising hardware-accelerated 3D
graphics.")
    (home-page "https://www.ogre3d.org/")
    (license license:expat)))

(define-public openexr
  (package
    (name "openexr")
    (version (package-version ilmbase))
    (source (origin
              (inherit (package-source ilmbase))
              (file-name (git-file-name "openexr" version))
              (modules '((guix build utils)))
              (snippet
               '(begin
                  (substitute* (find-files "OpenEXR" "tmpDir\\.h")
                    (("\"/var/tmp/\"")
                     "\"/tmp/\""))
                  #t))))
    (build-system cmake-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'change-directory
           (lambda _
             (chdir "OpenEXR")
             #t))
         (add-after 'change-directory 'increase-test-timeout
           (lambda _
             ;; On armhf-linux, we need to override the CTest default
             ;; timeout of 1500 seconds for the OpenEXR.IlmImf test.
             (substitute* "IlmImfTest/CMakeLists.txt"
               (("add_test\\(NAME OpenEXR\\.IlmImf.*" all)
                (string-append
                 all
                 "set_tests_properties(OpenEXR.IlmImf PROPERTIES TIMEOUT 2000)")))
             #t))
         ,@(if (not (target-64bit?))
               `((add-after 'change-directory 'disable-broken-test
                   ;; This test fails on i686. Upstream developers suggest that
                   ;; this test is broken on i686 and can be safely disabled:
                   ;; https://github.com/openexr/openexr/issues/67#issuecomment-21169748
                   (lambda _
                     (substitute* "IlmImfTest/main.cpp"
                       ((".*testOptimizedInterleavePatterns.*") ""))
                     #t)))
               '()))))
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (propagated-inputs
     `(("ilmbase" ,ilmbase)                       ;used in public headers
       ("zlib" ,zlib)))                           ;OpenEXR.pc reads "-lz"
    (home-page "https://www.openexr.com/")
    (synopsis "High-dynamic range file format library")
    (description
     "OpenEXR is a high dynamic-range (HDR) image file format developed for
use in computer imaging applications.  The IlmImf C++ libraries support
storage of the \"EXR\" file format for storing 16-bit floating-point images.")
    (license license:bsd-3)))

(define-public openimageio
  (package
    (name "openimageio")
    (version "2.0.13")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/OpenImageIO/oiio")
                    (commit (string-append "Release-" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0czcls82v71wkw1syib16ncg7463hx0py0xclycsiv4w6i3wlkzz"))))
    (build-system cmake-build-system)
    ;; FIXME: To run all tests successfully, test image sets from multiple
    ;; third party sources have to be present.  For details see
    ;; https://github.com/OpenImageIO/oiio/blob/master/INSTALL
    (arguments
     `(#:tests? #f))
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (inputs
     `(("boost" ,boost)
       ("libpng" ,libpng)
       ("libjpeg" ,libjpeg-turbo)
       ("libtiff" ,libtiff)
       ("giflib" ,giflib)
       ("openexr" ,openexr)
       ("ilmbase" ,ilmbase)
       ("python" ,python-wrapper)
       ("pybind11" ,pybind11)
       ("robin-map" ,robin-map)
       ("zlib" ,zlib)))
    (synopsis "C++ library for reading and writing images")
    (description
     "OpenImageIO is a library for reading and writing images, and a bunch of
related classes, utilities, and applications.  There is a particular emphasis
on formats and functionality used in professional, large-scale animation and
visual effects work for film.")
    (home-page "https://www.openimageio.org")
    (license license:bsd-3)))

(define-public openscenegraph
  (package
    (name "openscenegraph")
    (version "3.6.5")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/openscenegraph/OpenSceneGraph")
             (commit (string-append "OpenSceneGraph-" version))))
       (sha256
        (base32 "00i14h82qg3xzcyd8p02wrarnmby3aiwmz0z43l50byc9f8i05n1"))
       (file-name (git-file-name name version))))
    (properties
     `((upstream-name . "OpenSceneGraph")))
    (build-system cmake-build-system)
    (arguments
     `(#:tests? #f                      ; no test target available
       ;; Without this flag, 'rd' will be added to the name of the
       ;; library binaries and break linking with other programs.
       #:build-type "Release"
       #:configure-flags
       (list (string-append "-DCMAKE_INSTALL_RPATH="
                            (assoc-ref %outputs "out") "/lib:"
                            (assoc-ref %outputs "out") "/lib64"))))
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("unzip" ,unzip)))
    (inputs
     `(("giflib" ,giflib)
       ("libjpeg" ,libjpeg-turbo)       ; required for the JPEG texture plugin.
       ("jasper" ,jasper)
       ("librsvg" ,librsvg)
       ("libxrandr" ,libxrandr)
       ("ffmpeg" ,ffmpeg)
       ("mesa" ,mesa)))
    (synopsis "High-performance real-time graphics toolkit")
    (description
     "The OpenSceneGraph is a high-performance 3D graphics toolkit
used by application developers in fields such as visual simulation, games,
virtual reality, scientific visualization and modeling.")
    (home-page "http://www.openscenegraph.org")
    ;; The 'LICENSE' file explains that the source is licensed under
    ;; LGPL 2.1, but with 4 exceptions. This version is called OSGPL.
    (license license:lgpl2.1)))

;; We need this for simgear
(define-public openscenegraph-3.4
  (package (inherit openscenegraph)
    (name "openscenegraph")
    (version "3.4.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/openscenegraph/OpenSceneGraph")
             (commit (string-append "OpenSceneGraph-" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "1fbzg1ihjpxk6smlq80p3h3ggllbr16ihd2fxpfwzam8yr8yxip9"))))
    (arguments
     (substitute-keyword-arguments (package-arguments openscenegraph)
       ((#:configure-flags flags)
        `(cons
          ;; The jpeg plugin requires conversion between integers and booleans
          "-DCMAKE_CXX_FLAGS=-fpermissive"
          ,flags))))
    (inputs
     `(("libjpeg" ,libjpeg-turbo)
       ,@(package-inputs openscenegraph)))))


(define-public openmw-openscenegraph
  ;; OpenMW prefers its own fork of openscenegraph:
  ;; https://wiki.openmw.org/index.php?title=Development_Environment_Setup#OpenSceneGraph.
  (let ((commit "36a962845a2c87a6671fd822157e0729d164e940"))
    (hidden-package
     (package
       (inherit openscenegraph)
       (version (git-version "3.6" "1" commit))
       (source
        (origin
          (method git-fetch)
          (uri (git-reference
                (url "https://github.com/OpenMW/osg/")
                (commit commit)))
          (file-name (git-file-name (package-name openscenegraph) version))
          (sha256
           (base32
            "05yhgq3qm5q277y32n5sf36vx5nv5qd3zlhz4csgd3a6190jrnia"))))
       (arguments
        (substitute-keyword-arguments (package-arguments openscenegraph)
          ((#:configure-flags flags)
           ;; As per the above wiki link, the following plugins are enough:
           `(append
             '("-DBUILD_OSG_PLUGINS_BY_DEFAULT=0"
               "-DBUILD_OSG_PLUGIN_OSG=1"
               "-DBUILD_OSG_PLUGIN_DDS=1"
               "-DBUILD_OSG_PLUGIN_TGA=1"
               "-DBUILD_OSG_PLUGIN_BMP=1"
               "-DBUILD_OSG_PLUGIN_JPEG=1"
               "-DBUILD_OSG_PLUGIN_PNG=1"
               "-DBUILD_OSG_DEPRECATED_SERIALIZERS=0"
               ;; The jpeg plugin requires conversion between integers and booleans
               "-DCMAKE_CXX_FLAGS=-fpermissive")
             ,flags))))))))

(define-public povray
  (package
    (name "povray")
    (version "3.7.0.8")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/POV-Ray/povray")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1q114n4m3r7qy3yn954fq7p46rg7ypdax5fazxr9yj1jklf1lh6z"))
              (modules '((guix build utils)))
              (snippet
               '(begin
                  ;; Delete bundled libraries.
                  (delete-file-recursively "libraries")
                  #t))))
    (build-system gnu-build-system)
    (native-inputs
     `(("autoconf" ,autoconf)
       ("automake" ,automake)
       ("pkg-config" ,pkg-config)))
    (inputs
     `(("boost" ,boost)
       ("libjpeg" ,libjpeg-turbo)
       ("libpng" ,libpng)
       ("libtiff" ,libtiff)
       ("openexr" ,openexr)
       ("sdl" ,sdl)
       ("zlib" ,zlib)))
    (arguments
     '(#:configure-flags
       (list "COMPILED_BY=Guix"
             (string-append "--with-boost-libdir="
                            (assoc-ref %build-inputs "boost") "/lib")
             "--disable-optimiz-arch")
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'run-prebuild
           (lambda _
             (setenv "HOME" (getcwd))
             (with-directory-excursion "unix"
               (substitute* "prebuild.sh"
                 (("/bin/sh") (which "sh")))
               (invoke "sh" "prebuild.sh"))
             #t))
         ;; The bootstrap script is run by the prebuild script in the
         ;; "run-prebuild" phase.
         (delete 'bootstrap))))
    (synopsis "Tool for creating three-dimensional graphics")
    (description
     "@code{POV-Ray} is short for the Persistence of Vision Raytracer, a tool
for producing high-quality computer graphics.  @code{POV-Ray} creates
three-dimensional, photo-realistic images using a rendering technique called
ray-tracing.  It reads in a text file containing information describing the
objects and lighting in a scene and generates an image of that scene from the
view point of a camera also described in the text file.  Ray-tracing is not a
fast process by any means, but it produces very high quality images with
realistic reflections, shading, perspective and other effects.")
    (home-page "http://www.povray.org/")
    (license license:agpl3+)))

(define-public rapicorn
  (package
    (name "rapicorn")
    (version "16.0.0")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://testbit.eu/pub/dists/rapicorn/"
                                  "rapicorn-" version ".tar.xz"))
              (sha256
               (base32
                "1y51yjrpsihas1jy905m9p3r8iiyhq6bwi2690c564i5dnix1f9d"))
              (patches (search-patches "rapicorn-isnan.patch"))))
    (build-system gnu-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'fix-tests
           (lambda _
             ;; Our grep does not support perl regular expressions.
             (substitute* "taptool.sh"
               (("grep -P") "grep -E"))
             ;; Disable path tests because we cannot access /bin or /sbin.
             (substitute* "rcore/tests/multitest.cc"
               (("TCMP \\(Path::equals \\(\"/bin\"") "//"))
             #t))
         (add-before 'check 'pre-check
           (lambda _
             ;; The test suite requires a running X server (with DISPLAY
             ;; number 99 or higher).
             (system "Xvfb :99 &")
             (setenv "DISPLAY" ":99")
             #t))
         (add-after 'unpack 'replace-fhs-paths
           (lambda _
             (substitute* (cons "Makefile.decl"
                                (find-files "." "^Makefile\\.in$"))
               (("/bin/ls") (which "ls"))
               (("/usr/bin/env") (which "env")))
             #t)))))
    ;; These libraries are listed in the "Required" section of the pkg-config
    ;; file.
    (propagated-inputs
     `(("librsvg" ,librsvg)
       ("cairo" ,cairo)
       ("pango" ,pango)
       ("libxml2" ,libxml2)
       ("python2-enum34" ,python2-enum34)))
    (inputs
     `(("gdk-pixbuf" ,gdk-pixbuf)
       ("libpng" ,libpng-1.2)
       ("readline" ,readline)
       ("libcroco" ,libcroco)
       ("python" ,python-2)
       ("cython" ,python2-cython)))
    (native-inputs
     `(("pandoc" ,ghc-pandoc)
       ("bison" ,bison)
       ("flex" ,flex)
       ("doxygen" ,doxygen)
       ("graphviz" ,graphviz)
       ("intltool" ,intltool)
       ("pkg-config" ,pkg-config)
       ("xvfb" ,xorg-server-for-tests)))
    (home-page "https://rapicorn.testbit.org/")
    (synopsis "Toolkit for rapid development of user interfaces")
    (description
     "Rapicorn is a toolkit for rapid development of user interfaces in C++
and Python.  The user interface is designed in a declarative markup language
and is connected to the programming logic using data bindings and commands.")
    (license license:mpl2.0)))

(define-public ctl
  (package
    (name "ctl")
    (version "1.5.2")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://github.com/ampas/CTL/archive/ctl-"
                                  version ".tar.gz"))
              (sha256
               (base32
                "1gg04pyvw0m398akn0s1l07g5b1haqv5na1wpi5dii1jjd1w3ynp"))))
    (build-system cmake-build-system)
    (arguments '(#:tests? #f))                    ;no 'test' target

    ;; Headers include OpenEXR and IlmBase headers.
    (propagated-inputs `(("openexr" ,openexr)))

    (home-page "http://ampasctl.sourceforge.net")
    (synopsis "Color Transformation Language")
    (description
     "The Color Transformation Language, or CTL, is a small programming
language that was designed to serve as a building block for digital color
management systems.  CTL allows users to describe color transforms in a
concise and unambiguous way by expressing them as programs.  In order to apply
a given transform to an image, the color management system instructs a CTL
interpreter to load and run the CTL program that describes the transform.  The
original and the transformed image constitute the CTL program's input and
output.")

    ;; The web site says it's under a BSD-3 license, but the 'LICENSE' file
    ;; and headers use different wording.
    (license (license:non-copyleft "file://LICENSE"))))

(define-public brdf-explorer
  ;; There are no release tarballs, and not even tags in the repo,
  ;; so use the latest revision.
  (let ((commit "5b2cd46f38a06e47207fa7229b72d37beb945019")
        (revision "1"))
    (package
      (name "brdf-explorer")
      (version (string-append "1.0.0-" revision "." (string-take commit 9)))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/wdas/brdf")
                      (commit commit)))
                (sha256
                 (base32
                  "06vzbiajzbi2xl8jlff5d45bc9wd68i3jdndfab1f3jgfrd8bsgx"))
                (file-name (string-append name "-" version "-checkout"))))
      (build-system gnu-build-system)
      (arguments
       `(#:phases (modify-phases %standard-phases
                    (replace 'configure
                      (lambda* (#:key outputs #:allow-other-keys)
                        (let ((out (assoc-ref outputs "out")))
                          (invoke "qmake"
                                  (string-append "prefix=" out)))))
                    (add-after 'install 'wrap-program
                      (lambda* (#:key outputs #:allow-other-keys)
                        (let* ((out (assoc-ref outputs "out"))
                               (bin (string-append out "/bin"))
                               (data (string-append
                                      out "/share/brdf")))
                          (with-directory-excursion bin
                            (rename-file "brdf" ".brdf-real")
                            (call-with-output-file "brdf"
                              (lambda (port)
                                (format port "#!/bin/sh
# Run the thing from its home, otherwise it just bails out.
cd \"~a\"
exec -a \"$0\" ~a/.brdf-real~%"
                                        data bin)))
                            (chmod "brdf" #o555)))
                        #t)))))
      (native-inputs
       `(("qttools" ,qttools))) ;for 'qmake'
      (inputs
       `(("qtbase" ,qtbase)
         ("mesa" ,mesa)
         ("glew" ,glew)
         ("freeglut" ,freeglut)
         ("zlib" ,zlib)))
      (home-page "https://www.disneyanimation.com/technology/brdf.html")
      (synopsis
       "Analyze bidirectional reflectance distribution functions (BRDFs)")
      (description
       "BRDF Explorer is an application that allows the development and analysis
of bidirectional reflectance distribution functions (BRDFs).  It can load and
plot analytic BRDF functions (coded as functions in OpenGL's GLSL shader
language), measured material data from the MERL database, and anisotropic
measured material data from MIT CSAIL.  Graphs and visualizations update in
real time as parameters are changed, making it a useful tool for evaluating
and understanding different BRDFs (and other component functions).")
      (license license:ms-pl))))

(define-public agg
  (package
    (name "agg")
    (version "2.5")
    (source (origin
              (method url-fetch)
              (uri (list (string-append
                          "ftp://ftp.fau.de/gentoo/distfiles/agg-"
                          version ".tar.gz")
                         (string-append
                          "ftp://ftp.ula.ve/gentoo/distfiles/agg-"
                          version ".tar.gz")

                         ;; Site was discontinued.
                         (string-append "http://www.antigrain.com/agg-"
                                        version ".tar.gz")))
              (sha256
               (base32 "07wii4i824vy9qsvjsgqxppgqmfdxq0xa87i5yk53fijriadq7mb"))
              (patches (search-patches "agg-am_c_prototype.patch"))))
    (build-system gnu-build-system)
    (arguments
     '(#:configure-flags
       (list (string-append "--x-includes=" (assoc-ref %build-inputs "libx11")
                            "/include")
             (string-append "--x-libraries=" (assoc-ref %build-inputs "libx11")
                            "/lib")
             "--disable-examples")
       #:phases
       (modify-phases %standard-phases
         (replace 'bootstrap
           (lambda _
             ;; let's call configure from configure phase and not now
             (substitute* "autogen.sh" (("./configure") "# ./configure"))
             (invoke "sh" "autogen.sh"))))))
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("libtool" ,libtool)
       ("autoconf" ,autoconf)
       ("automake" ,automake)))
    (inputs
     `(("libx11" ,libx11)
       ("freetype" ,freetype)
       ("sdl" ,sdl)))

    ;; Antigrain.com was discontinued.
    (home-page "http://agg.sourceforge.net/antigrain.com/index.html")
    (synopsis "High-quality 2D graphics rendering engine for C++")
    (description
     "Anti-Grain Geometry is a high quality rendering engine written in C++.
It supports sub-pixel resolutions and anti-aliasing.  It is also library for
rendering SVG graphics.")
    (license license:gpl2+)))

(define-public python-pastel
  (package
    (name "python-pastel")
    (version "0.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "pastel" version))
       (sha256
        (base32
         "0dnaw44ss10i10z4ksy0xljknvjap7rb7g0b8p6yzm5x4g2my5a6"))))
    (build-system python-build-system)
    (arguments
     `(#:phases (modify-phases %standard-phases
                  (replace 'check
                    (lambda _ (invoke "pytest" "pastel" "tests/"))))))
    (native-inputs
     `(("python-pytest" ,python-pytest)))
    (home-page "https://github.com/sdispater/pastel")
    (synopsis "Library to colorize strings in your terminal")
    (description "Pastel is a simple library to help you colorize strings in
your terminal.")
    (license license:expat)))

(define-public python2-pastel
  (package-with-python2 python-pastel))

(define-public fgallery
  (package
    (name "fgallery")
    (version "1.8.2")
    (source (origin
              (method url-fetch)
              (uri
               (string-append
                "http://www.thregr.org/~wavexx/software/fgallery/releases/"
                "fgallery-" version ".zip"))
              (sha256
               (base32
                "18wlvqbxcng8pawimbc8f2422s8fnk840hfr6946lzsxr0ijakvf"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f ; no tests
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (delete 'build)
         (replace 'install
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((out    (assoc-ref outputs "out"))
                    (bin    (string-append out "/bin/"))
                    (share  (string-append out "/share/fgallery"))
                    (man    (string-append out "/share/man/man1"))
                    (perl5lib (getenv "PERL5LIB"))
                    (script (string-append share "/fgallery")))
               (define (bin-directory input-name)
                 (string-append (assoc-ref inputs input-name) "/bin"))

               (mkdir-p man)
               (copy-file "fgallery.1" (string-append man "/fgallery.1"))

               (mkdir-p share)
               (copy-recursively "." share)

               ;; fgallery copies files from store when it is run. The
               ;; read-only permissions from the store directories will cause
               ;; fgallery to fail. Do not preserve file attributes when
               ;; copying files to prevent it.
               (substitute* script
                 (("'cp'")
                  "'cp', '--no-preserve=all'"))

               (mkdir-p bin)
               (symlink script (string-append out "/bin/fgallery"))

               (wrap-program script
                 `("PATH" ":" prefix
                   ,(map bin-directory '("imagemagick"
                                         "lcms"
                                         "fbida"
                                         "libjpeg"
                                         "zip"
                                         "jpegoptim"
                                         "pngcrush"
                                         "p7zip")))
                 `("PERL5LIB" ":" prefix (,perl5lib)))
               #t))))))
    (native-inputs
     `(("unzip" ,unzip)))
    ;; TODO: Add missing optional dependency: facedetect.
    (inputs
     `(("imagemagick" ,imagemagick)
       ("lcms" ,lcms)
       ("fbida" ,fbida)
       ("libjpeg" ,libjpeg-turbo)
       ("zip" ,zip)
       ("perl" ,perl)
       ("perl-cpanel-json-xs" ,perl-cpanel-json-xs)
       ("perl-image-exiftool" ,perl-image-exiftool)
       ("jpegoptim" ,jpegoptim)
       ("pngcrush" ,pngcrush)
       ("p7zip" ,p7zip)))
    (home-page "http://www.thregr.org/~wavexx/software/fgallery/")
    (synopsis "Static photo gallery generator")
    (description
     "FGallery is a static, JavaScript photo gallery generator with minimalist
look.  The result can be uploaded on any web server without additional
requirements.")
    (license license:gpl2+)))

(define-public opensubdiv
  (package
    (name "opensubdiv")
    (version "3.4.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/PixarAnimationStudios/OpenSubdiv")
                    (commit (string-append "v" (string-join (string-split version #\.)
                                                            "_")))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0cippg6aqc5dlya1cmh3908pwssrg52fwgyylnvz5343yrxmgk12"))))
    (build-system cmake-build-system)
    (arguments
     `(#:phases (modify-phases %standard-phases
                  (add-before 'configure 'set-glew-location
                    (lambda* (#:key inputs #:allow-other-keys)
                      (setenv "GLEW_LOCATION" (assoc-ref inputs "glew"))
                      #t))
                  (add-before 'check 'start-xorg-server
                    (lambda* (#:key inputs #:allow-other-keys)
                      ;; The test suite requires a running X server.
                      (system (string-append (assoc-ref inputs "xorg-server")
                                             "/bin/Xvfb :1 &"))
                      (setenv "DISPLAY" ":1")
                      #t)))))
    (native-inputs
     `(("xorg-server" ,xorg-server-for-tests)))
    (inputs
     `(("glew" ,glew)
       ("libxrandr" ,libxrandr)
       ("libxcursor" ,libxcursor)
       ("libxinerama" ,libxinerama)
       ("libxi" ,libxi)
       ("zlib" ,zlib)
       ("glfw" ,glfw)))
    (home-page "https://graphics.pixar.com/opensubdiv/")
    (synopsis "High performance subdivision surface evaluation")
    (description "OpenSubdiv is a set of libraries that implement high
performance subdivision surface (subdiv) evaluation on massively parallel CPU
and GPU architectures.")
    (license license:asl2.0)))

(define-public opencsg
  (let ((dot-to-dash (lambda (c) (if (char=? c #\.) #\- c))))
    (package
      (name "opencsg")
      (version "1.4.2")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/floriankirsch/OpenCSG")
               (commit (string-append "opencsg-"
                                      (string-map dot-to-dash version)
                                      "-release"))))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "00m4vs6jn3scqczscc4591l1d6zg6anqp9v1ldf9ymf70rdyvm7m"))))
      (build-system gnu-build-system)
      (arguments
       `(#:phases
         (modify-phases %standard-phases
           (replace 'configure
             (lambda* (#:key outputs #:allow-other-keys)
               (substitute* "src/Makefile"
                 (("/usr/local") (assoc-ref outputs "out")))
               #t))
           (add-before 'build 'skip-example
             (lambda _ (chdir "src") #t)))))
      (inputs
       `(("glew" ,glew)
         ("freeglut" ,freeglut)))
      (synopsis "Library for rendering Constructive Solid Geometry (CSG)")
      (description
       "OpenCSG is a library for rendering Constructive Solid Geometry (CSG) using
OpenGL.  CSG is an approach for modeling complex 3D-shapes using simpler ones.
For example, two shapes can be combined by uniting them, by intersecting them,
or by subtracting one shape from the other.")
      (home-page "http://www.opencsg.org/")
      (license license:gpl2))))

(define-public coin3D
  ;; The ‘4.0.0’ zip archive isn't stable, nor in fact a release.  See:
  ;; https://bitbucket.org/Coin3D/coin/issues/179/coin-400-srczip-has-been-modified
  (let ((revision 1)
        (changeset "ab8d0e47a4de3230a8137feb39c142d6ba45f97d"))
    (package
      (name "coin3D")
      (version
       (simple-format #f "3.1.3-~A-~A" revision (string-take changeset 7)))
      (source
       (origin
         (method hg-fetch)
         (uri (hg-reference
               (url "https://bitbucket.org/Coin3D/coin")
               (changeset changeset)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1ff44jz6lg4rylljvy69n1hcjh9y6achbv9jpn1cv2sf8cxn3r2j"))
         (modules '((guix build utils)))
         (snippet
          '(begin
             (for-each delete-file
                       '("cfg/csubst.exe"
                         "cfg/wrapmsvc.exe"))
             #t))))
      (build-system cmake-build-system)
      (native-inputs
       `(("doxygen" ,doxygen)
         ("graphviz" ,graphviz)))
      (inputs
       `(("boost" ,boost)
         ("freeglut" ,freeglut)
         ("glew" ,glew)))
      (arguments
       `(#:configure-flags
         (list
          "-DCOIN_BUILD_DOCUMENTATION_MAN=ON"
          (string-append "-DBOOST_ROOT="
                         (assoc-ref %build-inputs "boost")))))
      (home-page "https://bitbucket.org/Coin3D/coin/wiki/Home")
      (synopsis
       "High-level 3D visualization library with Open Inventor 2.1 API")
      (description
       "Coin is a 3D graphics library with an Application Programming Interface
based on the Open Inventor 2.1 API.  For those who are not familiar with
Open Inventor, it is a scene-graph based retain-mode rendering and model
interaction library, written in C++, which has become the de facto
standard graphics library for 3D visualization and visual simulation
software in the scientific and engineering community.")
      (license license:bsd-3))))

(define-public superfamiconv
  (package
    (name "superfamiconv")
    (version "0.8.8")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Optiroc/SuperFamiconv")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "0848szv6a2b8wdganh6mw5i8vn8cqvn1kbwzx7mb9wlrf5wzqn37"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f ; no tests
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((outdir (assoc-ref outputs "out"))
                    (bindir (string-append outdir "/bin")))
               (install-file "bin/superfamiconv" bindir)
               #t))))))
    (home-page "https://github.com/Optiroc/SuperFamiconv")
    (synopsis "Tile graphics converter supporting SNES, Game Boy Color
and PC Engine formats")
    (description "SuperFamiconv is a converter for tiled graphics, supporting
the graphics formats of the SNES, Game Boy Color and PC Engine game consoles.
Automated palette selection is supported.")
    (license license:expat)))
