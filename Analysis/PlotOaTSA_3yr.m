% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= %
% Script : PlotOaTSA_3yr.m                                                %
%                                                                         %
% Description :                                                           %
% This script produces plots of the results for a sensitivity analysis of %
% BFM17 + POM1D. The values of the model parameters are one-at-a-time     %
% perturbed up and down, the effect on the model output is calculated to  %
% determine the relative importance on the different parameters on the    %
% model solution. This script uses monthly averages from the final year   %
% of a 3 year simulation to calculate the RMSD for the objective          % 
% function.                                                               %
%                                                                         %
% Developed : Skyler Kern                                                 %
%                                                                         %
% Institution :                                                           %
% This was created in support of research done in the Turbulence and      %
% Energy Systems Laboratory (TESLa) from the Paul M. Rady Department of   %
% Mechanical Engineering at the University of Colorado Boulder.           %           
%                                                                         %
% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= %
% Preample
close all, clear all, clc

% Set Text Interpreter
set(0, 'DefaultTextInterpreter', 'latex')

% Font Controls
fname = 'Times';
fsize = 9;

% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= %
% CODE ...                                                                %
% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= %

% Sensitivity Analysis run directory
RootDir = '../SA-Runs/V1_UpdatedRuns-230308/OaT-Pert-dt400-05perc-bats/';
% Output file name
File = 'bfm17_pom1d.nc';

Parameter_List = ...
    {'p_PAR', '$\varepsilon_{\mathrm{PAR}}$'; ...
      'p_eps0', '$\lambda _w$'; ...
      'p_epsR6', '$c_{R^(2)}$'; ...
      'p_pe_R1c', '$\varepsilon_{Z}^{(\mathrm{C})}$'; ...
      'p_pe_R1n', '$\varepsilon_{Z}^{(\mathrm{N})}$'; ...
      'p_pe_R1p', '$\varepsilon_{Z}^{(\mathrm{P})}$'; ...
      'p_sum', '$r_P^{(0)}$'; ...
      'p_srs', '$b_P$'; ...
      'p_sdmo', '$d_P^{(0)}$'; ...
      'p_thdo', '$h_P^{(\mathrm{N,P})}$'; ...
      'p_pu_ea', '$\beta_P$'; ...
      'p_pu_ra', '$\gamma_P$'; ...
      'p_qun', '$a_P^{(\mathrm{N})}$'; ...
      'p_lN4', '$h_P^{(\mathrm{N})}$'; ...
      'p_qnlc', '$\phi_{\mathrm{N}}^{(\mathrm{mn})}$';...
      'p_qncPPY','$\phi_{\mathrm{N}}^{(\mathrm{op})}$'; ...
      'p_xqn', '$\phi_{\mathrm{N}}^{(\mathrm{mx})}$'; ...
      'p_qup', '$a_P^{(\mathrm{P})}$'; ...
      'p_qplc', '$\phi_{\mathrm{P}}^{(\mathrm{mn})}$'; ...
      'p_qpcPPY', '$\phi_{\mathrm{P}}^{(\mathrm{op})}$'; ...
      'p_xqp', '$\phi_{\mathrm{P}}^{(\mathrm{mx})}$'; ...
      'p_esNI', '$l_P^{(\mathrm{sk})}$'; ...
      'p_res', '$w_P^{(\mathrm{sk})}$'; ...
      'p_alpha_chl', '$\alpha_{\mathrm{chl}}^{(0)}$'; ...
      'p_qlcPPY', '$\theta_{\mathrm{chl}}^{(0)}$'; ...
      'p_epsChla', '$c_P$'; ...
      'z_srs', '$b_Z$'; ...
      'z_sum', '$r_Z^{(0)}$'; ...
      'z_sdo', '$d_Z^{(0)}$'; ...
      'z_sd', '$d_Z$'; ...
      'z_pu', '$\eta_Z$'; ...
      'z_pu_ea', '$\beta_Z$'; ...
      'z_chro', '$h_Z^{(O)}$'; ...
      'z_chuc', '$h_Z^{(F)}$'; ...
      'z_minfood', '$\mu_Z$'; ...
      'z_qpcMIZ', '$\varphi_{\mathrm{P}}^{(\mathrm{op})}$'; ...
      'z_qncMIZ', '$\varphi_{\mathrm{N}}^{(\mathrm{op})}$'; ...
      'z_paPPY', '$\delta_{Z,P}$'; ...
      'p_sN4N3', '$\lambda_{N^{(3)}}^{(\mathrm{nit})}$'; ...
      'p_clO2o', '$h_N^{(O)}$'; ...
      'p_sR6O3', '$\xi_{\mathrm{CO}_2}$'; ...
      'p_sR6N1', '$\xi_{N^{(1)}}$'; ...
      'p_sR6N4', '$\xi_{N^{(2)}}$'; ...
      'p_sR1O3', '$\zeta_{\mathrm{CO}_2}$'; ...
      'p_sR1N1', '$\zeta_{N^{(1)}}$'; ...
      'p_sR1N4', '$\zeta_{N^{(2)}}$'; ...
      'p_rR6m', '$v^{(\mathrm{st})}$'; ...
      'NRT_o2o', '$\lambda_{O}$'; ...
      'NRT_n1p', '$\lambda_{N^{(1)}}$'; ...
      'NRT_n3n', '$\lambda_{N^{(2)}}$'; ...
      'NRT_n4n', '$\lambda_{N^{(3)}}$'};

Parameters = Parameter_List(:,1);
Parameter_Labels = Parameter_List(:,2);

%%

% State Variables for BFM17 + POM1D are: 
State_Variables = {'P2l','P2c','P2n','P2p','Z5c','Z5n','Z5p','R1c',... 
                   'R1n','R1p','R6c','R6n','R6p','N1p','N3n','N4n','O2o'};

% Limiting Data to final year of 3 year simulation
% iday = 1;         % initial day
% eday = 30;        % end day

iday = 2*360+1;         % initial day
eday = 360*3;           % end day

% Location of data from nominal mdl run
RefDir = [RootDir 'RefRun/' File];
for sv = 1:length(State_Variables)
    tmp(:,:) = ncread(RefDir,State_Variables{sv});
    bfm_ref_data(sv,:,:) = tmp(:,iday:eday);
    
    % Calculate the STD of each field for normalization 
    STD(sv,:) = std(bfm_ref_data(sv,:,:),0,'all');
end

depth = 150;

AvgData_ref = zeros(length(State_Variables),depth,12); 
for n = 1:length(State_Variables)
    for m = 1:12
        AvgData_ref(n,1:depth,m) = mean(bfm_ref_data(n,1:depth,[(m-1)*30+1 : m*30]),3);
    end
end
AvgData_ref = AvgData_ref./30;


for prm = 1:length(Parameters)
    index = 1;
    
    for dir = {'up','dn'}
        
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
        end
        
        AvgData_tst = zeros(length(State_Variables),depth,12); 
        for n = 1:length(State_Variables)
            for m = 1:12
                AvgData_tst(n,1:depth,m) = mean(bfm_tst_data(n,1:depth,[(m-1)*30+1 : m*30]),3);
            end
        end
        AvgData_tst = AvgData_tst./30;
        
        % Calculating Root Mean Squared Values of Daily Values
%         RMSD(prm,index,:) = ...
%             sqrt(sum(sum( (bfm_tst_data - bfm_ref_data).^2, 3), 2)./(150*30));
        RMSD(prm,index,:) = ...
            sqrt(sum(sum( (AvgData_tst - AvgData_ref).^2, 3), 2)./(150*12));
        
        % Normalizing the RMSD
        RMSD_norm(prm,index,:) = squeeze(RMSD(prm,index,:)) ./ STD;
        
        index = index + 1;
    end
end

% Analysis for RMSD with Normalization
% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= %
Total_Norm_RMSD_up = sum(RMSD_norm(:,1,:),3);
Total_Norm_RMSD_dn = sum(RMSD_norm(:,2,:),3);

% Max RMSD for each parameter
Max_Norm_RMSD = max(Total_Norm_RMSD_up, Total_Norm_RMSD_dn);
% Sort to arrange parameters in ascending order
[Max_Norm_RMSD_Srt, Prm_Ind_Srt] = sort(Max_Norm_RMSD,'descend');

%%
% save('RefPlots/OaTSA-BATS-3rdYrMonAvg-MaxNRMSD-tst.mat','Max_Norm_RMSD')

%%
for pind = 1:51
    % Parameter Names organized according to descending Max RMSD Values
    PrmAxisLabels{pind} = Parameter_Labels{Prm_Ind_Srt(pind)};
end

for i = 2:2:51
    PrmAxisLabels{i} = ['- - - ' PrmAxisLabels{i}];
end


%% Plotting 
% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= %
close all

FigWidth = 7;           % Figure Width          (inches)
FigHeight = 2.25;          % Figure Heigth         (inches)

wd = 0.84;              % Plot Width            (proportion of frame)
ht = 0.725;             % Plot Height           (proportion of frame)
lf = 0.08;             % Offset from left      (proportion of frame)
bt = 0.25;              % Offset from bottom    (proportion of frame)


f1 = figure(1); f1.Color = 'w'; f1.InvertHardcopy = 'off';
% Sizing Figure
f1.Units = 'inches'; 
f1.Position = [12 6 FigWidth FigHeight];

subplot('Position',[lf bt wd ht ])
yyaxis right
plt = bar(Max_Norm_RMSD_Srt/Max_Norm_RMSD_Srt(1));

yl = ylabel({'Relative Importance','$S_p / S_p^{(\mathrm{max})}$'});
yl.FontName = fname; yl.FontSize = fsize; ylim([0 1.0])
ax = gca; ax.YColor = 'k';

yyaxis left
plt = bar(Max_Norm_RMSD_Srt);

yl = ylabel({'Sensitivity Factor','$S_p$'}); 
yl.FontName = fname; yl.FontSize = fsize; ylim([0 Max_Norm_RMSD_Srt(1)])

ax = gca; ax.YColor = 'k';
ax.XTick = [1:length(Parameters)]; ax.XTickLabel = PrmAxisLabels; 
ax.XTickLabelRotation = 270; ax.FontName = fname; ax.FontSize = fsize;
ax.TickLabelInterpreter = 'latex';

f1.PaperPosition = [12 12 FigWidth FigHeight];
print(f1,'-dpng', '-r600','RefPlots/SAResults_3rdYrAvg-ref.png')