# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils perl-functions cmake-utils wxwidgets

WX_GTK_VER="3.0-gtk3"

DESCRIPTION="A mesh slicer to generate G-code for fused-filament-fabrication (3D printers)"
HOMEPAGE="http://slic3r.org"
#SRC_URI="https://github.com/prusa3d/slic3r/archive/version_${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://github.com/prusa3d/PrusaSlicer/archive/version_2.3.0.tar.gz -> ${P}.tar.gz"
MASTERS=gentoo

LICENSE="AGPL-3 CC-BY-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+gui perl test static"

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
	test? ( dev-cpp/gtest )
	gui? ( x11-libs/wxGTK[opengl,webkit]
			media-libs/glew
			media-libs/libpng )
	dev-libs/expat"
DEPEND="${RDEPEND}
	dev-cpp/tbb
	>=net-misc/curl-7.58.0
	dev-libs/openssl
	sci-libs/nlopt[cxx]
	!static? ( dev-cpp/eigen )
	static? ( dev-libs/openssl )"

#S="${WORKDIR}/Slic3r-version_${PV}/"
S="${WORKDIR}/PrusaSlicer-version_2.3.0/"

src_prepare() {
	#pushd "${WORKDIR}/Slic3r-version_${PV}" || die
	pushd "${WORKDIR}/PrusaSlicer-version_2.3.0" || die
	#eapply "${FILESDIR}/${P}-add_install.patch"
	#eapply "${FILESDIR}/${P}-fix_disappearing_tabs.patch"
	#eapply "${FILESDIR}/${P}-cmake_paths.patch"
	#eapply "${FILESDIR}/${P}-adjust_var_path.patch"
	cmake-utils_src_prepare
	#eapply_user
	popd || die
}

src_configure() {
	use gui && setup-wxwidgets
	#SLIC3R_NO_AUTO=1 perl-module_src_configure
	local mycmakeargs=(
		-DSLIC3R_FHS=ON
		-DSLIC3R_WX_STABLE=ON
		-DSLIC3R_GUI="$(usex gui)"
		-DSLIC3R_STATIC="$(usex static)"
		-DSLIC3R_BUILD_TESTS="$(usex test)"
	)

	cmake-utils_src_configure
}

#src_test() {
#	perl-module_src_test
#	pushd .. || die
#	prove -Ixs/blib/arch -Ixs/blib/lib/ t/ || die "Tests failed"
#	popd || die
#}

src_install() {
	cmake-utils_src_install
#	pushd lib || die
#	perl_domodule -C Slic3r -r .
#	popd

#	perl-module_src_install

#	pushd .. || die
#	insinto "${VENDOR_LIB}"
#	doins -r lib/Slic3r.pm lib/Slic3r

#	insinto "${VENDOR_LIB}"/Slic3r
#	doins -r var

#	exeinto "${VENDOR_LIB}"/Slic3r
#	doexe slic3r.pl

#	dosym "${ED%/}"/usr/bin/slic3r-prusa3d /usr/bin/slic3r.pl

	make_desktop_entry prusa-slicer \
		"PrusaSlicer" \
		"/usr/share/PrusaSlicer/icons/PrusaSlicer.icns" \
		"Graphics;3DGraphics;Engineering;Development"
#	popd || die
}
