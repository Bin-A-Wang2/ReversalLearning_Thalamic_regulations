
function batch_spm12_gPPI_RL_MFMB_MD(RootDir,Subjects,VOIname,VOIxyz,VOIradius,analysis_dir,condition_name)  
% Run gPPI in SPM12 and save the results 

% 
% RootDir=['/Users/binwang/Documents/Bochum/DATA/fMRI_RL_GoNoGo/'];
% Subjects=[2 3 4 5 7 8 11 12 13 14 15 16 17 18 19 20 22 23 26 27 28 29 31 32 33 34 35 36 37 38 39 40]; %% good subjects
% VOIname='MD_-2_-22_10_r6';%VOIname='MD_4_-20_12_r6';
% VOIxyz=[-2 -22 10];  %VOIxyz=[4 -20 12];
% VOIradius = 6;
% analysis_dir='Results_outcome_LNLERNRE_cue_DCM_new_3sess';
% condition_name={'outcome_LE','outcome_RN'};

%
% USAGE:
%     batch_spm12_gPPI_RL(RootDir,Subjects,,VOIname,VOIxyz,VOIradius) 
%
% INPUT:
%      RootDir: the directory including folders of all subjects (Sub01, Sub02,...)
%      Subjects: subject number [1,2,3,...]
%      VOIname: the name of VOI
%      VOIxyz: the coordinate of peak voxel in VOI
%      VOIradius: the radius of VOI 
%      Condition_name: the conditions used for contrast
% OUTPUT:
%
%  Edit by Bin Wang 07/09/2019 Bochum


for i = 1:length(Subjects)
    
    fprintf('Working on participant %d\n',Subjects(i));
    
    inputpath= fullfile(RootDir,'/Results_MD/Participants', sprintf('Sub%02d',Subjects(i)),analysis_dir);
    gPPI_dir=  fullfile(RootDir,'/Results_MD/Participants', sprintf('Sub%02d',Subjects(i)));
    
    cd(inputpath)
    
    %% Create a VOI mask using creat_sphere_image
    % Go to this subjects gPPI directory. If the mask exists, move on. If the
    % masks does not exist, create it.
    if exist(fullfile(inputpath,[VOIname,'_mask.nii']), 'file') % if there is already a VOI image for this person, move on
    else                                     % if not...
        create_sphere_image_RL(fullfile(inputpath,'SPM.mat'),VOIxyz,{VOIname},VOIradius) % create sphere around seed and save it in this subjects gPPI dir
    end
    
    % avoid VOI going beyond the first level mask
      
    V = spm_vol_nifti(fullfile(inputpath,'mask.nii'));
    Matrix_mask = spm_read_vols(V);
    
    V_ROI = spm_vol_nifti([VOIname,'_mask.nii']);
    Matrix_ROI = spm_read_vols(V_ROI);
    
    Matrix_new=Matrix_mask.*Matrix_ROI;
    spm_write_vol(V_ROI,Matrix_new);
    
    %% Load first level univariate parameters and remove 'Run#_' from the beginning of regressor names
    % In order to avoid a concatenation bug, go to this subject's
    % first level analysis directory and edit his/her first level SPM
    % parameters file ('SPM.mat') by removing "Run#_" from the front of
    % regressor names. For example, if the first level model has
    % "Run1_TRIALTYPE" and "Run2_TRIALTYPE". See WIKI for further explanation.
    % Note this overwrites the SPM.mat file which already exists
    
%     
%     load(fullfile(inputpath,'SPM.mat'))                                     % Load this subject's SPM parameters
%     for k = 1:length(SPM.Sess)                                             % for each Session...
%         for u = 1:length(SPM.Sess(k).U)                                     % for each Trial Type in Session k...
%             if strcmp(SPM.Sess(k).U(u).name{1}(1:3),'Run')                  % If this regressor has "Run" as the first 3 characters...
%                 SPM.Sess(k).U(u).name{1} = SPM.Sess(k).U(u).name{1}(6:end); % Remove the first 5 characters of the regressor's name
%                 disp(SPM.Sess(k).U(u).name{1})                              % Display the changeed regressor name in the MATLAB Command Window
%             else
%             end
%         end
%     end
%     save('SPM.mat','SPM') % Save the SPM parameters loaded above to a file called "SPM.mat" in this subject's first level analysis directory.
   

    
    %% Configure the PPPI Parameter structure
    P.subject       =[sprintf('Sub%02d',Subjects(i))];           % A string with the subjects id
    P.directory     =inputpath;                                  % path to the first level GLM directory
    P.VOI           =fullfile(inputpath,[VOIname,'_mask.nii']);  % path to the ROI image, created above
    P.Region        =VOIname;                                    % string, basename of output folder
    P.Estimate      =1;                                          %whether or not to estimate the PPI design
    P.contrast      =1;                                          %Contrast to adjust for: 0 for no
    P.extract       ='eig';                                      % method for ROI extraction. Default is eigenvariate
    P.Tasks         ={'1' condition_name{1} condition_name{2}};  %'1':they must exist in all sessions
    P.Weights       =[];                                         %For traditional PPI, you must specify weight vector for each task
    P.maskdir       = gPPI_dir;                                  % Where should we save the masks?
    P.equalroi      = 1;                                         % When 1, All ROI's must be of equal size. When 0, all ROIs do not have to be of equal size
    P.FLmask        = 1;                                         % restrict the ROI's by the first level mask. This is useful when ROI is close to the edge of the brain
    P.analysis      ='psy';                                      % psychophysiological interaction ('psy'); physiophysiological interaction('phys');
                                                                 % or psychophysiophysiological interactions ('psyphy)
    P.method        ='cond';                                     % 'trad' traditional SPM PPI
    P.CompContrasts =0;                                          % 1 to estimate contrasts
    P.Weighted      =0;                                          % Weight tasks by number of trials. Default is 0 for do not weight
    P.outdir        = gPPI_dir;                                  % Output directory
    P.ConcatR       =0;                                          % Tells gPPI toolbox to concatenate runs
%     
%     P.Contrasts(1).left={'outcome_LE'};     % left side or positive side of contrast  'sample_keep'
%     P.Contrasts(1).right={'outcome_RN'};  % right side or negative side of contrast
%     P.Contrasts(1).STAT='T';                 % T contrast
%     P.Contrasts(1).Weighted=0;               % Wieghting contrasts by trials. Deafult is 0 for do not weight
%     P.Contrasts(1).MinEvents=1;              % min number of event need to compute this contrast
%     P.Contrasts(1).name='LE_minus_RN'; % Name of this contrast
%     
%     P.Contrasts(2).left={'outcome_RN'};     % left side or positive side of contrast
%     P.Contrasts(2).right={'outcome_LE'};  % right side or negative side of contrast
%     P.Contrasts(2).STAT='T';                 % T contrast
%     P.Contrasts(2).Weighted=0;               % Wieghting contrasts by trials. Deafult is 0 for do not weight
%     P.Contrasts(2).MinEvents=1;              % min number of event need to compute this contrast
%     P.Contrasts(2).name='RN_minus_LE'; % Name of this contrast
    
%     P.Contrasts(3).left={'keep_prior belief'};     % left side or positive side of contrast  'sample_keep'
%     P.Contrasts(3).right={'change_prior belief'};  % right side or negative side of contrast
%     P.Contrasts(3).STAT='T';                 % T contrast
%     P.Contrasts(3).Weighted=0;               % Wieghting contrasts by trials. Deafult is 0 for do not weight
%     P.Contrasts(3).MinEvents=1;              % min number of event need to compute this contrast
%     P.Contrasts(3).name='Prior_belief_keep_minus_change'; % Name of this contrast
%     
%     P.Contrasts(4).left={'change_prior belief'};     % left side or positive side of contrast
%     P.Contrasts(4).right={'keep_prior belief'};  % right side or negative side of contrast
%     P.Contrasts(4).STAT='T';                 % T contrast
%     P.Contrasts(4).Weighted=0;               % Wieghting contrasts by trials. Deafult is 0 for do not weight
%     P.Contrasts(4).MinEvents=1;              % min number of event need to compute this contrast
%     P.Contrasts(4).name='Prior_belief_change_minus_keep'; % Name of this contrast
    
    %%% Below are parameters for gPPI. All set to zero for do not use. See website
    %%% for more details on what they do.
    P.FSFAST           = 0;
    P.peerservevarcorr = 0;
    P.wb               = 0;
    P.zipfiles         = 0;
    P.rWLS             = 0;
    
    %% Actually Run PPI
    PPPI(P)
end