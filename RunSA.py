#
#
import numpy as np
import os

# Namelist Dictionary defines which parameters are in a given namelist file
Namelist_Dictionary = {
  'BFM_General.nml' : ['p_PAR', 'p_eps0', 'p_epsR6', 'p_pe_R1c', 'p_pe_R1n', 'p_pe_R1p'],
  'Pelagic_Ecology.nml' : ['p_sum', 'p_srs', 'p_sdmo', 'p_thdo', 'p_pu_ea', 'p_pu_ra', \
  'p_qun', 'p_lN4', 'p_qnlc', 'p_qncPPY', 'p_xqn', 'p_qup', 'p_qplc', 'p_qpcPPY', \
  'p_xqp', 'p_esNI', 'p_res', 'p_alpha_chl', 'p_qlcPPY', 'p_epsChla', 'z_srs', 'z_sum', \
  'z_sdo', 'z_sd', 'z_pu', 'z_pu_ea', 'z_chro', 'z_chuc', 'z_minfood', 'z_qpcMIZ', \
  'z_qncMIZ', 'z_paPPY'],
  'Pelagic_Environment.nml' : ['p_sN4N3', 'p_clO2o', 'p_sR6O3', 'p_sR6N1', 'p_sR6N4', \
  'p_sR1O3', 'p_sR1N1', 'p_sR1N4', 'p_rR6m'],
  'params_POMBFM.nml' : ['NRT_o2o', 'NRT_n1p', 'NRT_n3n', 'NRT_n4n']
}

# Function to return Key for parameter Dictionary
def find_key(Dict,val):
    key_list = list(Dict.keys())

    for key in key_list:
      Search_List = Dict[key]
      if val in Search_List:
        return key

# Parameter Names
PN = []
# Parameter Controls
PC = []
# Parameter Nominal Values
NV = np.zeros(51)
# Parameter Lower Bound
LB = np.zeros(51)
# Parameter Upper Bound
UB = np.zeros(51)

LnPI = 17 # Parameter Input Line
with open('SACase.in') as readFile:
    for i, line in enumerate(readFile):
        if i == 7:
            Option_Cntrl = line.split()
            RunDir = Option_Cntrl[2]

        if i == 9:
            Option_Cntrl = line.split()
            Exprmt = Option_Cntrl[2]

        if i == 11:
            Option_Cntrl = line.split()
            Pert = eval(Option_Cntrl[2])

        if i >= LnPI:
            Parameter_Entry = line.split()

            # Assign Parameter Name
            PN.append(Parameter_Entry[1])
            # Assign Parameter Control
            PC.append(eval(Parameter_Entry[2]))
            # Assign Parameter Nominal Value
            NV[i-LnPI] = Parameter_Entry[3]
            # Assign Parameter Lower Boundary
            LB[i-LnPI] = Parameter_Entry[4]
            # Assign Parameter Upper Boundary
            UB[i-LnPI] = Parameter_Entry[5]


Home = os.getcwd()

# print(RunDir)
# print(Exprmt)
# print(PN)
# print(PC)
# print(NV)

# Calculate the Normalized Nominal Values
Norm_Val = (NV - LB) / (UB - LB)
# Pert_Val = np.copy(Norm_Val)

# Create the run directory
os.system("mkdir " + RunDir)

# Keep copy of SACase.in in run directory
os.system("cp SACase.in " + RunDir)

# Copy source code to compile BFM17 + POM1D
os.system("cp -r Source/Source-BFMPOM " + RunDir + "/Config")

# Compile BFM17 + POM1D, generate executable
os.chdir(RunDir + "/Config")
os.system("./Config_BFMPOM.sh")
os.chdir(Home)

# Create template folder for sensitivity study
# os.system("cp -r Source/Source-Run " + RunDir + "/Source")
os.system("cp -r Source/Source-Run " + RunDir + "/Source")

# Put executable in template folder
os.system("cp " + RunDir + "/Config/bin/pom.exe " + RunDir + "/Source")

# Copy input files
# os.system("cp -r Source/Source-BFMPOM/Inputs " + RunDir)

# Copy input data
if Exprmt == 'bats':
    os.system("cp -r Source/inputs_bats " + RunDir)

    os.system("sed -i '' \"s/{InDir}/..\/inputs_bats/\" " + RunDir + "/Source/BFM_General.nml")
    os.system("sed -i '' \"s/{InDir}/..\/inputs_bats/\" " + RunDir + "/Source/pom_input.nml")

elif Exprmt == 'hots':
    os.system("cp -r Source/inputs_hots " + RunDir)

    os.system("sed -i '' \"s/{InDir}/..\/inputs_hots/\" " + RunDir + "/Source/BFM_General.nml")
    os.system("sed -i '' \"s/{InDir}/..\/inputs_hots/\" " + RunDir + "/Source/pom_input.nml")

else:
    print('Not valid case.')
    exit()

# Perform Reference Model Run
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #
os.system("cp -r " + RunDir + "/Source " + RunDir + "/RefRun")
os.chdir(RunDir + "/RefRun")
# Writing Parameter Values to Namelists
for i, prm in enumerate(PN):
    Nml_File = find_key(Namelist_Dictionary, prm)

    # Replace of current parameter in namelist with nominal value
    os.system("sed -i '' \"s/{" + prm + "}/" + str(NV[i]) +"/\" " + Nml_File)

# Run Reference Evaluation
os.system("./pom.exe")
os.chdir(Home)

# Start by cycling through all the parameters
for ind, prm in enumerate(PN):
    # Current parameter will be perturbed up and down
    for prt in ['up','dn']:
        # Generate the directory name for current run
        Eval_Directory = RunDir + "/Eval_" + prm + '-' + prt

        # Calculate the perturbed value of the nominal normalized value
        if prt == 'up':
            # Pert_Val[ind] = Pert_Val[ind] + Pert
            test_val = NV[ind] + NV[ind]*0.05
        elif prt == 'dn':
            # Pert_Val[ind] = Pert_Val[ind] - Pert
            test_val = NV[ind] - NV[ind]*0.05

        # Corrections for if the perturbation pushes the parameter out of the
        # 0 to 1 normalized parameter space
        # if Pert_Val[ind] > 1.0:
        #     Pert_Val[ind] = Pert_Val[ind] - 1.0
        # elif Pert_Val[ind] < 0.0:
        #     Pert_Val[ind] = Pert_Val[ind] + 1.0

        if test_val > UB[ind] or test_val < LB[ind]:
            continue

        # Create current evaluation directory
        os.system("cp -r " + RunDir + "/Source " + Eval_Directory)
        os.chdir(Eval_Directory)

        # Writing parameter values to namelist
        for iprm, prm_in in enumerate(PN):
            # identify namelist for current parameter
            Nml_File = find_key(Namelist_Dictionary, prm_in)

            # Replace value of current parameter - select between pert val and nom val
            if prm_in == prm:
                # val = Pert_Val[iprm] * (UB[iprm] - LB[iprm]) + LB[iprm]
                val = test_val
            else:
                val = NV[iprm]


            # Replace value of current parameter
            os.system("sed -i '' \"s/{" + prm_in + "}/" + str(val) +"/\" " + Nml_File)

        # Running executable
        os.system("./pom.exe")
        os.chdir(Home)

        # Set parameter value back to initial value
        # Pert_Val[ind] = Norm_Val[ind]
