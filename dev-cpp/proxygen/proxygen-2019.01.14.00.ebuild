# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=1
AUTOTOOLS_AUTORECONF=1
inherit autotools-utils

DESCRIPTION="A collection of C++ HTTP libraries including an easy to use HTTP server"
HOMEPAGE="https://github.com/facebook/proxygen"
SRC_URI="https://github.com/facebook/proxygen/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs test"

RDEPEND=">=dev-cpp/folly-0.35.0
		dev-cpp/wangle
		sys-libs/libcap"
DEPEND="${RDEPEND}
		sys-devel/autoconf-archive
		dev-util/gperf"
#		test? ( dev-cpp/gmock )"

S="${WORKDIR}/${P}/${PN}"

#PATCHES=( "${FILESDIR}/proxygen-0.29.0-optional-tests.diff" )
