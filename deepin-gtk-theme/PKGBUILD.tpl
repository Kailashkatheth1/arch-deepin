# Maintainer: Xu Fasheng <fasheng.xu[AT]gmail.com>
# Contributor: Josip Ponjavic <josipponjavic at gmail dot com>

pkgname=deepin-gtk-theme
pkgver={% pkgver %}
pkgrel=1
pkgdesc='Gtk3 theme from Linux Deepin'
arch=('any')
url="http://www.linuxdeepin.com/"
license=('LGPL3')
depends=('gtk-engine-unico')

_fileurl={% fileurl %}
source=("${_fileurl}")
md5sums=('{% md5 %}')

_filename="$(basename "${_fileurl}")"
_filename="${_filename%.tar.gz}"
_innerdir="${_filename/_/-}"

_install_copyright_and_changelog() {
    mkdir -p "${pkgdir}/usr/share/doc/${pkgname}"
    cp -f debian/copyright "${pkgdir}/usr/share/doc/${pkgname}/"
    gzip -c debian/changelog > "${pkgdir}/usr/share/doc/${pkgname}/changelog.gz"
}

# Usage: _easycp dest files...
_easycp () {
    local dest=$1; shift
    mkdir -p "${dest}"
    cp -R -t "${dest}" "$@"
}

package() {
    cd "${srcdir}/${_innerdir}"

    _easycp "${pkgdir}"/usr/share/backgrounds debian/backgrounds/*
    _easycp "${pkgdir}"/usr/share/themes/Deepin-Legacy Deepin/*
    _easycp "${pkgdir}"/usr/share/themes/Deepin Deepin-Dark/*

    # change gtk-theme name
    sed -i 's/Deepin-Dark/Deepin/g' "$pkgdir/usr/share/themes/Deepin/index.theme"
    sed -i 's/Deepin/Deepin-Legacy/g' "$pkgdir/usr/share/themes/Deepin-Legacy/index.theme"

    _install_copyright_and_changelog
}
