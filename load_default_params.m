function [PhysParam,DCESeqParam,SimParam,T1acqParam] = load_default_params

%% Physiological parameters
PhysParam.Hct = 0.42; % Haematocrit
PhysParam.vE = 0.2; % EES volume fraction
PhysParam.FP_mlPer100gPerMin = 11; % Plasma flow
PhysParam.T10_blood_s = 1.90; % baseline T1 blood
PhysParam.T10_tissue_s = 0.92; % baseline T1 tissue (NAWM)
PhysParam.T2s0_blood_s = 0.19; % baseline T2* blood
PhysParam.T2s0_tissue_s = 0.050; % baseline T2* tissue
PhysParam.S0_blood = 100; % baseline signal blood
PhysParam.S0_tissue = 100; % baseline signal tissue
PhysParam.kbe_perS = 2.75; % blood - EES water exchange rate
PhysParam.kie_perS = 1.7; % intracellular space - EES exchange rate
PhysParam.vP_fixed = 0.015; % plasma volume fraction
PhysParam.PS_fixed = 2.96 * 1e-4; % surface area - permeability product

%% DCE Sequence parameters
DCESeqParam.t_acq_s = 1268; % acquisition duration
DCESeqParam.t_res_sample_s = 39.62; % sample temporal resolution
DCESeqParam.TR_s = 1e-3*3.4; % repetition time
DCESeqParam.TE_s = 1e-3*1.7; % echo time
DCESeqParam.r1_per_mM_per_s = 5.0; % T1 relaxivity of contrast agent
DCESeqParam.r2_per_mM_per_s = 0; % T2 relaxivity of contrast agent
DCESeqParam.NPoints = round(DCESeqParam.t_acq_s/DCESeqParam.t_res_sample_s); % number of sample points

DCESeqParam.FA_nom_deg = 15; % nominal flip angle
DCESeqParam.blood_FA_error = 1; % k value (flip angle error) for blood
DCESeqParam.tissue_FA_error = 1; % k value (flip angle error) for tissue
DCESeqParam.blood_FA_true_deg = DCESeqParam.blood_FA_error*DCESeqParam.FA_nom_deg; % true flip angle
DCESeqParam.tissue_FA_true_deg = DCESeqParam.tissue_FA_error*DCESeqParam.FA_nom_deg; % true flip angle

%% Simulation parameters
SimParam.N_repetitions = 1000; % repetitions at each PS or vP (to quantify effects of noise)
SimParam.t_res_full_s = 0.1; % generated temporal resolution of simulations
SimParam.SNR = 230; % signal to noise ratio for NAWM
SimParam.drift_pctPerMin = 0; % signal drift
SimParam.min_PS = 0 * 1e-4; % minimum PS to test vP
SimParam.max_PS = 5 * 1e-4; % maximum PS to test vP
SimParam.min_vP = 0.01; % minimum vP to test PS (vP range from Leenders 1990)
SimParam.max_vP = 0.02; % maximum vP to test PS

SimParam.venous_delay_s = 6; % delay of measured VIF compared to AIF
SimParam.t_start_s = 119; % injection delay in seconds
SimParam.InjectionRate = 'fast'; % Speed of injection (slow or fast)
SimParam.syn_model = '2CXM'; % model to simulate contrast leakage
SimParam.water_exch_model = '2S1XA'; % water exchange model to generate signals
SimParam.baselineScans = [1:3]; % datapoints to use for calculating base signal
SimParam.NIgnore = max(SimParam.baselineScans); % number of post-contrast points to exclude (always uses 3 points for baseline signal)
SimParam.SXLfit = 0; % fit enhancements according to SXL method
SimParam.Plot_extra_figs = 0; % plot figures of extra data for each simulation

%% T1 acquisition parameters
T1acqParam.T1_acq_method = 'VFA';  
T1acqParam.isFit = [1 1 1]; % which acquisitions to fit
T1acqParam.TR_s = [0.0054 0.0054 0.0054]; % repetition times for T1 acqusition
T1acqParam.blood_FA_nom_rads = [2 5 12]*2*(pi/360); % Nominal FA in rads
T1acqParam.tissue_FA_nom_rads = T1acqParam.blood_FA_nom_rads; % Nominal FA for blood and tissue is equal without correction
T1acqParam.blood_FA_true_rads = DCESeqParam.blood_FA_error * T1acqParam.blood_FA_nom_rads; % derive actual flip angles for T1 acquisition
T1acqParam.tissue_FA_true_rads = DCESeqParam.tissue_FA_error * T1acqParam.tissue_FA_nom_rads;
T1acqParam.isIR = [0 0 0]; % indicates which are IR-SPGR
T1acqParam.TI_s = [NaN NaN NaN]; % Inversion times for T1 acquisition (for HIFI)
T1acqParam.PECentre = [NaN NaN NaN]; % indicates time of centre of k-space
T1acqParam.NReadout = [160 160 160]; % number of readout pulses (Siemens - number of slices)
T1acqParam.NTry = 1; % fitting attempts
T1acqParam.T1_SNR = 318;
T1acqParam.blood_FA_error_meas = DCESeqParam.blood_FA_error;
T1acqParam.tissue_FA_error_meas = DCESeqParam.tissue_FA_error;
DCESeqParam.blood_FA_meas_deg = DCESeqParam.FA_nom_deg;
DCESeqParam.tissue_FA_meas_deg = DCESeqParam.FA_nom_deg;

end