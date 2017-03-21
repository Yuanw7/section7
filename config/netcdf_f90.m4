#

# from http://www.arsc.edu/support/news/HPCnews/HPCnews249.shtml
#
#        Copyright (C) 2000-2016 the YAMBO team
#              http://www.yambo-code.org
#
# Authors (see AUTHORS file for details): AM, AF, DS
#
# This file is distributed under the terms of the GNU
# General Public License. You can redistribute it and/or
# modify it under the terms of the GNU General Public
# License as published by the Free Software Foundation;
# either version 2, or (at your option) any later version.
#
# This program is distributed in the hope that it will
# be useful, but WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public
# License along with this program; if not, write to the Free
# Software Foundation, Inc., 59 Temple Place - Suite 330,Boston,
# MA 02111-1307, USA or visit http://www.gnu.org/copyleft/gpl.txt.
#
AC_DEFUN([AC_HAVE_NETCDF_F90],[

AC_ARG_WITH(netcdf_libs,AC_HELP_STRING([--with-netcdf-libs=<libs>],
            [Use NetCDF libraries <libs>],[32]))
AC_ARG_WITH(netcdf_path, AC_HELP_STRING([--with-netcdf-path=<path>],
            [Path to the NetCDF install directory],[32]),[],[])
AC_ARG_WITH(netcdf_libdir,AC_HELP_STRING([--with-netcdf-libdir=<path>],
            [Path to the NetCDF lib directory],[32]))
AC_ARG_WITH(netcdf_includedir,AC_HELP_STRING([--with-netcdf-includedir=<path>],
            [Path to the NetCDF include directory],[32]))
#
AC_ARG_WITH(netcdff_libs,AC_HELP_STRING([--with-netcdff-libs=<libs>],
            [Use NetCDFF libraries <libs>],[32]))
AC_ARG_WITH(netcdff_path, AC_HELP_STRING([--with-netcdff-path=<path>],
            [Path to the NetCDFF install directory],[32]),[],[])
AC_ARG_WITH(netcdff_libdir,AC_HELP_STRING([--with-netcdff-libdir=<path>],
            [Path to the NetCDFF lib directory],[32]))
AC_ARG_WITH(netcdff_includedir,AC_HELP_STRING([--with-netcdff-includedir=<path>],
            [Path to the NetCDFF include directory],[32]))
#
AC_ARG_WITH(hdf5_libs,AC_HELP_STRING([--with-hdf5-libs=<libs>],
            [Use HDF5 libraries <libs>],[32]))
AC_ARG_WITH(hdf5_path, AC_HELP_STRING([--with-hdf5-path=<path>],
            [Path to the HDF5 install directory],[32]),[],[])
AC_ARG_WITH(hdf5_libdir,AC_HELP_STRING([--with-hdf5-libdir=<path>],
            [Path to the HDF5 lib directory],[32]))
AC_ARG_WITH(hdf5_includedir,AC_HELP_STRING([--with-hdf5-includedir=<path>],
            [Path to the HDF5 include directory],[32]))
#
# Large Databases Support (LFS)
#
AC_ARG_ENABLE(netcdf-classic, AC_HELP_STRING([--enable-netcdf-classic],
             [Switch to OLD NetCDF classic. Default is no.]))
#
# HDF5 support
#
AC_ARG_ENABLE(netcdf_hdf5,AC_HELP_STRING([--enable-netcdf-hdf5],
             [Activate the HDF5 support. Default is no.]))
#
#
# HDF5 data compression
#
AC_ARG_ENABLE(hdf5_compression,AC_HELP_STRING([--enable-hdf5-compression],
             [Activate the HDF5 data compression. Default is no.]))
#
enable_netcdf="no"
enable_hdf5="no"
compile_netcdf="no"
compile_hdf5="no"
dnetcdf=""
NETCDF_OPT="--disable-netcdf-4"
IFLAG=""
#
# global options
#
#
if test -d "$with_hdf5_libdir"          ; then enable_hdf5=yes ; fi
if test -d "$with_hdf5_path"            ; then enable_hdf5=yes ; fi
if test x"$with_hdf5_libs" != "x"       ; then enable_hdf5=yes ; fi
if test x"$enable_netcdf_hdf5" = "xyes" ; then enable_hdf5=yes ; fi
#
# F90 module flag
#
IFLAG=$ax_cv_f90_modflag
if test -z "$IFLAG" ; then IFLAG="-I" ; fi
#
# Set NETCDF LIBS and FLAGS from INPUT
#
if test -d "$with_netcdf_path" || test -d "$with_netcdf_libdir" ; then
  #
  # external netcdf
  #
  if test -d "$with_netcdf_libdir" ; then AC_MSG_CHECKING([for NetCDF in $with_netcdf_libdir]) 
  elif test -d "$with_netcdf_path" ; then AC_MSG_CHECKING([for NetCDF in $with_netcdf_path]) 
  fi
  #
  if test -d "$with_netcdf_path" ; then 
      try_libdir=$with_netcdf_path/lib
      try_incdir=$with_netcdf_path/include
  fi
  if test -d "$with_netcdff_path" ; then 
      tryf_libdir=$with_netcdff_path/lib
      tryf_incdir=$with_netcdff_path/include
  fi
  #
  if test -d "$with_netcdf_libdir"     ; then try_libdir=$with_netcdf_libdir ; fi
  if test -d "$with_netcdf_includedir" ; then try_incdir=$with_netcdf_includedir ; fi
  #
  if test -d "$with_netcdff_libdir"     ; then tryf_libdir=$with_netcdff_libdir ; fi
  if test -d "$with_netcdff_includedir" ; then tryf_incdir=$with_netcdff_includedir ; fi
  #
  if test -z "$try_libdir" ; then AC_MSG_ERROR([No lib-dir specified]) ; fi
  if test -z "$try_incdir" ; then AC_MSG_ERROR([No include-dir specified]) ; fi
  #
  AC_LANG([Fortran])
  #
  try_NETCDF_INCS="$IFLAG$try_incdir"
  if test -d "$tryf_incdir" ; then
    try_NETCDF_INCS="$IFLAG$try_incdir $IFLAG$tryf_incdir"
  fi
  #
  try_NETCDF_LIBS="-L$try_libdir -lnetcdf"
  if test -r $tryf_libdir/libnetcdff.a ; then
    try_NETCDF_LIBS="-L$tryf_libdir -lnetcdff -L$try_libdir -lnetcdf"
  elif test -r $try_libdir/libnetcdff.a ; then
    try_NETCDF_LIBS="-L$try_libdir -lnetcdff -lnetcdf"
  fi
  #
elif test x"$with_netcdf_libs" != "x" ; then
  #
  # directly provided lib
  #
  AC_MSG_CHECKING([for NetCDF Library using $with_netcdf_libs])
  compile_netcdf="no"
  if test -d "$with_netcdf_includedir" ; then  try_NETCDF_INCS="$IFLAG$with_netcdf_includedir" ; fi
  if test -d "$with_netcdff_includedir" ; then try_NETCDF_INCS="$NETCDF_INCS $IFLAG$with_netcdff_includedir" ; fi
  netcdf=yes
  try_NETCDF_LIBS="$with_netcdff_libs $with_netcdf_libs" 
  AC_MSG_RESULT(yes)
  #
fi
#
# TEST NETCDF LIBS and FLAGS
#
if test x"$enable_hdf5" = "xno"; then
  #
  netcdf=no;
  #
  if test -d "$with_netcdf_path" || test -d "$with_netcdf_libdir" || test x"$with_netcdf_libs" != "x"; then
    #
    save_fcflags="$FCFLAGS"
    save_libs="$LIBS"
    #
    FCFLAGS="$try_NETCDF_INCS $save_fcflags";
    LIBS="$try_NETCDF_LIBS $save_libs";
    #
     AC_COMPILE_IFELSE(AC_LANG_PROGRAM([], [
       use netcdf
       implicit none
       integer nf_err
       integer ID
       nf_err = nf90_create('netcdf_test',nf90_share,ID)]),
       [netcdf=yes], [netcdf=no]);
    #
    if test "x$netcdf" = xyes; then
      AC_MSG_RESULT([yes])
      NETCDF_INCS="$try_NETCDF_INCS"
      NETCDF_LIBS="$try_NETCDF_LIBS"
    else
      AC_MSG_RESULT([no])
    fi
    #
    FCFLAGS="$save_fcflags"
    LIBS="$save_libs"
    #
  fi
  if test "x$netcdf" = xno; then
    #
    # internal netcdf
    #
    AC_MSG_CHECKING([for internal NetCDF library])
    #
    compile_netcdf="yes"
    if test "x$build_os" = "xaix" ; then ETCDF_AUX=-DIBMR2Fortran ; fi
    # 
    # the following may change if we use a different version
    # of the netcdf lib
    #
    #NETCDF_LIBS="-L${extlibs_path}/lib -lnetcdf"
    NETCDF_LIBS="-L${extlibs_path}/lib -lnetcdff -lnetcdf"
    NETCDF_INCS="${IFLAG}${extlibs_path}/include"
    #
    netcdf=yes
    AC_MSG_RESULT([ok])
    #
  fi
  #
fi
#
#
# HDF5 support
#
hdf5="no"
#
if test x"$enable_hdf5" = "xyes"; then
  #
  if   test -d "$with_hdf5_libdir"    ; then AC_MSG_CHECKING([for HDF5 in $with_hdf5_libdir]) 
  elif test -d "$with_hdf5_path"    ;   then AC_MSG_CHECKING([for HDF5 in $with_hdf5_path]) 
  elif test x"$with_hdf5_libs" != "x" ; then AC_MSG_CHECKING([for HDF5 using $with_hdf5_libs])
  fi
  #
  AC_LANG([Fortran])       
  #
  # re-define lib and inc dirs
  #
  if test -d "$with_hdf5_path" ; then 
      try_libdir=$with_hdf5_path/lib
      try_incdir=$with_hdf5_path/include
  fi
  if test -d "$with_hdf5_libdir"     ; then try_libdir=$with_hdf5_libdir ; fi
  if test -d "$with_hdf5_includedir" ; then try_incdir=$with_hdf5_includedir ; fi
  #
  if test x"$with_hdf5_libs" != "x" ; then try_HDF5_LIBS="$with_hdf5_libs" ; fi
  #
  if test -d "$try_libdir" ; then try_HDF5_LIBS="-L$try_libdir -lhdf5hl_fortran -lhdf5_fortran -lhdf5_hl -lhdf5" ; fi
  #
  if test -d "$try_incdir" ; then try_HDF5_INCS="$IFLAG$try_incdir" ; fi
  #
  save_libs="$LIBS"
  save_fcflags="$FCFLAGS"
  #
  FCFLAGS="$try_NETCDF_INCS $try_HDF5_INCS $save_fcflags"
  #
  for ldflag in "-lcurl -lz"           "-lcurl -lsz -lz"           "-lsz -lz"           "-lz"           " " \
                "-lcurl -lz -lm"       "-lcurl -lsz -lz -lm"       "-lsz -lz -lm"       "-lz -lm"       "-lm" \
                "-lcurl -lz -ldl"      "-lcurl -lsz -lz -ldl"      "-lsz -lz -ldl"      "-lz -ldl"      "-ldl" \
                "-lcurl -lz -lm -ldl"  "-lcurl -lsz -lz -lm -ldl"  "-lsz -lz -lm -ldl"  "-lz -lm -ldl"  "-lm -ldl"; do
    LIBS="$try_NETCDF_LIBS $try_HDF5_LIBS $ldflag"
    AC_LINK_IFELSE(AC_LANG_PROGRAM([], [
       use hdf5
       use netcdf
       implicit none
       integer cmode
       cmode = NF90_HDF5
       cmode = nf90_abort(1)
       call h5open_f(cmode)]),
       [hdf5=yes], [hdf5=no]);
    netcdf=$hdf5;
    if test "x$hdf5" = xyes; then
      HDF5_LIBS="$try_HDF5_LIBS $ldflag"
      HDF5_INCS="$try_HDF5_INCS"
      NETCDF_LIBS="$try_NETCDF_LIBS"
      NETCDF_INCS="$try_NETCDF_INCS"
      AC_MSG_RESULT([yes])
      break
    fi
  done
  #
  FCFLAGS="$save_fcflags"    
  LIBS="$save_libs"
  #
  if test "x$hdf5" = xno; then
    if   test -d "$with_hdf5_libdir" || test -d "$with_hdf5_path"; then AC_MSG_RESULT([no]) ; fi
    #
    AC_MSG_CHECKING([for internal NETCDF+HDF5 library]);
    compile_hdf5="yes"  ;
    compile_netcdf="yes"  ;
    #
    HDF5_LIBS="-L${extlibs_path}/lib -lhdf5hl_fortran -lhdf5_fortran -lhdf5_hl -lhdf5 -lz -lm -ldl"
    HDF5_INCS="${IFLAG}${extlibs_path}/include"
    NETCDF_LIBS="-L${extlibs_path}/lib -lnetcdff -lnetcdf"
    NETCDF_INCS="${IFLAG}${extlibs_path}/include"
    #
    netcdf=yes
    hdf5=yes
    AC_MSG_RESULT([ok])
    #
  fi
fi
#
if test x"$enable_hdf5" = "xyes" && test x"$compile_netcdf" = "xyes" ; then NETCDF_OPT=""; fi
#
# Large File Support
#
if test x"$enable_netcdf_classic" = "xyes"; then
  dnetcdf="-D_NC_CLASSIC";
fi
#
# NETCDF-HDF5 IO
#
if test x"$netcdf" = "xyes" && test x"$hdf5" = "xyes" && test x"$enable_netcdf_hdf5" = "xyes" ; then
  dnetcdf="${dnetcdf} -D_HDF5_IO";
fi
#
# HDF5-DATA COMPRESSION
#
if test x"$netcdf" = "xyes" && test x"$hdf5" = "xyes" && test x"$enable_netcdf_hdf5" = "xyes" && test x"$enable_hdf5_compression" = "xyes" ; then
    dnetcdf="${dnetcdf} -D_HDF5_COMPRESSION";
fi
#
AC_SUBST(NETCDF_LIBS)
AC_SUBST(NETCDF_INCS)
AC_SUBST(NETCDF_OPT)
AC_SUBST(HDF5_LIBS)
AC_SUBST(HDF5_INCS)
AC_SUBST(netcdf)
AC_SUBST(hdf5)
AC_SUBST(dnetcdf)
AC_SUBST(compile_netcdf)
AC_SUBST(compile_hdf5)

])
