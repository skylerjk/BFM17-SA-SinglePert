% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= %
% Script : PlotSPS.m                                                      %
%                                                                         %
% Description :                                                           %
% This script produces plots of the single parameter sweeps (SPS). One    %
% parameter at a time, a sweep is performed through the parameter range   %
% while all other parameters are left at thier nominal value. This helps  %
% to determine the influence any given parameter effects that objective   %
% function space.                                                         %
%                                                                         %
% Developed :                                                             %
% Skyler Kern - October 21, 2021                                          %
%                                                                         %
% Institution :                                                           %
% This was created in support of research done in the Turbulence and      %
% Energy Systems Laboratory (TESLa) from the Paul M. Rady Department of   %
% Mechanical Engineering at the University of Colorado Boulder.           %           
%                                                                         %
% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= %

% % Preface : 

% Clear the work space
close all, clear all, clc

% Set color scheme for plots
FigClr = 'w'; 
AxsClr = 'k'; 
TxtClr = 'k';
lbox = 'off';

% Directory with nominal BFM17 run
Ref_Directory = '../SA-Runs/OaT-Sweep-dt400/RefRun/bfm17_pom1d.nc';
% Directory with Sweeps
Swp_Directory = '../SA-Runs/OaT-Sweep-dt400/';

% % Parameter Names
Parameter_Names = ...
    {'p_PAR','p_eps0','p_epsR6','p_pe_R1c','p_pe_R1n','p_pe_R1p','p_sum',...
    'p_srs','p_sdmo','p_thdo','p_pu_ea','p_pu_ra','p_qun','p_lN4','p_qnlc',...
    'p_qncPPY','p_xqn','p_qup','p_qplc','p_qpcPPY','p_xqp','p_esNI','p_res',...
    'p_alpha_chl','p_qlcPPY','p_epsChla','z_srs','z_sum','z_sdo','z_sd','z_pu',...
    'z_pu_ea','z_chro','z_chuc','z_minfood','z_qpcMIZ','z_qncMIZ','z_paPPY',...
    'p_sN4N3','p_clO2o','p_sR6O3','p_sR6N1','p_sR6N4','p_sR1O3','p_sR1N1',...
    'p_sR1N4','p_rR6m','NRT_o2o','NRT_n1p','NRT_n3n','NRT_n4n'};

% Parameter Names
% Parameter_Names = {'p_pe_R1c','p_qpcPPY','z_sd','p_sR6O3','p_sR1O3'};
% Parameter_Names = {'p_qup','p_qplc','p_qpcPPY','z_sd','p_sR6N1'};
% Parameter_Names = {'p_PAR','p_eps0'};
 
% State_Variables of interest
State_Variables = ...
    {'P2l','P2c','P2n','P2p','Z5c','Z5n','Z5p','R1c','R1n','R1p', ...
     'R6c','R6n','R6p','N1p','N3n','N4n','O2o'};

% Control Values
Num_Eval = 50;      % Number of model evaluations    
% iday = 2*360+1;     % Initial day
% eday = 3*360;       % End day 

iday = 1;
eday = 30;
N = 150 * 30;       % Number of points in field

%% Analysis %%
% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= %

% Loading Data from nominal BFM17 run
for ind = 1:length(State_Variables)
  tmp(:,:) = ncread(Ref_Directory,State_Variables{ind});
  bfm_ref_data(ind,:,:) = tmp(:,iday:eday);
  
  % MaxVal(ind,:) = max(max(bfm_ref_data(ind,:,:)));
  STD(ind,:) = std(bfm_ref_data(ind,:,:),0,'all');
end

% Remove the temporary variable
clear tmp



for iprm = 1:length(Parameter_Names)
    
    for evl = 1:Num_Eval
        EvalDir = ['Sweep_' Parameter_Names{iprm} '-Eval_' num2str(evl-1)];
        
        for stvr = 1:length(State_Variables)
            tmp(stvr,:,:) = ncread([Swp_Directory EvalDir '/bfm17_pom1d.nc'],State_Variables{stvr});
        end
        
        bfm_swp_data(:,:,:) = tmp(:,:,iday:eday); 
        clear tmp;
            
        RMSD(iprm,evl,:) = sqrt( sum(sum( (bfm_ref_data - bfm_swp_data) .^2, 3), 2) ./N);
        
        % RMSD_norm(iprm,evl,:) = squeeze(RMSD(iprm,evl,:)) ./ MaxVal;
        RMSD_norm(iprm,evl,:) = squeeze(RMSD(iprm,evl,:)) ./ STD;
    end
end

Total_RMSD = sum(RMSD,3);

Total_Norm_RMSD = sum(RMSD_norm,3);

%% Plot Results %%
% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= %

f1 = figure(1); 
for iprm = 1:length(Parameter_Names)
    plot(linspace(0,1,50),Total_RMSD(iprm,:),'-o'), hold on
end

ttl = title('Single Parameter Sweep');
xl = xlabel('Normalized parameter value');
yl = ylabel('Total RMSD');

% legend({'p\_pe\_R1c','p\_qpcPPY','z\_sd','p\_sR6O3','p\_sR1O3'})
legend({'p\_qup','p\_qplc','p\_qpcPPY','z\_sd','p\_sR6N1'})

%%
f2 = figure(2); f2.Color = FigClr; f2.InvertHardcopy = 'off'; 
for iprm = 1:length(Parameter_Names)
    plot(linspace(0,1,50),Total_Norm_RMSD(iprm,:),'-o'), hold on
end

ttl = title('Single Parameter Sweep','RMSD Normalized by the Standard Deviation of the Reference Field');
xl = xlabel('Normalized parameter value');
yl = ylabel('Total Normalized RMSD');

% legend({'p\_pe\_R1c','p\_qpcPPY','z\_sd','p\_sR6O3','p\_sR1O3'})
legend({'p\_qup','p\_qplc','p\_qpcPPY','z\_sd','p\_sR6N1'})
