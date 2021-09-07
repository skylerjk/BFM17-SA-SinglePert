#!/bin/zsh

# Output Directory
CaseDir=$1; shift
# Output Parameter Values
Parameter_Vals=( $@ )

p_PAR=$Parameter_Vals[1]
p_eps0=$Parameter_Vals[2]
p_epsR6=$Parameter_Vals[3]
p_pe_R1c=$Parameter_Vals[4]
p_pe_R1n=$Parameter_Vals[5]
p_pe_R1p=$Parameter_Vals[6]
p_sum=$Parameter_Vals[7]
p_srs=$Parameter_Vals[8]
p_sdmo=$Parameter_Vals[9]
p_thdo=$Parameter_Vals[10]
p_pu_ea=$Parameter_Vals[11]
p_pu_ra=$Parameter_Vals[12]
p_qun=$Parameter_Vals[13]
p_lN4=$Parameter_Vals[14]
p_qnlc=$Parameter_Vals[15]
p_qncPPY=$Parameter_Vals[16]
p_xqn=$Parameter_Vals[17]
p_qup=$Parameter_Vals[18]
p_qplc=$Parameter_Vals[19]
p_qpcPPY=$Parameter_Vals[20]
p_xqp=$Parameter_Vals[21]
p_esNI=$Parameter_Vals[22]
p_res=$Parameter_Vals[23]
p_alpha_chl=$Parameter_Vals[24]
p_qlcPPY=$Parameter_Vals[25]
p_epsChla=$Parameter_Vals[26]
z_srs=$Parameter_Vals[27]
z_sum=$Parameter_Vals[28]
z_sdo=$Parameter_Vals[29]
z_sd=$Parameter_Vals[30]
z_pu=$Parameter_Vals[31]
z_pu_ea=$Parameter_Vals[32]
z_chro=$Parameter_Vals[33]
z_chuc=$Parameter_Vals[34]
z_minfood=$Parameter_Vals[35]
z_qpcMIZ=$Parameter_Vals[36]
z_qncMIZ=$Parameter_Vals[37]
z_paPPY=$Parameter_Vals[38]
p_sN4N3=$Parameter_Vals[39]
p_clO2o=$Parameter_Vals[40]
p_sR6O3=$Parameter_Vals[41]
p_sR6N1=$Parameter_Vals[42]
p_sR6N4=$Parameter_Vals[43]
p_sR1O3=$Parameter_Vals[44]
p_sR1N1=$Parameter_Vals[45]
p_sR1N4=$Parameter_Vals[46]
p_rR6m=$Parameter_Vals[47]
NRT_o2o=$Parameter_Vals[48]
NRT_n1p=$Parameter_Vals[49]
NRT_n3n=$Parameter_Vals[50]
NRT_n4n=$Parameter_Vals[51]

# Write Parameter Values to Corresponding Namelist
./write_BFMGen.sh $CaseDir \
                       $p_PAR $p_eps0 $p_epsR6 $p_pe_R1c $p_pe_R1n $p_pe_R1p
./write_PelEco.sh $CaseDir \
                        $p_sum $p_srs $p_sdmo $p_thdo $p_pu_ea \
                        $p_pu_ra $p_qun $p_lN4 $p_qnlc $p_qncPPY \
                        $p_xqn $p_qup $p_qplc $p_qpcPPY $p_xqp $p_esNI \
                        $p_res $p_sdchl $p_alpha_chl $p_qlcPPY \
                        $p_epsChla \
                        $z_srs $z_sum $z_sdo $z_sd $z_pu $z_pu_ea \
                        $z_chro $z_chuc $z_minfood $z_qpcMIZ $z_qncMIZ $z_paPPY
./write_PelEnv.sh $CaseDir \
                        $p_sN4N3 $p_clO2o $p_sR6O3 $p_sR6N1 $p_sR6N4 $p_sR1O3 $p_sR1N1 \
                        $p_sR1N4 $p_rR6m
./write_params.sh $CaseDir \
                        $NRT_o2o $NRT_n1p $NRT_n3n $NRT_n4n
