

Subjects=[2 3 4 5 7 8 11 12 13 14 15 16 17 18 19 20 22 23 26 27 28 29 31 32 33 34 35 36 37 38 39 40]; %% good subjects
%Sub03-No BG; Sub20-No dmPFC; Sub27-No MD; Sub36-No MD; Sub37-No MD; Sub33-No dmPFC; Sub38-No dmPFC
Subjects=[2 4 5 7 8 11 12 13 14 15 16 17 18 19 22 23 26 28 29 31 32 34 35 39 40];

RootDir=['D:\Bochum\DATA\fMRI_RL_GoNoGo\Results_MD\Participants\'];
analysis_dir='Results_outcome_LNLERNRE_cue_DCM_new';
VOIradius_global= 16;
VOIradius_local = 8;
VOIname={'MD','dmPFC','BG'};
VOIxyz={[4 -14 10],[6 26 50],[14 8 16]};  %

%VOIxyz={[-2 -16 8],[2 18 28],[14 8 16]};  %
%VOIxyz={[2 -14 10],[2 18 28],[14 8 16]};  %


% Initialise SPM
%--------------------------------------------------------------------------
spm('Defaults','fMRI');
spm_jobman('initcfg');
%spm_get_defaults('cmdline',1);

for n = 1:length(Subjects)
    fprintf('Working on participant %d\n',Subjects(n));
    
    inputpath= fullfile(RootDir, sprintf('Sub%02d',Subjects(n)),analysis_dir);
    
    outputpath=fullfile(RootDir, sprintf('Sub%02d',Subjects(n)),'DCM_MD_dmPFC_BG_new2_test');
    mkdir(outputpath)
    
%     clear matlabbatch
    
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
%         % Define thresholded SPM for finding the subject's local peak response
%         matlabbatch{i}.spm.util.voi.roi{1}.spm.spmmat = {''}; % using SPM.mat above
%         
%         matlabbatch{i}.spm.util.voi.roi{1}.spm.contrast = 6;  % Outcome_LEvsRN
%         
%         matlabbatch{i}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
%         matlabbatch{i}.spm.util.voi.roi{1}.spm.thresh = 0.05;
%         matlabbatch{i}.spm.util.voi.roi{1}.spm.extent = 0;
%         
%         % Define large fixed outer sphere to fine the peak
%         matlabbatch{i}.spm.util.voi.roi{2}.sphere.centre = VOIxyz{i};
%         matlabbatch{i}.spm.util.voi.roi{2}.sphere.radius = VOIradius_global;
%         matlabbatch{i}.spm.util.voi.roi{2}.sphere.move.fixed = 1;
%         
%         % Define smaller inner sphere which jumps to the peak of the outer sphere
%         matlabbatch{i}.spm.util.voi.roi{3}.sphere.centre           = [0 0 0]; % Leave this at zero
%         matlabbatch{i}.spm.util.voi.roi{3}.sphere.radius           = VOIradius_local;       % Set radius here (mm)
%         matlabbatch{i}.spm.util.voi.roi{3}.sphere.move.global.spm  = 1;       % Index of SPM within the batch
%         matlabbatch{i}.spm.util.voi.roi{3}.sphere.move.global.mask = 'i2';    % Index of the outer sphere within the batch
%         
%         % Include voxels in the thresholded SPM (i1) and the mobile inner sphere (i3)
%         matlabbatch{i}.spm.util.voi.expression = 'i1 & i3';
%         
%     end
%     
%     
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
    DCM.U.name = [SPM.Sess(1).U(2).name SPM.Sess(1).U(3).name];
    DCM.U.u    = [SPM.Sess.U(2).u(33:end,1) ...       % LE
                  SPM.Sess.U(3).u(33:end,1)];         % RN     
                  

    
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
    DCM.a = [1 1 1 ; 1 1 1 ; 1 1 1 ]; % endogenous connections  n_node x n_node
    DCM.d = zeros(3,3,0); %nonlinear modulation: n_node x n_node x n_node
    
    %% Bilinear Driving input-MD
    DCM.c = [1 1; 0 0; 0 0];% driving input to a node: n_node x n_conditions
    
    %model 1: 
    DCM.b = zeros(3,3,2);                 % Bilinear: n_node x n_node x n_conditions
    DCM.b(2,1,1) = 1;  DCM.b(1,2,1) = 1;  % MD->dmPFC  & dmPFC->MD  in LE 
    DCM.b(3,1,1) = 1;  DCM.b(1,3,1) = 1;  % MD->BG     & BG->MD     in LE 
    
    DCM.b(2,1,2) = 1;  DCM.b(1,2,2) = 1;  % MD->dmPFC  & dmPFC->MD  in RN 
    DCM.b(3,1,2) = 1;  DCM.b(1,3,2) = 1;  % MD->BG     & BG->MD     in RN 

    save(fullfile(outputpath,'DCM_mod01_bilinear.mat'),'DCM');
    
    %model 2: 
    DCM.b = zeros(3,3,2); 
    DCM.b(2,1,1) = 1;  DCM.b(1,2,1) = 1;  % MD->dmPFC  & dmPFC->MD  in LE 
    DCM.b(3,1,1) = 1;  DCM.b(2,3,1) = 1;  % MD->BG     & BG->dmPFC  in LE 
    
    DCM.b(2,1,2) = 1;  DCM.b(1,2,2) = 1;  % MD->dmPFC  & dmPFC->MD  in RN 
    DCM.b(3,1,2) = 1;  DCM.b(2,3,2) = 1;  % MD->BG     & BG->dmPFC  in RN  
    save(fullfile(outputpath,'DCM_mod02_bilinear.mat'),'DCM');
    
    %model 3:
    DCM.b = zeros(3,3,2); 
    DCM.b(2,1,1) = 1;  DCM.b(1,2,1) = 1;  % MD->dmPFC  & dmPFC->MD  in LE 
    DCM.b(3,1,1) = 1;  DCM.b(3,2,1) = 1;  % MD->BG     & dmPFC->BG  in LE 
    
    DCM.b(2,1,2) = 1;  DCM.b(1,2,2) = 1;  % MD->dmPFC  & dmPFC->MD  in RN 
    DCM.b(3,1,2) = 1;  DCM.b(3,2,2) = 1;  % MD->BG     & dmPFC->BG  in RN  
    save(fullfile(outputpath,'DCM_mod03_bilinear.mat'),'DCM');
    
    %model 4:
    DCM.b = zeros(3,3,2); 
    DCM.b(2,1,1) = 1;  DCM.b(1,2,1) = 1;  % MD->dmPFC  & dmPFC->MD  in LE 
    DCM.b(1,3,1) = 1;  DCM.b(3,2,1) = 1;  % BG->MD     & dmPFC->BG  in LE 
    
    DCM.b(2,1,2) = 1;  DCM.b(1,2,2) = 1;  % MD->dmPFC  & dmPFC->MD  in RN 
    DCM.b(1,3,2) = 1;  DCM.b(3,2,2) = 1;  % BG->MD     & dmPFC->BG  in RN    
    save(fullfile(outputpath,'DCM_mod04_bilinear.mat'),'DCM');
    
    %model 5:
    DCM.b = zeros(3,3,2); 
    DCM.b(2,1,1) = 1;  DCM.b(1,2,1) = 1;  % MD->dmPFC  & dmPFC->MD  in LE 
    DCM.b(1,3,1) = 1;  DCM.b(2,3,1) = 1;  % BG->MD     & BG->dmPFC  in LE 
    
    DCM.b(2,1,2) = 1;  DCM.b(1,2,2) = 1;  % MD->dmPFC  & dmPFC->MD  in RN 
    DCM.b(1,3,2) = 1;  DCM.b(2,3,2) = 1;  % BG->MD     & BG->dmPFC  in RN   
    save(fullfile(outputpath,'DCM_mod05_bilinear.mat'),'DCM');
   
    %model 6:
    DCM.b = zeros(3,3,2); 
    DCM.b(3,2,1) = 1;  DCM.b(2,3,1) = 1;  % dmPFC->BG  & BG->dmPFC     in LE 
    DCM.b(2,1,1) = 1;  DCM.b(1,2,1) = 1;  % MD->dmPFC  & dmPFC->MD     in LE 
    
    DCM.b(3,2,2) = 1;  DCM.b(2,3,2) = 1;  % dmPFC->BG  & BG->dmPFC   in RN   
    DCM.b(2,1,2) = 1;  DCM.b(1,2,2) = 1;  % MD->dmPFC  & dmPFC->MD   in RN 
    save(fullfile(outputpath,'DCM_mod06_bilinear.mat'),'DCM');
    
    %model 7:
    DCM.b = zeros(3,3,2); 
    DCM.b(3,2,1) = 1;  DCM.b(2,3,1) = 1;  % dmPFC->BG  & BG->dmPFC     in LE 
    DCM.b(1,3,1) = 1;  DCM.b(2,1,1) = 1;  % BG->MD     & MD->dmPFC     in LE 
    
    DCM.b(3,2,2) = 1;  DCM.b(2,3,2) = 1;  % dmPFC->BG  & BG->dmPFC     in RN   
    DCM.b(1,3,2) = 1;  DCM.b(2,1,2) = 1;  % BG->MD     & MD->dmPFC     in RN  
    save(fullfile(outputpath,'DCM_mod07_bilinear.mat'),'DCM');
    
    %model 8:
    DCM.b = zeros(3,3,2); 
    DCM.b(3,2,1) = 1;  DCM.b(2,3,1) = 1;  % dmPFC->BG  & BG->dmPFC     in LE 
    DCM.b(1,3,1) = 1;  DCM.b(1,2,1) = 1;  % BG->MD     & dmPFC->MD     in LE 
    
    DCM.b(3,2,2) = 1;  DCM.b(2,3,2) = 1;  % dmPFC->BG  & BG->dmPFC     in RN   
    DCM.b(1,3,2) = 1;  DCM.b(1,2,2) = 1;  % BG->MD     & dmPFC->MD     in RN     
    save(fullfile(outputpath,'DCM_mod08_bilinear.mat'),'DCM');
    
    %model 9:
    DCM.b = zeros(3,3,2); 
    DCM.b(3,2,1) = 1;  DCM.b(2,3,1) = 1;  % dmPFC->BG  & BG->dmPFC     in LE 
    DCM.b(3,1,1) = 1;  DCM.b(1,2,1) = 1;  % MD->BG     & dmPFC->MD     in LE 
    
    DCM.b(3,2,2) = 1;  DCM.b(2,3,2) = 1;  % dmPFC->BG  & BG->dmPFC     in RN   
    DCM.b(3,1,2) = 1;  DCM.b(1,2,2) = 1;  % MD->BG     & dmPFC->MD     in RN 
    save(fullfile(outputpath,'DCM_mod09_bilinear.mat'),'DCM');

    %model 10:
    DCM.b = zeros(3,3,2); 
    DCM.b(3,2,1) = 1;  DCM.b(2,3,1) = 1;  % dmPFC->BG  & BG->dmPFC     in LE 
    DCM.b(3,1,1) = 1;  DCM.b(2,1,1) = 1;  % MD->BG     & MD->dmPFC     in LE 
    
    DCM.b(3,2,2) = 1;  DCM.b(2,3,2) = 1;  % dmPFC->BG  & BG->dmPFC     in RN   
    DCM.b(3,1,2) = 1;  DCM.b(2,1,2) = 1;  % MD->BG     & MD->dmPFC     in RN 
    save(fullfile(outputpath,'DCM_mod10_bilinear.mat'),'DCM');

    %model 11:
    DCM.b = zeros(3,3,2); 
    DCM.b(3,1,1) = 1;  DCM.b(1,3,1) = 1;  % MD->BG     &  BG->MD     in LE 
    DCM.b(3,2,1) = 1;  DCM.b(2,3,1) = 1;  % dmPFC->BG  &  BG->dmPFC  in LE 
    
    DCM.b(3,1,2) = 1;  DCM.b(1,3,2) = 1;  % MD->BG     &  BG->MD     in RN 
    DCM.b(3,2,2) = 1;  DCM.b(2,3,2) = 1;  % dmPFC->BG  &  BG->dmPFC  in RN 
    save(fullfile(outputpath,'DCM_mod11_bilinear.mat'),'DCM');    
    
    %model 12:
    DCM.b = zeros(3,3,2); 
    DCM.b(3,1,1) = 1;  DCM.b(1,3,1) = 1;  % MD->BG     &  BG->MD     in LE 
    DCM.b(3,2,1) = 1;  DCM.b(2,1,1) = 1;  % dmPFC->BG  &  MD->dmPFC  in LE 
    
    DCM.b(3,1,2) = 1;  DCM.b(1,3,2) = 1;  % MD->BG     &  BG->MD     in RN 
    DCM.b(3,2,2) = 1;  DCM.b(2,1,2) = 1;  % dmPFC->BG  &  MD->dmPFC  in RN 
    save(fullfile(outputpath,'DCM_mod12_bilinear.mat'),'DCM');       
    
    %model 13:
    DCM.b = zeros(3,3,2); 
    DCM.b(3,1,1) = 1;  DCM.b(1,3,1) = 1;  % MD->BG     &  BG->MD     in LE 
    DCM.b(2,3,1) = 1;  DCM.b(2,1,1) = 1;  % BG->dmPFC  &  MD->dmPFC  in LE 
    
    DCM.b(3,1,2) = 1;  DCM.b(1,3,2) = 1;  % MD->BG     &  BG->MD     in RN 
    DCM.b(2,3,2) = 1;  DCM.b(2,1,2) = 1;  % BG->dmPFC  &  MD->dmPFC  in RN 
    save(fullfile(outputpath,'DCM_mod13_bilinear.mat'),'DCM');     
    
    %model 14:
    DCM.b = zeros(3,3,2); 
    DCM.b(3,1,1) = 1;  DCM.b(1,3,1) = 1;  % MD->BG     &  BG->MD     in LE 
    DCM.b(2,3,1) = 1;  DCM.b(1,2,1) = 1;  % BG->dmPFC  &  dmPFC-> MD in LE 
    
    DCM.b(3,1,2) = 1;  DCM.b(1,3,2) = 1;  % MD->BG     &  BG->MD     in RN 
    DCM.b(2,3,2) = 1;  DCM.b(1,2,2) = 1;  % BG->dmPFC  &  dmPFC-> MD  in RN 
    save(fullfile(outputpath,'DCM_mod14_bilinear.mat'),'DCM');     
 
    %model 15:
    DCM.b = zeros(3,3,2); 
    DCM.b(3,1,1) = 1;  DCM.b(1,3,1) = 1;  % MD->BG     &  BG->MD     in LE 
    DCM.b(3,2,1) = 1;  DCM.b(1,2,1) = 1;  % dmPFC->BG  &  dmPFC-> MD in LE 
    
    DCM.b(3,1,2) = 1;  DCM.b(1,3,2) = 1;  % MD->BG     &  BG->MD     in RN 
    DCM.b(3,2,2) = 1;  DCM.b(1,2,2) = 1;  % dmPFC->BG  &  dmPFC-> MD  in RN 
    save(fullfile(outputpath,'DCM_mod15_bilinear.mat'),'DCM'); 
    
    
    %% Bilinear Driving input-ACC
    DCM.c = [0 0; 1 1; 0 0];% driving input to a node: n_node x n_conditions   

    %model 16: 
    DCM.b = zeros(3,3,2);                 % Bilinear: n_node x n_node x n_conditions
    DCM.b(2,1,1) = 1;  DCM.b(1,2,1) = 1;  % MD->dmPFC  & dmPFC->MD  in LE 
    DCM.b(3,1,1) = 1;  DCM.b(1,3,1) = 1;  % MD->BG     & BG->MD     in LE 
    
    DCM.b(2,1,2) = 1;  DCM.b(1,2,2) = 1;  % MD->dmPFC  & dmPFC->MD  in RN 
    DCM.b(3,1,2) = 1;  DCM.b(1,3,2) = 1;  % MD->BG     & BG->MD     in RN 

    save(fullfile(outputpath,'DCM_mod16_bilinear.mat'),'DCM');
    
    %model 17: 
    DCM.b = zeros(3,3,2); 
    DCM.b(2,1,1) = 1;  DCM.b(1,2,1) = 1;  % MD->dmPFC  & dmPFC->MD  in LE 
    DCM.b(3,1,1) = 1;  DCM.b(2,3,1) = 1;  % MD->BG     & BG->dmPFC  in LE 
    
    DCM.b(2,1,2) = 1;  DCM.b(1,2,2) = 1;  % MD->dmPFC  & dmPFC->MD  in RN 
    DCM.b(3,1,2) = 1;  DCM.b(2,3,2) = 1;  % MD->BG     & BG->dmPFC  in RN  
    save(fullfile(outputpath,'DCM_mod17_bilinear.mat'),'DCM');
    
    %model 18:
    DCM.b = zeros(3,3,2); 
    DCM.b(2,1,1) = 1;  DCM.b(1,2,1) = 1;  % MD->dmPFC  & dmPFC->MD  in LE 
    DCM.b(3,1,1) = 1;  DCM.b(3,2,1) = 1;  % MD->BG     & dmPFC->BG  in LE 
    
    DCM.b(2,1,2) = 1;  DCM.b(1,2,2) = 1;  % MD->dmPFC  & dmPFC->MD  in RN 
    DCM.b(3,1,2) = 1;  DCM.b(3,2,2) = 1;  % MD->BG     & dmPFC->BG  in RN  
    save(fullfile(outputpath,'DCM_mod18_bilinear.mat'),'DCM');
    
    %model 19:
    DCM.b = zeros(3,3,2); 
    DCM.b(2,1,1) = 1;  DCM.b(1,2,1) = 1;  % MD->dmPFC  & dmPFC->MD  in LE 
    DCM.b(1,3,1) = 1;  DCM.b(3,2,1) = 1;  % BG->MD     & dmPFC->BG  in LE 
    
    DCM.b(2,1,2) = 1;  DCM.b(1,2,2) = 1;  % MD->dmPFC  & dmPFC->MD  in RN 
    DCM.b(1,3,2) = 1;  DCM.b(3,2,2) = 1;  % BG->MD     & dmPFC->BG  in RN    
    save(fullfile(outputpath,'DCM_mod19_bilinear.mat'),'DCM');
    
    %model 20:
    DCM.b = zeros(3,3,2); 
    DCM.b(2,1,1) = 1;  DCM.b(1,2,1) = 1;  % MD->dmPFC  & dmPFC->MD  in LE 
    DCM.b(1,3,1) = 1;  DCM.b(2,3,1) = 1;  % BG->MD     & BG->dmPFC  in LE 
    
    DCM.b(2,1,2) = 1;  DCM.b(1,2,2) = 1;  % MD->dmPFC  & dmPFC->MD  in RN 
    DCM.b(1,3,2) = 1;  DCM.b(2,3,2) = 1;  % BG->MD     & BG->dmPFC  in RN   
    save(fullfile(outputpath,'DCM_mod20_bilinear.mat'),'DCM');
   
    %model 21:
    DCM.b = zeros(3,3,2); 
    DCM.b(3,2,1) = 1;  DCM.b(2,3,1) = 1;  % dmPFC->BG  & BG->dmPFC     in LE 
    DCM.b(2,1,1) = 1;  DCM.b(1,2,1) = 1;  % MD->dmPFC  & dmPFC->MD     in LE 
    
    DCM.b(3,2,2) = 1;  DCM.b(2,3,2) = 1;  % dmPFC->BG  & BG->dmPFC   in RN   
    DCM.b(2,1,2) = 1;  DCM.b(1,2,2) = 1;  % MD->dmPFC  & dmPFC->MD   in RN 
    save(fullfile(outputpath,'DCM_mod21_bilinear.mat'),'DCM');
    
    %model 22:
    DCM.b = zeros(3,3,2); 
    DCM.b(3,2,1) = 1;  DCM.b(2,3,1) = 1;  % dmPFC->BG  & BG->dmPFC     in LE 
    DCM.b(1,3,1) = 1;  DCM.b(2,1,1) = 1;  % BG->MD     & MD->dmPFC     in LE 
    
    DCM.b(3,2,2) = 1;  DCM.b(2,3,2) = 1;  % dmPFC->BG  & BG->dmPFC     in RN   
    DCM.b(1,3,2) = 1;  DCM.b(2,1,2) = 1;  % BG->MD     & MD->dmPFC     in RN  
    save(fullfile(outputpath,'DCM_mod22_bilinear.mat'),'DCM');
    
    %model 23:
    DCM.b = zeros(3,3,2); 
    DCM.b(3,2,1) = 1;  DCM.b(2,3,1) = 1;  % dmPFC->BG  & BG->dmPFC     in LE 
    DCM.b(1,3,1) = 1;  DCM.b(1,2,1) = 1;  % BG->MD     & dmPFC->MD     in LE 
    
    DCM.b(3,2,2) = 1;  DCM.b(2,3,2) = 1;  % dmPFC->BG  & BG->dmPFC     in RN   
    DCM.b(1,3,2) = 1;  DCM.b(1,2,2) = 1;  % BG->MD     & dmPFC->MD     in RN     
    save(fullfile(outputpath,'DCM_mod23_bilinear.mat'),'DCM');
    
    %model 24:
    DCM.b = zeros(3,3,2); 
    DCM.b(3,2,1) = 1;  DCM.b(2,3,1) = 1;  % dmPFC->BG  & BG->dmPFC     in LE 
    DCM.b(3,1,1) = 1;  DCM.b(1,2,1) = 1;  % MD->BG     & dmPFC->MD     in LE 
    
    DCM.b(3,2,2) = 1;  DCM.b(2,3,2) = 1;  % dmPFC->BG  & BG->dmPFC     in RN   
    DCM.b(3,1,2) = 1;  DCM.b(1,2,2) = 1;  % MD->BG     & dmPFC->MD     in RN 
    save(fullfile(outputpath,'DCM_mod24_bilinear.mat'),'DCM');

    %model 25:
    DCM.b = zeros(3,3,2); 
    DCM.b(3,2,1) = 1;  DCM.b(2,3,1) = 1;  % dmPFC->BG  & BG->dmPFC     in LE 
    DCM.b(3,1,1) = 1;  DCM.b(2,1,1) = 1;  % MD->BG     & MD->dmPFC     in LE 
    
    DCM.b(3,2,2) = 1;  DCM.b(2,3,2) = 1;  % dmPFC->BG  & BG->dmPFC     in RN   
    DCM.b(3,1,2) = 1;  DCM.b(2,1,2) = 1;  % MD->BG     & MD->dmPFC     in RN 
    save(fullfile(outputpath,'DCM_mod25_bilinear.mat'),'DCM');

    %model 26:
    DCM.b = zeros(3,3,2); 
    DCM.b(3,1,1) = 1;  DCM.b(1,3,1) = 1;  % MD->BG     &  BG->MD     in LE 
    DCM.b(3,2,1) = 1;  DCM.b(2,3,1) = 1;  % dmPFC->BG  &  BG->dmPFC  in LE 
    
    DCM.b(3,1,2) = 1;  DCM.b(1,3,2) = 1;  % MD->BG     &  BG->MD     in RN 
    DCM.b(3,2,2) = 1;  DCM.b(2,3,2) = 1;  % dmPFC->BG  &  BG->dmPFC  in RN 
    save(fullfile(outputpath,'DCM_mod26_bilinear.mat'),'DCM');    
    
    %model 27:
    DCM.b = zeros(3,3,2); 
    DCM.b(3,1,1) = 1;  DCM.b(1,3,1) = 1;  % MD->BG     &  BG->MD     in LE 
    DCM.b(3,2,1) = 1;  DCM.b(2,1,1) = 1;  % dmPFC->BG  &  MD->dmPFC  in LE 
    
    DCM.b(3,1,2) = 1;  DCM.b(1,3,2) = 1;  % MD->BG     &  BG->MD     in RN 
    DCM.b(3,2,2) = 1;  DCM.b(2,1,2) = 1;  % dmPFC->BG  &  MD->dmPFC  in RN 
    save(fullfile(outputpath,'DCM_mod27_bilinear.mat'),'DCM');       
    
    %model 28:
    DCM.b = zeros(3,3,2); 
    DCM.b(3,1,1) = 1;  DCM.b(1,3,1) = 1;  % MD->BG     &  BG->MD     in LE 
    DCM.b(2,3,1) = 1;  DCM.b(2,1,1) = 1;  % BG->dmPFC  &  MD->dmPFC  in LE 
    
    DCM.b(3,1,2) = 1;  DCM.b(1,3,2) = 1;  % MD->BG     &  BG->MD     in RN 
    DCM.b(2,3,2) = 1;  DCM.b(2,1,2) = 1;  % BG->dmPFC  &  MD->dmPFC  in RN 
    save(fullfile(outputpath,'DCM_mod28_bilinear.mat'),'DCM');     
    
    %model 29:
    DCM.b = zeros(3,3,2); 
    DCM.b(3,1,1) = 1;  DCM.b(1,3,1) = 1;  % MD->BG     &  BG->MD     in LE 
    DCM.b(2,3,1) = 1;  DCM.b(1,2,1) = 1;  % BG->dmPFC  &  dmPFC-> MD in LE 
    
    DCM.b(3,1,2) = 1;  DCM.b(1,3,2) = 1;  % MD->BG     &  BG->MD     in RN 
    DCM.b(2,3,2) = 1;  DCM.b(1,2,2) = 1;  % BG->dmPFC  &  dmPFC-> MD  in RN 
    save(fullfile(outputpath,'DCM_mod29_bilinear.mat'),'DCM');     
 
    %model 30:
    DCM.b = zeros(3,3,2); 
    DCM.b(3,1,1) = 1;  DCM.b(1,3,1) = 1;  % MD->BG     &  BG->MD     in LE 
    DCM.b(3,2,1) = 1;  DCM.b(1,2,1) = 1;  % dmPFC->BG  &  dmPFC-> MD in LE 
    
    DCM.b(3,1,2) = 1;  DCM.b(1,3,2) = 1;  % MD->BG     &  BG->MD     in RN 
    DCM.b(3,2,2) = 1;  DCM.b(1,2,2) = 1;  % dmPFC->BG  &  dmPFC-> MD  in RN 
    save(fullfile(outputpath,'DCM_mod30_bilinear.mat'),'DCM');   

    %% Bilinear Driving input-BG
    DCM.c = [0 0; 0 0; 1 1];% driving input to a node: n_node x n_conditions   

    %model 31: 
    DCM.b = zeros(3,3,2);                 % Bilinear: n_node x n_node x n_conditions
    DCM.b(2,1,1) = 1;  DCM.b(1,2,1) = 1;  % MD->dmPFC  & dmPFC->MD  in LE 
    DCM.b(3,1,1) = 1;  DCM.b(1,3,1) = 1;  % MD->BG     & BG->MD     in LE 
    
    DCM.b(2,1,2) = 1;  DCM.b(1,2,2) = 1;  % MD->dmPFC  & dmPFC->MD  in RN 
    DCM.b(3,1,2) = 1;  DCM.b(1,3,2) = 1;  % MD->BG     & BG->MD     in RN 

    save(fullfile(outputpath,'DCM_mod31_bilinear.mat'),'DCM');
    
    %model 32: 
    DCM.b = zeros(3,3,2); 
    DCM.b(2,1,1) = 1;  DCM.b(1,2,1) = 1;  % MD->dmPFC  & dmPFC->MD  in LE 
    DCM.b(3,1,1) = 1;  DCM.b(2,3,1) = 1;  % MD->BG     & BG->dmPFC  in LE 
    
    DCM.b(2,1,2) = 1;  DCM.b(1,2,2) = 1;  % MD->dmPFC  & dmPFC->MD  in RN 
    DCM.b(3,1,2) = 1;  DCM.b(2,3,2) = 1;  % MD->BG     & BG->dmPFC  in RN  
    save(fullfile(outputpath,'DCM_mod32_bilinear.mat'),'DCM');
    
    %model 33:
    DCM.b = zeros(3,3,2); 
    DCM.b(2,1,1) = 1;  DCM.b(1,2,1) = 1;  % MD->dmPFC  & dmPFC->MD  in LE 
    DCM.b(3,1,1) = 1;  DCM.b(3,2,1) = 1;  % MD->BG     & dmPFC->BG  in LE 
    
    DCM.b(2,1,2) = 1;  DCM.b(1,2,2) = 1;  % MD->dmPFC  & dmPFC->MD  in RN 
    DCM.b(3,1,2) = 1;  DCM.b(3,2,2) = 1;  % MD->BG     & dmPFC->BG  in RN  
    save(fullfile(outputpath,'DCM_mod33_bilinear.mat'),'DCM');
    
    %model 34:
    DCM.b = zeros(3,3,2); 
    DCM.b(2,1,1) = 1;  DCM.b(1,2,1) = 1;  % MD->dmPFC  & dmPFC->MD  in LE 
    DCM.b(1,3,1) = 1;  DCM.b(3,2,1) = 1;  % BG->MD     & dmPFC->BG  in LE 
    
    DCM.b(2,1,2) = 1;  DCM.b(1,2,2) = 1;  % MD->dmPFC  & dmPFC->MD  in RN 
    DCM.b(1,3,2) = 1;  DCM.b(3,2,2) = 1;  % BG->MD     & dmPFC->BG  in RN    
    save(fullfile(outputpath,'DCM_mod34_bilinear.mat'),'DCM');
    
    %model 35:
    DCM.b = zeros(3,3,2); 
    DCM.b(2,1,1) = 1;  DCM.b(1,2,1) = 1;  % MD->dmPFC  & dmPFC->MD  in LE 
    DCM.b(1,3,1) = 1;  DCM.b(2,3,1) = 1;  % BG->MD     & BG->dmPFC  in LE 
    
    DCM.b(2,1,2) = 1;  DCM.b(1,2,2) = 1;  % MD->dmPFC  & dmPFC->MD  in RN 
    DCM.b(1,3,2) = 1;  DCM.b(2,3,2) = 1;  % BG->MD     & BG->dmPFC  in RN   
    save(fullfile(outputpath,'DCM_mod35_bilinear.mat'),'DCM');
   
    %model 36:
    DCM.b = zeros(3,3,2); 
    DCM.b(3,2,1) = 1;  DCM.b(2,3,1) = 1;  % dmPFC->BG  & BG->dmPFC     in LE 
    DCM.b(2,1,1) = 1;  DCM.b(1,2,1) = 1;  % MD->dmPFC  & dmPFC->MD     in LE 
    
    DCM.b(3,2,2) = 1;  DCM.b(2,3,2) = 1;  % dmPFC->BG  & BG->dmPFC   in RN   
    DCM.b(2,1,2) = 1;  DCM.b(1,2,2) = 1;  % MD->dmPFC  & dmPFC->MD   in RN 
    save(fullfile(outputpath,'DCM_mod36_bilinear.mat'),'DCM');
    
    %model 37:
    DCM.b = zeros(3,3,2); 
    DCM.b(3,2,1) = 1;  DCM.b(2,3,1) = 1;  % dmPFC->BG  & BG->dmPFC     in LE 
    DCM.b(1,3,1) = 1;  DCM.b(2,1,1) = 1;  % BG->MD     & MD->dmPFC     in LE 
    
    DCM.b(3,2,2) = 1;  DCM.b(2,3,2) = 1;  % dmPFC->BG  & BG->dmPFC     in RN   
    DCM.b(1,3,2) = 1;  DCM.b(2,1,2) = 1;  % BG->MD     & MD->dmPFC     in RN  
    save(fullfile(outputpath,'DCM_mod37_bilinear.mat'),'DCM');
    
    %model 38:
    DCM.b = zeros(3,3,2); 
    DCM.b(3,2,1) = 1;  DCM.b(2,3,1) = 1;  % dmPFC->BG  & BG->dmPFC     in LE 
    DCM.b(1,3,1) = 1;  DCM.b(1,2,1) = 1;  % BG->MD     & dmPFC->MD     in LE 
    
    DCM.b(3,2,2) = 1;  DCM.b(2,3,2) = 1;  % dmPFC->BG  & BG->dmPFC     in RN   
    DCM.b(1,3,2) = 1;  DCM.b(1,2,2) = 1;  % BG->MD     & dmPFC->MD     in RN     
    save(fullfile(outputpath,'DCM_mod38_bilinear.mat'),'DCM');
    
    %model 39:
    DCM.b = zeros(3,3,2); 
    DCM.b(3,2,1) = 1;  DCM.b(2,3,1) = 1;  % dmPFC->BG  & BG->dmPFC     in LE 
    DCM.b(3,1,1) = 1;  DCM.b(1,2,1) = 1;  % MD->BG     & dmPFC->MD     in LE 
    
    DCM.b(3,2,2) = 1;  DCM.b(2,3,2) = 1;  % dmPFC->BG  & BG->dmPFC     in RN   
    DCM.b(3,1,2) = 1;  DCM.b(1,2,2) = 1;  % MD->BG     & dmPFC->MD     in RN 
    save(fullfile(outputpath,'DCM_mod39_bilinear.mat'),'DCM');

    %model 40:
    DCM.b = zeros(3,3,2); 
    DCM.b(3,2,1) = 1;  DCM.b(2,3,1) = 1;  % dmPFC->BG  & BG->dmPFC     in LE 
    DCM.b(3,1,1) = 1;  DCM.b(2,1,1) = 1;  % MD->BG     & MD->dmPFC     in LE 
    
    DCM.b(3,2,2) = 1;  DCM.b(2,3,2) = 1;  % dmPFC->BG  & BG->dmPFC     in RN   
    DCM.b(3,1,2) = 1;  DCM.b(2,1,2) = 1;  % MD->BG     & MD->dmPFC     in RN 
    save(fullfile(outputpath,'DCM_mod40_bilinear.mat'),'DCM');

    %model 41:
    DCM.b = zeros(3,3,2); 
    DCM.b(3,1,1) = 1;  DCM.b(1,3,1) = 1;  % MD->BG     &  BG->MD     in LE 
    DCM.b(3,2,1) = 1;  DCM.b(2,3,1) = 1;  % dmPFC->BG  &  BG->dmPFC  in LE 
    
    DCM.b(3,1,2) = 1;  DCM.b(1,3,2) = 1;  % MD->BG     &  BG->MD     in RN 
    DCM.b(3,2,2) = 1;  DCM.b(2,3,2) = 1;  % dmPFC->BG  &  BG->dmPFC  in RN 
    save(fullfile(outputpath,'DCM_mod41_bilinear.mat'),'DCM');    
    
    %model 42:
    DCM.b = zeros(3,3,2); 
    DCM.b(3,1,1) = 1;  DCM.b(1,3,1) = 1;  % MD->BG     &  BG->MD     in LE 
    DCM.b(3,2,1) = 1;  DCM.b(2,1,1) = 1;  % dmPFC->BG  &  MD->dmPFC  in LE 
    
    DCM.b(3,1,2) = 1;  DCM.b(1,3,2) = 1;  % MD->BG     &  BG->MD     in RN 
    DCM.b(3,2,2) = 1;  DCM.b(2,1,2) = 1;  % dmPFC->BG  &  MD->dmPFC  in RN 
    save(fullfile(outputpath,'DCM_mod42_bilinear.mat'),'DCM');       
    
    %model 43:
    DCM.b = zeros(3,3,2); 
    DCM.b(3,1,1) = 1;  DCM.b(1,3,1) = 1;  % MD->BG     &  BG->MD     in LE 
    DCM.b(2,3,1) = 1;  DCM.b(2,1,1) = 1;  % BG->dmPFC  &  MD->dmPFC  in LE 
    
    DCM.b(3,1,2) = 1;  DCM.b(1,3,2) = 1;  % MD->BG     &  BG->MD     in RN 
    DCM.b(2,3,2) = 1;  DCM.b(2,1,2) = 1;  % BG->dmPFC  &  MD->dmPFC  in RN 
    save(fullfile(outputpath,'DCM_mod43_bilinear.mat'),'DCM');     
    
    %model 44:
    DCM.b = zeros(3,3,2); 
    DCM.b(3,1,1) = 1;  DCM.b(1,3,1) = 1;  % MD->BG     &  BG->MD     in LE 
    DCM.b(2,3,1) = 1;  DCM.b(1,2,1) = 1;  % BG->dmPFC  &  dmPFC-> MD in LE 
    
    DCM.b(3,1,2) = 1;  DCM.b(1,3,2) = 1;  % MD->BG     &  BG->MD     in RN 
    DCM.b(2,3,2) = 1;  DCM.b(1,2,2) = 1;  % BG->dmPFC  &  dmPFC-> MD  in RN 
    save(fullfile(outputpath,'DCM_mod44_bilinear.mat'),'DCM');     
 
    %model 45:
    DCM.b = zeros(3,3,2); 
    DCM.b(3,1,1) = 1;  DCM.b(1,3,1) = 1;  % MD->BG     &  BG->MD     in LE 
    DCM.b(3,2,1) = 1;  DCM.b(1,2,1) = 1;  % dmPFC->BG  &  dmPFC-> MD in LE 
    
    DCM.b(3,1,2) = 1;  DCM.b(1,3,2) = 1;  % MD->BG     &  BG->MD     in RN 
    DCM.b(3,2,2) = 1;  DCM.b(1,2,2) = 1;  % dmPFC->BG  &  dmPFC-> MD  in RN 
    save(fullfile(outputpath,'DCM_mod45_bilinear.mat'),'DCM');  
    
    
    % DCM Estimation
    %--------------------------------------------------------------------------
    clear matlabbatch
    
    
    matlabbatch{1}.spm.dcm.fmri.estimate.dcmmat = {...
        fullfile(outputpath,'DCM_mod01_bilinear.mat');...
        fullfile(outputpath,'DCM_mod02_bilinear.mat');...
        fullfile(outputpath,'DCM_mod03_bilinear.mat');...
        fullfile(outputpath,'DCM_mod04_bilinear.mat');...
        fullfile(outputpath,'DCM_mod05_bilinear.mat');...
        fullfile(outputpath,'DCM_mod06_bilinear.mat');...
        fullfile(outputpath,'DCM_mod07_bilinear.mat');...
        fullfile(outputpath,'DCM_mod08_bilinear.mat');...
        fullfile(outputpath,'DCM_mod09_bilinear.mat');...
        fullfile(outputpath,'DCM_mod10_bilinear.mat');...
        fullfile(outputpath,'DCM_mod11_bilinear.mat');...
        fullfile(outputpath,'DCM_mod12_bilinear.mat');...
        fullfile(outputpath,'DCM_mod13_bilinear.mat');...
        fullfile(outputpath,'DCM_mod14_bilinear.mat');...
        fullfile(outputpath,'DCM_mod15_bilinear.mat');...
        fullfile(outputpath,'DCM_mod16_bilinear.mat');...
        fullfile(outputpath,'DCM_mod17_bilinear.mat');...
        fullfile(outputpath,'DCM_mod18_bilinear.mat');...
        fullfile(outputpath,'DCM_mod19_bilinear.mat');...
        fullfile(outputpath,'DCM_mod20_bilinear.mat');...
        fullfile(outputpath,'DCM_mod21_bilinear.mat');...
        fullfile(outputpath,'DCM_mod22_bilinear.mat');...
        fullfile(outputpath,'DCM_mod23_bilinear.mat');...
        fullfile(outputpath,'DCM_mod24_bilinear.mat');...
        fullfile(outputpath,'DCM_mod25_bilinear.mat');...
        fullfile(outputpath,'DCM_mod26_bilinear.mat');...
        fullfile(outputpath,'DCM_mod27_bilinear.mat');...
        fullfile(outputpath,'DCM_mod28_bilinear.mat');...
        fullfile(outputpath,'DCM_mod29_bilinear.mat');...
        fullfile(outputpath,'DCM_mod30_bilinear.mat');...
        fullfile(outputpath,'DCM_mod31_bilinear.mat');...
        fullfile(outputpath,'DCM_mod32_bilinear.mat');...
        fullfile(outputpath,'DCM_mod33_bilinear.mat');...
        fullfile(outputpath,'DCM_mod34_bilinear.mat');...
        fullfile(outputpath,'DCM_mod35_bilinear.mat');...
        fullfile(outputpath,'DCM_mod36_bilinear.mat');...
        fullfile(outputpath,'DCM_mod37_bilinear.mat');...
        fullfile(outputpath,'DCM_mod38_bilinear.mat');...
        fullfile(outputpath,'DCM_mod39_bilinear.mat');...
        fullfile(outputpath,'DCM_mod40_bilinear.mat');...
        fullfile(outputpath,'DCM_mod41_bilinear.mat');...
        fullfile(outputpath,'DCM_mod42_bilinear.mat');...
        fullfile(outputpath,'DCM_mod43_bilinear.mat');...
        fullfile(outputpath,'DCM_mod44_bilinear.mat');...
        fullfile(outputpath,'DCM_mod45_bilinear.mat')};
    
    
    spm_jobman('run',matlabbatch);
    
    % Bayesian Model Comparison
    %--------------------------------------------------------------------------
%     DCM_1 = load('DCM_mod1_test.mat','F');
%     DCM_2 = load('DCM_mod2_test.mat','F');
%     fprintf('Model evidence: %f (mod1) vs %f (mod2)\n',DCM_1.F,DCM_2.F);
end
