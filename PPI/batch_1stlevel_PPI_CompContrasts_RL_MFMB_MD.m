% List of open inputs
function batch_1stlevel_PPI_CompContrasts_RL_MFMB_MD(RootDir,Subjects,VOIname)  %Subjects=[1 2 4 6 9 10 12 15 16 17 18 19 20 21 22 23 24 25 26 28 29 30 31 32 33];

%RootDir=['/Users/binwang/Documents/Bochum/DATA/fMRI_RL_GoNoGo/'];
%Subjects=[2 3 4 5 7 8 11 12 13 14 15 16 17 18 19 20 22 23 26 27 29 31 32 33 34 35 36 37 38 39 40]; %% good subjects
% VOIname='MD_-2_-22_10_r6';%VOIname='MD_4_-20_12_r6';

contrast_name={'PPI_outcome_RN','PPI_RN_minus_LE'};
contrast= {[0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0];
           [0 0 0 0 0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1 1 0 0 0 0 0 0 0]};

%spm('defaults','fMRI')
prfx='Sub';

for i=1:length(Subjects)
    sub=Subjects(i);
    inputpath= fullfile(RootDir,'Results_MD/Participants/',[prfx,num2str(sub,'%.2d')],['PPI_',VOIname]);
      
    %% define the name and contrast
    
    

    matlabbatch{1}.spm.stats.con.spmmat(1) = {fullfile(inputpath,'\SPM.mat')};
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = contrast_name{1};
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = contrast{1};
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = contrast_name{2};
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = contrast{2};
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.delete = 0;
    
%     %%result check
%     matlabbatch{2}.spm.stats.results.spmmat(1) = cfg_dep('Contrast Manager: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
%     matlabbatch{2}.spm.stats.results.conspec(1).titlestr = '';
%     matlabbatch{2}.spm.stats.results.conspec(1).contrasts = 1;
%     matlabbatch{2}.spm.stats.results.conspec(1).threshdesc = 'none';
%     matlabbatch{2}.spm.stats.results.conspec(1).thresh = 0.001;
%     matlabbatch{2}.spm.stats.results.conspec(1).extent = 0;
%     matlabbatch{2}.spm.stats.results.conspec(1).conjunction = 1;
%     matlabbatch{2}.spm.stats.results.conspec(1).mask.none = 1;
%     
%     matlabbatch{2}.spm.stats.results.conspec(2).titlestr = '';
%     matlabbatch{2}.spm.stats.results.conspec(2).contrasts = 2;
%     matlabbatch{2}.spm.stats.results.conspec(2).threshdesc = 'none';
%     matlabbatch{2}.spm.stats.results.conspec(2).thresh = 0.001;
%     matlabbatch{2}.spm.stats.results.conspec(2).extent = 0;
%     matlabbatch{2}.spm.stats.results.conspec(2).conjunction = 1;
%     matlabbatch{2}.spm.stats.results.conspec(2).mask.none = 1;
    
       
%     
%     matlabbatch{2}.spm.stats.results.units = 1;
%     matlabbatch{2}.spm.stats.results.export{1}.ps = true;
    
    spm_jobman('run',matlabbatch);
    
end

