

clear all
close all
load('D:\Bochum\DATA\fMRI_RL_GoNoGo\Results_MD\Results_RSA\#RDMs_RN_new\RDMs\RL_GoNoGo_RDMs.mat');
load('D:\Bochum\DATA\fMRI_RL_GoNoGo\Results_MD\Results_RSA\#RDMs_RN_new\RDMs\RL_GoNoGo_Models.mat');

for m=1:length(Models)
    
    Model_current=Models(m);
    a=[Model_current.RDM(1,2:end),Model_current.RDM(2,3:end),Model_current.RDM(3,4:end)];
    
    for i=1:size(RDMs,2) %subjects
        
        %MD
        RDM_MD=RDMs(1,i).RDM;
        RDM_MD=[RDM_MD(1,2:end),RDM_MD(2,3:end),RDM_MD(3,4:end)];
        
        RDM_MD_0=mean(RDM_MD(a==0));
        RDM_MD_1=mean(RDM_MD(a==1));
        
        %dACC
        RDM_dACC=RDMs(2,i).RDM;
        RDM_dACC=[RDM_dACC(1,2:end),RDM_dACC(2,3:end),RDM_dACC(3,4:end)];
        
        RDM_dACC_0=mean(RDM_dACC(a==0));
        RDM_dACC_1=mean(RDM_dACC(a==1));
        
        %dmPFC
        RDM_dmPFC=RDMs(3,i).RDM;
        RDM_dmPFC=[RDM_dmPFC(1,2:end),RDM_dmPFC(2,3:end),RDM_dmPFC(3,4:end)];
        
        RDM_dmPFC_0=mean(RDM_dmPFC(a==0));
        RDM_dmPFC_1=mean(RDM_dmPFC(a==1));
        
        %Caudate
        RDM_CAU=RDMs(4,i).RDM;
        RDM_CAU=[RDM_CAU(1,2:end),RDM_CAU(2,3:end),RDM_CAU(3,4:end)];
        
        RDM_CAU_0=mean(RDM_CAU(a==0));
        RDM_CAU_1=mean(RDM_CAU(a==1));
        
        
        
        RDM_MD_0_all(i,m)=RDM_MD_0;
        RDM_MD_1_all(i,m)=RDM_MD_1;
        
        RDM_dACC_0_all(i,m)=RDM_dACC_0;
        RDM_dACC_1_all(i,m)=RDM_dACC_1;
        
        RDM_dmPFC_0_all(i,m)=RDM_dmPFC_0;
        RDM_dmPFC_1_all(i,m)=RDM_dmPFC_1;
        
        RDM_CAU_0_all(i,m)=RDM_CAU_0;
        RDM_CAU_1_all(i,m)=RDM_CAU_1;
        
    end     
end

%% permutation test 
%cue model
%[p, observeddifference, effectsize] = permutationTest(RDM_cluster_OFC_1_all(:,1),RDM_cluster_OFC_0_all(:,1), 10000, 'sidedness','larger','plotresult', 1,'showprogress', 500)
[P,H,STATS] = signrank(RDM_MD_1_all(:,1),RDM_MD_0_all(:,1),'tail','right')
[P,H,STATS] = signrank(RDM_dACC_1_all(:,1),RDM_dACC_0_all(:,1),'tail','right')
[P,H,STATS] = signrank(RDM_dmPFC_1_all(:,1),RDM_dmPFC_0_all(:,1),'tail','right')
[P,H,STATS] = signrank(RDM_CAU_1_all(:,1),RDM_CAU_0_all(:,1),'tail','right')

%response model
[P,H,STATS] = signrank(RDM_MD_1_all(:,2),RDM_MD_0_all(:,2),'tail','right')
[P,H,STATS] = signrank(RDM_dACC_1_all(:,2),RDM_dACC_0_all(:,2),'tail','right')
[P,H,STATS] = signrank(RDM_dmPFC_1_all(:,2),RDM_dmPFC_0_all(:,2),'tail','right')
[P,H,STATS] = signrank(RDM_CAU_1_all(:,2),RDM_CAU_0_all(:,2),'tail','right')

%strategy model
[P,H,STATS] = signrank(RDM_MD_1_all(:,3),RDM_MD_0_all(:,3),'tail','right')
[P,H,STATS] = signrank(RDM_dACC_1_all(:,3),RDM_dACC_0_all(:,3),'tail','right')
[P,H,STATS] = signrank(RDM_dmPFC_1_all(:,3),RDM_dmPFC_0_all(:,3),'tail','right')
[P,H,STATS] = signrank(RDM_CAU_1_all(:,3),RDM_CAU_0_all(:,3),'tail','right')

[P,H,STATS] = signrank(RDM_MD_1_all(:,3),RDM_MD_0_all(:,3))
[P,H,STATS] = signrank(RDM_dmPFC_1_all(:,3),RDM_dmPFC_0_all(:,3))
[P,H,STATS] = signrank(RDM_CAU_1_all(:,3),RDM_CAU_0_all(:,3))
[p, observeddifference, effectsize] = permutationTest(RDM_MD_1_all(:,3),RDM_MD_0_all(:,3), 10000, 'sidedness','larger','plotresult', 1,'showprogress', 500)
[p, observeddifference, effectsize] = permutationTest(RDM_dmPFC_1_all(:,3),RDM_dmPFC_0_all(:,3), 10000, 'sidedness','larger','plotresult', 1,'showprogress', 500)
[p, observeddifference, effectsize] = permutationTest(RDM_CAU_1_all(:,3),RDM_CAU_0_all(:,3), 10000, 'sidedness','larger','plotresult', 1,'showprogress', 500)

%% plot the figure for same vs. differnet
x=RDM_CAU_1_all(:,3);
y=RDM_CAU_0_all(:,3);

scrsz = get(0,'ScreenSize');
outerpos = [0.3*scrsz(3),0.3*scrsz(4),0.10*scrsz(3),0.4*scrsz(4)];
figure1 = figure('OuterPosition', outerpos,'Color',[1 1 1]);

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% Create multiple lines using matrix input to plot
plot([1,2],[y,x],'MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0],...
    'Marker','o','Markersize',6,...
    'LineWidth',1,...
    'Color',[0 0 0],...
    'Parent',axes1);
xlim(axes1,[0 3]);
ylim(axes1,[0.1 0.8]);

ylabel('Corr. Coef.','FontSize',14);
set(axes1,'FontSize',14,'XTick',zeros(1,0),'XTickLabel',{});
set(axes1,'XTick',[1 2],'XTickLabel',{'Same','Diff'});

%% bar for distribution of difference
rdm_diff=x-y;

scrsz = get(0,'ScreenSize');
outerpos = [0.3*scrsz(3),0.3*scrsz(4),0.10*scrsz(3),0.4*scrsz(4)];
figure2 = figure('OuterPosition', outerpos,'Color',[1 1 1]);
% Create axes
axes2 = axes('Parent',figure2);
hold(axes2,'on');

bar(mean(rdm_diff),'FaceColor',[0.5 0.5 0.5])

hold on
plot2=plot(1,rdm_diff,'MarkerSize',10,'Marker','.');
set(plot2,'MarkerFaceColor',[0 0 0],'Color',[0 0 0]);

ylabel('Difference in corr. coef.','FontSize',14);
set(axes2,'FontSize',14,'XTick',[1],'XTickLabel',{'Diff-Same'});




