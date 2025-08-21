function batch_2ndlevel_outcome_LNLERNRE_cue_MD_PSw_MB1(RootDir,Subjects) %Subjects=[1 2 4 6 9 10 12 15 16 17 18 19 20 21 23 24 25 26 28 29 30 31];

spm('defaults','fMRI')
prfx='Sub';

Results=[{'Result_Outcome_LEvsRN'},{'Result_Outcome_LEvsRE'},...
         {'Result_Outcome_LN_PSw_MB1'}, {'Result_Outcome_LE_PSw_MB1'}, {'Result_Outcome_RN_PSw_MB1'}, {'Result_Outcome_RE_PSw_MB1'}, {'Result_Outcome_all_PSw_MB1'}];

for j=1:length(Results)
    Result_con=Results{j};
    pathdir=[RootDir,'Results_MD/Participants/'];
    outputdir=[RootDir,'Results_MD/Results_GLM/Group_outcome_LNLERNRE_cue_PSw_MB1/',Result_con];
    
    
    for i=1:length(Subjects)
        j=Subjects(i);
        
        if strcmp(Result_con,'Result_Outcome_LEvsRN')==1
            pathscan{i,1}=[pathdir,prfx,num2str(j,'%.2d'),'/Results_outcome_LNLERNRE_cue_PSw_MB1/con_0001.nii'];
        elseif strcmp(Result_con,'Result_Outcome_LEvsRE')==1
            pathscan{i,1}=[pathdir,prfx,num2str(j,'%.2d'),'/Results_outcome_LNLERNRE_cue_PSw_MB1/con_0002.nii'];
        elseif strcmp(Result_con,'Result_Outcome_LN_PSw_MB1')==1
            pathscan{i,1}=[pathdir,prfx,num2str(j,'%.2d'),'/Results_outcome_LNLERNRE_cue_PSw_MB1/con_0003.nii'];
        elseif strcmp(Result_con,'Result_Outcome_LE_PSw_MB1')==1
            pathscan{i,1}=[pathdir,prfx,num2str(j,'%.2d'),'/Results_outcome_LNLERNRE_cue_PSw_MB1/con_0004.nii'];
        elseif strcmp(Result_con,'Result_Outcome_RN_PSw_MB1')==1
            pathscan{i,1}=[pathdir,prfx,num2str(j,'%.2d'),'/Results_outcome_LNLERNRE_cue_PSw_MB1/con_0005.nii'];
        elseif strcmp(Result_con,'Result_Outcome_RE_PSw_MB1')==1
            pathscan{i,1}=[pathdir,prfx,num2str(j,'%.2d'),'/Results_outcome_LNLERNRE_cue_PSw_MB1/con_0006.nii'];
        elseif strcmp(Result_con,'Result_Outcome_all_PSw_MB1')==1
            pathscan{i,1}=[pathdir,prfx,num2str(j,'%.2d'),'/Results_outcome_LNLERNRE_cue_PSw_MB1/con_0007.nii'];
        end
    end
    
    clear matlabbatch
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
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = Result_con;
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
    
    % run job
    spm_jobman('run',matlabbatch);
    
end
