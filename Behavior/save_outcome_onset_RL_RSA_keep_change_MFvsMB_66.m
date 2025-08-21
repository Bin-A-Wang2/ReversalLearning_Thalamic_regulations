function save_outcome_onset_RL_RSA_keep_change_MFvsMB_66 (RootDir,Subjects,onset_pulse)

% RootDir=['/Users/binwang/Documents/Bochum/DATA/fMRI_RL_GoNoGo/'];
% Subjects=[2 3 4 5 7 8 11 12 13 14 15 16 17 18 19 20 22 23 26 27 28 29 31 32 33 34 35 36 37 38 39 40]; %% good subjects
% 
% onset_pulse=[13189 15530 15559; 15465 15915 15939; 13453 15338 14766;  8934 15728 15121;  8933 14490 14655; 15559 13103 15458; 15813 18060 18996; ... 
%              16104 16559 16170; 15009 15899 16482; 16151 16543 16483; 16090 16192 16046; 13849 16109 15833; 15814 16035 15811; 15952 15877 15808; 15977 15907 16228; 15355 16177 16152; ...
%              15920 15309 15572; 15409 15717 15705; 15735 15860 16090; 15824 16006 16063; 15421 15715 15358; 15430 15892 14864; 15877 15132 15723; ...
%              15214 16048 15774; 14251 14116 13251; 14812 15660 15494; 15556 15402 15609; 15055 15117 15359; 14958 15369 15253; 14498 15366 14845; 14844 14640 13572; 15691 15509 16142];

% Calculate and save the time onset time-locked to the cue and outcomes
%
% USAGE:
%     save_onset_RL_MD (RootDir,Subjects,onset_pulse)
%
% INPUT:
%      RootDir: the directory including folders of all subjects (Sub01, Sub02,...)
%      Subjects: subject number [1,2,3,...]
%      onset_pulse: the onset of first fmri pulse ( from the logfile of Presentation )
%
% OUTPUT:
%      
%
%  Edit by Bin Wang 07/09/2020 Bochum
%--------------------------------------------------------------------------

%clear all
%close all



%% load the index for MFvsMB
load('/Users/binwang/Documents/Bochum/DATA/fMRI_RL_GoNoGo/Results_MD/Results_RLmodel_fit/MFvsMB/#workspace_with_across_switch_MFvsMB_flags_v0c.mat',...
        'flag_block_MF_vs_MB_halves_from_dist',...
        'flag_block_MF_vs_MB_halves_from_dist_2',...
        'flag_block_MF_vs_MB_halves_from_w');
% 0 means the switch in the block is better explained by MB and
% 1 means the switch in the block is better explained by MF

LogDir=['/Users/binwang/Documents/Bochum/DATA/fMRI_RL_GoNoGo/Logfile/'];

for i = 1:length(Subjects)
    j=Subjects(i);
    outputDir=[RootDir,'Results_MD/Participants/','Sub',num2str(j,'%.2d')];
    
    if exist([outputDir],'dir')==0
       mkdir(outputDir);
    end
        
    Result=importdata([LogDir,'sub' num2str(j,'%.2d') '_RL_Go_NoGo_results_all.txt']);
    
    Index_B1=[ones(10,1);0;0;2*ones(10,1);3*ones(10,1);0;0;0;4*ones(10,1)];
    Index_B2=[ones(10,1);0;0;0;0;2*ones(10,1);3*ones(10,1);0;4*ones(10,1)];
    Index_B3=[ones(10,1);0;2*ones(10,1);3*ones(10,1);0;0;0;0;4*ones(10,1)];
    Index_B4=[ones(10,1);0;0;0;2*ones(10,1);3*ones(10,1);0;0;4*ones(10,1)];
    Index_B5=[ones(10,1);0;0;0;0;0;2*ones(10,1);3*ones(10,1);4*ones(10,1)];
    Index_B6=[ones(10,1);0;0;2*ones(10,1);3*ones(10,1);0;0;0;4*ones(10,1)];
    Index_B7=[ones(10,1);0;0;0;0;2*ones(10,1);3*ones(10,1);0;4*ones(10,1)];
    Index_B8=[ones(10,1);2*ones(10,1);3*ones(10,1);0;0;0;0;0;4*ones(10,1)];
    Index_B9=[ones(10,1);2*ones(10,1);3*ones(10,1);0;0;0;0;0;4*ones(10,1)];
    Index_B10=[ones(10,1);0;0;0;0;2*ones(10,1);3*ones(10,1);0;4*ones(10,1)];
    Index_B11=[ones(10,1);0;0;0;2*ones(10,1);3*ones(10,1);0;0;4*ones(10,1)];
    Index_B12=[ones(10,1);0;2*ones(10,1);3*ones(10,1);0;0;0;0;4*ones(10,1)];
    
    Index_all=[Index_B1;Index_B2;Index_B3;Index_B4;Index_B5;Index_B6;Index_B7;...
               Index_B8;Index_B9;Index_B10;Index_B11;Index_B12]; %1-LN;2-LE;3-RN;4-RE
    
    all_outcome_onset=[Result.data(:,[3,6,7]),Index_all]; %trial type; outcome onset;reponses;stages index
    
    
    index_MFvsMB_currentsubj=flag_block_MF_vs_MB_halves_from_dist(:,i);


    all_outcome_onset(1:45,5)=index_MFvsMB_currentsubj(1);
    all_outcome_onset(46:90,5)=index_MFvsMB_currentsubj(2);
    all_outcome_onset(91:135,5)=index_MFvsMB_currentsubj(3);
    all_outcome_onset(136:180,5)=index_MFvsMB_currentsubj(4);
    all_outcome_onset(181:225,5)=index_MFvsMB_currentsubj(5);
    all_outcome_onset(226:270,5)=index_MFvsMB_currentsubj(6);
    all_outcome_onset(271:315,5)=index_MFvsMB_currentsubj(7);
    all_outcome_onset(316:360,5)=index_MFvsMB_currentsubj(8);
    all_outcome_onset(361:405,5)=index_MFvsMB_currentsubj(9);
    all_outcome_onset(406:450,5)=index_MFvsMB_currentsubj(10);
    all_outcome_onset(451:495,5)=index_MFvsMB_currentsubj(11);
    all_outcome_onset(496:540,5)=index_MFvsMB_currentsubj(12);


    %% outcome onset
    %R1
    R1_outcome=all_outcome_onset(1:180,:,:);
    %subtract onset of first pulse
    R1_outcome(:,2)=(R1_outcome(:,2)-onset_pulse(i,1))/1000;


    %Cue1-Go/Cue1-NoGo/Cue2-NoGo/Cue2_Go
    %block1
    R1_outcome_B1=R1_outcome(1:45,:);

    %RN MF
    onset_outcome_cue1Go_R1_RN_MF_B1  =R1_outcome_B1((R1_outcome_B1(:,1)==1|R1_outcome_B1(:,1)==2)&(R1_outcome_B1(:,3)==1|R1_outcome_B1(:,3)==2)&R1_outcome_B1(:,4)==3&R1_outcome_B1(:,5)==1,2);
    onset_outcome_cue2NoGo_R1_RN_MF_B1=R1_outcome_B1((R1_outcome_B1(:,1)==3|R1_outcome_B1(:,1)==4)&(R1_outcome_B1(:,3)==3|R1_outcome_B1(:,3)==4)&R1_outcome_B1(:,4)==3&R1_outcome_B1(:,5)==1,2);
    onset_outcome_cue1NoGo_R1_RN_MF_B1=R1_outcome_B1((R1_outcome_B1(:,1)==1|R1_outcome_B1(:,1)==2)&(R1_outcome_B1(:,3)==3|R1_outcome_B1(:,3)==4)&R1_outcome_B1(:,4)==3&R1_outcome_B1(:,5)==1,2);
    onset_outcome_cue2Go_R1_RN_MF_B1  =R1_outcome_B1((R1_outcome_B1(:,1)==3|R1_outcome_B1(:,1)==4)&(R1_outcome_B1(:,3)==1|R1_outcome_B1(:,3)==2)&R1_outcome_B1(:,4)==3&R1_outcome_B1(:,5)==1,2);
  
    %RN MB
    onset_outcome_cue1Go_R1_RN_MB_B1  =R1_outcome_B1((R1_outcome_B1(:,1)==1|R1_outcome_B1(:,1)==2)&(R1_outcome_B1(:,3)==1|R1_outcome_B1(:,3)==2)&R1_outcome_B1(:,4)==3&R1_outcome_B1(:,5)==0,2);
    onset_outcome_cue2NoGo_R1_RN_MB_B1=R1_outcome_B1((R1_outcome_B1(:,1)==3|R1_outcome_B1(:,1)==4)&(R1_outcome_B1(:,3)==3|R1_outcome_B1(:,3)==4)&R1_outcome_B1(:,4)==3&R1_outcome_B1(:,5)==0,2);
    onset_outcome_cue1NoGo_R1_RN_MB_B1=R1_outcome_B1((R1_outcome_B1(:,1)==1|R1_outcome_B1(:,1)==2)&(R1_outcome_B1(:,3)==3|R1_outcome_B1(:,3)==4)&R1_outcome_B1(:,4)==3&R1_outcome_B1(:,5)==0,2);
    onset_outcome_cue2Go_R1_RN_MB_B1  =R1_outcome_B1((R1_outcome_B1(:,1)==3|R1_outcome_B1(:,1)==4)&(R1_outcome_B1(:,3)==1|R1_outcome_B1(:,3)==2)&R1_outcome_B1(:,4)==3&R1_outcome_B1(:,5)==0,2);

    
    %block2
    R1_outcome_B2=R1_outcome(46:90,:);

    %RN MF
    onset_outcome_cue1Go_R1_RN_MF_B2  =R1_outcome_B2((R1_outcome_B2(:,1)==3|R1_outcome_B2(:,1)==4)&(R1_outcome_B2(:,3)==1|R1_outcome_B2(:,3)==2)&R1_outcome_B2(:,4)==3&R1_outcome_B2(:,5)==1,2);
    onset_outcome_cue2NoGo_R1_RN_MF_B2=R1_outcome_B2((R1_outcome_B2(:,1)==1|R1_outcome_B2(:,1)==2)&(R1_outcome_B2(:,3)==3|R1_outcome_B2(:,3)==4)&R1_outcome_B2(:,4)==3&R1_outcome_B2(:,5)==1,2);
    onset_outcome_cue1NoGo_R1_RN_MF_B2=R1_outcome_B2((R1_outcome_B2(:,1)==3|R1_outcome_B2(:,1)==4)&(R1_outcome_B2(:,3)==3|R1_outcome_B2(:,3)==4)&R1_outcome_B2(:,4)==3&R1_outcome_B2(:,5)==1,2);
    onset_outcome_cue2Go_R1_RN_MF_B2  =R1_outcome_B2((R1_outcome_B2(:,1)==1|R1_outcome_B2(:,1)==2)&(R1_outcome_B2(:,3)==1|R1_outcome_B2(:,3)==2)&R1_outcome_B2(:,4)==3&R1_outcome_B2(:,5)==1,2);
    
    %RN MB
    onset_outcome_cue1Go_R1_RN_MB_B2  =R1_outcome_B2((R1_outcome_B2(:,1)==3|R1_outcome_B2(:,1)==4)&(R1_outcome_B2(:,3)==1|R1_outcome_B2(:,3)==2)&R1_outcome_B2(:,4)==3&R1_outcome_B2(:,5)==0,2);
    onset_outcome_cue2NoGo_R1_RN_MB_B2=R1_outcome_B2((R1_outcome_B2(:,1)==1|R1_outcome_B2(:,1)==2)&(R1_outcome_B2(:,3)==3|R1_outcome_B2(:,3)==4)&R1_outcome_B2(:,4)==3&R1_outcome_B2(:,5)==0,2);
    onset_outcome_cue1NoGo_R1_RN_MB_B2=R1_outcome_B2((R1_outcome_B2(:,1)==3|R1_outcome_B2(:,1)==4)&(R1_outcome_B2(:,3)==3|R1_outcome_B2(:,3)==4)&R1_outcome_B2(:,4)==3&R1_outcome_B2(:,5)==0,2);
    onset_outcome_cue2Go_R1_RN_MB_B2  =R1_outcome_B2((R1_outcome_B2(:,1)==1|R1_outcome_B2(:,1)==2)&(R1_outcome_B2(:,3)==1|R1_outcome_B2(:,3)==2)&R1_outcome_B2(:,4)==3&R1_outcome_B2(:,5)==0,2);
    

    %block3
    R1_outcome_B3=R1_outcome(91:135,:);
    
    %RN MF
    onset_outcome_cue1Go_R1_RN_MF_B3  =R1_outcome_B3((R1_outcome_B3(:,1)==1|R1_outcome_B3(:,1)==2)&(R1_outcome_B3(:,3)==1|R1_outcome_B3(:,3)==2)&R1_outcome_B3(:,4)==3&R1_outcome_B3(:,5)==1,2);
    onset_outcome_cue2NoGo_R1_RN_MF_B3=R1_outcome_B3((R1_outcome_B3(:,1)==3|R1_outcome_B3(:,1)==4)&(R1_outcome_B3(:,3)==3|R1_outcome_B3(:,3)==4)&R1_outcome_B3(:,4)==3&R1_outcome_B3(:,5)==1,2);
    onset_outcome_cue1NoGo_R1_RN_MF_B3=R1_outcome_B3((R1_outcome_B3(:,1)==1|R1_outcome_B3(:,1)==2)&(R1_outcome_B3(:,3)==3|R1_outcome_B3(:,3)==4)&R1_outcome_B3(:,4)==3&R1_outcome_B3(:,5)==1,2);
    onset_outcome_cue2Go_R1_RN_MF_B3  =R1_outcome_B3((R1_outcome_B3(:,1)==3|R1_outcome_B3(:,1)==4)&(R1_outcome_B3(:,3)==1|R1_outcome_B3(:,3)==2)&R1_outcome_B3(:,4)==3&R1_outcome_B3(:,5)==1,2);

    %RN MB
    onset_outcome_cue1Go_R1_RN_MB_B3  =R1_outcome_B3((R1_outcome_B3(:,1)==1|R1_outcome_B3(:,1)==2)&(R1_outcome_B3(:,3)==1|R1_outcome_B3(:,3)==2)&R1_outcome_B3(:,4)==3&R1_outcome_B3(:,5)==0,2);
    onset_outcome_cue2NoGo_R1_RN_MB_B3=R1_outcome_B3((R1_outcome_B3(:,1)==3|R1_outcome_B3(:,1)==4)&(R1_outcome_B3(:,3)==3|R1_outcome_B3(:,3)==4)&R1_outcome_B3(:,4)==3&R1_outcome_B3(:,5)==0,2);
    onset_outcome_cue1NoGo_R1_RN_MB_B3=R1_outcome_B3((R1_outcome_B3(:,1)==1|R1_outcome_B3(:,1)==2)&(R1_outcome_B3(:,3)==3|R1_outcome_B3(:,3)==4)&R1_outcome_B3(:,4)==3&R1_outcome_B3(:,5)==0,2);
    onset_outcome_cue2Go_R1_RN_MB_B3  =R1_outcome_B3((R1_outcome_B3(:,1)==3|R1_outcome_B3(:,1)==4)&(R1_outcome_B3(:,3)==1|R1_outcome_B3(:,3)==2)&R1_outcome_B3(:,4)==3&R1_outcome_B3(:,5)==0,2);


    %block4    
    R1_outcome_B4=R1_outcome(136:180,:);

    %RN MF
    onset_outcome_cue1Go_R1_RN_MF_B4  =R1_outcome_B4((R1_outcome_B4(:,1)==3|R1_outcome_B4(:,1)==4)&(R1_outcome_B4(:,3)==1|R1_outcome_B4(:,3)==2)&R1_outcome_B4(:,4)==3&R1_outcome_B4(:,5)==1,2);
    onset_outcome_cue2NoGo_R1_RN_MF_B4=R1_outcome_B4((R1_outcome_B4(:,1)==1|R1_outcome_B4(:,1)==2)&(R1_outcome_B4(:,3)==3|R1_outcome_B4(:,3)==4)&R1_outcome_B4(:,4)==3&R1_outcome_B4(:,5)==1,2);
    onset_outcome_cue1NoGo_R1_RN_MF_B4=R1_outcome_B4((R1_outcome_B4(:,1)==3|R1_outcome_B4(:,1)==4)&(R1_outcome_B4(:,3)==3|R1_outcome_B4(:,3)==4)&R1_outcome_B4(:,4)==3&R1_outcome_B4(:,5)==1,2);
    onset_outcome_cue2Go_R1_RN_MF_B4  =R1_outcome_B4((R1_outcome_B4(:,1)==1|R1_outcome_B4(:,1)==2)&(R1_outcome_B4(:,3)==1|R1_outcome_B4(:,3)==2)&R1_outcome_B4(:,4)==3&R1_outcome_B4(:,5)==1,2);

    %RN MB
    onset_outcome_cue1Go_R1_RN_MB_B4  =R1_outcome_B4((R1_outcome_B4(:,1)==3|R1_outcome_B4(:,1)==4)&(R1_outcome_B4(:,3)==1|R1_outcome_B4(:,3)==2)&R1_outcome_B4(:,4)==3&R1_outcome_B4(:,5)==0,2);
    onset_outcome_cue2NoGo_R1_RN_MB_B4=R1_outcome_B4((R1_outcome_B4(:,1)==1|R1_outcome_B4(:,1)==2)&(R1_outcome_B4(:,3)==3|R1_outcome_B4(:,3)==4)&R1_outcome_B4(:,4)==3&R1_outcome_B4(:,5)==0,2);
    onset_outcome_cue1NoGo_R1_RN_MB_B4=R1_outcome_B4((R1_outcome_B4(:,1)==3|R1_outcome_B4(:,1)==4)&(R1_outcome_B4(:,3)==3|R1_outcome_B4(:,3)==4)&R1_outcome_B4(:,4)==3&R1_outcome_B4(:,5)==0,2);
    onset_outcome_cue2Go_R1_RN_MB_B4  =R1_outcome_B4((R1_outcome_B4(:,1)==1|R1_outcome_B4(:,1)==2)&(R1_outcome_B4(:,3)==1|R1_outcome_B4(:,3)==2)&R1_outcome_B4(:,4)==3&R1_outcome_B4(:,5)==0,2);
    
    %All
    onset_outcome_cue1Go_R1_RN_MF  =[onset_outcome_cue1Go_R1_RN_MF_B1;  onset_outcome_cue1Go_R1_RN_MF_B2;  onset_outcome_cue1Go_R1_RN_MF_B3;  onset_outcome_cue1Go_R1_RN_MF_B4];
    onset_outcome_cue2NoGo_R1_RN_MF=[onset_outcome_cue2NoGo_R1_RN_MF_B1;onset_outcome_cue2NoGo_R1_RN_MF_B2;onset_outcome_cue2NoGo_R1_RN_MF_B3;onset_outcome_cue2NoGo_R1_RN_MF_B4];
    onset_outcome_cue1NoGo_R1_RN_MF=[onset_outcome_cue1NoGo_R1_RN_MF_B1;onset_outcome_cue1NoGo_R1_RN_MF_B2;onset_outcome_cue1NoGo_R1_RN_MF_B3;onset_outcome_cue1NoGo_R1_RN_MF_B4];
    onset_outcome_cue2Go_R1_RN_MF  =[onset_outcome_cue2Go_R1_RN_MF_B1  ;onset_outcome_cue2Go_R1_RN_MF_B2;  onset_outcome_cue2Go_R1_RN_MF_B3;  onset_outcome_cue2Go_R1_RN_MF_B4];
    
    onset_outcome_cue1Go_R1_RN_MB  =[onset_outcome_cue1Go_R1_RN_MB_B1;  onset_outcome_cue1Go_R1_RN_MB_B2;  onset_outcome_cue1Go_R1_RN_MB_B3;  onset_outcome_cue1Go_R1_RN_MB_B4];
    onset_outcome_cue2NoGo_R1_RN_MB=[onset_outcome_cue2NoGo_R1_RN_MB_B1;onset_outcome_cue2NoGo_R1_RN_MB_B2;onset_outcome_cue2NoGo_R1_RN_MB_B3;onset_outcome_cue2NoGo_R1_RN_MB_B4];
    onset_outcome_cue1NoGo_R1_RN_MB=[onset_outcome_cue1NoGo_R1_RN_MB_B1;onset_outcome_cue1NoGo_R1_RN_MB_B2;onset_outcome_cue1NoGo_R1_RN_MB_B3;onset_outcome_cue1NoGo_R1_RN_MB_B4];
    onset_outcome_cue2Go_R1_RN_MB  =[onset_outcome_cue2Go_R1_RN_MB_B1  ;onset_outcome_cue2Go_R1_RN_MB_B2;  onset_outcome_cue2Go_R1_RN_MB_B3;  onset_outcome_cue2Go_R1_RN_MB_B4];   



    %% R2
    R2_outcome=all_outcome_onset(181:360,:);
    %subtract onset of first pulse
    R2_outcome(:,2)=(R2_outcome(:,2)-onset_pulse(i,2))/1000;

    
    %Cue1-Go/Cue1-NoGo/Cue2-NoGo/Cue2_Go
    %block1
    R2_outcome_B1=R2_outcome(1:45,:);

    %RN MF
    onset_outcome_cue1Go_R2_RN_MF_B1  =R2_outcome_B1((R2_outcome_B1(:,1)==1|R2_outcome_B1(:,1)==2)&(R2_outcome_B1(:,3)==1|R2_outcome_B1(:,3)==2)&R2_outcome_B1(:,4)==3&R2_outcome_B1(:,5)==1,2);
    onset_outcome_cue2NoGo_R2_RN_MF_B1=R2_outcome_B1((R2_outcome_B1(:,1)==3|R2_outcome_B1(:,1)==4)&(R2_outcome_B1(:,3)==3|R2_outcome_B1(:,3)==4)&R2_outcome_B1(:,4)==3&R2_outcome_B1(:,5)==1,2);
    onset_outcome_cue1NoGo_R2_RN_MF_B1=R2_outcome_B1((R2_outcome_B1(:,1)==1|R2_outcome_B1(:,1)==2)&(R2_outcome_B1(:,3)==3|R2_outcome_B1(:,3)==4)&R2_outcome_B1(:,4)==3&R2_outcome_B1(:,5)==1,2);
    onset_outcome_cue2Go_R2_RN_MF_B1  =R2_outcome_B1((R2_outcome_B1(:,1)==3|R2_outcome_B1(:,1)==4)&(R2_outcome_B1(:,3)==1|R2_outcome_B1(:,3)==2)&R2_outcome_B1(:,4)==3&R2_outcome_B1(:,5)==1,2);
    
    %RN MB
    onset_outcome_cue1Go_R2_RN_MB_B1  =R2_outcome_B1((R2_outcome_B1(:,1)==1|R2_outcome_B1(:,1)==2)&(R2_outcome_B1(:,3)==1|R2_outcome_B1(:,3)==2)&R2_outcome_B1(:,4)==3&R2_outcome_B1(:,5)==0,2);
    onset_outcome_cue2NoGo_R2_RN_MB_B1=R2_outcome_B1((R2_outcome_B1(:,1)==3|R2_outcome_B1(:,1)==4)&(R2_outcome_B1(:,3)==3|R2_outcome_B1(:,3)==4)&R2_outcome_B1(:,4)==3&R2_outcome_B1(:,5)==0,2);
    onset_outcome_cue1NoGo_R2_RN_MB_B1=R2_outcome_B1((R2_outcome_B1(:,1)==1|R2_outcome_B1(:,1)==2)&(R2_outcome_B1(:,3)==3|R2_outcome_B1(:,3)==4)&R2_outcome_B1(:,4)==3&R2_outcome_B1(:,5)==0,2);
    onset_outcome_cue2Go_R2_RN_MB_B1  =R2_outcome_B1((R2_outcome_B1(:,1)==3|R2_outcome_B1(:,1)==4)&(R2_outcome_B1(:,3)==1|R2_outcome_B1(:,3)==2)&R2_outcome_B1(:,4)==3&R2_outcome_B1(:,5)==0,2);

    %block2
    R2_outcome_B2=R2_outcome(46:90,:);

    %RN MF
    onset_outcome_cue1Go_R2_RN_MF_B2  =R2_outcome_B2((R2_outcome_B2(:,1)==3|R2_outcome_B2(:,1)==4)&(R2_outcome_B2(:,3)==1|R2_outcome_B2(:,3)==2)&R2_outcome_B2(:,4)==3&R2_outcome_B2(:,5)==1,2);
    onset_outcome_cue2NoGo_R2_RN_MF_B2=R2_outcome_B2((R2_outcome_B2(:,1)==1|R2_outcome_B2(:,1)==2)&(R2_outcome_B2(:,3)==3|R2_outcome_B2(:,3)==4)&R2_outcome_B2(:,4)==3&R2_outcome_B2(:,5)==1,2);
    onset_outcome_cue1NoGo_R2_RN_MF_B2=R2_outcome_B2((R2_outcome_B2(:,1)==3|R2_outcome_B2(:,1)==4)&(R2_outcome_B2(:,3)==3|R2_outcome_B2(:,3)==4)&R2_outcome_B2(:,4)==3&R2_outcome_B2(:,5)==1,2);
    onset_outcome_cue2Go_R2_RN_MF_B2  =R2_outcome_B2((R2_outcome_B2(:,1)==1|R2_outcome_B2(:,1)==2)&(R2_outcome_B2(:,3)==1|R2_outcome_B2(:,3)==2)&R2_outcome_B2(:,4)==3&R2_outcome_B2(:,5)==1,2);
    
    %RN MB
    onset_outcome_cue1Go_R2_RN_MB_B2  =R2_outcome_B2((R2_outcome_B2(:,1)==3|R2_outcome_B2(:,1)==4)&(R2_outcome_B2(:,3)==1|R2_outcome_B2(:,3)==2)&R2_outcome_B2(:,4)==3&R2_outcome_B2(:,5)==0,2);
    onset_outcome_cue2NoGo_R2_RN_MB_B2=R2_outcome_B2((R2_outcome_B2(:,1)==1|R2_outcome_B2(:,1)==2)&(R2_outcome_B2(:,3)==3|R2_outcome_B2(:,3)==4)&R2_outcome_B2(:,4)==3&R2_outcome_B2(:,5)==0,2);
    onset_outcome_cue1NoGo_R2_RN_MB_B2=R2_outcome_B2((R2_outcome_B2(:,1)==3|R2_outcome_B2(:,1)==4)&(R2_outcome_B2(:,3)==3|R2_outcome_B2(:,3)==4)&R2_outcome_B2(:,4)==3&R2_outcome_B2(:,5)==0,2);
    onset_outcome_cue2Go_R2_RN_MB_B2  =R2_outcome_B2((R2_outcome_B2(:,1)==1|R2_outcome_B2(:,1)==2)&(R2_outcome_B2(:,3)==1|R2_outcome_B2(:,3)==2)&R2_outcome_B2(:,4)==3&R2_outcome_B2(:,5)==0,2);    


    
    %block3
    R2_outcome_B3=R2_outcome(91:135,:);
    
    %RN MF
    onset_outcome_cue1Go_R2_RN_MF_B3  =R2_outcome_B3((R2_outcome_B3(:,1)==1|R2_outcome_B3(:,1)==2)&(R2_outcome_B3(:,3)==1|R2_outcome_B3(:,3)==2)&R2_outcome_B3(:,4)==3&R2_outcome_B3(:,5)==1,2);
    onset_outcome_cue2NoGo_R2_RN_MF_B3=R2_outcome_B3((R2_outcome_B3(:,1)==3|R2_outcome_B3(:,1)==4)&(R2_outcome_B3(:,3)==3|R2_outcome_B3(:,3)==4)&R2_outcome_B3(:,4)==3&R2_outcome_B3(:,5)==1,2);
    onset_outcome_cue1NoGo_R2_RN_MF_B3=R2_outcome_B3((R2_outcome_B3(:,1)==1|R2_outcome_B3(:,1)==2)&(R2_outcome_B3(:,3)==3|R2_outcome_B3(:,3)==4)&R2_outcome_B3(:,4)==3&R2_outcome_B3(:,5)==1,2);
    onset_outcome_cue2Go_R2_RN_MF_B3  =R2_outcome_B3((R2_outcome_B3(:,1)==3|R2_outcome_B3(:,1)==4)&(R2_outcome_B3(:,3)==1|R2_outcome_B3(:,3)==2)&R2_outcome_B3(:,4)==3&R2_outcome_B3(:,5)==1,2);

    %RN MB
    onset_outcome_cue1Go_R2_RN_MB_B3  =R2_outcome_B3((R2_outcome_B3(:,1)==1|R2_outcome_B3(:,1)==2)&(R2_outcome_B3(:,3)==1|R2_outcome_B3(:,3)==2)&R2_outcome_B3(:,4)==3&R2_outcome_B3(:,5)==0,2);
    onset_outcome_cue2NoGo_R2_RN_MB_B3=R2_outcome_B3((R2_outcome_B3(:,1)==3|R2_outcome_B3(:,1)==4)&(R2_outcome_B3(:,3)==3|R2_outcome_B3(:,3)==4)&R2_outcome_B3(:,4)==3&R2_outcome_B3(:,5)==0,2);
    onset_outcome_cue1NoGo_R2_RN_MB_B3=R2_outcome_B3((R2_outcome_B3(:,1)==1|R2_outcome_B3(:,1)==2)&(R2_outcome_B3(:,3)==3|R2_outcome_B3(:,3)==4)&R2_outcome_B3(:,4)==3&R2_outcome_B3(:,5)==0,2);
    onset_outcome_cue2Go_R2_RN_MB_B3  =R2_outcome_B3((R2_outcome_B3(:,1)==3|R2_outcome_B3(:,1)==4)&(R2_outcome_B3(:,3)==1|R2_outcome_B3(:,3)==2)&R2_outcome_B3(:,4)==3&R2_outcome_B3(:,5)==0,2);
    
   
    %block4    
    R2_outcome_B4=R2_outcome(136:180,:);
    
    %RN MF
    onset_outcome_cue1Go_R2_RN_MF_B4  =R2_outcome_B4((R2_outcome_B4(:,1)==3|R2_outcome_B4(:,1)==4)&(R2_outcome_B4(:,3)==1|R2_outcome_B4(:,3)==2)&R2_outcome_B4(:,4)==3&R2_outcome_B4(:,5)==1,2);
    onset_outcome_cue2NoGo_R2_RN_MF_B4=R2_outcome_B4((R2_outcome_B4(:,1)==1|R2_outcome_B4(:,1)==2)&(R2_outcome_B4(:,3)==3|R2_outcome_B4(:,3)==4)&R2_outcome_B4(:,4)==3&R2_outcome_B4(:,5)==1,2);
    onset_outcome_cue1NoGo_R2_RN_MF_B4=R2_outcome_B4((R2_outcome_B4(:,1)==3|R2_outcome_B4(:,1)==4)&(R2_outcome_B4(:,3)==3|R2_outcome_B4(:,3)==4)&R2_outcome_B4(:,4)==3&R2_outcome_B4(:,5)==1,2);
    onset_outcome_cue2Go_R2_RN_MF_B4  =R2_outcome_B4((R2_outcome_B4(:,1)==1|R2_outcome_B4(:,1)==2)&(R2_outcome_B4(:,3)==1|R2_outcome_B4(:,3)==2)&R2_outcome_B4(:,4)==3&R2_outcome_B4(:,5)==1,2);

    %RN MB
    onset_outcome_cue1Go_R2_RN_MB_B4  =R2_outcome_B4((R2_outcome_B4(:,1)==3|R2_outcome_B4(:,1)==4)&(R2_outcome_B4(:,3)==1|R2_outcome_B4(:,3)==2)&R2_outcome_B4(:,4)==3&R2_outcome_B4(:,5)==0,2);
    onset_outcome_cue2NoGo_R2_RN_MB_B4=R2_outcome_B4((R2_outcome_B4(:,1)==1|R2_outcome_B4(:,1)==2)&(R2_outcome_B4(:,3)==3|R2_outcome_B4(:,3)==4)&R2_outcome_B4(:,4)==3&R2_outcome_B4(:,5)==0,2);
    onset_outcome_cue1NoGo_R2_RN_MB_B4=R2_outcome_B4((R2_outcome_B4(:,1)==3|R2_outcome_B4(:,1)==4)&(R2_outcome_B4(:,3)==3|R2_outcome_B4(:,3)==4)&R2_outcome_B4(:,4)==3&R2_outcome_B4(:,5)==0,2);
    onset_outcome_cue2Go_R2_RN_MB_B4  =R2_outcome_B4((R2_outcome_B4(:,1)==1|R2_outcome_B4(:,1)==2)&(R2_outcome_B4(:,3)==1|R2_outcome_B4(:,3)==2)&R2_outcome_B4(:,4)==3&R2_outcome_B4(:,5)==0,2);
    
    %All
    onset_outcome_cue1Go_R2_RN_MF  =[onset_outcome_cue1Go_R2_RN_MF_B1;  onset_outcome_cue1Go_R2_RN_MF_B2;  onset_outcome_cue1Go_R2_RN_MF_B3;  onset_outcome_cue1Go_R2_RN_MF_B4];
    onset_outcome_cue2NoGo_R2_RN_MF=[onset_outcome_cue2NoGo_R2_RN_MF_B1;onset_outcome_cue2NoGo_R2_RN_MF_B2;onset_outcome_cue2NoGo_R2_RN_MF_B3;onset_outcome_cue2NoGo_R2_RN_MF_B4];
    onset_outcome_cue1NoGo_R2_RN_MF=[onset_outcome_cue1NoGo_R2_RN_MF_B1;onset_outcome_cue1NoGo_R2_RN_MF_B2;onset_outcome_cue1NoGo_R2_RN_MF_B3;onset_outcome_cue1NoGo_R2_RN_MF_B4];
    onset_outcome_cue2Go_R2_RN_MF  =[onset_outcome_cue2Go_R2_RN_MF_B1  ;onset_outcome_cue2Go_R2_RN_MF_B2;  onset_outcome_cue2Go_R2_RN_MF_B3;  onset_outcome_cue2Go_R2_RN_MF_B4];

    onset_outcome_cue1Go_R2_RN_MB  =[onset_outcome_cue1Go_R2_RN_MB_B1;  onset_outcome_cue1Go_R2_RN_MB_B2;  onset_outcome_cue1Go_R2_RN_MB_B3;  onset_outcome_cue1Go_R2_RN_MB_B4];
    onset_outcome_cue2NoGo_R2_RN_MB=[onset_outcome_cue2NoGo_R2_RN_MB_B1;onset_outcome_cue2NoGo_R2_RN_MB_B2;onset_outcome_cue2NoGo_R2_RN_MB_B3;onset_outcome_cue2NoGo_R2_RN_MB_B4];
    onset_outcome_cue1NoGo_R2_RN_MB=[onset_outcome_cue1NoGo_R2_RN_MB_B1;onset_outcome_cue1NoGo_R2_RN_MB_B2;onset_outcome_cue1NoGo_R2_RN_MB_B3;onset_outcome_cue1NoGo_R2_RN_MB_B4];
    onset_outcome_cue2Go_R2_RN_MB  =[onset_outcome_cue2Go_R2_RN_MB_B1  ;onset_outcome_cue2Go_R2_RN_MB_B2;  onset_outcome_cue2Go_R2_RN_MB_B3;  onset_outcome_cue2Go_R2_RN_MB_B4];
    

    

    %% R3
    R3_outcome=all_outcome_onset(361:540,:);
    %subtract onset of first pulse
    R3_outcome(:,2)=(R3_outcome(:,2)-onset_pulse(i,3))/1000;
    
    
    %Cue1-Go/Cue1-NoGo/Cue2-NoGo/Cue2_Go
    %block1
    R3_outcome_B1=R3_outcome(1:45,:);

    %RN MF
    onset_outcome_cue1Go_R3_RN_MF_B1  =R3_outcome_B1((R3_outcome_B1(:,1)==1|R3_outcome_B1(:,1)==2)&(R3_outcome_B1(:,3)==1|R3_outcome_B1(:,3)==2)&R3_outcome_B1(:,4)==3&R3_outcome_B1(:,5)==1,2);
    onset_outcome_cue2NoGo_R3_RN_MF_B1=R3_outcome_B1((R3_outcome_B1(:,1)==3|R3_outcome_B1(:,1)==4)&(R3_outcome_B1(:,3)==3|R3_outcome_B1(:,3)==4)&R3_outcome_B1(:,4)==3&R3_outcome_B1(:,5)==1,2);
    onset_outcome_cue1NoGo_R3_RN_MF_B1=R3_outcome_B1((R3_outcome_B1(:,1)==1|R3_outcome_B1(:,1)==2)&(R3_outcome_B1(:,3)==3|R3_outcome_B1(:,3)==4)&R3_outcome_B1(:,4)==3&R3_outcome_B1(:,5)==1,2);
    onset_outcome_cue2Go_R3_RN_MF_B1  =R3_outcome_B1((R3_outcome_B1(:,1)==3|R3_outcome_B1(:,1)==4)&(R3_outcome_B1(:,3)==1|R3_outcome_B1(:,3)==2)&R3_outcome_B1(:,4)==3&R3_outcome_B1(:,5)==1,2);
 
    %RN MB
    onset_outcome_cue1Go_R3_RN_MB_B1  =R3_outcome_B1((R3_outcome_B1(:,1)==1|R3_outcome_B1(:,1)==2)&(R3_outcome_B1(:,3)==1|R3_outcome_B1(:,3)==2)&R3_outcome_B1(:,4)==3&R3_outcome_B1(:,5)==0,2);
    onset_outcome_cue2NoGo_R3_RN_MB_B1=R3_outcome_B1((R3_outcome_B1(:,1)==3|R3_outcome_B1(:,1)==4)&(R3_outcome_B1(:,3)==3|R3_outcome_B1(:,3)==4)&R3_outcome_B1(:,4)==3&R3_outcome_B1(:,5)==0,2);
    onset_outcome_cue1NoGo_R3_RN_MB_B1=R3_outcome_B1((R3_outcome_B1(:,1)==1|R3_outcome_B1(:,1)==2)&(R3_outcome_B1(:,3)==3|R3_outcome_B1(:,3)==4)&R3_outcome_B1(:,4)==3&R3_outcome_B1(:,5)==0,2);
    onset_outcome_cue2Go_R3_RN_MB_B1  =R3_outcome_B1((R3_outcome_B1(:,1)==3|R3_outcome_B1(:,1)==4)&(R3_outcome_B1(:,3)==1|R3_outcome_B1(:,3)==2)&R3_outcome_B1(:,4)==3&R3_outcome_B1(:,5)==0,2);


    %block2
    R3_outcome_B2=R3_outcome(46:90,:);

    %RN MF
    onset_outcome_cue1Go_R3_RN_MF_B2  =R3_outcome_B2((R3_outcome_B2(:,1)==3|R3_outcome_B2(:,1)==4)&(R3_outcome_B2(:,3)==1|R3_outcome_B2(:,3)==2)&R3_outcome_B2(:,4)==3&R3_outcome_B2(:,5)==1,2);
    onset_outcome_cue2NoGo_R3_RN_MF_B2=R3_outcome_B2((R3_outcome_B2(:,1)==1|R3_outcome_B2(:,1)==2)&(R3_outcome_B2(:,3)==3|R3_outcome_B2(:,3)==4)&R3_outcome_B2(:,4)==3&R3_outcome_B2(:,5)==1,2);
    onset_outcome_cue1NoGo_R3_RN_MF_B2=R3_outcome_B2((R3_outcome_B2(:,1)==3|R3_outcome_B2(:,1)==4)&(R3_outcome_B2(:,3)==3|R3_outcome_B2(:,3)==4)&R3_outcome_B2(:,4)==3&R3_outcome_B2(:,5)==1,2);
    onset_outcome_cue2Go_R3_RN_MF_B2  =R3_outcome_B2((R3_outcome_B2(:,1)==1|R3_outcome_B2(:,1)==2)&(R3_outcome_B2(:,3)==1|R3_outcome_B2(:,3)==2)&R3_outcome_B2(:,4)==3&R3_outcome_B2(:,5)==1,2);

    %RN MB
    onset_outcome_cue1Go_R3_RN_MB_B2  =R3_outcome_B2((R3_outcome_B2(:,1)==3|R3_outcome_B2(:,1)==4)&(R3_outcome_B2(:,3)==1|R3_outcome_B2(:,3)==2)&R3_outcome_B2(:,4)==3&R3_outcome_B2(:,5)==0,2);
    onset_outcome_cue2NoGo_R3_RN_MB_B2=R3_outcome_B2((R3_outcome_B2(:,1)==1|R3_outcome_B2(:,1)==2)&(R3_outcome_B2(:,3)==3|R3_outcome_B2(:,3)==4)&R3_outcome_B2(:,4)==3&R3_outcome_B2(:,5)==0,2);
    onset_outcome_cue1NoGo_R3_RN_MB_B2=R3_outcome_B2((R3_outcome_B2(:,1)==3|R3_outcome_B2(:,1)==4)&(R3_outcome_B2(:,3)==3|R3_outcome_B2(:,3)==4)&R3_outcome_B2(:,4)==3&R3_outcome_B2(:,5)==0,2);
    onset_outcome_cue2Go_R3_RN_MB_B2  =R3_outcome_B2((R3_outcome_B2(:,1)==1|R3_outcome_B2(:,1)==2)&(R3_outcome_B2(:,3)==1|R3_outcome_B2(:,3)==2)&R3_outcome_B2(:,4)==3&R3_outcome_B2(:,5)==0,2);    
    
    %block3
    R3_outcome_B3=R3_outcome(91:135,:);

    %RN MF
    onset_outcome_cue1Go_R3_RN_MF_B3  =R3_outcome_B3((R3_outcome_B3(:,1)==1|R3_outcome_B3(:,1)==2)&(R3_outcome_B3(:,3)==1|R3_outcome_B3(:,3)==2)&R3_outcome_B3(:,4)==3&R3_outcome_B3(:,5)==1,2);
    onset_outcome_cue2NoGo_R3_RN_MF_B3=R3_outcome_B3((R3_outcome_B3(:,1)==3|R3_outcome_B3(:,1)==4)&(R3_outcome_B3(:,3)==3|R3_outcome_B3(:,3)==4)&R3_outcome_B3(:,4)==3&R3_outcome_B3(:,5)==1,2);
    onset_outcome_cue1NoGo_R3_RN_MF_B3=R3_outcome_B3((R3_outcome_B3(:,1)==1|R3_outcome_B3(:,1)==2)&(R3_outcome_B3(:,3)==3|R3_outcome_B3(:,3)==4)&R3_outcome_B3(:,4)==3&R3_outcome_B3(:,5)==1,2);
    onset_outcome_cue2Go_R3_RN_MF_B3  =R3_outcome_B3((R3_outcome_B3(:,1)==3|R3_outcome_B3(:,1)==4)&(R3_outcome_B3(:,3)==1|R3_outcome_B3(:,3)==2)&R3_outcome_B3(:,4)==3&R3_outcome_B3(:,5)==1,2);

    %RN MB
    onset_outcome_cue1Go_R3_RN_MB_B3  =R3_outcome_B3((R3_outcome_B3(:,1)==1|R3_outcome_B3(:,1)==2)&(R3_outcome_B3(:,3)==1|R3_outcome_B3(:,3)==2)&R3_outcome_B3(:,4)==3&R3_outcome_B3(:,5)==0,2);
    onset_outcome_cue2NoGo_R3_RN_MB_B3=R3_outcome_B3((R3_outcome_B3(:,1)==3|R3_outcome_B3(:,1)==4)&(R3_outcome_B3(:,3)==3|R3_outcome_B3(:,3)==4)&R3_outcome_B3(:,4)==3&R3_outcome_B3(:,5)==0,2);
    onset_outcome_cue1NoGo_R3_RN_MB_B3=R3_outcome_B3((R3_outcome_B3(:,1)==1|R3_outcome_B3(:,1)==2)&(R3_outcome_B3(:,3)==3|R3_outcome_B3(:,3)==4)&R3_outcome_B3(:,4)==3&R3_outcome_B3(:,5)==0,2);
    onset_outcome_cue2Go_R3_RN_MB_B3  =R3_outcome_B3((R3_outcome_B3(:,1)==3|R3_outcome_B3(:,1)==4)&(R3_outcome_B3(:,3)==1|R3_outcome_B3(:,3)==2)&R3_outcome_B3(:,4)==3&R3_outcome_B3(:,5)==0,2);
    
   
    %block4    
    R3_outcome_B4=R3_outcome(136:180,:);
    
    %RN MF
    onset_outcome_cue1Go_R3_RN_MF_B4  =R3_outcome_B4((R3_outcome_B4(:,1)==3|R3_outcome_B4(:,1)==4)&(R3_outcome_B4(:,3)==1|R3_outcome_B4(:,3)==2)&R3_outcome_B4(:,4)==3&R3_outcome_B4(:,5)==1,2);
    onset_outcome_cue2NoGo_R3_RN_MF_B4=R3_outcome_B4((R3_outcome_B4(:,1)==1|R3_outcome_B4(:,1)==2)&(R3_outcome_B4(:,3)==3|R3_outcome_B4(:,3)==4)&R3_outcome_B4(:,4)==3&R3_outcome_B4(:,5)==1,2);
    onset_outcome_cue1NoGo_R3_RN_MF_B4=R3_outcome_B4((R3_outcome_B4(:,1)==3|R3_outcome_B4(:,1)==4)&(R3_outcome_B4(:,3)==3|R3_outcome_B4(:,3)==4)&R3_outcome_B4(:,4)==3&R3_outcome_B4(:,5)==1,2);
    onset_outcome_cue2Go_R3_RN_MF_B4  =R3_outcome_B4((R3_outcome_B4(:,1)==1|R3_outcome_B4(:,1)==2)&(R3_outcome_B4(:,3)==1|R3_outcome_B4(:,3)==2)&R3_outcome_B4(:,4)==3&R3_outcome_B4(:,5)==1,2);
    
    %RN MB
    onset_outcome_cue1Go_R3_RN_MB_B4  =R3_outcome_B4((R3_outcome_B4(:,1)==3|R3_outcome_B4(:,1)==4)&(R3_outcome_B4(:,3)==1|R3_outcome_B4(:,3)==2)&R3_outcome_B4(:,4)==3&R3_outcome_B4(:,5)==0,2);
    onset_outcome_cue2NoGo_R3_RN_MB_B4=R3_outcome_B4((R3_outcome_B4(:,1)==1|R3_outcome_B4(:,1)==2)&(R3_outcome_B4(:,3)==3|R3_outcome_B4(:,3)==4)&R3_outcome_B4(:,4)==3&R3_outcome_B4(:,5)==0,2);
    onset_outcome_cue1NoGo_R3_RN_MB_B4=R3_outcome_B4((R3_outcome_B4(:,1)==3|R3_outcome_B4(:,1)==4)&(R3_outcome_B4(:,3)==3|R3_outcome_B4(:,3)==4)&R3_outcome_B4(:,4)==3&R3_outcome_B4(:,5)==0,2);
    onset_outcome_cue2Go_R3_RN_MB_B4  =R3_outcome_B4((R3_outcome_B4(:,1)==1|R3_outcome_B4(:,1)==2)&(R3_outcome_B4(:,3)==1|R3_outcome_B4(:,3)==2)&R3_outcome_B4(:,4)==3&R3_outcome_B4(:,5)==0,2);

    %All
    onset_outcome_cue1Go_R3_RN_MF  =[onset_outcome_cue1Go_R3_RN_MF_B1;  onset_outcome_cue1Go_R3_RN_MF_B2;  onset_outcome_cue1Go_R3_RN_MF_B3;  onset_outcome_cue1Go_R3_RN_MF_B4];
    onset_outcome_cue2NoGo_R3_RN_MF=[onset_outcome_cue2NoGo_R3_RN_MF_B1;onset_outcome_cue2NoGo_R3_RN_MF_B2;onset_outcome_cue2NoGo_R3_RN_MF_B3;onset_outcome_cue2NoGo_R3_RN_MF_B4];
    onset_outcome_cue1NoGo_R3_RN_MF=[onset_outcome_cue1NoGo_R3_RN_MF_B1;onset_outcome_cue1NoGo_R3_RN_MF_B2;onset_outcome_cue1NoGo_R3_RN_MF_B3;onset_outcome_cue1NoGo_R3_RN_MF_B4];
    onset_outcome_cue2Go_R3_RN_MF  =[onset_outcome_cue2Go_R3_RN_MF_B1  ;onset_outcome_cue2Go_R3_RN_MF_B2;  onset_outcome_cue2Go_R3_RN_MF_B3;  onset_outcome_cue2Go_R3_RN_MF_B4];
  
    onset_outcome_cue1Go_R3_RN_MB  =[onset_outcome_cue1Go_R3_RN_MB_B1;  onset_outcome_cue1Go_R3_RN_MB_B2;  onset_outcome_cue1Go_R3_RN_MB_B3;  onset_outcome_cue1Go_R3_RN_MB_B4];
    onset_outcome_cue2NoGo_R3_RN_MB=[onset_outcome_cue2NoGo_R3_RN_MB_B1;onset_outcome_cue2NoGo_R3_RN_MB_B2;onset_outcome_cue2NoGo_R3_RN_MB_B3;onset_outcome_cue2NoGo_R3_RN_MB_B4];
    onset_outcome_cue1NoGo_R3_RN_MB=[onset_outcome_cue1NoGo_R3_RN_MB_B1;onset_outcome_cue1NoGo_R3_RN_MB_B2;onset_outcome_cue1NoGo_R3_RN_MB_B3;onset_outcome_cue1NoGo_R3_RN_MB_B4];
    onset_outcome_cue2Go_R3_RN_MB  =[onset_outcome_cue2Go_R3_RN_MB_B1  ;onset_outcome_cue2Go_R3_RN_MB_B2;  onset_outcome_cue2Go_R3_RN_MB_B3;  onset_outcome_cue2Go_R3_RN_MB_B4];

    %% concatenate three onset to one
    
    %Cue1-Go/Cue1-NoGo/Cue2-NoGo/Cue2_Go
    onset_outcome_cue1Go_RN_MF_all=[onset_outcome_cue1Go_R1_RN_MF;(453*2.2)+onset_outcome_cue1Go_R2_RN_MF;(906*2.2)+onset_outcome_cue1Go_R3_RN_MF];
    onset_outcome_cue2NoGo_RN_MF_all=[onset_outcome_cue2NoGo_R1_RN_MF;(453*2.2)+onset_outcome_cue2NoGo_R2_RN_MF;(906*2.2)+onset_outcome_cue2NoGo_R3_RN_MF];
    onset_outcome_cue1NoGo_RN_MF_all=[onset_outcome_cue1NoGo_R1_RN_MF;(453*2.2)+onset_outcome_cue1NoGo_R2_RN_MF;(906*2.2)+onset_outcome_cue1NoGo_R3_RN_MF];
    onset_outcome_cue2Go_RN_MF_all=[onset_outcome_cue2Go_R1_RN_MF;(453*2.2)+onset_outcome_cue2Go_R2_RN_MF;(906*2.2)+onset_outcome_cue2Go_R3_RN_MF];

    onset_outcome_cue1Go_RN_MB_all=[onset_outcome_cue1Go_R1_RN_MB;(453*2.2)+onset_outcome_cue1Go_R2_RN_MB;(906*2.2)+onset_outcome_cue1Go_R3_RN_MB];
    onset_outcome_cue2NoGo_RN_MB_all=[onset_outcome_cue2NoGo_R1_RN_MB;(453*2.2)+onset_outcome_cue2NoGo_R2_RN_MB;(906*2.2)+onset_outcome_cue2NoGo_R3_RN_MB];
    onset_outcome_cue1NoGo_RN_MB_all=[onset_outcome_cue1NoGo_R1_RN_MB;(453*2.2)+onset_outcome_cue1NoGo_R2_RN_MB;(906*2.2)+onset_outcome_cue1NoGo_R3_RN_MB];
    onset_outcome_cue2Go_RN_MB_all=[onset_outcome_cue2Go_R1_RN_MB;(453*2.2)+onset_outcome_cue2Go_R2_RN_MB;(906*2.2)+onset_outcome_cue2Go_R3_RN_MB];

    
    save([outputDir,'/Onset_outcome_RSA_RN_MFvsMB.mat'],'onset_outcome_cue1Go_R1_RN_MF',   'onset_outcome_cue1Go_R2_RN_MF',   'onset_outcome_cue1Go_R3_RN_MF',   'onset_outcome_cue1Go_RN_MF_all',...
                                                    'onset_outcome_cue2NoGo_R1_RN_MF', 'onset_outcome_cue2NoGo_R2_RN_MF', 'onset_outcome_cue2NoGo_R3_RN_MF', 'onset_outcome_cue2NoGo_RN_MF_all',...
                                                    'onset_outcome_cue1NoGo_R1_RN_MF', 'onset_outcome_cue1NoGo_R2_RN_MF', 'onset_outcome_cue1NoGo_R3_RN_MF', 'onset_outcome_cue1NoGo_RN_MF_all',...
                                                    'onset_outcome_cue2Go_R1_RN_MF',   'onset_outcome_cue2Go_R2_RN_MF',   'onset_outcome_cue2Go_R3_RN_MF',   'onset_outcome_cue2Go_RN_MF_all',...
                                                    'onset_outcome_cue1Go_R1_RN_MB',   'onset_outcome_cue1Go_R2_RN_MB',   'onset_outcome_cue1Go_R3_RN_MB',   'onset_outcome_cue1Go_RN_MB_all',...
                                                    'onset_outcome_cue2NoGo_R1_RN_MB', 'onset_outcome_cue2NoGo_R2_RN_MB', 'onset_outcome_cue2NoGo_R3_RN_MB', 'onset_outcome_cue2NoGo_RN_MB_all',...
                                                    'onset_outcome_cue1NoGo_R1_RN_MB', 'onset_outcome_cue1NoGo_R2_RN_MB', 'onset_outcome_cue1NoGo_R3_RN_MB', 'onset_outcome_cue1NoGo_RN_MB_all',...
                                                    'onset_outcome_cue2Go_R1_RN_MB',   'onset_outcome_cue2Go_R2_RN_MB',   'onset_outcome_cue2Go_R3_RN_MB',   'onset_outcome_cue2Go_RN_MB_all');
    
                                          
end

end
