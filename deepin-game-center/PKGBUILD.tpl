# Maintainer: Xu Fasheng <fasheng.xu[AT]gmail.com>
# Contributor: Josip Ponjavic <josipponjavic at gmail dot com>


pkgname=deepin-game-center
pkgver={% pkgver %}
pkgrel=1
pkgdesc="Game center for Linuxdeepin"
arch=('any')
url="https://github.com/linuxdeepin/deepin-game-center"
license=('GPL2')
depends=('deepin-ui' 'flashplugin' 'hicolor-icon-theme' 'python2' 'python2-deepin-storm' 'python2-scipy' 'python2-jswebkit')
install=${pkgname}.install

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

prepare() {
    cd "${srcdir}/${_innerdir}"

    # fix python version
    find -iname "*.py" | xargs sed -i 's=\(^#! */usr/bin.*\)python=\1python2='
}

package() {
    cd "${srcdir}/${_innerdir}"

    mkdir -p "${pkgdir}"/usr/{bin,share/{${pkgname},applications,icons/hicolor/48x48/apps}}

    cp -rf {app_theme,image,locale,skin,src,static,weibo_skin,weibo_theme} "${pkgdir}/usr/share/${pkgname}"

    install -m 0755 "${pkgname}.desktop" "${pkgdir}/usr/share/applications/"
    install -m 0755 "debian/${pkgname}.png" "${pkgdir}/usr/share/icons/hicolor/48x48/apps/"
    ln -s /usr/share/${pkgname}/src/${pkgname}.py "${pkgdir}/usr/bin/${pkgname}"

    _install_copyright_and_changelog
}
