
function batch_2ndlevel_gPPI_RL_MFMB_MD(RootDir,Subjects,VOIname,contrast_name) %Subjects=[1 2 4 6 9 10 12 15 16 17 18 19 20 21 22 23 24 25 26 28 29 30 31 32 33];

% RootDir=['/Users/binwang/Documents/Bochum/DATA/fMRI_RL_GoNoGo/'];
% Subjects=[2 3 4 5 7 8 11 12 13 14 15 16 17 18 19 20 22 23 26 27 29 31 32 33 34 35 36 37 38 39 40]; %% good subjects
% VOIname='MD_-2_-22_10_r6';%VOIname='MD_4_-20_12_r6';
% contrast_name='PPI_outcome_RN'; %contrast_name='PPI_RN_minus_LE';


spm('defaults','fMRI')
prfx='Sub';

Results=contrast_name;


outputdir=fullfile(RootDir,'Results_MD/Results_PPI/',['Group_',VOIname,'_',Results(5:end)]);

%% get the path of all con file for each subjects

for i=1:length(Subjects)
    n=Subjects(i);
    pathscan{i,1}=fullfile([RootDir,'Results_MD/Participants/',prfx,num2str(n,'%.2d')],['PPI_',VOIname],['con_0001.nii']);
end


matlabbatch{1}.spm.stats.factorial_design.dir = {outputdir};
matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = pathscan;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = Results;
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = 1;
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;

matlabbatch{4}.spm.stats.results.spmmat(1) = cfg_dep('Contrast Manager: SPM.mat File', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{4}.spm.stats.results.conspec.titlestr = '';
matlabbatch{4}.spm.stats.results.conspec.contrasts = 1;
matlabbatch{4}.spm.stats.results.conspec.threshdesc = 'none';
matlabbatch{4}.spm.stats.results.conspec.thresh = 0.001;
matlabbatch{4}.spm.stats.results.conspec.extent = 0;
matlabbatch{4}.spm.stats.results.conspec.conjunction = 1;
matlabbatch{4}.spm.stats.results.conspec.mask.none = 1;
matlabbatch{4}.spm.stats.results.units = 1;
matlabbatch{4}.spm.stats.results.export{1}.ps = true;

spm_jobman('run',matlabbatch)