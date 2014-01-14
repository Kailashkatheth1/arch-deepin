# Maintainer: Xu Fasheng <fasheng.xu[AT]gmail.com>

pkgname=deepin-terminal
pkgver={% pkgver %}
pkgrel=1
pkgdesc='Awesome terminal for Linux Deepin'
arch=('any')
url="http://www.linuxdeepin.com/"
license=('GPL2')
depends=('deepin-ui' 'deepin-vte-plus' 'python2-dbus')

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

    _easycp "${pkgdir}"/usr/share/deepin-terminal/ app_theme
    _easycp "${pkgdir}"/usr/share/deepin-terminal/ locale
    _easycp "${pkgdir}"/usr/share/deepin-terminal/ skin
    _easycp "${pkgdir}"/usr/share/deepin-terminal/ src
    _easycp "${pkgdir}"/usr/share/deepin-terminal/ image
    _easycp "${pkgdir}"/usr/share/deepin-terminal/ tools
    _easycp "${pkgdir}"/usr/share/icons/hicolor/24x24/apps/ deepin-terminal.png

    mkdir -p "${pkgdir}"/usr/share/applications
    install -m 0644 deepin-terminal.desktop "${pkgdir}"/usr/share/applications/

    mkdir -p "${pkgdir}"/usr/bin
    ln -s /usr/share/deepin-terminal/src/main.py "${pkgdir}"/usr/bin/deepin-terminal

    _install_copyright_and_changelog

    # fix python version
    find "${pkgdir}" -iname "*.py" | xargs sed -i 's=\(^#! */usr/bin.*\)python=\1python2='

    # there is no 'XHei' font on archinux, so replace it
    sed -i 's/XHei Mono.Ubuntu/Monospace/' "${pkgdir}"/usr/share/deepin-terminal/src/main.py
}
