clear all, clc, close all

Data3600 = load('Plots/1007-OaTSA-10perc/OaTSA_RMSD_dt3600.mat');
TotRMSD3600_up = Data3600.Total_RMSD_up;
TotRMSD3600_dn = Data3600.Total_RMSD_dn;

Data400 = load('Plots/1007-OaTSA-10perc/OaTSA_RMSD_dt3600.mat');
TotRMSD400_up = Data400.Total_RMSD_up;
TotRMSD400_dn = Data400.Total_RMSD_dn;

Dif_TotRMSD_up = TotRMSD3600_up - TotRMSD400_up;
Dif_TotRMSD_dn = TotRMSD3600_dn - TotRMSD400_dn;

%%
close all

f1 = figure();
bar(Dif_TotRMSD_up), hold on 
bar(Dif_TotRMSD_dn)

% ylim([-15 15]); 
xlim([.25 51.75]);
set(gca,'yticklabel',num2str(abs(get(gca,'ytick').')));

title('Single Parameter Pertubration Sensitivity Analysis');
ylabel('Total RMSD'); xlabel('Parameter Index');

legend('Pert. Up','Pert. Down')
