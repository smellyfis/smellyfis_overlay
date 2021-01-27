# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="a full featured, high performance C++ futures implementation"
HOMEPAGE="https://github.com/facebook/wangle"
SRC_URI="https://github.com/facebook/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz "

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test examples +static-libs"

RDEPEND="dev-cpp/folly
		dev-cpp/fizz
		dev-libs/openssl:*
		>=dev-libs/boost-1.51.0[context,threads]
		sys-libs/zlib
		dev-cpp/wangle"
DEPEND="${RDEPEND}"
#		test? ( dev-cpp/gmock )"

S="${WORKDIR}/${P}/${PN}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS="$(usex test)"
		-DBUILD_EXAMPLES="$(usex examples)"
		-DBUILD_SHARED_LIBS="$(usex static-libs OFF ON)"
	)

	cmake-utils_src_configure
}
