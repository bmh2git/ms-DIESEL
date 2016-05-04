#!/bin/sh

# Make these items external variables
PGMNAM=OpenSSL
MAJVER=1_0_2g
GITREP=https://github.com/openssl/openssl.git
export RELEASENUM=7
LANDINGZONE=/software/OpenSSL/RHEL7/64bit
REPODIR=/data02/RHEL7/OpenSSL
REMDIR="/root/${RPMNAME}-$RPMVERSION"
RPMBLD="/root/rpmbuild"

# These are being contructed
TAGNAME="${PGMNAM}_${MAJVER}"
RPMNAME="${PGMNAM}-CTL"
export RPMVERSION=$(echo ${MAJVER} | sed -e "s/_/./g")
TARBALL="${RPMBLD}/SOURCES/${RPMNAME}-${RPMVERSION}.tar.gz"
SPECFILE="${RPMBLD}/SPECS/openssl.spec"
RELEASENUM="7"

## Configure Environment on target server
mkdir -p ${RPMBLD}/SPECS
mkdir -p ${RPMBLD}/SOURCES
mkdir -p ${REMDIR}/
cp openssl.spec ${SPECFILE}

# Download the current version
echo "Current Tag = "${TAGNAME}
wget -O ${TARBALL} https://github.com/openssl/openssl/tarball/${TAGNAME}

# Reformat the tarfile
mkdir -p ${RPMBLD}/SOURCES/temp
cd ${RPMBLD}/SOURCES/temp
tar zxf ${TARBALL}
mv $(ls) ${RPMNAME}-${RPMVERSION}
tar zxf ${TARBALL}
tar zcf ${TARBALL} ${RPMNAME}-${RPMVERSION}/
rm -rf ${RPMBLD}/SOURCES/temp

# Install Pre-requisits
yum install -y rpm-build
yum install -y gcc

# Start RPM Build
echo;echo;echo;
echo "starting build"
rpmbuild -ba ${SPECFILE}
