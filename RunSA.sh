#!/bin/zsh
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- #
# Reading information for Parameter Sensitivity Study                          #
# To Run: ./RunSA.sh SA-Case.in
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- #

# Input file
IptFl=$1

ind=`grep -n 'RunDir' $IptFl | cut -d: -f1`
RunDir=`head -$ind $IptFl | tail -1 | cut -d '=' -f2`

echo 'RunDir = ' $RunDir

# Identify if running an initial evaluation of the model
ind=`grep -n 'PrtCase' $IptFl | cut -d: -f1`
PrtCase=`head -$ind $IptFl | tail -1 | cut -d '=' -f2`

echo 'PrtCase = ' $PrtCase

# Using BFM17 with POM1D, there are 51 possible parameters:
NumPrm=51

# Read parameter information from input file
ind=`grep -n 'ParameterList' $IptFl | cut -d: -f1`
for i in {1..$NumPrm}
do
  line=(`head -$(( $ind+$i )) $IptFl |tail -1`)

  # Parameter
  prms+=($line[2])
  # Include parameter in SA?
  prms_bl+=($line[3])
  # Nomial parameter value
  prms_nm+=($line[4])
done

HEAD_Directory=$(pwd)
echo $HEAD_Directory

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- #
# Setting Up BFM17 - POM1D Model                                               #
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- #

# Location of Sensitivity Study
RunDir=SA-Runs/$RunDir
mkdir $RunDir

# Set Current Directory to BFM17-POM1D Config directory
ConfigDir=$RunDir/Config

# Copy Source Code to Config Directory
cp -r Source/Source-BFMPOM $ConfigDir
cd $ConfigDir

# Run Configuration
export BFMDIR="$(pwd)"
export NETCDF="/usr/local/netcdf"
export BFMDIR_RUN="$BFMDIR/bfm_run"

cd $BFMDIR/build

./bfm_configure.sh -gdc -p BFM_POM BFM17

cd ../../../../

# Run Base Case
CaseSource=$RunDir/Source

cp -r Source/Inputs $RunDir
cp -r Source/Source-Run $CaseSource
cp $ConfigDir/bin/pom.exe $CaseSource



CaseDir=$RunDir/BaseCase
cp -r $CaseSource $CaseDir

./WriteNamelists.sh $CaseDir $prms_nm[@]

cd $CaseDir
./pom.exe

cd ../../../

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- #
# Interating through Perturbed cases                                           #
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- #

for i in {1..$NumPrm}
do
  NomVal=$prms_nm[i]

  for prt in {up,dn}
  do
    CaseDir=$RunDir/$prms[i]-$prt
    cp -r $CaseSource $CaseDir

    case $prt in
      up )
      # prms_nm[i]=$(( 2.0*$prms_nm[i] ))
      prms_nm[i]=$(( 1.25*$prms_nm[i] ))
        ;;
      dn )
      # prms_nm[i]=$(( $prms_nm[i]/2.0 ))
      prms_nm[i]=$(( 0.75*$prms_nm[i] ))
        ;;
    esac

    ./WriteNamelists.sh $CaseDir $prms_nm[@]

    cd $CaseDir
    ./pom.exe

    cd ../../../

    prms_nm[i]=$NomVal
  done

done
