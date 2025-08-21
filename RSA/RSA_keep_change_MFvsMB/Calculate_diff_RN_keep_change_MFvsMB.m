

clear all
close all
RDMs_MF=load('/Users/binwang/Documents/Bochum/DATA/fMRI_RL_GoNoGo/Results_MD/Results_RSA/#RDMs_RN_new_MFvsMB/RDMs_RN_new_MF/RDMs/RL_GoNoGo_RDMs2.mat','RDMs');
RDMs_MB=load('/Users/binwang/Documents/Bochum/DATA/fMRI_RL_GoNoGo/Results_MD/Results_RSA/#RDMs_RN_new_MFvsMB/RDMs_RN_new_MB/RDMs/RL_GoNoGo_RDMs2.mat','RDMs');

    
for i=1:size(RDMs_MB.RDMs,2) %subjects

    %% overall
    %dmPFC
    RDM_dmPFC_overall_MF(i,1)=0.5.*(RDMs_MF.RDMs(1, i).RDM(1,2)+RDMs_MF.RDMs(1, i).RDM(3,4));
    RDM_dmPFC_overall_MB(i,1)=0.5.*(RDMs_MB.RDMs(1, i).RDM(1,2)+RDMs_MB.RDMs(1, i).RDM(3,4));

    %dlPFC
    RDM_dlPFC_overall_MF(i,1)=0.5.*(RDMs_MF.RDMs(2, i).RDM(1,2)+RDMs_MF.RDMs(2, i).RDM(3,4));
    RDM_dlPFC_overall_MB(i,1)=0.5.*(RDMs_MB.RDMs(2, i).RDM(1,2)+RDMs_MB.RDMs(2, i).RDM(3,4));


    %OFC
    RDM_OFC_overall_MF(i,1)=0.5.*(RDMs_MF.RDMs(3, i).RDM(1,2)+RDMs_MF.RDMs(3, i).RDM(3,4));
    RDM_OFC_overall_MB(i,1)=0.5.*(RDMs_MB.RDMs(3, i).RDM(1,2)+RDMs_MB.RDMs(3, i).RDM(3,4));

    %% keep
    %dmPFC
    RDM_dmPFC_keep_MF(i,1)=RDMs_MF.RDMs(1, i).RDM(1,2);
    RDM_dmPFC_keep_MB(i,1)=RDMs_MB.RDMs(1, i).RDM(1,2);

    %dlPFC
    RDM_dlPFC_keep_MF(i,1)=RDMs_MF.RDMs(2, i).RDM(1,2);
    RDM_dlPFC_keep_MB(i,1)=RDMs_MB.RDMs(2, i).RDM(1,2);

    %OFC
    RDM_OFC_keep_MF(i,1)=RDMs_MF.RDMs(3, i).RDM(1,2);
    RDM_OFC_keep_MB(i,1)=RDMs_MB.RDMs(3, i).RDM(1,2);

    %% change
    %dmPFC
    RDM_dmPFC_change_MF(i,1)=RDMs_MF.RDMs(1, i).RDM(3,4);
    RDM_dmPFC_change_MB(i,1)=RDMs_MB.RDMs(1, i).RDM(3,4);

    %dlPFC
    RDM_dlPFC_change_MF(i,1)=RDMs_MF.RDMs(2, i).RDM(3,4);
    RDM_dlPFC_change_MB(i,1)=RDMs_MB.RDMs(2, i).RDM(3,4);

    %OFC
    RDM_OFC_change_MF(i,1)=RDMs_MF.RDMs(3, i).RDM(3,4);
    RDM_OFC_change_MB(i,1)=RDMs_MB.RDMs(3, i).RDM(3,4);

end

%overall
[P,H,STATS] = signrank(RDM_dmPFC_overall_MF,RDM_dmPFC_overall_MB,'tail','right')
[P,H,STATS] = signrank(RDM_dlPFC_overall_MF,RDM_dlPFC_overall_MB,'tail','right')
[P,H,STATS] = signrank(RDM_OFC_overall_MF,RDM_OFC_overall_MB,'tail','right')

%keep
[P,H,STATS] = signrank(RDM_dmPFC_keep_MF,RDM_dmPFC_keep_MB,'tail','right')
[P,H,STATS] = signrank(RDM_dlPFC_keep_MF,RDM_dlPFC_keep_MB,'tail','right')
[P,H,STATS] = signrank(RDM_OFC_keep_MF,RDM_OFC_keep_MB,'tail','right')

%change
[P,H,STATS] = signrank(RDM_dmPFC_change_MF,RDM_dmPFC_change_MB,'tail','right')
[P,H,STATS] = signrank(RDM_dlPFC_change_MF,RDM_dlPFC_change_MB,'tail','right')
[P,H,STATS] = signrank(RDM_OFC_change_MF,RDM_OFC_change_MB,'tail','right')

%% plot the figure for same vs. differnet


rdm_diff_dmPFC=[RDM_dmPFC_overall_MF-RDM_dmPFC_overall_MB,RDM_dmPFC_keep_MF-RDM_dmPFC_keep_MB,RDM_dmPFC_change_MF-RDM_dmPFC_change_MB];
rdm_diff_dlPFC=[RDM_dlPFC_overall_MF-RDM_dlPFC_overall_MB,RDM_dlPFC_keep_MF-RDM_dlPFC_keep_MB,RDM_dlPFC_change_MF-RDM_dlPFC_change_MB];
rdm_diff_OFC=[RDM_OFC_overall_MF-RDM_OFC_overall_MB,RDM_OFC_keep_MF-RDM_OFC_keep_MB,RDM_OFC_change_MF-RDM_OFC_change_MB];

%dmPFC
scrsz = get(0,'ScreenSize');
outerpos = [0.3*scrsz(3),0.3*scrsz(4),0.10*scrsz(3),0.4*scrsz(4)];
figure2 = figure('OuterPosition', outerpos,'Color',[1 1 1]);
% Create axes
axes2 = axes('Parent',figure2);
hold(axes2,'on');

bar(mean(rdm_diff_dmPFC),'FaceColor',[0.5 0.5 0.5])

hold on
plot2=plot([1,2,3],rdm_diff_dmPFC,'MarkerSize',10,'Marker','.','LineStyle','none');
set(plot2,'MarkerFaceColor',[0 0 0],'Color',[0 0 0]);

ylabel('Difference in corr. coef. (MF-MB)','FontSize',14);
set(axes2,'FontSize',14,'XTick',[1 2 3],'XTickLabel',{'Overall','Keep','Change'});


%dlPFC
scrsz = get(0,'ScreenSize');
outerpos = [0.3*scrsz(3),0.3*scrsz(4),0.10*scrsz(3),0.4*scrsz(4)];
figure2 = figure('OuterPosition', outerpos,'Color',[1 1 1]);
% Create axes
axes2 = axes('Parent',figure2);
hold(axes2,'on');

bar(mean(rdm_diff_dlPFC),'FaceColor',[0.5 0.5 0.5])

hold on
plot2=plot([1,2,3],rdm_diff_dlPFC,'MarkerSize',10,'Marker','.','LineStyle','none');
set(plot2,'MarkerFaceColor',[0 0 0],'Color',[0 0 0]);

ylabel('Difference in corr. coef.(MF-MB)','FontSize',14);
set(axes2,'FontSize',14,'XTick',[1 2 3],'XTickLabel',{'Overall','Keep','Change'});


%OFC
scrsz = get(0,'ScreenSize');
outerpos = [0.3*scrsz(3),0.3*scrsz(4),0.10*scrsz(3),0.4*scrsz(4)];
figure2 = figure('OuterPosition', outerpos,'Color',[1 1 1]);
% Create axes
axes2 = axes('Parent',figure2);
hold(axes2,'on');

bar(mean(rdm_diff_OFC),'FaceColor',[0.5 0.5 0.5])

hold on
plot2=plot([1,2,3],rdm_diff_OFC,'MarkerSize',10,'Marker','.','LineStyle','none');
set(plot2,'MarkerFaceColor',[0 0 0],'Color',[0 0 0]);

ylabel('Difference in corr. coef.(MF-MB)','FontSize',14);
set(axes2,'FontSize',14,'XTick',[1 2 3],'XTickLabel',{'Overall','Keep','Change'});


%% plots for the difference between keep and change
%dmPFC
Diff_dmPFC_MF=RDM_dmPFC_keep_MF-RDM_dmPFC_change_MF;
Diff_dmPFC_MB=RDM_dmPFC_keep_MB-RDM_dmPFC_change_MB;

[h,p]=ttest(Diff_dmPFC_MF,Diff_dmPFC_MB)

scrsz = get(0,'ScreenSize');
outerpos = [0.3*scrsz(3),0.3*scrsz(4),0.15*scrsz(3),0.4*scrsz(4)];
figure1 = figure('OuterPosition', outerpos,'Color',[1 1 1]);
% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');
boxplot([Diff_dmPFC_MF,Diff_dmPFC_MB])

xlim(axes1,[0.5 2.5]);
ylim(axes1,[-0.4 0.7]);

ylabel('Difference in corr. coef.(Keep-Change)','FontSize',14);
set(axes1,'FontSize',12,'LineWidth',1,'TickLabelInterpreter','none','XTick',...
    [1 2],'XTickLabel',{'MF','MB'});


%dlPFC
Diff_dlPFC_MF=RDM_dlPFC_keep_MF-RDM_dlPFC_change_MF;
Diff_dlPFC_MB=RDM_dlPFC_keep_MB-RDM_dlPFC_change_MB;

[h,p]=ttest(Diff_dlPFC_MF,Diff_dlPFC_MB)

scrsz = get(0,'ScreenSize');
outerpos = [0.3*scrsz(3),0.3*scrsz(4),0.15*scrsz(3),0.4*scrsz(4)];
figure2 = figure('OuterPosition', outerpos,'Color',[1 1 1]);
% Create axes
axes2 = axes('Parent',figure2);
hold(axes2,'on');
boxplot([Diff_dlPFC_MF,Diff_dlPFC_MB])

xlim(axes2,[0.5 2.5]);
ylim(axes2,[-0.5 0.7]);

ylabel('Difference in corr. coef.(Keep-Change)','FontSize',14);
set(axes2,'FontSize',12,'LineWidth',1,'TickLabelInterpreter','none','XTick',...
    [1 2],'XTickLabel',{'MF','MB'});



%OFC
Diff_OFC_MF=RDM_OFC_keep_MF-RDM_OFC_change_MF;
Diff_OFC_MB=RDM_OFC_keep_MB-RDM_OFC_change_MB;

[h,p]=ttest(Diff_OFC_MF,Diff_OFC_MB)

scrsz = get(0,'ScreenSize');
outerpos = [0.3*scrsz(3),0.3*scrsz(4),0.15*scrsz(3),0.4*scrsz(4)];
figure3 = figure('OuterPosition', outerpos,'Color',[1 1 1]);
% Create axes
axes3 = axes('Parent',figure3);
hold(axes3,'on');
boxplot([Diff_OFC_MF,Diff_OFC_MB])

xlim(axes3,[0.5 2.5]);
ylim(axes3,[-0.5 0.7]);

ylabel('Difference in corr. coef.(Keep-Change)','FontSize',14);
set(axes3,'FontSize',12,'LineWidth',1,'TickLabelInterpreter','none','XTick',...
    [1 2],'XTickLabel',{'MF','MB'});

