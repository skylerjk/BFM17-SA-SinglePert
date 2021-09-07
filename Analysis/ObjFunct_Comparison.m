%% Plotting the 10% parameter optimization cases

close all, clear all, clc

% Set color scheme for plots
ClrCase = 'Presentation';
switch ClrCase
    case 'Paper'
        FigClr = 'w'; AxsClr = 'k'; TxtClr = 'k';
        lbox = 'off';
    case 'Presentation'
        FigClr = 'k'; AxsClr = 'w'; TxtClr = 'w';
        lbox = 'off';
end

% % Directory Information % %
%FileLoc = {'../PE-Runs/05Prm-OSSE-1D-FRCG/opt_dir/PEOutput.dat',
%        '../PE-Runs/05Prm-OSSE-1D-COBYLA/opt_dir/PEOutput.dat'};
    
FileLoc = {'../PE-Runs/05Prm-OSSE-1D-FRCGwNorm/opt_dir/PEOutput.dat',
        '../PE-Runs/05Prm-OSSE-1D-COBYLAwNorm/opt_dir/PEOutput.dat'};

% - Parameters Being Tested
prmtrs = {'p_PAR','p_eps0', 'p_sum','z_sum','z_paPPY'};

% - Parameter reference values
prmval = [0.5,0.5,0.2,0.25,1.0];
Clr = {'c','m','g','b'};
% Clr = {'g','b'};

% Optimization output data formatting parameters
delimiter = ' ';
hdr_lines = 1;

for Test = 2:2;

    temp = importdata(FileLoc{Test},delimiter,hdr_lines);
    data = temp.data;

    [num_evl, num] = size(data);
    num_prm = num - 1; 
    
    prm_val = data(:,1:num_prm);
    obj_val = data(:,num);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Figure 1: Plot of Objective Function Evaluations %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    f1 = figure(1);  f1.Color = FigClr; f1.InvertHardcopy = 'off';
    scatter([1:length(obj_val)],obj_val,[45],Clr{Test},'filled'), hold on
    
    if Test == 1; 
    ttl = title('Parameter Study Optimizing the RMSD Summed'); ttl.Color = TxtClr;
    ylabel('Objective Function, \Sigma RMSD_i'), xlabel('Optimization Index')
    
    ax = gca; 
    ax.Color = FigClr; ax.XColor = AxsClr; ax.YColor = AxsClr;
    ax.Box = 'on'; ax.FontName = 'Times';
    end
    
    if Test == 2;
    lg = legend('FRCG','COBYLA');
    lg.Color = FigClr; lg.TextColor = TxtClr; lg.Box = lbox; lg.FontSize = 10;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Figure 2: Plot of Objective Function Evaluations %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    f2 = figure(2);  f2.Color = FigClr; f2.InvertHardcopy = 'off';
    scatter([1:length(obj_val)],obj_val,[45],Clr{Test},'filled'), hold on
    
    if Test == 1; 
    % ttl = title('Parameter Study Optimizing the Summed RMSD'); ttl.Color = TxtClr;
    % ylabel('Objective Function, RMSD'), xlabel('Optimization Index')
    
    ax = gca; ax.YScale='log';
    ax.Color = FigClr; ax.XColor = AxsClr; ax.YColor = AxsClr;
    ax.Box = 'on'; ax.FontName = 'Times';
    end
    
	% if Test == 2;
	% lg = legend('FRCG','COBYLA');
	% lg.Color = FigClr; lg.TextColor = TxtClr; lg.Box = lbox; lg.FontSize = 10;
	% end
    
end
% % Color Gradient for the progression of Optimization
% clrgrd=[1:num_evl]/num_evl;
% 
% %%%%%%%%%%%%%%%%
% % % Figure 1 % %
% %%%%%%%%%%%%%%%%
% f1 = figure(1);  f1.Color = FigClr; f1.InvertHardcopy = 'off';
% scatter([1:length(obj_val)],obj_val,[45],clrgrd,'filled')
% 
% ttl = title('Optimization of RMSD'); ttl.Color = TxtClr;
% ylabel('Objective Function, RMSD'), xlabel('Objective Function Evaluation')
% %ylim([1 51])
% % 
% ax = gca;
% ax.Color = FigClr; ax.XColor = AxsClr; ax.YColor = AxsClr;
% ax.Box = 'on'; ax.FontName = 'Times';
% 
% colormap cool
% 
% %%%%%%%%%%%%%%%%
% % % Figure 2 % % 
% %%%%%%%%%%%%%%%%
% f2 = figure(2);  f2.Color = FigClr; f2.InvertHardcopy = 'off';
% scatter([1:length(obj_val)],obj_val,[45],clrgrd,'filled')
% 
% ttl = title('Optimization of RMSD'); ttl.Color = TxtClr;
% ylabel('Objective Function, RMSD'), xlabel('Objective Function Evaluation')
% 
% 
% ax = gca; ax.YScale='log'
% ax.Color = FigClr; ax.XColor = AxsClr; ax.YColor = AxsClr;
% ax.Box = 'on'; ax.FontName = 'Times';
% 
% colormap cool
% %%%%%%%%%%%%%%%%
% % % Figure 2 % % 
% %%%%%%%%%%%%%%%%
% % f2 = figure(2); f2.Color = FigClr; f2.InvertHardcopy = 'off';
% % Diff_final = prmval - prm_val(length(prm_val),:);
% % scatter(1:num_prm,Diff_final)
% % 
% % ttl = title('OSSE of 51 Parameters'); ttl.Color = TxtClr;
% % xlabel('Parameter Index'), ylabel('Diff, Nom Val - Opt Val')
% % line([1 51],[0 0]), xlim([0 51])
% % % 
% % ax = gca;
% % ax.Color = FigClr; ax.XColor = AxsClr; ax.YColor = AxsClr;
% % ax.Box = 'on'; ax.FontName = 'Times';
% 
% %%%%%%%%%%%%%%%%
% % % Figure 3 % %
% %%%%%%%%%%%%%%%%
% f3 = figure(3); f3.Color = FigClr; f3.InvertHardcopy = 'off';
% for i=1:num_prm
%     Diff_final = prm_val(:,i) - prmval(i) ;
%     scatter(i*ones(1,num_evl),Diff_final,[45],clrgrd,'filled'), hold on
% 
% end 
% ttl = title('OSSE of 51 Parameters'); ttl.Color = TxtClr;
% xlabel('Parameter Index'), ylabel('Diff [ p_i - p_{o} ]')
% line([0 6],[0 0]), xlim([0 6])
% % 
% ax = gca;
% ax.Color = FigClr; ax.XColor = AxsClr; ax.YColor = AxsClr;
% ax.Box = 'on'; ax.FontName = 'Times';
% 
% colormap cool
% cb = colorbar;
% cb.Limits =[0.,1.], cb.Ticks=[0,1]; cb.TickLabels = {'Beginning','End'};
% cb.Color = TxtClr; cb.Location ='southoutside';