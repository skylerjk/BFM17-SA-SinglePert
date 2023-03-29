# BFM17-SA-SinglePert

This code is used to perfrom a sensitivity study of the BFM17+POM1D (Smith et al, 2021) using a single parameter perturbation methodology. The input parameters for the biogeochemical model (BFM) are iteratively perturbed up and down by a fraction of their nominal value. In the provided input script (SACase.in) the parameters are set to be pertrubed by 5% (set as 0.05). Running the sensitivity analysis code requires python with the numpy and os libraries. The code is run via running the RunSA.py script:

>> python RunSA.py

In order for the sensitivity analysis to proceed you need to be able to compile the BFM17+POM1D code locally. This is part of running the code above but requires GNU fortran compilers, OpenMPI, and NetCDF. You may need to update the compiler command which is included as the variables FD and LD in Source/Source-BFMPOM/compilers/gfortran.inc. 

The sensitivity analysis is able to be run for two implementations of the BFM17+POM1D model: one corresponding to data from the Bermuda Atlantic time-series and another from the Hawaii Ocean time-series. The implementation used for the sensitivity analysis is selected by setting the Exprmt input to 'bats' or 'hots' respectively in the SACase.in file. The perturbation size is set using the PrtCase input, while the run directory is set using RunDir. There are 51 parameters available for inclusion in the sensitivity analysis which are set in lines 18 through 68 of the input file. The parameter name, parameter control, nominal value, lower bound, upper bound and description are included in columns. The parameter control allows for parameters to be included/excluded by toggling between True and False. 