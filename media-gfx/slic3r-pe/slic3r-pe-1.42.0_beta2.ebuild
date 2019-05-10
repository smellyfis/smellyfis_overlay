# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils perl-functions cmake-utils wxwidgets

WX_GTK_VER="3.1"

DESCRIPTION="A mesh slicer to generate G-code for fused-filament-fabrication (3D printers)"
HOMEPAGE="http://slic3r.org"
#SRC_URI="https://github.com/prusa3d/slic3r/archive/version_${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://github.com/prusa3d/slic3r/archive/version_1.42.0-beta2.tar.gz -> ${P}.tar.gz"
MASTERS=gentoo

LICENSE="AGPL-3 CC-BY-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+gui perl test static"

RDEPEND=">=dev-libs/boost-1.55[threads]
	perl? ( !=dev-lang/perl-5.16*
		dev-perl/Class-XSAccessor
		>=dev-perl/Encode-Locale-1.50.0
		dev-perl/IO-stringy
		>=dev-perl/Math-PlanePath-53.0.0
		>=dev-perl/Moo-1.3.1
		dev-perl/XML-SAX-ExpatXS
		dev-perl/local-lib
		virtual/perl-Carp
		virtual/perl-Encode
		virtual/perl-File-Spec
		virtual/perl-Getopt-Long
		virtual/perl-parent
		virtual/perl-Scalar-List-Utils
		virtual/perl-Test-Simple
		virtual/perl-Thread-Semaphore
		>=virtual/perl-threads-1.960.0
		virtual/perl-Time-HiRes
		virtual/perl-Unicode-Normalize
		virtual/perl-XSLoader
	gui? ( dev-perl/Class-Accessor
		dev-perl/Growl-GNTP
		dev-perl/libwww-perl
		dev-perl/Module-Pluggable
		dev-perl/Net-Bonjour
		dev-perl/Net-DBus
		dev-perl/OpenGL
		>=dev-perl/Wx-0.991.800
		dev-perl/Wx-GLCanvas
		>=media-libs/freeglut-3
		virtual/perl-Math-Complex
		>=virtual/perl-Socket-2.16.0
		x11-libs/libXmu
		) )
	gui? ( x11-libs/wxGTK[opengl,webkit] )"
DEPEND="${RDEPEND}
	dev-cpp/tbb
	net-misc/curl
	sci-libs/nlopt[cxx]
	!static? ( dev-cpp/eigen
		dev-libs/expat
		media-libs/glew )
	static? ( dev-libs/openssl )
	perl? ( >=dev-perl/ExtUtils-CppGuess-0.70.0
		>=dev-perl/ExtUtils-Typemaps-Default-1.50.0
		>=dev-perl/ExtUtils-XSpp-0.170.0
		>=dev-perl/Module-Build-0.380.0
		>=dev-perl/Module-Build-WithXSpp-0.140.0
		>=virtual/perl-ExtUtils-MakeMaker-6.800.0
		>=virtual/perl-ExtUtils-ParseXS-3.220.0
	)
	test? ( perl? (	virtual/perl-Test-Harness
	virtual/perl-Test-Simple ) )"

#S="${WORKDIR}/Slic3r-version_${PV}/"
S="${WORKDIR}/Slic3r-version_1.42.0-beta2/"

src_prepare() {
	#pushd "${WORKDIR}/Slic3r-version_${PV}" || die
	pushd "${WORKDIR}/Slic3r-version_1.42.0-beta2" || die
	#eapply "${FILESDIR}/${P}-add_install.patch"
	#eapply "${FILESDIR}/${P}-fix_disappearing_tabs.patch"
	#eapply "${FILESDIR}/${P}-cmake_paths.patch"
	#eapply "${FILESDIR}/${P}-adjust_var_path.patch"
	setup-wxwidgets
	cmake-utils_src_prepare
	#eapply_user
	popd || die
}

src_configure() {
	#SLIC3R_NO_AUTO=1 perl-module_src_configure
	local mycmakeargs=(
		-DSLIC3R_FHS=ON
		-DSLIC3R_GUI="$(usex gui)"
		-DSLIC3r_PERL_XS="$(usex perl)"
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

	make_desktop_entry slic3r-gui \
		"Slic3r Prusa Edition" \
		"/usr/share/slic3r-prusa3d/icons/Slic3r.icns" \
		"Graphics;3DGraphics;Engineering;Development"
#	popd || die
}
