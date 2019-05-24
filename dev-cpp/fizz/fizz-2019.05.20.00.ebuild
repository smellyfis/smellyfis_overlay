# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="An open-source C++ library developed and used at Facebook"
HOMEPAGE="https://github.com/facebookincubator/fizz"
SRC_URI="https://github.com/facebookincubator/fizz/archive/v2019.05.20.00.tar.gz"
KEYWORDS="~amd64"

LICENSE="Apache-2.0"
SLOT="0"
#IUSE="static-libs debug"
IUSE=""

DEPEND="dev-libs/double-conversion
		dev-libs/libevent
		dev-libs/openssl:*
		dev-cpp/gflags
		dev-cpp/glog
		>=dev-libs/boost-1.51.0[context,threads]
		app-arch/lz4
		app-arch/snappy
		sys-libs/zlib
		app-arch/xz-utils
		app-arch/lzma
		dev-libs/jemalloc"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/${PN}"
