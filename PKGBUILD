pkgname="emacs-my-build-git"
pkgver=29.0.60.1
pkgrel=1
arch=("x86_64")

pkgdesc="GNU Emacs."
url="http://www.gnu.org/software/emacs/"
license=("GPL3")

depends=(

    "alsa-lib"                         # --with-sound=alsa
    "gnutls" "libxml2"                 #
    "gpm"                              # mouse support on a GNU/Linux console
    "gtk3" "libsm" "libxcb" "xcb-util" # --with-pgtk
    "harfbuzz"                         # Complex Text Layout support libraries
    "jansson"                          # --with-json
    "libgccjit"                        # --with-native-compilation
    "tree-sitter"                      # --with-tree-sitter
    "webkit2gtk" "webkit2gtk-4.1"      # --with-xwidgets

    "giflib" "libjpeg-turbo" "libpng" "libtiff" "libwebp" "libxpm" # images
)
makedepends=("git" "gcc" "xorgproto" "libxi")

provides=('emacs')
replaces=('emacs')
conflicts=('emacs')

_REPO_URL='https://gitlab.com/daemacs-daan/emacs.git'
# _REPO_URL='https://git.savannah.gnu.org/git/emacs.git'
# _REPO_URL='https://emba.gnu.org/emacs/emacs.git'
# _REPO_URL='https://github.com/emacs-mirror/emacs.git'

# https://wiki.archlinux.org/title/PKGBUILD#source
# https://man.archlinux.org/man/PKGBUILD.5#USING_VCS_SOURCES
_SOURCE_FRAGMENT="${_SOURCE_FRAGMENT:-}"

source=("emacs::git+${_REPO_URL}#$([[ -n $_SOURCE_FRAGMENT ]] && echo "$_SOURCE_FRAGMENT")")
# echo "${source[@]}"

cksums=('SKIP')

function pkgver() {
    cd "$srcdir/emacs"
    printf "%s.%s" \
        $(grep AC_INIT configure.ac |
            awk -F',' '{ gsub("[ \\[\\]]","",$2); print $2 }') \
        $(git rev-list --count HEAD)
}

function prepare() {
    cd "$srcdir/emacs"
    # [[ -f ./configure ]] && rm ./configure
    [[ -f ./configure ]] || ./autogen.sh
    # mostlyclean doesn't delete stale native-lisp/*
    make clean
}

_config_flags=""

# _config_flags+=" --without-gconf --without-gsettings" # disable synchronizing face with DE, but isn't just using the same font better?
_config_flags+=" --program-transform-name='s/\(ctags\)/\1.emacs/'" # https://ctags.io/ conflict

# _config_flags+=" --with-harfbuzz"   # default since 27
# _config_flags+=" --with-json"       # default since 27
# _config_flags+=" --with-libsystemd" # default since 26
_config_flags+=" --with-mailutils" # otherwise builds and installs auxiliary 'movemail', a limited and insecure substitute
_config_flags+=" --with-modules"   # support dynamic modules ; default since 27
_config_flags+=" --with-native-compilation"
_config_flags+=" --with-pgtk --without-xaw3d"
_config_flags+=" --with-sound=alsa"
_config_flags+=" --with-tree-sitter"
_config_flags+=" --with-xinput2" # support touchscreens, pinch gestures, scroll wheels at pixel-level precision ; default since 29
_config_flags+=" --with-xwidgets"
_config_flags+=" --without-gconf --without-gsettings"
_config_flags+=" --without-libotf --without-m17n-flt" # no need when harfbuzz

function build() {

    cd "$srcdir/emacs"

    export PATH="/usr/lib/ccache/bin/:$PATH"

    local prefixes=" \
    --sysconfdir=/etc \
    --prefix=/usr \
    --libexecdir=/usr/lib \
    --localstatedir=/var \
    "

    # options specific for a system-wide installation

    _config_flags=$(sed -E 's/ --without-gconf//' <<<"$_config_flags")
    _config_flags=$(sed -E 's/ --without-gsettings//' <<<"$_config_flags")

    # _config_flags=$(sed -E 's/ --with-native-compilation//' <<<"$_config_flags")
    # _config_flags+=" --with-native-compilation=aot"

    # _config_flags+=" --without-compress-install"

    ./configure ${prefixes} $_config_flags

    make

}

function package() {

    cd "$srcdir/emacs"
    make DESTDIR="$pkgdir/" install
    chown -R root:root "$pkgdir"/{*,.*}

}
