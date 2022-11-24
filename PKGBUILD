pkgname="emacs-my-build-git"
pkgver=29.0.50.1
pkgrel=1
arch=("x86_64")

pkgdesc="GNU Emacs, with Tree Sitter and more."
url="http://www.gnu.org/software/emacs/"
license=("GPL3")

depends=(
    'alsa-lib'
    'giflib'
    'gnutls'
    'gpm'
    'gtk3'
    'harfbuzz'
    'jansson'
    'libgccjit'
    'libjpeg-turbo'
    'libotf'
    'libxml2'
    'webkit2gtk'
)
makedepends=('git' 'xorgproto' 'libxi')

provides=('emacs')
replaces=('emacs')
conflicts=('emacs')

_REPO_URL='https://gitlab.com/daemacs-daan/emacs.git'
# _REPO_URL='https://git.savannah.gnu.org/git/emacs.git'
# _REPO_URL='https://emba.gnu.org/emacs/emacs.git'
# _REPO_URL='https://github.com/emacs-mirror/emacs.git'
_REPO_BRANCH=""

source=("emacs::git+${_REPO_URL}#$([[ -n $_REPO_BRANCH ]] && echo "branch=$_REPO_BRANCH")")

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

function build() {

    cd "$srcdir/emacs"

    export PATH="/usr/lib/ccache/bin/:$PATH"

    local _confflags=" \
    --sysconfdir=/etc \
    --prefix=/usr \
    --libexecdir=/usr/lib \
    --localstatedir=/var \
    "

    ./configure \
        ${_confflags} \
        --program-transform-name='s/\(ctags\)/\1.emacs/' \
        --with-json \
        --with-libsystemd \
        --with-mailutils \
        --with-modules \
        --with-pgtk --without-xaw3d \
        --with-sound=alsa \
        --with-xinput2 \
        --with-xwidgets \
        --without-compress-install \
        --with-native-compilation=aot \
        --with-tree-sitter
    # --without-gconf
    # --without-gsettings

    make

}

function package() {

    cd "$srcdir/emacs"
    make DESTDIR="$pkgdir/" install
    chown -R root:root "$pkgdir"/{*,.*}

}
