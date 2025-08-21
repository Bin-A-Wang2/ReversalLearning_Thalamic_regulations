function save_onset_outcome_RN_RSA (RootDir,Subjects,onset_pulse)

% Calculate and save the time onset time-locked to the outcome 
%
% USAGE:
%     save_onset_outcome_correct_wrong_RL_RSA (RootDir,Subjects,onset_pulse)
%
% INPUT:
%      RootDir: the directory including folders of all subjects (Sub01, Sub02,...)
%      Subjects: subject number [1,2,3,...]
%      onset_pulse: the onset of first fmri pulse ( from the logfile of Presentation )
%
% 
%  Edit by Bin Wang 01/04/2022 Bochum
%--------------------------------------------------------------------------

%clear all
%close all

LogDir=['D:\Bochum\DATA\fMRI_RL_GoNoGo\Logfile\'];

for i = 1:length(Subjects)
    j=Subjects(i);
    outputDir=[RootDir,'Results_MD\Participants\','Sub',num2str(j,'%.2d')];
    
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
    
    
    
    all_outcome_onset=[Result.data(:,[3,6,7,8]),Index_all]; %trial type; outcome onset;reponses;stages,index
    

    %% Tactile outcome onset
    
    %R1
    R1_outcome=all_outcome_onset(1:180,:);
    %subtract onset of first pulse
    R1_outcome(:,2)=(R1_outcome(:,2)-onset_pulse(i,1))/1000;
    
    %all and missing
    onset_outcome_RN_R1=R1_outcome(R1_outcome(:,3)~=5&R1_outcome(:,5)==3,2);
    onset_outcome_missing_RN_R1=R1_outcome(R1_outcome(:,3)==5&R1_outcome(:,5)==2,2);

    %correct/wrong    
    onset_outcome_correct_RN_R1=R1_outcome(R1_outcome(:,3)~=5&(R1_outcome(:,3)==1|R1_outcome(:,3)==4)&R1_outcome(:,5)==3,2);
    onset_outcome_wrong_RN_R1=R1_outcome(R1_outcome(:,3)~=5&(R1_outcome(:,3)==2|R1_outcome(:,3)==3)&R1_outcome(:,5)==3,2);
    
    
    %Cue1-Go/Cue1-NoGo/Cue2-NoGo/Cue2_Go
    %block1
    R1_outcome_B1=R1_outcome(1:45,:);

    %RN
    onset_outcome_cue1Go_R1_RN_B1  =R1_outcome_B1((R1_outcome_B1(:,1)==1|R1_outcome_B1(:,1)==2)&(R1_outcome_B1(:,3)==1|R1_outcome_B1(:,3)==2)&R1_outcome_B1(:,5)==3,2);
    onset_outcome_cue2NoGo_R1_RN_B1=R1_outcome_B1((R1_outcome_B1(:,1)==3|R1_outcome_B1(:,1)==4)&(R1_outcome_B1(:,3)==3|R1_outcome_B1(:,3)==4)&R1_outcome_B1(:,5)==3,2);
    onset_outcome_cue1NoGo_R1_RN_B1=R1_outcome_B1((R1_outcome_B1(:,1)==1|R1_outcome_B1(:,1)==2)&(R1_outcome_B1(:,3)==3|R1_outcome_B1(:,3)==4)&R1_outcome_B1(:,5)==3,2);
    onset_outcome_cue2Go_R1_RN_B1  =R1_outcome_B1((R1_outcome_B1(:,1)==3|R1_outcome_B1(:,1)==4)&(R1_outcome_B1(:,3)==1|R1_outcome_B1(:,3)==2)&R1_outcome_B1(:,5)==3,2);

    %block2
    R1_outcome_B2=R1_outcome(46:90,:);

    %RN
    onset_outcome_cue1Go_R1_RN_B2  =R1_outcome_B2((R1_outcome_B2(:,1)==3|R1_outcome_B2(:,1)==4)&(R1_outcome_B2(:,3)==1|R1_outcome_B2(:,3)==2)&R1_outcome_B2(:,5)==3,2);
    onset_outcome_cue2NoGo_R1_RN_B2=R1_outcome_B2((R1_outcome_B2(:,1)==1|R1_outcome_B2(:,1)==2)&(R1_outcome_B2(:,3)==3|R1_outcome_B2(:,3)==4)&R1_outcome_B2(:,5)==3,2);
    onset_outcome_cue1NoGo_R1_RN_B2=R1_outcome_B2((R1_outcome_B2(:,1)==3|R1_outcome_B2(:,1)==4)&(R1_outcome_B2(:,3)==3|R1_outcome_B2(:,3)==4)&R1_outcome_B2(:,5)==3,2);
    onset_outcome_cue2Go_R1_RN_B2  =R1_outcome_B2((R1_outcome_B2(:,1)==1|R1_outcome_B2(:,1)==2)&(R1_outcome_B2(:,3)==1|R1_outcome_B2(:,3)==2)&R1_outcome_B2(:,5)==3,2);
    
    %block3
    R1_outcome_B3=R1_outcome(91:135,:);
    
    %RN
    onset_outcome_cue1Go_R1_RN_B3  =R1_outcome_B3((R1_outcome_B3(:,1)==1|R1_outcome_B3(:,1)==2)&(R1_outcome_B3(:,3)==1|R1_outcome_B3(:,3)==2)&R1_outcome_B3(:,5)==3,2);
    onset_outcome_cue2NoGo_R1_RN_B3=R1_outcome_B3((R1_outcome_B3(:,1)==3|R1_outcome_B3(:,1)==4)&(R1_outcome_B3(:,3)==3|R1_outcome_B3(:,3)==4)&R1_outcome_B3(:,5)==3,2);
    onset_outcome_cue1NoGo_R1_RN_B3=R1_outcome_B3((R1_outcome_B3(:,1)==1|R1_outcome_B3(:,1)==2)&(R1_outcome_B3(:,3)==3|R1_outcome_B3(:,3)==4)&R1_outcome_B3(:,5)==3,2);
    onset_outcome_cue2Go_R1_RN_B3  =R1_outcome_B3((R1_outcome_B3(:,1)==3|R1_outcome_B3(:,1)==4)&(R1_outcome_B3(:,3)==1|R1_outcome_B3(:,3)==2)&R1_outcome_B3(:,5)==3,2);
    
    %block4    
    R1_outcome_B4=R1_outcome(136:180,:);
    
    %RN
    onset_outcome_cue1Go_R1_RN_B4  =R1_outcome_B4((R1_outcome_B4(:,1)==3|R1_outcome_B4(:,1)==4)&(R1_outcome_B4(:,3)==1|R1_outcome_B4(:,3)==2)&R1_outcome_B4(:,5)==3,2);
    onset_outcome_cue2NoGo_R1_RN_B4=R1_outcome_B4((R1_outcome_B4(:,1)==1|R1_outcome_B4(:,1)==2)&(R1_outcome_B4(:,3)==3|R1_outcome_B4(:,3)==4)&R1_outcome_B4(:,5)==3,2);
    onset_outcome_cue1NoGo_R1_RN_B4=R1_outcome_B4((R1_outcome_B4(:,1)==3|R1_outcome_B4(:,1)==4)&(R1_outcome_B4(:,3)==3|R1_outcome_B4(:,3)==4)&R1_outcome_B4(:,5)==3,2);
    onset_outcome_cue2Go_R1_RN_B4  =R1_outcome_B4((R1_outcome_B4(:,1)==1|R1_outcome_B4(:,1)==2)&(R1_outcome_B4(:,3)==1|R1_outcome_B4(:,3)==2)&R1_outcome_B4(:,5)==3,2);
    
    %All
    onset_outcome_cue1Go_R1_RN  =[onset_outcome_cue1Go_R1_RN_B1;  onset_outcome_cue1Go_R1_RN_B2;  onset_outcome_cue1Go_R1_RN_B3;  onset_outcome_cue1Go_R1_RN_B4];
    onset_outcome_cue2NoGo_R1_RN=[onset_outcome_cue2NoGo_R1_RN_B1;onset_outcome_cue2NoGo_R1_RN_B2;onset_outcome_cue2NoGo_R1_RN_B3;onset_outcome_cue2NoGo_R1_RN_B4];
    onset_outcome_cue1NoGo_R1_RN=[onset_outcome_cue1NoGo_R1_RN_B1;onset_outcome_cue1NoGo_R1_RN_B2;onset_outcome_cue1NoGo_R1_RN_B3;onset_outcome_cue1NoGo_R1_RN_B4];
    onset_outcome_cue2Go_R1_RN  =[onset_outcome_cue2Go_R1_RN_B1  ;onset_outcome_cue2Go_R1_RN_B2;  onset_outcome_cue2Go_R1_RN_B3;  onset_outcome_cue2Go_R1_RN_B4];
    
       
    %R2
    R2_outcome=all_outcome_onset(181:360,:);
    %subtract onset of first pulse
    R2_outcome(:,2)=(R2_outcome(:,2)-onset_pulse(i,1))/1000;
    
    %all and missing
    onset_outcome_RN_R2=R2_outcome(R2_outcome(:,3)~=5&R2_outcome(:,5)==3,2);
    onset_outcome_missing_RN_R2=R2_outcome(R2_outcome(:,3)==5&R2_outcome(:,5)==2,2);

    %correct/wrong    
    onset_outcome_correct_RN_R2=R2_outcome(R2_outcome(:,3)~=5&(R2_outcome(:,3)==1|R2_outcome(:,3)==4)&R2_outcome(:,5)==3,2);
    onset_outcome_wrong_RN_R2=R2_outcome(R2_outcome(:,3)~=5&(R2_outcome(:,3)==2|R2_outcome(:,3)==3)&R2_outcome(:,5)==3,2);
    
    
    %Cue1-Go/Cue1-NoGo/Cue2-NoGo/Cue2_Go
    %block1
    R2_outcome_B1=R2_outcome(1:45,:);

    %RN
    onset_outcome_cue1Go_R2_RN_B1  =R2_outcome_B1((R2_outcome_B1(:,1)==1|R2_outcome_B1(:,1)==2)&(R2_outcome_B1(:,3)==1|R2_outcome_B1(:,3)==2)&R2_outcome_B1(:,5)==3,2);
    onset_outcome_cue2NoGo_R2_RN_B1=R2_outcome_B1((R2_outcome_B1(:,1)==3|R2_outcome_B1(:,1)==4)&(R2_outcome_B1(:,3)==3|R2_outcome_B1(:,3)==4)&R2_outcome_B1(:,5)==3,2);
    onset_outcome_cue1NoGo_R2_RN_B1=R2_outcome_B1((R2_outcome_B1(:,1)==1|R2_outcome_B1(:,1)==2)&(R2_outcome_B1(:,3)==3|R2_outcome_B1(:,3)==4)&R2_outcome_B1(:,5)==3,2);
    onset_outcome_cue2Go_R2_RN_B1  =R2_outcome_B1((R2_outcome_B1(:,1)==3|R2_outcome_B1(:,1)==4)&(R2_outcome_B1(:,3)==1|R2_outcome_B1(:,3)==2)&R2_outcome_B1(:,5)==3,2);
    

    %block2
    R2_outcome_B2=R2_outcome(46:90,:);

    %RN
    onset_outcome_cue1Go_R2_RN_B2  =R2_outcome_B2((R2_outcome_B2(:,1)==3|R2_outcome_B2(:,1)==4)&(R2_outcome_B2(:,3)==1|R2_outcome_B2(:,3)==2)&R2_outcome_B2(:,5)==3,2);
    onset_outcome_cue2NoGo_R2_RN_B2=R2_outcome_B2((R2_outcome_B2(:,1)==1|R2_outcome_B2(:,1)==2)&(R2_outcome_B2(:,3)==3|R2_outcome_B2(:,3)==4)&R2_outcome_B2(:,5)==3,2);
    onset_outcome_cue1NoGo_R2_RN_B2=R2_outcome_B2((R2_outcome_B2(:,1)==3|R2_outcome_B2(:,1)==4)&(R2_outcome_B2(:,3)==3|R2_outcome_B2(:,3)==4)&R2_outcome_B2(:,5)==3,2);
    onset_outcome_cue2Go_R2_RN_B2  =R2_outcome_B2((R2_outcome_B2(:,1)==1|R2_outcome_B2(:,1)==2)&(R2_outcome_B2(:,3)==1|R2_outcome_B2(:,3)==2)&R2_outcome_B2(:,5)==3,2);
    
    
    %block3
    R2_outcome_B3=R2_outcome(91:135,:);
    
    %RN
    onset_outcome_cue1Go_R2_RN_B3  =R2_outcome_B3((R2_outcome_B3(:,1)==1|R2_outcome_B3(:,1)==2)&(R2_outcome_B3(:,3)==1|R2_outcome_B3(:,3)==2)&R2_outcome_B3(:,5)==3,2);
    onset_outcome_cue2NoGo_R2_RN_B3=R2_outcome_B3((R2_outcome_B3(:,1)==3|R2_outcome_B3(:,1)==4)&(R2_outcome_B3(:,3)==3|R2_outcome_B3(:,3)==4)&R2_outcome_B3(:,5)==3,2);
    onset_outcome_cue1NoGo_R2_RN_B3=R2_outcome_B3((R2_outcome_B3(:,1)==1|R2_outcome_B3(:,1)==2)&(R2_outcome_B3(:,3)==3|R2_outcome_B3(:,3)==4)&R2_outcome_B3(:,5)==3,2);
    onset_outcome_cue2Go_R2_RN_B3  =R2_outcome_B3((R2_outcome_B3(:,1)==3|R2_outcome_B3(:,1)==4)&(R2_outcome_B3(:,3)==1|R2_outcome_B3(:,3)==2)&R2_outcome_B3(:,5)==3,2);
    
   
    %block4    
    R2_outcome_B4=R2_outcome(136:180,:);
    
    %RN
    onset_outcome_cue1Go_R2_RN_B4  =R2_outcome_B4((R2_outcome_B4(:,1)==3|R2_outcome_B4(:,1)==4)&(R2_outcome_B4(:,3)==1|R2_outcome_B4(:,3)==2)&R2_outcome_B4(:,5)==3,2);
    onset_outcome_cue2NoGo_R2_RN_B4=R2_outcome_B4((R2_outcome_B4(:,1)==1|R2_outcome_B4(:,1)==2)&(R2_outcome_B4(:,3)==3|R2_outcome_B4(:,3)==4)&R2_outcome_B4(:,5)==3,2);
    onset_outcome_cue1NoGo_R2_RN_B4=R2_outcome_B4((R2_outcome_B4(:,1)==3|R2_outcome_B4(:,1)==4)&(R2_outcome_B4(:,3)==3|R2_outcome_B4(:,3)==4)&R2_outcome_B4(:,5)==3,2);
    onset_outcome_cue2Go_R2_RN_B4  =R2_outcome_B4((R2_outcome_B4(:,1)==1|R2_outcome_B4(:,1)==2)&(R2_outcome_B4(:,3)==1|R2_outcome_B4(:,3)==2)&R2_outcome_B4(:,5)==3,2);
    
    
    %All
    onset_outcome_cue1Go_R2_RN  =[onset_outcome_cue1Go_R2_RN_B1;  onset_outcome_cue1Go_R2_RN_B2;  onset_outcome_cue1Go_R2_RN_B3;  onset_outcome_cue1Go_R2_RN_B4];
    onset_outcome_cue2NoGo_R2_RN=[onset_outcome_cue2NoGo_R2_RN_B1;onset_outcome_cue2NoGo_R2_RN_B2;onset_outcome_cue2NoGo_R2_RN_B3;onset_outcome_cue2NoGo_R2_RN_B4];
    onset_outcome_cue1NoGo_R2_RN=[onset_outcome_cue1NoGo_R2_RN_B1;onset_outcome_cue1NoGo_R2_RN_B2;onset_outcome_cue1NoGo_R2_RN_B3;onset_outcome_cue1NoGo_R2_RN_B4];
    onset_outcome_cue2Go_R2_RN  =[onset_outcome_cue2Go_R2_RN_B1  ;onset_outcome_cue2Go_R2_RN_B2;  onset_outcome_cue2Go_R2_RN_B3;  onset_outcome_cue2Go_R2_RN_B4];
    
    
    
    %R3
    R3_outcome=all_outcome_onset(361:540,:);
    %subtract onset of first pulse
    R3_outcome(:,2)=(R3_outcome(:,2)-onset_pulse(i,1))/1000;
    
    %all and missing
    onset_outcome_RN_R3=R3_outcome(R3_outcome(:,3)~=5&R3_outcome(:,5)==3,2);
    onset_outcome_missing_RN_R3=R3_outcome(R3_outcome(:,3)==5&R3_outcome(:,5)==2,2);

    %correct/wrong    
    onset_outcome_correct_RN_R3=R3_outcome(R3_outcome(:,3)~=5&(R3_outcome(:,3)==1|R3_outcome(:,3)==4)&R3_outcome(:,5)==3,2);
    onset_outcome_wrong_RN_R3=R3_outcome(R3_outcome(:,3)~=5&(R3_outcome(:,3)==2|R3_outcome(:,3)==3)&R3_outcome(:,5)==3,2);
    
    
    %Cue1-Go/Cue1-NoGo/Cue2-NoGo/Cue2_Go
    %block1
    R3_outcome_B1=R3_outcome(1:45,:);

    %RN
    onset_outcome_cue1Go_R3_RN_B1  =R3_outcome_B1((R3_outcome_B1(:,1)==1|R3_outcome_B1(:,1)==2)&(R3_outcome_B1(:,3)==1|R3_outcome_B1(:,3)==2)&R3_outcome_B1(:,5)==3,2);
    onset_outcome_cue2NoGo_R3_RN_B1=R3_outcome_B1((R3_outcome_B1(:,1)==3|R3_outcome_B1(:,1)==4)&(R3_outcome_B1(:,3)==3|R3_outcome_B1(:,3)==4)&R3_outcome_B1(:,5)==3,2);
    onset_outcome_cue1NoGo_R3_RN_B1=R3_outcome_B1((R3_outcome_B1(:,1)==1|R3_outcome_B1(:,1)==2)&(R3_outcome_B1(:,3)==3|R3_outcome_B1(:,3)==4)&R3_outcome_B1(:,5)==3,2);
    onset_outcome_cue2Go_R3_RN_B1  =R3_outcome_B1((R3_outcome_B1(:,1)==3|R3_outcome_B1(:,1)==4)&(R3_outcome_B1(:,3)==1|R3_outcome_B1(:,3)==2)&R3_outcome_B1(:,5)==3,2);
    

    %block2
    R3_outcome_B2=R3_outcome(46:90,:);

    %RN
    onset_outcome_cue1Go_R3_RN_B2  =R3_outcome_B2((R3_outcome_B2(:,1)==3|R3_outcome_B2(:,1)==4)&(R3_outcome_B2(:,3)==1|R3_outcome_B2(:,3)==2)&R3_outcome_B2(:,5)==3,2);
    onset_outcome_cue2NoGo_R3_RN_B2=R3_outcome_B2((R3_outcome_B2(:,1)==1|R3_outcome_B2(:,1)==2)&(R3_outcome_B2(:,3)==3|R3_outcome_B2(:,3)==4)&R3_outcome_B2(:,5)==3,2);
    onset_outcome_cue1NoGo_R3_RN_B2=R3_outcome_B2((R3_outcome_B2(:,1)==3|R3_outcome_B2(:,1)==4)&(R3_outcome_B2(:,3)==3|R3_outcome_B2(:,3)==4)&R3_outcome_B2(:,5)==3,2);
    onset_outcome_cue2Go_R3_RN_B2  =R3_outcome_B2((R3_outcome_B2(:,1)==1|R3_outcome_B2(:,1)==2)&(R3_outcome_B2(:,3)==1|R3_outcome_B2(:,3)==2)&R3_outcome_B2(:,5)==3,2);
    
    
    %block3
    R3_outcome_B3=R3_outcome(91:135,:);
    
    %RN
    onset_outcome_cue1Go_R3_RN_B3  =R3_outcome_B3((R3_outcome_B3(:,1)==1|R3_outcome_B3(:,1)==2)&(R3_outcome_B3(:,3)==1|R3_outcome_B3(:,3)==2)&R3_outcome_B3(:,5)==3,2);
    onset_outcome_cue2NoGo_R3_RN_B3=R3_outcome_B3((R3_outcome_B3(:,1)==3|R3_outcome_B3(:,1)==4)&(R3_outcome_B3(:,3)==3|R3_outcome_B3(:,3)==4)&R3_outcome_B3(:,5)==3,2);
    onset_outcome_cue1NoGo_R3_RN_B3=R3_outcome_B3((R3_outcome_B3(:,1)==1|R3_outcome_B3(:,1)==2)&(R3_outcome_B3(:,3)==3|R3_outcome_B3(:,3)==4)&R3_outcome_B3(:,5)==3,2);
    onset_outcome_cue2Go_R3_RN_B3  =R3_outcome_B3((R3_outcome_B3(:,1)==3|R3_outcome_B3(:,1)==4)&(R3_outcome_B3(:,3)==1|R3_outcome_B3(:,3)==2)&R3_outcome_B3(:,5)==3,2);
    
   
    %block4    
    R3_outcome_B4=R3_outcome(136:180,:);
    
    %RN
    onset_outcome_cue1Go_R3_RN_B4  =R3_outcome_B4((R3_outcome_B4(:,1)==3|R3_outcome_B4(:,1)==4)&(R3_outcome_B4(:,3)==1|R3_outcome_B4(:,3)==2)&R3_outcome_B4(:,5)==3,2);
    onset_outcome_cue2NoGo_R3_RN_B4=R3_outcome_B4((R3_outcome_B4(:,1)==1|R3_outcome_B4(:,1)==2)&(R3_outcome_B4(:,3)==3|R3_outcome_B4(:,3)==4)&R3_outcome_B4(:,5)==3,2);
    onset_outcome_cue1NoGo_R3_RN_B4=R3_outcome_B4((R3_outcome_B4(:,1)==3|R3_outcome_B4(:,1)==4)&(R3_outcome_B4(:,3)==3|R3_outcome_B4(:,3)==4)&R3_outcome_B4(:,5)==3,2);
    onset_outcome_cue2Go_R3_RN_B4  =R3_outcome_B4((R3_outcome_B4(:,1)==1|R3_outcome_B4(:,1)==2)&(R3_outcome_B4(:,3)==1|R3_outcome_B4(:,3)==2)&R3_outcome_B4(:,5)==3,2);
    
    
    %All
    onset_outcome_cue1Go_R3_RN  =[onset_outcome_cue1Go_R3_RN_B1;  onset_outcome_cue1Go_R3_RN_B2;  onset_outcome_cue1Go_R3_RN_B3;  onset_outcome_cue1Go_R3_RN_B4];
    onset_outcome_cue2NoGo_R3_RN=[onset_outcome_cue2NoGo_R3_RN_B1;onset_outcome_cue2NoGo_R3_RN_B2;onset_outcome_cue2NoGo_R3_RN_B3;onset_outcome_cue2NoGo_R3_RN_B4];
    onset_outcome_cue1NoGo_R3_RN=[onset_outcome_cue1NoGo_R3_RN_B1;onset_outcome_cue1NoGo_R3_RN_B2;onset_outcome_cue1NoGo_R3_RN_B3;onset_outcome_cue1NoGo_R3_RN_B4];
    onset_outcome_cue2Go_R3_RN  =[onset_outcome_cue2Go_R3_RN_B1  ;onset_outcome_cue2Go_R3_RN_B2;  onset_outcome_cue2Go_R3_RN_B3;  onset_outcome_cue2Go_R3_RN_B4];
  
    
    
    %% concatenate three onset to one
    %all and missing
    onset_outcome_RN_all=[onset_outcome_RN_R1;(453*2.2)+onset_outcome_RN_R2;(906*2.2)+onset_outcome_RN_R3];
    onset_outcome_missing_RN_all=[onset_outcome_missing_RN_R1;(453*2.2)+onset_outcome_missing_RN_R2;(906*2.2)+onset_outcome_missing_RN_R3];
    %correct/wrong
    onset_outcome_correct_RN_all=[onset_outcome_correct_RN_R1;(453*2.2)+onset_outcome_correct_RN_R2;(906*2.2)+onset_outcome_correct_RN_R3];
    onset_outcome_wrong_RN_all=[onset_outcome_wrong_RN_R1;(453*2.2)+onset_outcome_wrong_RN_R2;(906*2.2)+onset_outcome_wrong_RN_R3];
    
    %Cue1-Go/Cue1-NoGo/Cue2-NoGo/Cue2_Go
    onset_outcome_cue1Go_RN_all=[onset_outcome_cue1Go_R1_RN;(453*2.2)+onset_outcome_cue1Go_R2_RN;(906*2.2)+onset_outcome_cue1Go_R3_RN];
    onset_outcome_cue2NoGo_RN_all=[onset_outcome_cue2NoGo_R1_RN;(453*2.2)+onset_outcome_cue2NoGo_R2_RN;(906*2.2)+onset_outcome_cue2NoGo_R3_RN];
    onset_outcome_cue1NoGo_RN_all=[onset_outcome_cue1NoGo_R1_RN;(453*2.2)+onset_outcome_cue1NoGo_R2_RN;(906*2.2)+onset_outcome_cue1NoGo_R3_RN];
    onset_outcome_cue2Go_RN_all=[onset_outcome_cue2Go_R1_RN;(453*2.2)+onset_outcome_cue2Go_R2_RN;(906*2.2)+onset_outcome_cue2Go_R3_RN];
    
    
    
    save([outputDir,'\Onset_outcome_RN.mat'],'onset_outcome_cue1Go_R1_RN',   'onset_outcome_cue1Go_R2_RN',   'onset_outcome_cue1Go_R3_RN',   'onset_outcome_cue1Go_RN_all',...
                                             'onset_outcome_cue2NoGo_R1_RN', 'onset_outcome_cue2NoGo_R2_RN', 'onset_outcome_cue2NoGo_R3_RN', 'onset_outcome_cue2NoGo_RN_all',...
                                             'onset_outcome_cue1NoGo_R1_RN', 'onset_outcome_cue1NoGo_R2_RN', 'onset_outcome_cue1NoGo_R3_RN', 'onset_outcome_cue1NoGo_RN_all',...
                                             'onset_outcome_cue2Go_R1_RN',   'onset_outcome_cue2Go_R2_RN',   'onset_outcome_cue2Go_R3_RN',   'onset_outcome_cue2Go_RN_all',...
                                             'onset_outcome_RN_R1',          'onset_outcome_RN_R2',          'onset_outcome_RN_R3',          'onset_outcome_RN_all',...
                                             'onset_outcome_missing_RN_R1',  'onset_outcome_missing_RN_R2',  'onset_outcome_missing_RN_R3',  'onset_outcome_missing_RN_all',...
                                             'onset_outcome_correct_RN_R1',  'onset_outcome_correct_RN_R2',  'onset_outcome_correct_RN_R3',  'onset_outcome_correct_RN_all',...
                                             'onset_outcome_wrong_RN_R1',    'onset_outcome_wrong_RN_R2',    'onset_outcome_wrong_RN_R3',    'onset_outcome_wrong_RN_all');

end

