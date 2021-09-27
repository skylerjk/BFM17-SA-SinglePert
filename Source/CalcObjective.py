import numpy as np
import matplotlib.pyplot as plt
from netCDF4 import Dataset
import sys

# List of State Variables of interest
State_Variables = ['P2l','P2c','P2n','P2p','Z5c','Z5n','Z5p','R1c','R1n','R1p','R6c','R6n','R6p','N1p','N3n','N4n','O2o']

depth = 150
Num_Days = 360
Sim_Days = 1080
Num_SVar = len(State_Variables)

# Control Flag for Initial Evaluation
Flag_IE = eval(sys.argv[1])
# Control Flag for Normalization
Flag_NO = eval(sys.argv[2])

# If initial evaluation, do not normalize RMSD values
if Flag_IE:
    Flag_NO = False

# Location of BFM17-POM1D results
NC_Ref_File_Location = 'bfm17_pom1d-ref.nc'
NC_Tst_File_Location = 'bfm17_pom1d.nc'

# Load the set of data
NC_Ref_Data = Dataset(NC_Ref_File_Location)
NC_Tst_Data = Dataset(NC_Tst_File_Location)

Temp_Ref = np.zeros([Num_SVar,Sim_Days,depth])
Temp_Tst = np.zeros([Num_SVar,Sim_Days,depth])

BGC_Ref_Data = np.zeros([Num_SVar,Num_Days,depth])
BGC_Tst_Data = np.zeros([Num_SVar,Num_Days,depth])

for i, var in enumerate(State_Variables):
    Temp_Ref[i,:,:] = NC_Ref_Data[var][:]
    BGC_Ref_Data[i,:,:] = Temp_Ref[i,-360:,:].transpose()

    Temp_Tst[i,:,:] = NC_Tst_Data[var][:]
    BGC_Tst_Data[i,:,:] = Temp_Tst[i,-360:,:].transpose()
    #
    # BGC_Ref_Data[i,:,:] = NC_Ref_Data[var][:]
    # BGC_Tst_Data[i,:,:] = NC_Tst_Data[var][:]

N = float(Num_Days*depth)

# Calculate the RMSD in the field of each state variable
RMSD = np.sqrt(np.sum(np.sum((BGC_Tst_Data - BGC_Ref_Data)**2, axis = 2), axis = 1)/N)

if Flag_NO:
    # Load RMSD values from base case evaluation
    RMSD_BaseCase = np.load('BaseCase_RMSD.npy')

    # Sum normalized RMSD values to calculate objective function
    obj = np.sum(RMSD/RMSD_BaseCase)

else:
    # Sum RMSD values to calculate objective function
    obj = np.sum(RMSD)

# How to output data
if Flag_IE:
    np.save('BaseCase_RMSD',RMSD)

else:
    ofile = open('result.out','w')
    ofile.write(repr(obj))
    ofile.close()
