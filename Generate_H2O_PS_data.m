
% Generates the water exchange PS simulation data as shown in Manning et al.
% (2020) Slow injection paper
% This is purely for aesthetics - all simulations can be run from the GUI
% for ease of use

clear; close all;

addpath('DCE_Simulation_Functions');
    
% Select default parameters
[PhysParam,DCESeqParam,SimParam,T1acqParam] = load_default_params;
 SimParam.water_exch_model = '2S1XA';
 
% ranges of PS and vP to test
PS_range = linspace(SimParam.min_PS,SimParam.max_PS,10)'+1e-8;
vP_fixed = PhysParam.vP_fixed;

%range sizes to test
N_PS = size(PS_range,1);
kbe_ranges = [1.375 2.75 5.5];

PS_means_H2O_fast = NaN(10,3);
PS_means_H2O_exclude = NaN(10,3);
PS_means_H2O_slow = NaN(10,3);
PS_devs_H2O_fast = NaN(10,3);
PS_devs_H2O_exclude = NaN(10,3);
PS_devs_H2O_slow = NaN(10,3);


 
%% Sim water exchange with Patlak fitting (fast injection, no exclude)
    for i = 1:size(kbe_ranges,2);
        PhysParam.kbe_perS = kbe_ranges(i);
        for i_PS = 1:N_PS
            PhysParam.vP = vP_fixed(1);
            PhysParam.PS_perMin = PS_range(i_PS);
            [temp, PS_fit_2S1X_fast(:,i_PS)] = master_single_sim(PhysParam,DCESeqParam,SimParam);
        end
        
        PS_means_H2O_fast(:,i) = mean(PS_fit_2S1X_fast,1)'; % add mean for each PS for 2S1X
        PS_devs_H2O_fast(:,i) = std(PS_fit_2S1X_fast,0,1)'; % add standard deviation for 2S1X
    end

    %% Sim water exchange with Patlak fitting (fast injection, exclude)
    SimParam.NIgnore = max(SimParam.baselineScans) + 3;
    
    for i = 1:size(kbe_ranges,2);
        PhysParam.kbe_perS = kbe_ranges(i);
        for i_PS = 1:N_PS
            PhysParam.vP = vP_fixed(1);
            PhysParam.PS_perMin = PS_range(i_PS);
            [temp, PS_fit_2S1X_exclude(:,i_PS)] = master_single_sim(PhysParam,DCESeqParam,SimParam);
        end
        
        PS_means_H2O_exclude(:,i) = mean(PS_fit_2S1X_exclude,1)'; % add mean for each PS for 2S1X
        PS_devs_H2O_exclude(:,i) = std(PS_fit_2S1X_exclude,0,1)'; % add standard deviation for 2S1X
    end

    %% Sim water exchange with Patlak fitting (slow injection)
    SimParam.InjectionRate = 'slow';
    SimParam.t_start_s = 0;
    SimParam.baselineScans = [1:3]; % datapoints to use for calculating base signal
    SimParam.NIgnore = max(SimParam.baselineScans);
    
    load('Slow_Cp_AIF_mM.mat') % load example slow injection VIF
    SimParam.Cp_AIF_mM = Cp_AIF_mM;
    SimParam.tRes_InputAIF_s = 39.62; % original time resolution of AIFs
    SimParam.InputAIFDCENFrames = 32; % number of time points
    
    for i = 1:size(kbe_ranges,2);
        PhysParam.kbe_perS = kbe_ranges(i);
        for i_PS = 1:N_PS
            PhysParam.vP = vP_fixed(1);
            PhysParam.PS_perMin = PS_range(i_PS);
            [temp, PS_fit_2S1X_slow(:,i_PS)] = master_single_sim(PhysParam,DCESeqParam,SimParam);
        end
        
        PS_means_H2O_slow(:,i) = mean(PS_fit_2S1X_slow,1)'; % add mean for each PS for 2S1X
        PS_devs_H2O_slow(:,i) = std(PS_fit_2S1X_slow,0,1)'; % add standard deviation for 2S1X
        
    end
    
    %% Sim water exchange with SXL fitting (fast injection, no exclude)
    [PhysParam,DCESeqParam,SimParam,T1acqParam] = load_default_params;
    SimParam.water_exch_model = '2S1XA';
    SimParam.SXLfit = 1;
     

    for i = 1:size(kbe_ranges,2);
        PhysParam.kbe_perS = kbe_ranges(i);
        for i_PS = 1:N_PS
            PhysParam.vP = vP_fixed(1);
            PhysParam.PS_perMin = PS_range(i_PS);
            [temp, PS_fit_2S1X_fast(:,i_PS)] = master_single_sim(PhysParam,DCESeqParam,SimParam);
        end
        
        PS_means_H2O_SXL_fast(:,i) = mean(PS_fit_2S1X_fast,1)'; % add mean for each PS for 2S1X
        PS_devs_H2O_SXL_fast(:,i) = std(PS_fit_2S1X_fast,0,1)'; % add standard deviation for 2S1X
    end

    %% Sim water exchange with SXL fitting (fast injection, exclude)
    SimParam.NIgnore = max(SimParam.baselineScans) + 3;
    
    for i = 1:size(kbe_ranges,2);
        PhysParam.kbe_perS = kbe_ranges(i);
        for i_PS = 1:N_PS
            PhysParam.vP = vP_fixed(1);
            PhysParam.PS_perMin = PS_range(i_PS);
            [temp, PS_fit_2S1X_exclude(:,i_PS)] = master_single_sim(PhysParam,DCESeqParam,SimParam);
        end
        
        PS_means_H2O_SXL_exclude(:,i) = mean(PS_fit_2S1X_exclude,1)'; % add mean for each PS for 2S1X
        PS_devs_H2O_SXL_exclude(:,i) = std(PS_fit_2S1X_exclude,0,1)'; % add standard deviation for 2S1X
    end
    
    %% Sim water exchange with SXL fitting (slow injection)
    SimParam.InjectionRate = 'slow';
    SimParam.t_start_s = 0;
    SimParam.baselineScans = [1:3]; % datapoints to use for calculating base signal
    SimParam.NIgnore = max(SimParam.baselineScans);
    
    load('Slow_Cp_AIF_mM.mat') % load example slow injection VIF
    SimParam.Cp_AIF_mM = Cp_AIF_mM;
    SimParam.tRes_InputAIF_s = 39.62; % original time resolution of AIFs
    SimParam.InputAIFDCENFrames = 32; % number of time points
        
    for i = 1:size(kbe_ranges,2);
        PhysParam.kbe_perS = kbe_ranges(i);
        for i_PS = 1:N_PS
            PhysParam.vP = vP_fixed(1);
            PhysParam.PS_perMin = PS_range(i_PS);
            [temp, PS_fit_2S1X_slow(:,i_PS)] = master_single_sim(PhysParam,DCESeqParam,SimParam);
        end
        
        PS_means_H2O_SXL_slow(:,i) = mean(PS_fit_2S1X_slow,1)'; % add mean for each PS for 2S1X
        PS_devs_H2O_SXL_slow(:,i) = std(PS_fit_2S1X_slow,0,1)'; % add standard deviation for 2S1X
        
    end

    %% Save simulation data
    PS_range = PS_range * 1e4;
    PS_means_H2OPatlak_fast = PS_means_H2O_fast * 1e4;
    PS_means_H2OPatlak_exclude = PS_means_H2O_exclude * 1e4;
    PS_means_H2OPatlak_slow = PS_means_H2O_slow * 1e4;
    PS_devs_H2OPatlak_fast = PS_devs_H2O_fast * 1e4;
    PS_devs_H2OPatlak_exclude = PS_devs_H2O_exclude * 1e4;
    PS_devs_H2OPatlak_slow = PS_devs_H2O_slow * 1e4;
    save('PS_H2OPatlak','PS_means_H2OPatlak_fast','PS_means_H2OPatlak_exclude',...
        'PS_means_H2OPatlak_slow','PS_devs_H2OPatlak_fast','PS_devs_H2OPatlak_exclude','PS_devs_H2OPatlak_slow')
    
    PS_means_SXL_fast = PS_means_H2O_SXL_fast * 1e4;
    PS_means_SXL_exclude = PS_means_H2O_SXL_exclude * 1e4;
    PS_means_SXL_slow = PS_means_H2O_SXL_slow * 1e4;
    PS_devs_SXL_fast = PS_devs_H2O_SXL_fast * 1e4;
    PS_devs_SXL_exclude = PS_devs_H2O_SXL_exclude * 1e4;
    PS_devs_SXL_slow = PS_devs_H2O_SXL_slow * 1e4;
    save('PS_H2OSXL','PS_means_SXL_fast','PS_means_SXL_exclude','PS_means_SXL_slow',...
        'PS_devs_SXL_fast','PS_devs_SXL_exclude','PS_devs_SXL_slow')

    Colour1  = [0 0.447 0.741 0.5];
Colour2 = [0.85 0.325 0.098 0.5];
Colour3 = [0.929 0.694 0.125 0.5];

%% Plot figures        
figure(2)

subplot(2,3,1)

plot(PS_range,zeros(size(PS_range)),'k:','DisplayName','True PS','HandleVisibility','off'); hold on;
errorbar(PS_range, PS_means_H2OPatlak_fast(:,1) - PS_range, 1*PS_devs_H2OPatlak_fast(:,1),'LineWidth',1.3,'Color',Colour1); hold on;
errorbar(PS_range + 0.03, PS_means_H2OPatlak_fast(:,2) - PS_range, 1*PS_devs_H2OPatlak_fast(:,2),'LineWidth',1.3,'Color',Colour2); hold on;
errorbar(PS_range + 0.06, PS_means_H2OPatlak_fast(:,3) - PS_range, 1*PS_devs_H2OPatlak_fast(:,3),'LineWidth',1.3,'Color',Colour3);
ylabel('fitted PS error (x10^{-4} min^{-1} )');
title('Bolus injection');
xlim([0 max(PS_range)]);
ylim([-5 5]);
legend({'k_{be} = 1.375 s^{-1}','k_{be} = 2.75 s^{-1}','k_{be} = 5.5 s^{-1}'},'Location','best')
legend('boxoff')

ax = gca;
ax.FontSize = 9;

subplot(2,3,2)

plot(PS_range,zeros(size(PS_range)),'k:','DisplayName','True PS','HandleVisibility','off'); hold on;
errorbar(PS_range, PS_means_H2OPatlak_exclude(:,1) - PS_range, 1*PS_devs_H2OPatlak_exclude(:,1),'LineWidth',1.3,'Color',Colour1); hold on;
errorbar(PS_range + 0.03, PS_means_H2OPatlak_exclude(:,2) - PS_range, 1*PS_devs_H2OPatlak_exclude(:,2),'LineWidth',1.3,'Color',Colour2); hold on;
errorbar(PS_range + 0.06, PS_means_H2OPatlak_exclude(:,3) - PS_range, 1*PS_devs_H2OPatlak_exclude(:,3),'LineWidth',1.3,'Color',Colour3);
title('Bolus injection (with exclusion)');
xlim([0 max(PS_range)]);
ylim([-2 2]);

ax = gca;
ax.FontSize = 9;

subplot(2,3,3)

plot(PS_range,zeros(size(PS_range)),'k:','DisplayName','True PS','HandleVisibility','off'); hold on;
errorbar(PS_range, PS_means_H2OPatlak_slow(:,1) - PS_range, 1*PS_devs_H2OPatlak_slow(:,1),'LineWidth',1.3,'Color',Colour1); hold on;
errorbar(PS_range + 0.03, PS_means_H2OPatlak_slow(:,2) - PS_range, 1*PS_devs_H2OPatlak_slow(:,2),'LineWidth',1.3,'Color',Colour2); hold on;
errorbar(PS_range + 0.06, PS_means_H2OPatlak_slow(:,3) - PS_range, 1*PS_devs_H2OPatlak_slow(:,3),'LineWidth',1.3,'Color',Colour3);
title('Slow injection');
xlim([0 max(PS_range)]);
ylim([-2 2]);

ax = gca;
ax.FontSize = 9;

subplot(2,3,4)

plot(PS_range,zeros(size(PS_range)),'k:','DisplayName','True PS','HandleVisibility','off'); hold on;
errorbar(PS_range, PS_means_SXL_fast(:,1) - PS_range, 1*PS_devs_SXL_fast(:,1),'LineWidth',1.3,'Color',Colour1); hold on;
errorbar(PS_range + 0.03, PS_means_SXL_fast(:,2) - PS_range, 1*PS_devs_SXL_fast(:,2),'LineWidth',1.3,'Color',Colour2); hold on;
errorbar(PS_range + 0.06, PS_means_SXL_fast(:,3) - PS_range, 1*PS_devs_SXL_fast(:,3),'LineWidth',1.3,'Color',Colour3);
xlabel(['True PS (x10^{-4} min^{-1} )']);
xlim([0 max(PS_range)]);
ylim([-2 2]);
% legend({'k_{be} = 2.5 s^{-1}','k_{be} = 5 s^{-1}','k_{be} = 10 s^{-1}'},'Location','best')
% legend('boxoff')

ax = gca;
ax.FontSize = 9;

subplot(2,3,5)

plot(PS_range,zeros(size(PS_range)),'k:','DisplayName','True PS','HandleVisibility','off'); hold on;
errorbar(PS_range, PS_means_SXL_exclude(:,1) - PS_range, 1*PS_devs_SXL_exclude(:,1),'LineWidth',1.3,'Color',Colour1); hold on;
errorbar(PS_range + 0.03, PS_means_SXL_exclude(:,2) - PS_range, 1*PS_devs_SXL_exclude(:,2),'LineWidth',1.3,'Color',Colour2); hold on;
errorbar(PS_range + 0.06, PS_means_SXL_exclude(:,3) - PS_range, 1*PS_devs_SXL_exclude(:,3),'LineWidth',1.3,'Color',Colour3);
xlabel(['True PS (x10^{-4} min^{-1} )']);
ylim([-2 2]);
xlim([0 max(PS_range)]);

ax = gca;
ax.FontSize = 9;

subplot(2,3,6)

plot(PS_range,zeros(size(PS_range)),'k:','DisplayName','True PS','HandleVisibility','off'); hold on;
errorbar(PS_range, PS_means_SXL_slow(:,1) - PS_range, 1*PS_devs_SXL_slow(:,1),'LineWidth',1.3,'Color',Colour1); hold on;
errorbar(PS_range + 0.03, PS_means_SXL_slow(:,2) - PS_range, 1*PS_devs_SXL_slow(:,2),'LineWidth',1.3,'Color',Colour2); hold on;
errorbar(PS_range + 0.06, PS_means_SXL_slow(:,3) - PS_range, 1*PS_devs_SXL_slow(:,3),'LineWidth',1.3,'Color',Colour3);
xlim([0 max(PS_range)]);
xlabel(['True PS (x10^{-4} min^{-1} )']);
ylim([-2 2]);

ax = gca;
ax.FontSize = 9;