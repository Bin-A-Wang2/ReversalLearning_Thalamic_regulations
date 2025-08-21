

Subjects=[2 3 4 5 7 8 11 12 13 14 15 16 17 18 19 20 22 23 26 27 28 29 31 32 33 34 35 36 37 38 39 40]; %% good subjects
RootDir=['/Users/binwang/Documents/Bochum/DATA/fMRI_RL_GoNoGo/Results_MD/'];
for n = 1:length(Subjects)
filepath1=fullfile(RootDir, 'Participants/', sprintf('Sub%02d',Subjects(n)),'DCM_MDm_MDl_OFC_dlPFC');
filepath2=fullfile(RootDir, 'Participants/', sprintf('Sub%02d',Subjects(n)),'DCM_MDm_MDl_OFC_dlPFC_MFvsMB');
%
DCM_SSvsSW=load([filepath1,'/DCM_mod05_bilinear.mat']);
%
DCM_MFvsMB=load([filepath2,'/DCM_mod06_bilinear.mat']);

DCM_SS_corticocortical=DCM_SSvsSW.Ep.B(3,4,1)+DCM_SSvsSW.Ep.B(4,3,1);
DCM_SS_thalamocortical=DCM_SSvsSW.Ep.B(3,1,1)+DCM_SSvsSW.Ep.B(4,1,1)+DCM_SSvsSW.Ep.B(3,2,1)+DCM_SSvsSW.Ep.B(4,2,1);

DCM_MF_corticocortical=DCM_MFvsMB.Ep.B(3,4,1)+DCM_MFvsMB.Ep.B(4,3,1);
DCM_MB_corticocortical=DCM_MFvsMB.Ep.B(3,4,2)+DCM_MFvsMB.Ep.B(4,3,2);
DCM_MF_thalamocortical=DCM_MFvsMB.Ep.B(3,1,1)+DCM_MFvsMB.Ep.B(4,1,1)+DCM_MFvsMB.Ep.B(3,2,1)+DCM_MFvsMB.Ep.B(4,2,1);
DCM_MB_thalamocortical=DCM_MFvsMB.Ep.B(3,1,2)+DCM_MFvsMB.Ep.B(4,1,2)+DCM_MFvsMB.Ep.B(3,2,2)+DCM_MFvsMB.Ep.B(4,2,2);

DCM_SS_corticocortical_all(:,n)=DCM_SS_corticocortical;
DCM_SS_thalamocortical_all(:,n)=DCM_SS_thalamocortical;
DCM_MF_corticocortical_all(:,n)=DCM_MF_corticocortical;
DCM_MB_corticocortical_all(:,n)=DCM_MB_corticocortical;
DCM_MF_thalamocortical_all(:,n)=DCM_MF_thalamocortical;
DCM_MB_thalamocortical_all(:,n)=DCM_MB_thalamocortical;


%new
DCM_SS_corticocortical2=DCM_SSvsSW.Ep.B(4,3,1);
DCM_SS_thalamocortical2=DCM_SSvsSW.Ep.B(3,1,1)+DCM_SSvsSW.Ep.B(3,2,1)+DCM_SSvsSW.Ep.B(4,2,1);
%
DCM_MF_corticocortical2=DCM_MFvsMB.Ep.B(4,3,1);
DCM_MB_corticocortical2=DCM_MFvsMB.Ep.B(4,3,2);
DCM_MF_thalamocortical2=DCM_MFvsMB.Ep.B(3,1,1)+DCM_MFvsMB.Ep.B(4,1,1)+DCM_MFvsMB.Ep.B(3,2,1);
DCM_MB_thalamocortical2=DCM_MFvsMB.Ep.B(3,1,2)+DCM_MFvsMB.Ep.B(4,1,2)+DCM_MFvsMB.Ep.B(3,2,2)+DCM_MFvsMB.Ep.B(4,2,2);
DCM_SS_corticocortical_all2(:,n)=DCM_SS_corticocortical2;
DCM_SS_thalamocortical_all2(:,n)=DCM_SS_thalamocortical2;
DCM_MF_corticocortical_all2(:,n)=DCM_MF_corticocortical2;
DCM_MB_corticocortical_all2(:,n)=DCM_MB_corticocortical2;
DCM_MF_thalamocortical_all2(:,n)=DCM_MF_thalamocortical2;
DCM_MB_thalamocortical_all2(:,n)=DCM_MB_thalamocortical2;

end

a = [mean(DCM_SS_thalamocortical_all2),mean(DCM_MF_thalamocortical_all2),mean(DCM_MB_thalamocortical_all2)];
figure;b=bar(a);
hold on
set(gca,'XTickLabel',{'SS','MF','MB'});
hold on;
E=(1/sqrt(size(DCM_SS_thalamocortical_all2,2)).*[std(DCM_SS_thalamocortical_all2),std(DCM_MF_thalamocortical_all2),std(DCM_MB_thalamocortical_all2)]);
errorbar(a,E,'linestyle','none');

hold on
plot(1,DCM_SS_corticocortical_all2','o','MarkerEdgeColor','k','MarkerFaceColor','k')

