

Subjects=[2 3 4 5 7 8 11 12 13 14 15 16 17 18 19 20 22 23 26 27 28 29 31 32 33 34 35 36 37 38 39 40]; %% good subjects


RootDir=['/Users/binwang/Documents/Bochum/DATA/fMRI_RL_GoNoGo/Results_MD/'];
analysis_dir='Results_outcome_LNLERNRE_cue_MFvsMB_66_dist';
%VOIradius_global= 16;
%VOIradius_local = 8;
VOIname={'rMDm','rMDl','rOFC','rdlPFC'};

%VOIxyz={[4 -14 10],[6 26 50],[14 8 16]};  %

%VOIxyz={[-2 -16 8],[2 18 28],[14 8 16]};  %
%VOIxyz={[2 -14 10],[2 18 28],[14 8 16]};  %


% Initialise SPM
%--------------------------------------------------------------------------
spm('Defaults','fMRI');
spm_jobman('initcfg');
%spm_get_defaults('cmdline',1);

for n = 1:length(Subjects)
    fprintf('Working on participant %d\n',Subjects(n));
    
    inputpath= fullfile(RootDir, 'Participants/', sprintf('Sub%02d',Subjects(n)),analysis_dir);
    
    outputpath=fullfile(RootDir, 'Participants/', sprintf('Sub%02d',Subjects(n)),'DCM_MDm_MDl_OFC_dlPFC_MFvsMB');
%     mkdir(outputpath)
%     
%     clear matlabbatch
%     
%     for i=1:length(VOIname)
%         
%         
%         % EXTRACTING TIME SERIES:
%         %--------------------------------------------------------------------------
%         matlabbatch{i}.spm.util.voi.spmmat = cellstr(fullfile(inputpath,'SPM.mat'));
%         matlabbatch{i}.spm.util.voi.adjust = 1;  % Effects of interest contrast (F-contrast) number
%         matlabbatch{i}.spm.util.voi.session = 1; %
%         matlabbatch{i}.spm.util.voi.name = VOIname{i};
%         
% %         % Define thresholded SPM for finding the subject's local peak response
% %         matlabbatch{i}.spm.util.voi.roi{1}.spm.spmmat = {''}; % using SPM.mat above
% %         
% %         matlabbatch{i}.spm.util.voi.roi{1}.spm.contrast = 6;  % Outcome_LEvsRN
% %         
% %         matlabbatch{i}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
% %         matlabbatch{i}.spm.util.voi.roi{1}.spm.thresh = 0.05;
% %         matlabbatch{i}.spm.util.voi.roi{1}.spm.extent = 0;
%        if i==1 
%        roipath={'/Users/binwang/Documents/Bochum/DATA/fMRI_RL_GoNoGo/Results_MD/Masks4DCM/rMDm.nii'};
%        elseif i==2
%        roipath={'/Users/binwang/Documents/Bochum/DATA/fMRI_RL_GoNoGo/Results_MD/Masks4DCM/rMDl.nii'};
%        elseif i==3
%        roipath={'/Users/binwang/Documents/Bochum/DATA/fMRI_RL_GoNoGo/Results_MD/Masks4DCM/rOFC.nii'};
%        elseif i==4
%        roipath={'/Users/binwang/Documents/Bochum/DATA/fMRI_RL_GoNoGo/Results_MD/Masks4DCM/rdlPFC.nii'};
%        end
%         matlabbatch{i}.spm.util.voi.roi{1}.mask.image = roipath;
%         matlabbatch{i}.spm.util.voi.roi{1}.mask.threshold = 0.5;
% 
%         matlabbatch{i}.spm.util.voi.expression = 'i1';
% 
%     end

    
    
%     spm_jobman('run',matlabbatch);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % DYNAMIC CAUSAL MODELLING
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    clear DCM
    
    % SPECIFICATION DCMs "attentional modulation of backward/forward connection"
    %--------------------------------------------------------------------------
    % To specify a DCM, you might want to create a template one using the GUI
    % then use spm_dcm_U.m and spm_dcm_voi.m to insert new inputs and new
    % regions. The following code creates a DCM file from scratch, which
    % involves some technical subtleties and a deeper knowledge of the DCM
    % structure.
    
    load(fullfile(inputpath,'SPM.mat'));
    
    % Load regions of interest
    %--------------------------------------------------------------------------
    for i=1:length(VOIname)
        
        load(fullfile(inputpath,['VOI_',VOIname{i},'_1.mat']),'xY');
        DCM.xY(i) = xY;

    end
    DCM.n = length(DCM.xY);      % number of regions
    DCM.v = length(DCM.xY(1).u); % number of time points
    
    % Time series
    %--------------------------------------------------------------------------
    DCM.Y.dt  = SPM.xY.RT;
    DCM.Y.X0  = DCM.xY(1).X0;
    for i = 1:DCM.n
        DCM.Y.y(:,i)  = DCM.xY(i).u;
        DCM.Y.name{i} = DCM.xY(i).name;
    end
    
    DCM.Y.Q    = spm_Ce(ones(1,DCM.n)*DCM.v);
    
    % Experimental inputs
    %--------------------------------------------------------------------------
    DCM.U.dt   =  SPM.Sess(1).U(1).dt;
    DCM.U.name = [SPM.Sess(1).U(2).name SPM.Sess(1).U(3).name SPM.Sess(1).U(4).name];
    DCM.U.u    = [SPM.Sess.U(2).u(33:end,1) ...       % LE
                  SPM.Sess.U(3).u(33:end,1) ...       % RN_MF
                  SPM.Sess.U(4).u(33:end,1)];         % RN_MB     
                  

    
    % DCM parameters and options
    %--------------------------------------------------------------------------
    DCM.delays = repmat(SPM.xY.RT/2,DCM.n,1);
    DCM.TE     = 0.04;
    
    DCM.options.nonlinear  = 0;
    DCM.options.two_state  = 0;
    DCM.options.stochastic = 0;
    DCM.options.nograph    = 1;
    
    % Connectivity matrices for model with backward modulation
    %--------------------------------------------------------------------------
    DCM.a = [0 1 1 1; 1 0 1 1; 1 1 1 1; 1 1 1 1]; % endogenous connections  n_node x n_node
    DCM.d = zeros(4,4,4); %nonlinear modulation: n_node x n_node x n_node
    
    %% Bilinear Driving input-MD
    DCM.c = [1 1 1; 1 1 1; 0 0 0;0 0 0];% driving input to a node: n_node x n_conditions
    
    %model 1: 
    DCM.b = zeros(4,4,3);                 % Bilinear: n_node x n_node x n_conditions

    %DCM.b(2,1,1) = 1;  DCM.b(1,2,1) = 1;  % LE
    DCM.b(3,1,1) = 1;  DCM.b(1,3,1) = 1;  % LE
    DCM.b(4,2,1) = 1;  DCM.b(2,4,1) = 1;  % LE

    DCM.b(3,4,1) = 1;  DCM.b(4,3,1) = 1;  % LE
    DCM.b(2,3,1) = 1;  DCM.b(3,2,1) = 1;  % LE
    DCM.b(4,1,1) = 1;  DCM.b(1,4,1) = 1;  % LE
    
    
    %DCM.b(2,1,2) = 1;  DCM.b(1,2,2) = 1;  % MF
    DCM.b(3,1,2) = 1;  DCM.b(1,3,2) = 1;  % MF
    DCM.b(4,2,2) = 1;  DCM.b(2,4,2) = 1;  % MF

    DCM.b(3,4,2) = 1;  DCM.b(4,3,2) = 1;  % MF
    DCM.b(2,3,2) = 1;  DCM.b(3,2,2) = 1;  % MF 
    DCM.b(4,1,2) = 1;  DCM.b(1,4,2) = 1;  % MF

   %DCM.b(2,1,3) = 1;  DCM.b(1,2,3) = 1;  % MB
    DCM.b(3,1,3) = 1;  DCM.b(1,3,3) = 1;  % MB
    DCM.b(4,2,3) = 1;  DCM.b(2,4,3) = 1;  % MB

    DCM.b(3,4,3) = 1;  DCM.b(4,3,3) = 1;  % MB
    DCM.b(2,3,3) = 1;  DCM.b(3,2,3) = 1;  % MB 
    DCM.b(4,1,3) = 1;  DCM.b(1,4,3) = 1;  % MB
    save(fullfile(outputpath,'DCM_mod05_bilinear.mat'),'DCM');
    
    % DCM Estimation
    %--------------------------------------------------------------------------
    clear matlabbatch
    
    
    matlabbatch{1}.spm.dcm.fmri.estimate.dcmmat = {...
        fullfile(outputpath,'DCM_mod05_bilinear.mat')};
    
    
    spm_jobman('run',matlabbatch);
    
    % Bayesian Model Comparison
    %--------------------------------------------------------------------------
%     DCM_1 = load('DCM_mod1_test.mat','F');
%     DCM_2 = load('DCM_mod2_test.mat','F');
%     fprintf('Model evidence: %f (mod1) vs %f (mod2)\n',DCM_1.F,DCM_2.F);
end
