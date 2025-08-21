% Recipe_fMRI_ROI
% this 'recipe' performs region of interest analysis on fMRI data.
% Cai Wingfield 5-2010, 6-2010, 7-2010, 8-2010
%__________________________________________________________________________
% Copyright (C) 2010 Medical Research Council

%%%%%%%%%%%%%%%%%%%%
%% Initialisation %%
%%%%%%%%%%%%%%%%%%%%
%toolboxRoot = 'D:\Bochum\toolbox\rsatoolbox\rsatoolbox-develop'; addpath(genpath(toolboxRoot));
%mkdir (userOptions.rootPath);

%% Define the condition labels %%

%labels for conditions in RN
conditionLabels = { ...
    'outcome_cue1_Go_RN_MB', ...
    'outcome_cue2_NoGo_RN_MB', ...
    'outcome_cue1_NoGo_RN_MB', ...
    'outcomet_cue2_Go_RN_MB', ...

    };


userOptions = defineUserOptions_RL_RN_MF_MB();
compareRDM=1;
%%

close all
userOptions.conditionLabels=conditionLabels;
%userOptions.rootPath = 'D:\Bochum\DATA\fMRI_RL_GoNoGo\Results_MD\Results_RSA\RDMs_RN_new';
userOptions.rootPath = '/Users/binwang/Documents/Bochum/DATA/fMRI_RL_GoNoGo/Results_MD/Results_RSA/RDMs_RN_new_MB';

mkdir(userOptions.rootPath)
cd (userOptions.rootPath)

%%%%%%%%%%%%%%%%%%%%%%%
%%% Data preparation %%
%%%%%%%%%%%%%%%%%%%%%%%

fullBrainVols = rsa.fmri.fMRIDataPreparation('SPM', userOptions);
binaryMasks_nS = rsa.fmri.fMRIMaskPreparation(userOptions);
responsePatterns = rsa.fmri.fMRIDataMasking(fullBrainVols, binaryMasks_nS, 'SPM', userOptions);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% First-order RDM calculation %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RDMs  = rsa.constructRDMs(responsePatterns, 'SPM', userOptions);

sRDMs = rsa.rdm.averageRDMs_subjectSession(RDMs, 'session');
%rsa.fig.figureRDMs(sRDMs, userOptions, struct('fileName', 'RoIRDMs', 'figureNumber', 1));

% sRDMs_mod=sRDMs;
% for m=1:size(sRDMs,1)
%     for n=1:size(sRDMs,2)
%         sRDMs_mod(m,n).RDM=sRDMs(m,n).RDM(1:4,5:8);
%     end
% end

mRDMs = rsa.rdm.averageRDMs_subjectSession(RDMs, 'session', 'subject');
%rsa.fig.figureRDMs(mRDMs, userOptions, struct('fileName', 'RoIRDMs', 'figureNumber', 2));

% mRDMs_mod=mRDMs;
% for j=1:length(mRDMs)
%     mRDMs_mod(j).RDM=mRDMs(j).RDM (1:4,5:8);
% end

save([userOptions.rootPath,'/RDMs/RL_GoNoGo_RDMs.mat'],'RDMs','mRDMs');

Models_all = rsa.constructModelRDMs(modelRDMs_RL_MD(), userOptions);

%% compare RDMs with models
if compareRDM
    
    rsa.fig.figureRDMs(Models_all, userOptions, struct('fileName', 'ModelRDMs', 'figureNumber', 3));
    roinumber=length(mRDMs);
    
    for i= 1:length(Models_all)
        
        Models=Models_all(i);
        for n=1:roinumber
            RDMs_allROI{n}=RDMs(n,:);
        end
        
        userOptions.RDMcorrelationType='Kendall_taua';
        userOptions.RDMrelatednessTest = 'subjectRFXsignedRank';
        userOptions.RDMrelatednessThreshold = 0.05;
        userOptions.nRandomisations = 1000;
        
        userOptions.figureIndex = [10 11];
        userOptions.RDMrelatednessMultipleTesting = 'FDR';
        userOptions.candRDMdifferencesMultipleTesting = 'FDR';
        userOptions.candRDMdifferencesTest = 'subjectRFXsignedRank';
        userOptions.candRDMdifferencesThreshold = 0.05;
        userOptions.candRDMdifferencesMultipleTesting = 'none';
        userOptions.plotpValues = '*';
        
        
        str_var=strrep(['Stats_',Models.name],' ','_');
        eval([str_var,'=rsa.compareRefRDM2candRDMs(Models, RDMs_allROI, userOptions);']);
        
        %stats=rsa.compareRefRDM2candRDMs(Models, RDMs_allROI, userOptions); % reference RDM = model RDM; candidate RDMs = OFC&S1 RDMs to test which region fits better to the model RDM
        
        save ([userOptions.rootPath,'\',str_var,'.mat'],str_var);
        % %
        %     roiIndex = 1;% index of the ROI for which the group average RDM will serve
        % %     % as the reference RDM.
        %     Models_all=
        %     for i=1:numel(Models)
        %          models{i}=Models(i);
        %     end
        %     stats_p_r=rsa.compareRefRDM2candRDMs(sRDMs(roiIndex,:), models, userOptions); %1 ROI RDM -> 2 model RDMs to test which model fits better to the ROI RDM
        %
    end
end



