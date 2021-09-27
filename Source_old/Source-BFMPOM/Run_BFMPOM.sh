#!/bin/zsh
# Script to define local paths, compile and execute BFM_POM 1D,
# change restart files names

export BFMDIR="$(pwd)"
export NETCDF="/usr/local/netcdf"
export BFMDIR_RUN="$BFMDIR/bfm_run"

cd $BFMDIR/build

./bfm_configure.sh -gdc -p BFM_POM BFM17

cd $BFMDIR_RUN/bfm17_pom1d

ln -s pom_restart_$ID_run fort.70 #in
ln -s pom_restart_$next_ID_run fort.71 #out

ln -s bfm_restart_$ID_run in_bfm_restart.nc #in
ln -s bfm_restart_$next_ID_run out_bfm_restart.nc #out

time ./pom.exe
