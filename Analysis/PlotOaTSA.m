% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= %
% Script : PlotOaTSA.m                                                    %
%                                                                         %
% Description :                                                           %
% This script produces plots of the results for a sensitivity analysis of %
% BFM17 + POM1D. The values of the model parameters have one-at-a-time    %
% (OaT) perturbed up and down, the effect on the model output is          %
% calculated to determine the relative importance on the different        %
% parameters on the model solution.                                       %
%                                                                         %
% Developed :                                                             %
% Skyler Kern - October 5, 2021                                           %
%                                                                         %
% Institution :                                                           %
% This was created in support of research done in the Turbulence and      %
% Energy Systems Laboratory (TESLa) from the Paul M. Rady Department of   %
% Mechanical Engineering at the University of Colorado Boulder.           %           
%                                                                         %
% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= %

% Clearing the work space
close all, clear all, clc

% Sensitivity Analysis run directory
RootDir = '../SA-Runs/OaT-Pert-dt400-05perc/';
% Output file name
File = 'bfm17_pom1d.nc';

% Parameters for BFM17 + POM1D are:
Parameters = ...
    {'p_PAR','p_eps0','p_epsR6','p_pe_R1c','p_pe_R1n','p_pe_R1p','p_sum',...
    'p_srs','p_sdmo','p_thdo','p_pu_ea','p_pu_ra','p_qun','p_lN4','p_qnlc',...
    'p_qncPPY','p_xqn','p_qup','p_qplc','p_qpcPPY','p_xqp','p_esNI','p_res',...
    'p_alpha_chl','p_qlcPPY','p_epsChla','z_srs','z_sum','z_sdo','z_sd','z_pu',...
    'z_pu_ea','z_chro','z_chuc','z_minfood','z_qpcMIZ','z_qncMIZ','z_paPPY',...
    'p_sN4N3','p_clO2o','p_sR6O3','p_sR6N1','p_sR6N4','p_sR1O3','p_sR1N1',...
    'p_sR1N4','p_rR6m','NRT_o2o','NRT_n1p','NRT_n3n','NRT_n4n'};

Parameter_Labels = ...
    {'p\_PAR','p\_eps0','p\_epsR6','p\_pe\_R1c','p\_pe\_R1n','p\_pe\_R1p','p\_sum',...
    'p\_srs','p\_sdmo','p\_thdo','p\_pu\_ea','p\_pu\_ra','p\_qun','p\_lN4','p\_qnlc',...
    'p\_qncPPY','p\_xqn','p\_qup','p\_qplc','p\_qpcPPY','p\_xqp','p\_esNI','p\_res',...
    'p\_alpha\_chl','p\_qlcPPY','p\_epsChla','z\_srs','z\_sum','z\_sdo','z\_sd','z\_pu',...
    'z\_pu\_ea','z\_chro','z\_chuc','z\_minfood','z\_qpcMIZ','z\_qncMIZ','z\_paPPY',...
    'p\_sN4N3','p\_clO2o','p\_sR6O3','p\_sR6N1','p\_sR6N4','p\_sR1O3','p\_sR1N1',...
    'p\_sR1N4','p\_rR6m','NRT\_o2o','NRT\_n1p','NRT\_n3n','NRT\_n4n'};

% State Variables for BFM17 + POM1D are: 
State_Variables = {'P2l','P2c','P2n','P2p','Z5c','Z5n','Z5p','R1c',... 
                   'R1n','R1p','R6c','R6n','R6p','N1p','N3n','N4n','O2o'};

% Limiting Data to final year of 3 year simulation
% iday = 2*360+1;         % initial day
% eday = 360*3;           % end day

iday = 1;         % initial day
eday = 30;        % end day

% Location of data from nominal mdl run
RefDir = [RootDir 'RefRun/' File];
for sv = 1:length(State_Variables)
  tmp(:,:) = ncread(RefDir,State_Variables{sv});
  bfm_ref_data(sv,:,:) = tmp(:,iday:eday);
  
  % Calculate the monthly averages of the nominal case
%   for mon = 1:12
%       bfm_ref_monavg(sv,:,mon) = ...
%           sum( bfm_ref_data(sv,:,30*(mon-1)+1:30*mon), 3) / 30.;
%   end

    STD(sv,:) = std(bfm_ref_data(sv,:,:),0,'all');
end

for prm = 1:length(Parameters)
    index = 1;
    
    for dir = {'up','dn'}
%          if strcmp(Parameters{prm},'p_eps0')
%              continue
%          end
%          
        if strcmp(Parameters{prm},'z_paPPY') & strcmp(dir,'up')
            continue
        end
%         
        if strcmp(Parameters{prm},'p_clO2o') & strcmp(dir,'up')
            continue
        end
%         
        if strcmp(Parameters{prm},'p_sR1O3') & strcmp(dir,'dn')
            continue
        end
%         
        if strcmp(Parameters{prm},'p_sR1N1') & strcmp(dir,'dn')
            continue
        end
%         
        if strcmp(Parameters{prm},'p_sR1N4') & strcmp(dir,'dn')
            continue
        end
        
        % Location of data from mdl run
        Loc = [RootDir 'Eval_' Parameters{prm} '-' dir '/' File];
        EvlDir = strjoin(Loc,'');
        
        % Get 
        for sv = 1:length(State_Variables)
            tmp(:,:) = ncread(EvlDir,State_Variables{sv});
            bfm_tst_data(sv,:,:) = tmp(:,iday:eday);
        
            % Calculating the monthly average of the mdl evl 
%             for mon = 1:12
%                 bfm_tst_monavg(sv,:,mon) = ...
%                     sum( bfm_tst_data(sv,:,30*(mon-1)+1:30*mon), 3) / 30.;
%             end
        end
        
        % Calculating Root Mean Squared Values of Daily Values
        RMSD(prm,index,:) = ...
            sqrt(sum(sum( (bfm_tst_data - bfm_ref_data).^2, 3), 2)./(150*30));
        
        % Normalizing the RMSD
        RMSD_norm(prm,index,:) = squeeze(RMSD(prm,index,:)) ./ STD;
        
        index = index + 1;
    end
end

% Analysis for RMSD without Normalization
% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= %
Total_RMSD_up = sum(RMSD(:,1,:),3);
Total_RMSD_dn = sum(RMSD(:,2,:),3);

% Max RMSD for each parameter
Max_RMSD = max(Total_RMSD_up, Total_RMSD_dn);
% Sort to arrange parameters in ascending order
[Max_RMSD_Srt, Prm_Ind_Srt] = sort(Max_RMSD,'descend');

Parameter_Srt_Dsc = {};
for pind = 1:length(Parameters)
    % Parameter Names organized according to descending Max RMSD Values
    Parameter_Srt_Dsc(pind) = Parameter_Labels(Prm_Ind_Srt(pind));
end

% Analysis for RMSD with Normalization
% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= %
Total_Norm_RMSD_up = sum(RMSD_norm(:,1,:),3);
Total_Norm_RMSD_dn = sum(RMSD_norm(:,2,:),3);

% Max RMSD for each parameter
Max_Norm_RMSD = max(Total_Norm_RMSD_up, Total_Norm_RMSD_dn);
% Sort to arrange parameters in ascending order
[Max_Norm_RMSD_Srt, Prm_Ind_Srt2] = sort(Max_Norm_RMSD,'descend');

Parameter_Srt_Dsc2 = {};
for pind = 1:length(Parameters)
    % Parameter Names organized according to descending Max RMSD Values
    Parameter_Srt_Dsc2(pind) = Parameter_Labels(Prm_Ind_Srt2(pind));
end

%% Plotting Results for Unnormalized RMSD Values %%
% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= %
close all

% Figure 1 : Sensitivity Results
f1 = figure(1);
bar(Total_RMSD_up), hold on
bar(-Total_RMSD_dn)

xlim([.25 51.75]); % ylim([-20 20]); 
set(gca,'yticklabel',num2str(abs(get(gca,'ytick').')));

title('Single Parameter Pertubration Sensitivity Analysis','RMSD without Normalization');
ylabel('Total RMSD'); xlabel('Parameter Index');

legend('Pert. Up','Pert. Down')

set(gca,'xtick',1:length(Parameters),'Xticklabel',Parameter_Labels,'xticklabelrotation',270);

% Figure 2 : Ranking Results
f2 = figure();
bar(Max_RMSD_Srt);

title('Parameter Ranking from Sinlge Parameter Perturbation SA','RMSD without Normalization')
ylabel('Max Total RMSD');

set(gca,'xtick',1:length(Parameters),'Xticklabel',Parameter_Srt_Dsc,'xticklabelrotation',270);

%% Plotting Results for Normalized RMSD Values %%
% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= %

% Figure 3 : Sensitivity Results for Normalized RMSD Values
f3 = figure(3);
bar(Total_Norm_RMSD_up), hold on
bar(-Total_Norm_RMSD_dn)

xlim([.25 51.75]); % ylim([-20 20]); 
set(gca,'yticklabel',num2str(abs(get(gca,'ytick').')));

title('Single Parameter Pertubration Sensitivity Analysis','RMSD Normalized by the Standard Deviation of the Reference Field');
ylabel('Total RMSD'); xlabel('Parameter Index');

legend('Pert. Up','Pert. Down')

set(gca,'xtick',1:length(Parameters),'Xticklabel',Parameter_Labels,'xticklabelrotation',270);

% Figure 4 : Ranking Results for Normalized RMSD Values
f4 = figure(4);
bar(Max_Norm_RMSD_Srt);

title('Parameter Ranking from Sinlge Parameter Perturbation SA','RMSD Normalized by the Standard Deviation of the Reference Field')
ylabel('Max Total Normalized RMSD');

set(gca,'xtick',1:length(Parameters),'Xticklabel',Parameter_Srt_Dsc2,'xticklabelrotation',270);


