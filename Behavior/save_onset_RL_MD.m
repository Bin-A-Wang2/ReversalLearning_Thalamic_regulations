function save_onset_RL_MD (RootDir,Subjects,onset_pulse)

%RootDir=['/Users/binwang/Documents/Bochum/DATA/fMRI_RL_GoNoGo/'];
%Subjects=[2 3 4 5 7 8 11 12 13 14 15 16 17 18 19 20 22 23 26 27 28 29 31 32 33 34 35 36 37 38 39 40]; %% good subjects

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



%% Resposne check (smoothed response and bar)


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
    
    all_cue_onset=[Result.data(:,[4,7]),Index_all];
    all_outcome_onset=[Result.data(:,[6,7]),Index_all];
    
    %% Tactile cue onset
    
    %R1
    R1_cue=all_cue_onset(1:180,:,:);
    %subtract onset of first pulse
    R1_cue(:,1)=(R1_cue(:,1)-onset_pulse(i,1))/1000;

    %LN/LE/RN/RE
    onset_cue_LN_R1=R1_cue(R1_cue(:,2)~=5&R1_cue(:,3)==1,1);
    onset_cue_LE_R1=R1_cue(R1_cue(:,2)~=5&R1_cue(:,3)==2,1);
    onset_cue_RN_R1=R1_cue(R1_cue(:,2)~=5&R1_cue(:,3)==3,1);
    onset_cue_RE_R1=R1_cue(R1_cue(:,2)~=5&R1_cue(:,3)==4,1);
    
    %unsigned    
    onset_cue_unsigned_R1=R1_cue(R1_cue(:,2)~=5&R1_cue(:,3)==0,1);
    
    %correct/wrong   
    onset_cue_correct_R1=R1_cue(R1_cue(:,2)==1|R1_cue(:,2)==4,1);
    onset_cue_wrong_R1=R1_cue(R1_cue(:,2)==2|R1_cue(:,2)==3,1);
    
    %all and missing
    onset_cue_all_R1=R1_cue(R1_cue(:,2)~=5,1);
    onset_cue_missing_R1=R1_cue(R1_cue(:,2)==5,1);


    %R2
    R2_cue=all_cue_onset(181:360,:);
    %subtract onset of first pulse
    R2_cue(:,1)=(R2_cue(:,1)-onset_pulse(i,2))/1000;
    
    %LN/LE/RN/RE
    onset_cue_LN_R2=R2_cue(R2_cue(:,2)~=5&R2_cue(:,3)==1,1);
    onset_cue_LE_R2=R2_cue(R2_cue(:,2)~=5&R2_cue(:,3)==2,1);
    onset_cue_RN_R2=R2_cue(R2_cue(:,2)~=5&R2_cue(:,3)==3,1);
    onset_cue_RE_R2=R2_cue(R2_cue(:,2)~=5&R2_cue(:,3)==4,1);
    
    %unsigned    
    onset_cue_unsigned_R2=R2_cue(R2_cue(:,2)~=5&R2_cue(:,3)==0,1);
    
    %correct/wrong    
    onset_cue_correct_R2=R2_cue(R2_cue(:,2)==1|R2_cue(:,2)==4,1);
    onset_cue_wrong_R2=R2_cue(R2_cue(:,2)==2|R2_cue(:,2)==3,1);
        
    %all and missing
    onset_cue_all_R2=R2_cue(R2_cue(:,2)~=5,1);
    onset_cue_missing_R2=R2_cue(R2_cue(:,2)==5,1);

    
    %R3
    R3_cue=all_cue_onset(361:540,:);
    %subtract onset of first pulse
    R3_cue(:,1)=(R3_cue(:,1)-onset_pulse(i,3))/1000;
    
    %LN/LE/RN/RE
    onset_cue_LN_R3=R3_cue(R3_cue(:,2)~=5&R3_cue(:,3)==1,1);
    onset_cue_LE_R3=R3_cue(R3_cue(:,2)~=5&R3_cue(:,3)==2,1);
    onset_cue_RN_R3=R3_cue(R3_cue(:,2)~=5&R3_cue(:,3)==3,1);
    onset_cue_RE_R3=R3_cue(R3_cue(:,2)~=5&R3_cue(:,3)==4,1);
    
    %unsigned    
    onset_cue_unsigned_R3=R3_cue(R3_cue(:,2)~=5&R3_cue(:,3)==0,1);
    
    %correct/wrong    
    onset_cue_correct_R3=R3_cue(R3_cue(:,2)==1|R3_cue(:,2)==4,1);
    onset_cue_wrong_R3=R3_cue(R3_cue(:,2)==2|R3_cue(:,2)==3,1);
    
    %all and missing
    onset_cue_all_R3=R3_cue(R3_cue(:,2)~=5,1);
    onset_cue_missing_R3=R3_cue(R3_cue(:,2)==5,1);

    %concatenate three onset to one
    %LN/LE/RN/RE
    onset_cue_LN_all=[onset_cue_LN_R1;(453*2.2)+onset_cue_LN_R2;(906*2.2)+onset_cue_LN_R3];
    onset_cue_LE_all=[onset_cue_LE_R1;(453*2.2)+onset_cue_LE_R2;(906*2.2)+onset_cue_LE_R3];
    onset_cue_RN_all=[onset_cue_RN_R1;(453*2.2)+onset_cue_RN_R2;(906*2.2)+onset_cue_RN_R3];
    onset_cue_RE_all=[onset_cue_RE_R1;(453*2.2)+onset_cue_RE_R2;(906*2.2)+onset_cue_RE_R3];
    
    %unsigned
    onset_cue_unsigned_all=[onset_cue_unsigned_R1;(453*2.2)+onset_cue_unsigned_R2;(906*2.2)+onset_cue_unsigned_R3];
    
    %correct and wrong
    onset_cue_correct_all=[onset_cue_correct_R1;(453*2.2)+onset_cue_correct_R2;(906*2.2)+onset_cue_correct_R3];
    onset_cue_wrong_all=[onset_cue_wrong_R1;(453*2.2)+onset_cue_wrong_R2;(906*2.2)+onset_cue_wrong_R3]; 
    
     
    %all and missing
    onset_cue_all=[onset_cue_all_R1;(453*2.2)+onset_cue_all_R2;(906*2.2)+onset_cue_all_R3];
    onset_cue_missing_all=[onset_cue_missing_R1;(453*2.2)+onset_cue_missing_R2;(906*2.2)+onset_cue_missing_R3];
    
    
    save([outputDir,'/Onset_cue_all.mat'],'onset_cue_LN_R1', 'onset_cue_LN_R2', 'onset_cue_LN_R3', 'onset_cue_LN_all',...
                                          'onset_cue_LE_R1', 'onset_cue_LE_R2', 'onset_cue_LE_R3', 'onset_cue_LE_all',...
                                          'onset_cue_RN_R1', 'onset_cue_RN_R2', 'onset_cue_RN_R3', 'onset_cue_RN_all',...
                                          'onset_cue_RE_R1', 'onset_cue_RE_R2', 'onset_cue_RE_R3', 'onset_cue_RE_all',...
                                          'onset_cue_unsigned_R1','onset_cue_unsigned_R2','onset_cue_unsigned_R3','onset_cue_unsigned_all',...
                                          'onset_cue_correct_R1','onset_cue_correct_R2','onset_cue_correct_R3','onset_cue_correct_all',...
                                          'onset_cue_wrong_R1','onset_cue_wrong_R2','onset_cue_wrong_R3','onset_cue_wrong_all',...
                                          'onset_cue_all_R1',     'onset_cue_all_R2',     'onset_cue_all_R3',     'onset_cue_all',...
                                          'onset_cue_missing_R1', 'onset_cue_missing_R2', 'onset_cue_missing_R3', 'onset_cue_missing_all');
    
   
    %% outcome onset
    
    %R1
    R1_outcome=all_outcome_onset(1:180,:,:);
    %subtract onset of first pulse
    R1_outcome(:,1)=(R1_outcome(:,1)-onset_pulse(i,1))/1000;

    
    %LN/LE/RN/RE
    onset_outcome_LN_R1=R1_outcome(R1_outcome(:,2)~=5&R1_outcome(:,3)==1,1);%LN
    onset_outcome_LE_R1=R1_outcome(R1_outcome(:,2)~=5&R1_outcome(:,3)==2,1);%LE
    onset_outcome_RN_R1=R1_outcome(R1_outcome(:,2)~=5&R1_outcome(:,3)==3,1);%RN
    onset_outcome_RE_R1=R1_outcome(R1_outcome(:,2)~=5&R1_outcome(:,3)==4,1);%RE
    
    %unsigned
    onset_outcome_unsigned_R1=R1_outcome(R1_outcome(:,2)~=5&R1_outcome(:,3)==0,1);%unsigned
    
    %correct/wrong
    onset_outcome_correct_R1=R1_outcome(R1_outcome(:,2)==1|R1_outcome(:,2)==4,1);%correct
    onset_outcome_wrong_R1=R1_outcome(R1_outcome(:,2)==2|R1_outcome(:,2)==3,1);%wrong
    
    %HIT/FA/MISS/CR
    onset_outcome_HIT_LN_R1=R1_outcome(R1_outcome(:,2)==1&R1_outcome(:,3)==1,1); %Hit in LN
    onset_outcome_HIT_LE_R1=R1_outcome(R1_outcome(:,2)==1&R1_outcome(:,3)==2,1); %Hit in LE
    onset_outcome_HIT_RN_R1=R1_outcome(R1_outcome(:,2)==1&R1_outcome(:,3)==3,1); %Hit in RN
    onset_outcome_HIT_RE_R1=R1_outcome(R1_outcome(:,2)==1&R1_outcome(:,3)==4,1); %Hit in RE
    
    onset_outcome_FA_LN_R1=R1_outcome(R1_outcome(:,2)==2&R1_outcome(:,3)==1,1); %FA in LN
    onset_outcome_FA_LE_R1=R1_outcome(R1_outcome(:,2)==2&R1_outcome(:,3)==2,1); %FA in LE
    onset_outcome_FA_RN_R1=R1_outcome(R1_outcome(:,2)==2&R1_outcome(:,3)==3,1); %FA in RN
    onset_outcome_FA_RE_R1=R1_outcome(R1_outcome(:,2)==2&R1_outcome(:,3)==4,1); %FA in RE
    
    onset_outcome_MISS_LN_R1=R1_outcome(R1_outcome(:,2)==3&R1_outcome(:,3)==1,1); %MISS in LN
    onset_outcome_MISS_LE_R1=R1_outcome(R1_outcome(:,2)==3&R1_outcome(:,3)==2,1); %MISS in LE
    onset_outcome_MISS_RN_R1=R1_outcome(R1_outcome(:,2)==3&R1_outcome(:,3)==3,1); %MISS in RN
    onset_outcome_MISS_RE_R1=R1_outcome(R1_outcome(:,2)==3&R1_outcome(:,3)==4,1); %MISS in RE
    
    onset_outcome_CR_LN_R1=R1_outcome(R1_outcome(:,2)==4&R1_outcome(:,3)==1,1); %CR in LN
    onset_outcome_CR_LE_R1=R1_outcome(R1_outcome(:,2)==4&R1_outcome(:,3)==2,1); %CR in LE
    onset_outcome_CR_RN_R1=R1_outcome(R1_outcome(:,2)==4&R1_outcome(:,3)==3,1); %CR in RN
    onset_outcome_CR_RE_R1=R1_outcome(R1_outcome(:,2)==4&R1_outcome(:,3)==4,1); %CR in RE
    
    %all and missing
    onset_outcome_all_R1=R1_outcome(R1_outcome(:,2)~=5,1);
    onset_outcome_missing_R1=R1_outcome(R1_outcome(:,2)==5,1);

    %R2
    R2_outcome=all_outcome_onset(181:360,:);
    %subtract onset of first pulse
    R2_outcome(:,1)=(R2_outcome(:,1)-onset_pulse(i,2))/1000;
    
    %LN/LE/RN/RE
    onset_outcome_LN_R2=R2_outcome(R2_outcome(:,2)~=5&R2_outcome(:,3)==1,1);%LN
    onset_outcome_LE_R2=R2_outcome(R2_outcome(:,2)~=5&R2_outcome(:,3)==2,1);%LE
    onset_outcome_RN_R2=R2_outcome(R2_outcome(:,2)~=5&R2_outcome(:,3)==3,1);%RN
    onset_outcome_RE_R2=R2_outcome(R2_outcome(:,2)~=5&R2_outcome(:,3)==4,1);%RE
    
    %unsigned
    onset_outcome_unsigned_R2=R2_outcome(R2_outcome(:,2)~=5&R2_outcome(:,3)==0,1);%unsigned
    
    %correct/wrong
    onset_outcome_correct_R2=R2_outcome(R2_outcome(:,2)==1|R2_outcome(:,2)==4,1);%correct
    onset_outcome_wrong_R2=R2_outcome(R2_outcome(:,2)==2|R2_outcome(:,2)==3,1);%wrong
    
    %HIT/FA/MISS/CR
    onset_outcome_HIT_LN_R2=R2_outcome(R2_outcome(:,2)==1&R2_outcome(:,3)==1,1); %Hit in LN
    onset_outcome_HIT_LE_R2=R2_outcome(R2_outcome(:,2)==1&R2_outcome(:,3)==2,1); %Hit in LE
    onset_outcome_HIT_RN_R2=R2_outcome(R2_outcome(:,2)==1&R2_outcome(:,3)==3,1); %Hit in RN
    onset_outcome_HIT_RE_R2=R2_outcome(R2_outcome(:,2)==1&R2_outcome(:,3)==4,1); %Hit in RE
    
    onset_outcome_FA_LN_R2=R2_outcome(R2_outcome(:,2)==2&R2_outcome(:,3)==1,1); %FA in LN
    onset_outcome_FA_LE_R2=R2_outcome(R2_outcome(:,2)==2&R2_outcome(:,3)==2,1); %FA in LE
    onset_outcome_FA_RN_R2=R2_outcome(R2_outcome(:,2)==2&R2_outcome(:,3)==3,1); %FA in RN
    onset_outcome_FA_RE_R2=R2_outcome(R2_outcome(:,2)==2&R2_outcome(:,3)==4,1); %FA in RE
    
    onset_outcome_MISS_LN_R2=R2_outcome(R2_outcome(:,2)==3&R2_outcome(:,3)==1,1); %MISS in LN
    onset_outcome_MISS_LE_R2=R2_outcome(R2_outcome(:,2)==3&R2_outcome(:,3)==2,1); %MISS in LE
    onset_outcome_MISS_RN_R2=R2_outcome(R2_outcome(:,2)==3&R2_outcome(:,3)==3,1); %MISS in RN
    onset_outcome_MISS_RE_R2=R2_outcome(R2_outcome(:,2)==3&R2_outcome(:,3)==4,1); %MISS in RE
    
    onset_outcome_CR_LN_R2=R2_outcome(R2_outcome(:,2)==4&R2_outcome(:,3)==1,1); %CR in LN
    onset_outcome_CR_LE_R2=R2_outcome(R2_outcome(:,2)==4&R2_outcome(:,3)==2,1); %CR in LE
    onset_outcome_CR_RN_R2=R2_outcome(R2_outcome(:,2)==4&R2_outcome(:,3)==3,1); %CR in RN
    onset_outcome_CR_RE_R2=R2_outcome(R2_outcome(:,2)==4&R2_outcome(:,3)==4,1); %CR in RE
    
    %all and missing
    onset_outcome_all_R2=R2_outcome(R2_outcome(:,2)~=5,1);
    onset_outcome_missing_R2=R2_outcome(R2_outcome(:,2)==5,1);

    %R3
    R3_outcome=all_outcome_onset(361:540,:);
    %subtract onset of first pulse
    R3_outcome(:,1)=(R3_outcome(:,1)-onset_pulse(i,3))/1000;
    
    
    %LN/LE/RN/RE
    onset_outcome_LN_R3=R3_outcome(R3_outcome(:,2)~=5&R3_outcome(:,3)==1,1);%LN
    onset_outcome_LE_R3=R3_outcome(R3_outcome(:,2)~=5&R3_outcome(:,3)==2,1);%LE
    onset_outcome_RN_R3=R3_outcome(R3_outcome(:,2)~=5&R3_outcome(:,3)==3,1);%RN
    onset_outcome_RE_R3=R3_outcome(R3_outcome(:,2)~=5&R3_outcome(:,3)==4,1);%RE
    
    %unsigned
    onset_outcome_unsigned_R3=R3_outcome(R3_outcome(:,2)~=5&R3_outcome(:,3)==0,1);%unsigned
    
    %correct/wrong
    onset_outcome_correct_R3=R3_outcome(R3_outcome(:,2)==1|R3_outcome(:,2)==4,1);%correct
    onset_outcome_wrong_R3=R3_outcome(R3_outcome(:,2)==2|R3_outcome(:,2)==3,1);%wrong
    
    %HIT/FA/MISS/CR   
    onset_outcome_HIT_LN_R3=R3_outcome(R3_outcome(:,2)==1&R3_outcome(:,3)==1,1); %Hit in LN
    onset_outcome_HIT_LE_R3=R3_outcome(R3_outcome(:,2)==1&R3_outcome(:,3)==2,1); %Hit in LE
    onset_outcome_HIT_RN_R3=R3_outcome(R3_outcome(:,2)==1&R3_outcome(:,3)==3,1); %Hit in RN
    onset_outcome_HIT_RE_R3=R3_outcome(R3_outcome(:,2)==1&R3_outcome(:,3)==4,1); %Hit in RE
    
    onset_outcome_FA_LN_R3=R3_outcome(R3_outcome(:,2)==2&R3_outcome(:,3)==1,1); %FA in LN
    onset_outcome_FA_LE_R3=R3_outcome(R3_outcome(:,2)==2&R3_outcome(:,3)==2,1); %FA in LE
    onset_outcome_FA_RN_R3=R3_outcome(R3_outcome(:,2)==2&R3_outcome(:,3)==3,1); %FA in RN
    onset_outcome_FA_RE_R3=R3_outcome(R3_outcome(:,2)==2&R3_outcome(:,3)==4,1); %FA in RE
    
    onset_outcome_MISS_LN_R3=R3_outcome(R3_outcome(:,2)==3&R3_outcome(:,3)==1,1); %MISS in LN
    onset_outcome_MISS_LE_R3=R3_outcome(R3_outcome(:,2)==3&R3_outcome(:,3)==2,1); %MISS in LE
    onset_outcome_MISS_RN_R3=R3_outcome(R3_outcome(:,2)==3&R3_outcome(:,3)==3,1); %MISS in RN
    onset_outcome_MISS_RE_R3=R3_outcome(R3_outcome(:,2)==3&R3_outcome(:,3)==4,1); %MISS in RE
    
    onset_outcome_CR_LN_R3=R3_outcome(R3_outcome(:,2)==4&R3_outcome(:,3)==1,1); %CR in LN
    onset_outcome_CR_LE_R3=R3_outcome(R3_outcome(:,2)==4&R3_outcome(:,3)==2,1); %CR in LE
    onset_outcome_CR_RN_R3=R3_outcome(R3_outcome(:,2)==4&R3_outcome(:,3)==3,1); %CR in RN
    onset_outcome_CR_RE_R3=R3_outcome(R3_outcome(:,2)==4&R3_outcome(:,3)==4,1); %CR in RE
    
    %all and missing
    onset_outcome_all_R3=R3_outcome(R3_outcome(:,2)~=5,1);
    onset_outcome_missing_R3=R3_outcome(R3_outcome(:,2)==5,1);

    %concatenate three onset to one
    
    onset_outcome_LN_all=[onset_outcome_LN_R1;(453*2.2)+onset_outcome_LN_R2;(906*2.2)+onset_outcome_LN_R3];
    onset_outcome_LE_all=[onset_outcome_LE_R1;(453*2.2)+onset_outcome_LE_R2;(906*2.2)+onset_outcome_LE_R3];
    onset_outcome_RN_all=[onset_outcome_RN_R1;(453*2.2)+onset_outcome_RN_R2;(906*2.2)+onset_outcome_RN_R3];
    onset_outcome_RE_all=[onset_outcome_RE_R1;(453*2.2)+onset_outcome_RE_R2;(906*2.2)+onset_outcome_RE_R3];
    
    onset_outcome_unsigned_all=[onset_outcome_unsigned_R1;(453*2.2)+onset_outcome_unsigned_R2;(906*2.2)+onset_outcome_unsigned_R3];
    
    onset_outcome_correct_all=[onset_outcome_correct_R1;(453*2.2)+onset_outcome_correct_R2;(906*2.2)+onset_outcome_correct_R3];
    onset_outcome_wrong_all=[onset_outcome_wrong_R1;(453*2.2)+onset_outcome_wrong_R2;(906*2.2)+onset_outcome_wrong_R3];
    
    onset_outcome_HIT_LN_all=[onset_outcome_HIT_LN_R1;(453*2.2)+onset_outcome_HIT_LN_R2;(906*2.2)+onset_outcome_HIT_LN_R3];
    onset_outcome_HIT_LE_all=[onset_outcome_HIT_LE_R1;(453*2.2)+onset_outcome_HIT_LE_R2;(906*2.2)+onset_outcome_HIT_LE_R3];
    onset_outcome_HIT_RN_all=[onset_outcome_HIT_RN_R1;(453*2.2)+onset_outcome_HIT_RN_R2;(906*2.2)+onset_outcome_HIT_RN_R3];
    onset_outcome_HIT_RE_all=[onset_outcome_HIT_RE_R1;(453*2.2)+onset_outcome_HIT_RE_R2;(906*2.2)+onset_outcome_HIT_RE_R3];
    
    onset_outcome_FA_LN_all=[onset_outcome_FA_LN_R1;(453*2.2)+onset_outcome_FA_LN_R2;(906*2.2)+onset_outcome_FA_LN_R3];
    onset_outcome_FA_LE_all=[onset_outcome_FA_LE_R1;(453*2.2)+onset_outcome_FA_LE_R2;(906*2.2)+onset_outcome_FA_LE_R3];
    onset_outcome_FA_RN_all=[onset_outcome_FA_RN_R1;(453*2.2)+onset_outcome_FA_RN_R2;(906*2.2)+onset_outcome_FA_RN_R3];
    onset_outcome_FA_RE_all=[onset_outcome_FA_RE_R1;(453*2.2)+onset_outcome_FA_RE_R2;(906*2.2)+onset_outcome_FA_RE_R3];
    
    onset_outcome_MISS_LN_all=[onset_outcome_MISS_LN_R1;(453*2.2)+onset_outcome_MISS_LN_R2;(906*2.2)+onset_outcome_MISS_LN_R3];
    onset_outcome_MISS_LE_all=[onset_outcome_MISS_LE_R1;(453*2.2)+onset_outcome_MISS_LE_R2;(906*2.2)+onset_outcome_MISS_LE_R3];
    onset_outcome_MISS_RN_all=[onset_outcome_MISS_RN_R1;(453*2.2)+onset_outcome_MISS_RN_R2;(906*2.2)+onset_outcome_MISS_RN_R3];
    onset_outcome_MISS_RE_all=[onset_outcome_MISS_RE_R1;(453*2.2)+onset_outcome_MISS_RE_R2;(906*2.2)+onset_outcome_MISS_RE_R3];
    
    onset_outcome_CR_LN_all=[onset_outcome_CR_LN_R1;(453*2.2)+onset_outcome_CR_LN_R2;(906*2.2)+onset_outcome_CR_LN_R3];
    onset_outcome_CR_LE_all=[onset_outcome_CR_LE_R1;(453*2.2)+onset_outcome_CR_LE_R2;(906*2.2)+onset_outcome_CR_LE_R3];
    onset_outcome_CR_RN_all=[onset_outcome_CR_RN_R1;(453*2.2)+onset_outcome_CR_RN_R2;(906*2.2)+onset_outcome_CR_RN_R3];
    onset_outcome_CR_RE_all=[onset_outcome_CR_RE_R1;(453*2.2)+onset_outcome_CR_RE_R2;(906*2.2)+onset_outcome_CR_RE_R3];
    
    onset_outcome_all=[onset_outcome_all_R1;(453*2.2)+onset_outcome_all_R2;(906*2.2)+onset_outcome_all_R3];
    onset_outcome_missing_all=[onset_outcome_missing_R1;(453*2.2)+onset_outcome_missing_R2;(906*2.2)+onset_outcome_missing_R3];
    
    
    save([outputDir,'/Onset_outcome_all.mat'],'onset_outcome_LN_R1',      'onset_outcome_LN_R2',      'onset_outcome_LN_R3',      'onset_outcome_LN_all',...
                                              'onset_outcome_LE_R1',      'onset_outcome_LE_R2',      'onset_outcome_LE_R3',      'onset_outcome_LE_all',...
                                              'onset_outcome_RN_R1',      'onset_outcome_RN_R2',      'onset_outcome_RN_R3',      'onset_outcome_RN_all',...
                                              'onset_outcome_RE_R1',      'onset_outcome_RE_R2',      'onset_outcome_RE_R3',      'onset_outcome_RE_all',...
                                              'onset_outcome_unsigned_R1','onset_outcome_unsigned_R2','onset_outcome_unsigned_R3','onset_outcome_unsigned_all',...
                                              'onset_outcome_correct_R1', 'onset_outcome_correct_R2', 'onset_outcome_correct_R3', 'onset_outcome_correct_all',...
                                              'onset_outcome_wrong_R1',   'onset_outcome_wrong_R2',   'onset_outcome_wrong_R3',   'onset_outcome_wrong_all',...
                                              'onset_outcome_HIT_LN_R1',  'onset_outcome_HIT_LN_R2',  'onset_outcome_HIT_LN_R3',  'onset_outcome_HIT_LN_all',...
                                              'onset_outcome_HIT_LE_R1',  'onset_outcome_HIT_LE_R2',  'onset_outcome_HIT_LE_R3',  'onset_outcome_HIT_LE_all',...
                                              'onset_outcome_HIT_RN_R1',  'onset_outcome_HIT_RN_R2',  'onset_outcome_HIT_RN_R3',  'onset_outcome_HIT_RN_all',...
                                              'onset_outcome_HIT_RE_R1',  'onset_outcome_HIT_RE_R2',  'onset_outcome_HIT_RE_R3',  'onset_outcome_HIT_RE_all',...
                                              'onset_outcome_FA_LN_R1',   'onset_outcome_FA_LN_R2',   'onset_outcome_FA_LN_R3',   'onset_outcome_FA_LN_all',...
                                              'onset_outcome_FA_LE_R1',   'onset_outcome_FA_LE_R2',   'onset_outcome_FA_LE_R3',   'onset_outcome_FA_LE_all',...
                                              'onset_outcome_FA_RN_R1',   'onset_outcome_FA_RN_R2',   'onset_outcome_FA_RN_R3',   'onset_outcome_FA_RN_all',...
                                              'onset_outcome_FA_RE_R1',   'onset_outcome_FA_RE_R2',   'onset_outcome_FA_RE_R3',   'onset_outcome_FA_RE_all',...
                                              'onset_outcome_MISS_LN_R1', 'onset_outcome_MISS_LN_R2', 'onset_outcome_MISS_LN_R3', 'onset_outcome_MISS_LN_all',...
                                              'onset_outcome_MISS_LE_R1', 'onset_outcome_MISS_LE_R2', 'onset_outcome_MISS_LE_R3', 'onset_outcome_MISS_LE_all',...
                                              'onset_outcome_MISS_RN_R1', 'onset_outcome_MISS_RN_R2', 'onset_outcome_MISS_RN_R3', 'onset_outcome_MISS_RN_all',...
                                              'onset_outcome_MISS_RE_R1', 'onset_outcome_MISS_RE_R2', 'onset_outcome_MISS_RE_R3', 'onset_outcome_MISS_RE_all',...
                                              'onset_outcome_CR_LN_R1',   'onset_outcome_CR_LN_R2',   'onset_outcome_CR_LN_R3',   'onset_outcome_CR_LN_all',...
                                              'onset_outcome_CR_LE_R1',   'onset_outcome_CR_LE_R2',   'onset_outcome_CR_LE_R3',   'onset_outcome_CR_LE_all',...
                                              'onset_outcome_CR_RN_R1',   'onset_outcome_CR_RN_R2',   'onset_outcome_CR_RN_R3',   'onset_outcome_CR_RN_all',...
                                              'onset_outcome_CR_RE_R1',   'onset_outcome_CR_RE_R2',   'onset_outcome_CR_RE_R3',   'onset_outcome_CR_RE_all',...
                                              'onset_outcome_all_R1',     'onset_outcome_all_R2',     'onset_outcome_all_R3',     'onset_outcome_all',...
                                              'onset_outcome_missing_R1', 'onset_outcome_missing_R2', 'onset_outcome_missing_R3', 'onset_outcome_missing_all');   
    

                                          
                                          
end
end
