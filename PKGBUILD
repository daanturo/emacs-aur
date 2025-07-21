pkgbase=emacs-my-build-base

# Technically there should be "-git" prefixes, but since there's no stable
# versions, no need to distinguish then
pkgname=(
    "emacs-my-build"
    "emacs-my-build-aot-native-comp"
    "emacs-my-build-debug"
)

pkgver=30.1.90.1
pkgrel=1

arch=("x86_64")
license=("GPL3")
pkgdesc="GNU Emacs."
url="http://www.gnu.org/software/emacs/"

depends=(

    libasound.so
    # alsa-lib                   # --with-sound=alsa
    gnutls libxml2             #
    gpm                        # mouse support on a GNU/Linux console
    gtk3 libsm libxcb xcb-util # --with-pgtk
    harfbuzz                   # Complex Text Layout support libraries
    # jansson                    # --with-json, Emacs [27, 29]
    libgccjit   # --with-native-compilation
    tree-sitter # --with-tree-sitter

    giflib libjpeg-turbo libpng libtiff libwebp libxpm # images

)
makedepends=("git" "gcc" "xorgproto" "libxi")

# $provides will conflict with other non-default Emacs builds
# provides=('emacs')

# replaces=('emacs')
# conflicts=('emacs')

_REPO_URL='https://gitlab.com/daemacs-daan/emacs.git'
# _REPO_URL='https://git.savannah.gnu.org/git/emacs.git'
# _REPO_URL='https://emba.gnu.org/emacs/emacs.git'
# _REPO_URL='https://github.com/emacs-mirror/emacs.git'

# https://wiki.archlinux.org/title/PKGBUILD#source
# https://man.archlinux.org/man/PKGBUILD.5#USING_VCS_SOURCES
_SOURCE_FRAGMENT="${_SOURCE_FRAGMENT:-}"

source=("${pkgbase}::git+${_REPO_URL}#$([[ -n $_SOURCE_FRAGMENT ]] && echo "$_SOURCE_FRAGMENT")")
# echo "${source[@]}"

cksums=('SKIP')

function pkgver() {
    cd "${srcdir}/${pkgbase}"
    printf "%s.%s" \
        $(grep AC_INIT configure.ac |
            awk -F',' '{ gsub("[ \\[\\]]","",$2); print $2 }') \
        $(git rev-list --count HEAD)
}

function prepare() {
    # echo "0001-Make-PGTK-fallback-to-nw-when-display-is-unavailable.patch ${srcdir} ${pkgname} ${pkgdir}"
    local base_src_dir="${srcdir}/${pkgbase}"
    # cp: cannot create regular file {...}.git/objects/pack Permission denied
    chmod u+rwx --recursive "${base_src_dir}"
    for variant in "${pkgname[@]}"; do
        cp --reflink=auto -ar --no-target-directory "${base_src_dir}" "${srcdir}/${variant}"
    done
}

_config_flags=()

_config_flags+=(--without-gconf --without-gsettings)              # disable synchronizing face with DE, but isn't just using the same font better?
_config_flags+=(--program-transform-name='s/\(ctags\)/\1.emacs/') # https://ctags.io/ conflict

_config_flags+=(--with-harfbuzz)   # default since 27
_config_flags+=(--with-json)       # default since 27
_config_flags+=(--with-libsystemd) # default since 26
_config_flags+=(--with-mailutils)  # otherwise builds and installs auxiliary 'movemail', a limited and insecure substitute
_config_flags+=(--with-modules)    # support dynamic modules ; default since 27
_config_flags+=(--with-native-compilation)
_config_flags+=(--with-pgtk --without-xaw3d)
_config_flags+=(--with-sound=alsa)
_config_flags+=(--with-xinput2) # support touchscreens, pinch gestures, scroll wheels at pixel-level precision ; default since 29
_config_flags+=(--without-gconf --without-gsettings)
_config_flags+=(--without-libotf --without-m17n-flt) # no need when harfbuzz
_config_flags+=(--with-small-ja-dic)                 # reduce installation size

_config_flags_debug=()
_config_flags_no_debug=()

# https://cgit.git.savannah.gnu.org/cgit/emacs.git/tree/etc/DEBUG
_config_flags_debug+=(--enable-checking='yes,glyphs' --enable-check-lisp-object-type)
_config_flags_debug+=(CFLAGS="${CFLAGS} -O0 -g3")

_config_flags_no_debug+=(--disable-gc-mark-trace) # better GC performance

# checking for webkit2gtk-4.1 >= 2.12 webkit2gtk-4.1 < 2.41.92... no
# checking for webkit2gtk-4.0 >= 2.12 webkit2gtk-4.0 < 2.41.92... no
# configure: error: xwidgets requested but WebKitGTK+ or WebKit framework not found.

# _config_flags+=(--with-xwidgets)
# depends+=(webkit2gtk webkit2gtk-4.1)

function _clean_old() {
    # [[ -f ./configure ]] && rm ./configure
    [[ -f ./configure ]] || ./autogen.sh
    # mostlyclean doesn't delete stale native-lisp/*
    make clean
}

function build() {

    export PATH="/usr/lib/ccache/bin/:$PATH"

    function _build_helper() {
        _clean_old
        echo ./configure "$@"
        ./configure "$@"
        make
    }

    # options specific for a system-wide installation

    deleting_conf_flags=("--without-gconf" "--without-gsettings"
        # "--with-native-compilation"
    )

    for del_elem in "${deleting_conf_flags[@]}"; do
        _config_flags=("${_config_flags[@]/$del_elem/}")
    done

    # _config_flags+=(--with-native-compilation=aot)
    # _config_flags+=(--without-compress-install)

    # error: /usr/local/share/man exists in filesystem (owned by filesystem)
    local prefixes=(
        --prefix=/usr/local
        --mandir=/usr/local/man
        --sysconfdir=/etc
        --localstatedir=/var
    )

    if printf "%s\0" "${pkgname[@]}" | grep -Fqxz -- "emacs-my-build"; then
        cd "${srcdir}/emacs-my-build"
        _build_helper "${_config_flags[@]}" "${_config_flags_no_debug[@]}" "${prefixes[@]}"
    fi

    if printf "%s\0" "${pkgname[@]}" | grep -Fqxz -- "emacs-my-build-aot-native-comp"; then
        cd "${srcdir}/emacs-my-build-aot-native-comp"
        _build_helper "${_config_flags[@]}" "${_config_flags_no_debug[@]}" --prefix=/opt/emacs-my-build-aot-native-comp/ --with-native-compilation=aot
    fi

    if printf "%s\0" "${pkgname[@]}" | grep -Fqxz -- "emacs-my-build-debug"; then
        cd "${srcdir}/emacs-my-build-debug"
        _build_helper "${_config_flags[@]}" "${_config_flags_debug[@]}" --prefix=/opt/emacs-my-build-debug/
    fi

}

function package_emacs-my-build() {
    cd "emacs-my-build"
    make DESTDIR="$pkgdir/" install
    find "$pkgdir" -maxdepth 1 -exec chown -R root:root {} \;
}

function package_emacs-my-build-aot-native-comp() {
    cd "emacs-my-build-aot-native-comp"
    make DESTDIR="$pkgdir/" install
    find "$pkgdir" -maxdepth 1 -exec chown -R root:root {} \;
}

function package_emacs-my-build-debug() {
    cd "emacs-my-build-debug"
    make DESTDIR="$pkgdir/" install
    find "$pkgdir" -maxdepth 1 -exec chown -R root:root {} \;
}
