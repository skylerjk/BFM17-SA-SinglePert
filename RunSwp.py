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

# Retrieve parameter values from input file
with open('SwpCase.in') as readFile:
    for i, line in enumerate(readFile):
        if i >= 7:
            Parameter_Entry = line.split()
            # Assign Parameter Name
            PN.append(Parameter_Entry[1])
            # Assign Parameter Control
            PC.append(eval(Parameter_Entry[2]))
            # Assign Parameter Nominal Value
            NV[i-7] = Parameter_Entry[3]
            # Assign Parameter Lower Boundary
            LB[i-7] = Parameter_Entry[4]
            # Assign Parameter Upper Boundary
            UB[i-7] = Parameter_Entry[5]

Home = os.getcwd()

# Number of parameter increments
Num_Evals = 50

# Create the run directory
RunDir = 'SA-Runs/OaT-Sweep-dt400'
os.system("mkdir " + RunDir)

# Copy source code to compile BFM17 + POM1D
os.system("cp -r Source/Source-BFMPOM " + RunDir + "/Config")

# Compile BFM17 + POM1D, generate executable
os.chdir(RunDir + "/Config")
os.system("./Config_BFMPOM.sh")
os.chdir(Home)

# Create template folder for sensitivity study
os.system("cp -r Source/Source-Run " + RunDir + "/Source")

# Put executable in template folder
os.system("cp " + RunDir + "/Config/bin/pom.exe " + RunDir + "/Source")

# Copy Input Data
os.system("cp -r Source/Source-BFMPOM/Inputs " + RunDir)

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

RV = np.copy(NV)   # array of values used in model evaluation

for i, prm in enumerate(PN):
    X = np.linspace(LB[i], UB[i], num = Num_Evals)

    for ii, val in enumerate(X):
        # Testing Value
        RV[i] = val

        # Evaluation Directory Name
        Eval_Directory = RunDir + "/Sweep_" + prm + '-Eval_' + str(ii)
        # Copy template directory to current run directory
        os.system("cp -r " + RunDir + "/Source " + Eval_Directory)

        # Change to current run directory
        os.chdir(Eval_Directory)

        # oprm - parameter being replaced in namelists
        for iii, oprm in enumerate(PN):
            Nml_File = find_key(Namelist_Dictionary, oprm)
            # Replace value of current parameter
            os.system("sed -i '' \"s/{" + oprm + "}/" + str(RV[iii]) +"/\" " + Nml_File)


        os.system("./pom.exe")
        os.chdir(Home)

        # Reassign changed value to nominal value
        RV[i] = NV[i]

print('Sweeps Completed')
