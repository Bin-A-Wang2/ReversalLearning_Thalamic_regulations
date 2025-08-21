

clear all
close all
load('/Users/binwang/Documents/Bochum/DATA/fMRI_RL_GoNoGo/Results_MD/Results_RSA/MD_MFvsMB/Cross_validation/RDMs_RN_MD_MFvsMB/RDMs/RL_GoNoGo_RDMs.mat')

m=1;
a=[0	1	1	1	1	0];%


for i=1:size(RDMs,2) %subjects
    %MD
    RDM_MD=RDMs(1,i).RDM;
    RDM_MD=[RDM_MD(1,2:end),RDM_MD(2,3:end),RDM_MD(3,4:end)];
    RDM_MD_0=mean(RDM_MD(a==0));
    RDM_MD_1=mean(RDM_MD(a==1));

    RDM_MD_0_all(i,m)=RDM_MD_0;
    RDM_MD_1_all(i,m)=RDM_MD_1;

end

[P,H,STATS] = signrank(RDM_MD_1_all(:,1),RDM_MD_0_all(:,1),'tail','right')

[p, observeddifference, effectsize] = permutationTest(RDM_MD_1_all(:,1),RDM_MD_0_all(:,1), 10000, 'sidedness','larger','plotresult', 1,'showprogress', 500)

%% plot the figure for same vs. different
x=RDM_dmPFC_1_all(:,1);
y=RDM_dmPFC_0_all(:,1);

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
ylim(axes1,[0 0.9]);

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


