# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake wxwidgets desktop xdg-utils

WX_GTK_VER="3.0-gtk3"

MY_PN="PrusaSlicer"

DESCRIPTION="A mesh slicer to generate G-code for fused-filament-fabrication (3D printers)"
HOMEPAGE="http://slic3r.org"
SRC_URI="https://github.com/prusa3d/${MY_PN}/archive/version_${PV}.tar.gz -> ${P}.tar.gz"
MASTERS=gentoo

LICENSE="AGPL-3 CC-BY-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+gui test static"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-libs/boost-1.75[threads]
	media-libs/qhull[static-libs]
	>=sci-mathematics/cgal-5.0.2
	dev-libs/cereal
	dev-libs/c-blosc
	media-libs/openexr
	dev-libs/mpfr
	dev-libs/gmp
	media-gfx/openvdb
	media-gfx/opencsg
	media-libs/glew:0=
	media-libs/libpng
	gui? ( x11-libs/wxGTK[opengl,webkit,X] )
	dev-libs/expat"
DEPEND="${RDEPEND}
	dev-cpp/tbb
	>=net-misc/curl-7.58.0
	dev-libs/openssl
	sci-libs/nlopt[cxx]
	!static? ( dev-cpp/eigen )
	static? ( dev-libs/openssl )"

S="${WORKDIR}/${MY_PN}-version_${PV}/"
PATCHES=(
	"${FILESDIR}/${P}-miniz-zip-header.patch"
)

src_prepare() {
	use gui && setup-wxwidgets
	cmake_src_prepare
}

src_configure() {
	CMAKE_BUILD_TYPE=Release

	local mycmakeargs=(
		-DSLIC3R_FHS=ON
		-DSLIC3R_WX_STABLE=ON
		-DSLIC3R_GUI="$(usex gui)"
		-DSLIC3R_STATIC="$(usex static)"
		-DSLIC3R_PCH=OFF
		-DSLIC3R_BUILD_TESTS="$(usex test)"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	doicon resources/icons/PrusaSlicer.png || die
	domenu "${FILESDIR}/PrusaGcodeviewer.desktop" || die
	domenu "${FILESDIR}/PrusaSlicer.desktop" || die
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
