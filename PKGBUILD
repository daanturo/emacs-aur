pkgname="emacs-treesit-git"
pkgver=29.0.50.1
pkgrel=1
arch=("x86_64")

pkgdesc="GNU Emacs, with Tree Sitter and more."
url="http://www.gnu.org/software/emacs/"
license=("GPL3")

depends=('gnutls' 'libxml2' 'jansson'
	'harfbuzz'
	'libgccjit'
	'gtk3'
	'webkit2gtk'
	'gpm')
makedepends=('git' 'xorgproto' 'libxi')

provides=('emacs')
replaces=('emacs')

_REPO='https://gitlab.com/emacs-mirror-daan/emacs.git'

source=("emacs::git+${_REPO}")
cksums=('SKIP')

# Force shallow clone
[[ -d ./emacs/ ]] || git clone --bare --depth=1 $_REPO emacs

function pkgver() {
	cd "$srcdir/emacs"
	printf "%s.%s" \
		"$(grep AC_INIT configure.ac |
			sed -e 's/^.\+\ \([0-9]\+\.[0-9]\+\.[0-9]\+\?\).\+$/\1/')" \
		"$(git rev-list --count HEAD)"
}

function prepare() {
	cd "$srcdir/emacs"
	# [[ -f ./configure ]] && rm ./configure
	[[ -f ./configure ]] || ./autogen.sh
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
		--program-transform-name=s/\([ec]tags\)/\1.emacs/ \
		--with-json \
		--with-libsystemd \
		--with-mailutils \
		--with-modules \
		--with-native-compilation \
		--with-pgtk --without-xaw3d \
		--with-sound=alsa \
		--with-xinput2 \
		--with-xwidgets \
		--without-compress-install \
		--with-tree-sitter
	# --without-gconf
	# --without-gsettings

	# make NATIVE_FULL_AOT=1 -j$(($(nproc) / 2))
	make -j$(($(nproc) / 2))

}

function package() {
	cd "$srcdir/emacs"
	make DESTDIR="$pkgdir/" install

}
