
datapath=['/Users/binwang/Documents/Bochum/DATA/fMRI_RL_GoNoGo/Results_MD/Participants/'];
Subjects=[2 3 4 5 7 8 11 12 13 14 15 16 17 18 19 20 22 23 26 27 28 29 31 32 33 34 35 36 37 38 39 40]; %% good subjects

Subjects=[2 4 5 7 8 11 12 13 14 15 16 17 18 19 22 23 26 28 29 31 32 34 35 39 40]; %% good subjects
for i = 1:length(Subjects)
sID=Subjects(i);
Result=load([datapath,'Sub' num2str(sID,'%.2d'),'/DCM_MD_dmPFC_BG_new2','/DCM_mod01_bilinear.mat' ]);
%LE
LE_estimates=Result.Ep.B(:,:,1);
LE_MD_dmPFC=LE_estimates(2,1);
LE_dmPFC_MD=LE_estimates(1,2);
LE_MD_CN=LE_estimates(3,1);
LE_CN_MD=LE_estimates(1,3);
%RN
RN_estimates=Result.Ep.B(:,:,2);
RN_MD_dmPFC=RN_estimates(2,1);
RN_dmPFC_MD=RN_estimates(1,2);
RN_MD_CN=RN_estimates(3,1);
RN_CN_MD=RN_estimates(1,3);
all_LE_MD_dmPFC(i,:)=LE_MD_dmPFC;
all_LE_dmPFC_MD(i,:)=LE_dmPFC_MD;
all_LE_MD_CN(i,:)=LE_MD_CN;
all_LE_CN_MD(i,:)=LE_CN_MD;
all_RN_MD_dmPFC(i,:)=RN_MD_dmPFC;
all_RN_dmPFC_MD(i,:)=RN_dmPFC_MD;
all_RN_MD_CN(i,:)=RN_MD_CN;
all_RN_CN_MD(i,:)=RN_CN_MD;
end
a=min_all([1 3 4 5 6 7 8 9 10 11 12 13 14 15 17 18 19 21 22 23 24 26 27 31 32]);

[r,p]=corr(all_RN_MD_dmPFC,a,'type','Spearman')
[r,p]=corr(all_RN_dmPFC_MD,a,'type','Spearman')
[r,p]=corr(all_RN_MD_CN,a,'type','Spearman')
[r,p]=corr(all_RN_CN_MD,a,'type','Spearman')


[r,p]=corr(all_RN_MD_dmPFC-all_LE_MD_dmPFC,a,'type','Spearman')
[r,p]=corr(all_RN_dmPFC_MD-all_LE_dmPFC_MD,a,'type','Spearman')
[r,p]=corr(all_RN_MD_CN-all_LE_MD_CN,a,'type','Spearman')
[r,p]=corr(all_RN_CN_MD-all_LE_CN_MD,a,'type','Spearman')