#!/bin/zsh

# Location to output the Namelist
FileLoc=$1; shift

/bin/cat << EOF >$FileLoc/Pelagic_Ecology.nml
!  PELAGIC BACTERIA
!-------------------------------------------------------------------------!
&PelBacteria_parameters
!                           B1
    p_version            =  1
    p_q10                =  2.95
    p_chdo               =  30.0
    p_sd                 =  0.1
    p_sd2                =  0.0
    p_suhR1              =  0.3
    p_sulR1              =  0.0
    p_suR2               =  0.0
    p_suR3               =  0.0
    p_suR6               =  0.01
    p_sum                =  8.38
    p_pu_ra              =  0.6
    p_pu_ra_o            =  0.2
    p_srs                =  0.01
    p_qncPBA             =  0.0167
    p_qpcPBA             =  0.00185
    p_qlnc               =  0.0167
    p_qlpc               =  0.00185
    p_qun                =  0.0
    p_qup                =  0.0
    p_chn                =  5.00
    p_chp                =  1.0
    p_rec                =  1.0
    p_ruen               =  1.0
    p_ruep               =  1.0
    p_pu_ea_R3           =  0.0
/

!  PELAGIC PHYTOPLANKTON
!-------------------------------------------------------------------------!
&Phyto_parameters
!                     P1       P2         P3       P4
    p_q10          =  2.0      2.0        2.0      2.0
    p_temp         =  0.0      0.0        0.0      0.0
    p_sum          =  2.5      $1        3.5      0.83
    p_srs          =  0.05     $2       0.05     0.1
    p_sdmo         =  0.01     $3       0.01     0.2
    p_thdo         =  0.1      $4        0.1      0.5
    p_seo          =  0.0      0.0        0.0      0.5
    p_sheo         =  0.0      0.0        0.0      100.0
    p_pu_ea        =  0.01     $5       0.1      0.15
    p_pu_ra        =  0.1      $6       0.2      0.1
    p_switchDOC    =  1        1          1        1
    p_netgrowth    =  .FALSE.  .FALSE.    .FALSE.  .FALSE.
    p_limnut       =  1        1          1        1
    p_qun          =  0.025    $7      0.025    0.025
    p_lN4          =  1.0      $8        0.1      1.0
    p_qnlc         =  6.87e-3  $9    6.87e-3  6.87e-3
EOF
shift 9
/bin/cat << EOF >>$FileLoc/Pelagic_Ecology.nml
    p_qncPPY       =  1.26e-2  $1    1.26e-2  1.26e-2
    p_xqn          =  2.0      $2        2.0      2.0
    p_qup          =  2.5e-3   $3     2.5e-3   2.5e-3
    p_qplc         =  4.29e-4  $4    4.29e-4  4.29e-4
    p_qpcPPY       =  7.86e-4  $5    7.86e-4  7.86e-4
    p_xqp          =  2.0      $6        2.0      2.0
    p_switchSi     =  1        0          0        0
    p_chPs         =  1.0      0.0        0.0      0.0
    p_Contois      =  0.0      0.0        0.0      0.0
    p_qus          =  0.0      0.0        0.0      0.0
    p_qslc         =  4.3e-3   0.0        0.0      0.0
    p_qscPPY       =  8.5e-3   0.0        0.0      0.0
    p_esNI         =  0.7      $7        0.75     0.75
    p_res          =  5.0      $8        0.5      5.0
    p_switchChl    =  3        3          3        3
    p_sdchl        =  0.2      0.0        0.2      0.2
    p_alpha_chl    =  1.1e-5   $9    0.7e-5   6.8e-6
EOF
shift 9
/bin/cat << EOF >>$FileLoc/Pelagic_Ecology.nml
    p_qlcPPY       =  0.035    $1      0.02     0.035
    p_epsChla      =  0.03     $2       0.03     0.03
    p_EpEk_or      =  3.0      0.0        3.0      3.0
    p_tochl_relt   =  0.25     0.0        0.25     0.25
/



&Phyto_parameters_iron
/



&PAR_parameters
    p_iswLtyp    =  5  5  5  5
/



&LightAdaptation_parameters
    p_isw                    =  1      1      1      1
    p_addepth                =  50.0   50.0   50.0   50.0
    p_chELiPPY               =  100.0  100.0  100.0  100.0
    p_clELiPPY               =  8.0    10.0   6.0    12.0
    p_ruELiPPY               =  0.2    0.25   0.3    0.15
/


!  MICRO-ZOOPLANKTON
!-------------------------------------------------------------------------!
&MicroZoo_parameters
!                        Z5       Z6
    p_q10             =  2.0        2.0
    p_srs             =  $3       0.02
    p_sum             =  $4        5.0
    p_sdo             =  $5       0.25
    p_sd              =  $6     0.0
    p_pu              =  $7        0.3
    p_pu_ea           =  $8       0.35
    p_chro            =  $9        0.5
EOF
shift 9
/bin/cat << EOF >>$FileLoc/Pelagic_Ecology.nml
    p_chuc            =  $1      200.0
    p_minfood         =  $2       50.0
    p_qpcMIZ          =  $3      1.85d-3
    p_qncMIZ          =  $4      1.67d-2
    p_paPBA           =  0.0        1.0
!                        P1       P2         P3   P4
!   Z5
    p_paPPY(1,:)      =  0.0      $5        0.0  0.0
!   Z6
    p_paPPY(2,:)      =  0.0      0.0        0.0  0.0
!                        Z5         Z6
!   Z5
    p_paMIZ(1,:)      =  0.0        0.0
!   Z6
    p_paMIZ(2,:)      =  0.0        0.0
/

!  MESO-ZOOPLANKTON
!-------------------------------------------------------------------------!

&MesoZoo_parameters
!                       Z3       Z4
    p_q10            =  2.0      2.0
    p_srs            =  0.01     0.02
    p_sum            =  2.0      2.0
    p_vum            =  0.025   0.025
    p_puI            =  0.6      0.6
    p_peI            =  0.3      0.35
    p_sdo            =  0.01     0.01
    p_sd             =  0.02     0.02
    p_sds            =  2.0      2.0
    p_qpcMEZ         =  1.67d-3  1.67d-3
    p_qncMEZ         =  0.015    0.015
    p_clO2o          =  30.0     30.0
!                       P1       P2       P3   P4
!   Z3
    p_paPPY(1,:)     =  0.0      0.0      0.0  0.0
!   Z4
    p_paPPY(2,:)     =  0.0      0.0      0.0  0.0
!                       Z5       Z6
!   Z3
    p_paMIZ(1,:)     =  0.0      0.0
!   Z4
    p_paMIZ(2,:)     =  0.0      0.0
!                       Z3       Z4
!   Z3
    p_paMEZ(1,:)     =  0.0      0.0
!   Z4
    p_paMEZ(2,:)     =  0.0      0.0
/
EOF
