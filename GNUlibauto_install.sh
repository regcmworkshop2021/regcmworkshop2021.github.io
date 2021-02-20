#!/bin/bash
#
# INSTALL AUTOTOOLS
#
# Requires wget program
#
# CHEK HERE BELOW THE COMPILERS
#
# Working CC Compiler
CC="gcc -fPIC"
#CC="icc -fPIC"
#CC="pgcc -fpic -DpgiFortran"
#CC="xlc_r -qpic"
# Working C++ Compiler
CXX="g++ -fPIC"
#CXX="icpc -fPIC"
#CXX="pgCC -fpic"
#CXX="xlc++_r -qpic"
# Working Fortran Compiler
FC="gfortran -fPIC"
#FC="ifort -fPIC"
#FC="pgf90 -fpic"
#FC="xlf2003_r -qpic"
# Destination directory
DEST=$PWD
DEST=${DEST}/GNUlibauto
mkdir $DEST

PREFIX=$DEST

autoconf_ver=2.69
automake_ver=1.15
libtool_ver=2.4.6

AUTOCONF=ftp://ftp.gnu.org/gnu/autoconf
AUTOMAKE=ftp://ftp.gnu.org/gnu/automake
LIBTOOL=ftp://ftp.gnu.org/gnu/libtool

export PATH=$DEST/bin:$PATH
export LD_LIBRARY_PATH=$DEST/lib:$LD_LIBRARY_PATH

if [ -z "$DEST" ]
then
  echo "SCRIPT TO INSTALL AUTOCONF AUTOMAKE LIBTOOL LIBRARIES."
  echo "EDIT ME TO DEFINE DEST, CC AND FC VARIABLE"
  exit 1
fi

MAKE=`which gmake 2> /dev/null`
if [ -z "$MAKE" ]
then
  echo "Assuming make program is GNU make program"
  MAKE=make
fi

WGET=`which wget 2> /dev/null`
if [ -z "$WGET" ]
then
  echo "wget programs must be installed to download netCDF lib."
  exit 1
fi

WGET="$WGET --no-check-certificate"

echo "This script installs the Autotools librares in the"
echo
echo -e "\t $DEST"
echo
echo "directory. If something goes wrong, logs are saved in"
echo
echo -e "\t$DEST/logs"
echo

cd $DEST
mkdir -p $DEST/logs
echo "Downloading Autoconf library..."
$WGET -c $AUTOCONF/autoconf-${autoconf_ver}.tar.gz -o $DEST/logs/download_autoconf.log
if [ $? -ne 0 ]
then
  echo "Error downloading Autoconf library from ftp.gnu.org"
  exit 1
fi
echo "Downloading Automake library..."
$WGET -c $AUTOMAKE/automake-${automake_ver}.tar.gz \
      -o $DEST/logs/download_automake.log
if [ $? -ne 0 ]
then
  echo "Error downloading Automake library from ftp.gnu.org"
  exit 1
fi
echo "Downloading Libtool Library..."
$WGET -c $LIBTOOL/libtool-${libtool_ver}.tar.gz -o $DEST/logs/download_libtool.log
if [ $? -ne 0 ]
then
  echo "Error downloading Libtool library from ftp.gnu.org"
  exit 1
fi

rm -f logs/*.log

echo "Compiling Autoconf Library."
tar zxvf autoconf-${autoconf_ver}.tar.gz >> $DEST/logs/extract.log
if [ $? -ne 0 ]
then
  echo "Error uncompressing Autoconf library"
  exit 1
fi
cd autoconf-${autoconf_ver}
echo ./configure CC="$CC" FC="$FC" CXX="$CXX" --prefix=$DEST >> \
	$DEST/logs/configure.log
./configure --prefix=$DEST CC="$CC" FC="$FC" >> \
             $DEST/logs/configure.log 2>&1
$MAKE >> $DEST/logs/compile.log 2>&1 && \
  $MAKE install >> $DEST/logs/install.log 2>&1
if [ $? -ne 0 ]
then
  echo "Error compiling Autoconf library"
  exit 1
fi
cd $DEST
rm -fr autoconf-${autoconf_ver}
echo "Compiled Autoconf library."

echo "Compiling Automake Library."
tar zxvf automake-${automake_ver}.tar.gz >> $DEST/logs/extract.log
if [ $? -ne 0 ]
then
  echo "Error uncompressing Automake library"
  exit 1
fi
cd automake-${automake_ver}
echo ./configure CC="$CC" FC="$FC" CXX="$CXX" --prefix=$DEST >> \
	$DEST/logs/configure.log
./configure --prefix=$DEST CC="$CC" FC="$FC" >> \
             $DEST/logs/configure.log 2>&1
$MAKE >> $DEST/logs/compile.log 2>&1 && \
  $MAKE install >> $DEST/logs/install.log 2>&1
if [ $? -ne 0 ]
then
  echo "Error compiling Automake library"
  exit 1
fi
cd $DEST
rm -fr automake-${automake_ver}
echo "Compiled Automake library."


echo "Compiling Libtool Library."
tar zxvf libtool-${libtool_ver}.tar.gz >> $DEST/logs/extract.log
if [ $? -ne 0 ]
then
  echo "Error uncompressing Libtool library"
  exit 1
fi
cd libtool-${libtool_ver}
echo ./configure CC="$CC" FC="$FC" CXX="$CXX" --prefix=$DEST >> \
	$DEST/logs/configure.log
./configure --prefix=$DEST CC="$CC" FC="$FC" >> \
             $DEST/logs/configure.log 2>&1
$MAKE >> $DEST/logs/compile.log 2>&1 && \
  $MAKE install >> $DEST/logs/install.log 2>&1
if [ $? -ne 0 ]
then
  echo "Error compiling Libtool library"
  exit 1
fi
cd $DEST
rm -fr libtool-${libtool_ver}
echo "Compiled Libtool library."

# Done
CC=`echo $CC | cut -d " " -f 1`
FC=`echo $FC | cut -d " " -f 1`
echo
echo "export LD_LIBRARY_PATH=$DEST/lib:\$LD_LIBRARY_PATH"
echo "export PATH=$DEST/bin:\$PATH"
echo
echo or
echo
echo "setenv LD_LIBRARY_PATH $DEST/lib:\$LD_LIBRARY_PATH"
echo "setenv PATH $DEST/bin:\$PATH"
echo "rehash"
echo

echo "Cleanup..."
mkdir -p src && mv -f *gz src || exit 1
exit 0
