

LogDir=['/Users/binwang/Documents/Bochum/DATA/fMRI_RL_GoNoGo/Logfile/'];

Subjects=[2 3 4 5 7 8 11 12 13 14 15 16 17 18 19 20 22 23 26 27 28 29 31 32 33 34 35 36 37 38 39 40]; %% good subjects


for i = 1:length(Subjects)
    sID=Subjects(i);
    Result=importdata([LogDir,'Sub' num2str(sID,'%.2d') '_RL_Go_NoGo_results_all.txt']);

    Results_all=Result.data(:,[3,5,7,8]);% trial type; Go/No-Go;correct/wrong; non-reveral/reversal
   
    %%1: cue1/Go; 2: cue1/NoGo; 3: cue2/NoGo; 4: cue2/Go.


    %RUN1
    %% block1
    %ac: correct strategy = 1:cue1/Go  &  3:cue2/NoGo
    for j=1:22
        block01_ac(j)= (Results_all(j,1)==1&Results_all(j,2)~=0)|(Results_all(j,1)==3&Results_all(j,2)==0&Results_all(j,3)~=5)...
                       |(Results_all(j,1)==2&Results_all(j,2)~=0|(Results_all(j,1)==4&Results_all(j,2)==0&Results_all(j,3)~=5)) ;
    end
    %re: correct strategy = 2:cue1/NoGo  &  4:cue2/Go
    for j=1:23
        block01_re(j)= (Results_all(22+j,1)==2&Results_all(22+j,2)==0&Results_all(22+j,3)~=5)|(Results_all(22+j,1)==4&Results_all(22+j,2)~=0)...
                       |(Results_all(22+j,1)==1&Results_all(22+j,2)==0&Results_all(22+j,3)~=5)|(Results_all(22+j,1)==3&Results_all(22+j,2)~=0) ;     
    end

    %% block2
    %ac: correct strategy = 2:cue1/NoGo  &  4:cue2/Go
    for j=1:24
        block02_ac(j)= (Results_all(45+j,1)==2&Results_all(45+j,2)==0&Results_all(45+j,3)~=5)|(Results_all(45+j,1)==4&Results_all(45+j,2)~=0)...
                       |(Results_all(45+j,1)==1&Results_all(45+j,2)==0&Results_all(45+j,3)~=5)|(Results_all(45+j,1)==3&Results_all(45+j,2)~=0) ;     
    end
    %re: correct strategy = 1:cue1/Go  &  3:cue2/NoGo
    for j=1:21
        block02_re(j)= (Results_all(69+j,1)==1&Results_all(69+j,2)~=0)|(Results_all(69+j,1)==3&Results_all(69+j,2)==0&Results_all(69+j,3)~=5)...
                       |(Results_all(69+j,1)==2&Results_all(69+j,2)~=0|(Results_all(69+j,1)==4&Results_all(69+j,2)==0&Results_all(69+j,3)~=5)) ;
    end

    %% block3
    %ac: correct strategy = 1:cue1/Go  &  3:cue2/NoGo
    for j=1:21
        block03_ac(j)=(Results_all(90+j,1)==1&Results_all(90+j,2)~=0)|(Results_all(90+j,1)==3&Results_all(90+j,2)==0&Results_all(90+j,3)~=5)...
                       |(Results_all(90+j,1)==2&Results_all(90+j,2)~=0|(Results_all(90+j,1)==4&Results_all(90+j,2)==0&Results_all(90+j,3)~=5)) ;
    end
    %re: correct strategy = 2:cue1/NoGo  &  4:cue2/Go
    for j=1:24
        block03_re(j)=(Results_all(111+j,1)==2&Results_all(111+j,2)==0&Results_all(111+j,3)~=5)|(Results_all(111+j,1)==4&Results_all(111+j,2)~=0)...
                       |(Results_all(111+j,1)==1&Results_all(111+j,2)==0&Results_all(111+j,3)~=5)|(Results_all(111+j,1)==3&Results_all(111+j,2)~=0) ;     
    end
    
    %% block4
    %ac: correct strategy = 2:cue1/NoGo  &  4:cue2/Go
    for j=1:23
        block04_ac(j)=(Results_all(135+j,1)==2&Results_all(135+j,2)==0&Results_all(135+j,3)~=5)|(Results_all(135+j,1)==4&Results_all(135+j,2)~=0)...
                       |(Results_all(135+j,1)==1&Results_all(135+j,2)==0&Results_all(135+j,3)~=5)|(Results_all(135+j,1)==3&Results_all(135+j,2)~=0) ;     
    end
     %re: correct strategy = 1:cue1/Go  &  3:cue2/NoGo
    for j=1:22
        block04_re(j)=(Results_all(158+j,1)==1&Results_all(158+j,2)~=0)|(Results_all(158+j,1)==3&Results_all(158+j,2)==0&Results_all(158+j,3)~=5)...
                       |(Results_all(158+j,1)==2&Results_all(158+j,2)~=0|(Results_all(158+j,1)==4&Results_all(158+j,2)==0&Results_all(158+j,3)~=5)) ;
    end
    
    %% RUN2
    %block1
    %ac: correct strategy = 1:cue1/Go  &  3:cue2/NoGo
    for j=1:25
        block05_ac(j)=(Results_all(180+j,1)==1&Results_all(180+j,2)~=0)|(Results_all(180+j,1)==3&Results_all(180+j,2)==0&Results_all(180+j,3)~=5)...
                       |(Results_all(180+j,1)==2&Results_all(180+j,2)~=0|(Results_all(180+j,1)==4&Results_all(180+j,2)==0&Results_all(180+j,3)~=5)) ;
    end
    %re: correct strategy = 2:cue1/NoGo  &  4:cue2/Go
    for j=1:20
        block05_re(j)=(Results_all(205+j,1)==2&Results_all(205+j,2)==0&Results_all(205+j,3)~=5)|(Results_all(205+j,1)==4&Results_all(205+j,2)~=0)...
                       |(Results_all(205+j,1)==1&Results_all(205+j,2)==0&Results_all(205+j,3)~=5)|(Results_all(205+j,1)==3&Results_all(205+j,2)~=0) ;     
    end
    %% block2
    %ac: correct strategy = 2:cue1/NoGo  &  4:cue2/Go
    for j=1:22
        block06_ac(j)=(Results_all(225+j,1)==2&Results_all(225+j,2)==0&Results_all(225+j,3)~=5)|(Results_all(225+j,1)==4&Results_all(225+j,2)~=0)...
                       |(Results_all(225+j,1)==1&Results_all(225+j,2)==0&Results_all(225+j,3)~=5)|(Results_all(225+j,1)==3&Results_all(225+j,2)~=0) ;     
    end
    %re: correct strategy = 1:cue1/Go  &  3:cue2/NoGo
    for j=1:23
        block06_re(j)=(Results_all(247+j,1)==1&Results_all(247+j,2)~=0)|(Results_all(247+j,1)==3&Results_all(247+j,2)==0&Results_all(247+j,3)~=5)...
                       |(Results_all(247+j,1)==2&Results_all(247+j,2)~=0|(Results_all(247+j,1)==4&Results_all(247+j,2)==0&Results_all(247+j,3)~=5)) ;
    end
    
    %% block3
    %ac: correct strategy = 1:cue1/Go  &  3:cue2/NoGo
    for j=1:24
        block07_ac(j)=(Results_all(270+j,1)==1&Results_all(270+j,2)~=0)|(Results_all(270+j,1)==3&Results_all(270+j,2)==0&Results_all(270+j,3)~=5)...
                       |(Results_all(270+j,1)==2&Results_all(270+j,2)~=0|(Results_all(270+j,1)==4&Results_all(270+j,2)==0&Results_all(270+j,3)~=5)) ;
    end
    %re: correct strategy = 2:cue1/NoGo  &  4:cue2/Go
    for j=1:21
        block07_re(j)=(Results_all(294+j,1)==2&Results_all(294+j,2)==0&Results_all(294+j,3)~=5)|(Results_all(294+j,1)==4&Results_all(294+j,2)~=0)...
                       |(Results_all(294+j,1)==1&Results_all(294+j,2)==0&Results_all(294+j,3)~=5)|(Results_all(294+j,1)==3&Results_all(294+j,2)~=0) ;     
    end
    
    %% block4
    %ac: correct strategy = 2:cue1/NoGo  &  4:cue2/Go
    for j=1:20
        block08_ac(j)=(Results_all(315+j,1)==2&Results_all(315+j,2)==0&Results_all(315+j,3)~=5)|(Results_all(315+j,1)==4&Results_all(315+j,2)~=0)...
                       |(Results_all(315+j,1)==1&Results_all(315+j,2)==0&Results_all(315+j,3)~=5)|(Results_all(315+j,1)==3&Results_all(315+j,2)~=0) ;     
    end
    %re: correct strategy = 1:cue1/Go  &  3:cue2/NoGo
    for j=1:25
        block08_re(j)=(Results_all(335+j,1)==1&Results_all(335+j,2)~=0)|(Results_all(335+j,1)==3&Results_all(335+j,2)==0&Results_all(335+j,3)~=5)...
                       |(Results_all(335+j,1)==2&Results_all(335+j,2)~=0|(Results_all(335+j,1)==4&Results_all(335+j,2)==0&Results_all(335+j,3)~=5)) ;
    end
    
    %% RUN3
    %block1
    %ac: correct strategy = 1:cue1/Go  &  3:cue2/NoGo
    for j=1:20
        block09_ac(j)=(Results_all(360+j,1)==1&Results_all(360+j,2)~=0)|(Results_all(360+j,1)==3&Results_all(360+j,2)==0&Results_all(360+j,3)~=5)...
                       |(Results_all(360+j,1)==2&Results_all(360+j,2)~=0|(Results_all(360+j,1)==4&Results_all(360+j,2)==0&Results_all(360+j,3)~=5)) ;
    end
    %re: correct strategy = 2:cue1/NoGo  &  4:cue2/Go
    for j=1:25
        block09_re(j)=(Results_all(380+j,1)==2&Results_all(380+j,2)==0&Results_all(380+j,3)~=5)|(Results_all(380+j,1)==4&Results_all(380+j,2)~=0)...
                       |(Results_all(380+j,1)==1&Results_all(380+j,2)==0&Results_all(380+j,3)~=5)|(Results_all(380+j,1)==3&Results_all(380+j,2)~=0) ;     
    end
    %% block2
    %ac: correct strategy = 2:cue1/NoGo  &  4:cue2/Go
    for j=1:24
        block10_ac(j)=(Results_all(405+j,1)==2&Results_all(405+j,2)==0&Results_all(405+j,3)~=5)|(Results_all(405+j,1)==4&Results_all(405+j,2)~=0)...
                       |(Results_all(405+j,1)==1&Results_all(405+j,2)==0&Results_all(405+j,3)~=5)|(Results_all(405+j,1)==3&Results_all(405+j,2)~=0) ;     
    end
    %re: correct strategy = 1:cue1/Go  &  3:cue2/NoGo
    for j=1:21
        block10_re(j)=(Results_all(429+j,1)==1&Results_all(429+j,2)~=0)|(Results_all(429+j,1)==3&Results_all(429+j,2)==0&Results_all(429+j,3)~=5)...
                       |(Results_all(429+j,1)==2&Results_all(429+j,2)~=0|(Results_all(429+j,1)==4&Results_all(429+j,2)==0&Results_all(429+j,3)~=5)) ;
    end
    
    %% block3
    %ac: correct strategy = 1:cue1/Go  &  3:cue2/NoGo
    for j=1:23
        block11_ac(j)=(Results_all(450+j,1)==1&Results_all(450+j,2)~=0)|(Results_all(450+j,1)==3&Results_all(450+j,2)==0&Results_all(450+j,3)~=5)...
                       |(Results_all(450+j,1)==2&Results_all(450+j,2)~=0|(Results_all(450+j,1)==4&Results_all(450+j,2)==0&Results_all(450+j,3)~=5)) ;
    end
    %re: correct strategy = 2:cue1/NoGo  &  4:cue2/Go
    for j=1:22
        block11_re(j)=(Results_all(473+j,1)==2&Results_all(473+j,2)==0&Results_all(473+j,3)~=5)|(Results_all(473+j,1)==4&Results_all(473+j,2)~=0)...
                       |(Results_all(473+j,1)==1&Results_all(473+j,2)==0&Results_all(473+j,3)~=5)|(Results_all(473+j,1)==3&Results_all(473+j,2)~=0) ;     
    end
    
    %% block4
    %ac: correct strategy = 2:cue1/NoGo  &  4:cue2/Go
    for j=1:21
        block12_ac(j)=(Results_all(495+j,1)==2&Results_all(495+j,2)==0&Results_all(495+j,3)~=5)|(Results_all(495+j,1)==4&Results_all(495+j,2)~=0)...
                       |(Results_all(495+j,1)==1&Results_all(495+j,2)==0&Results_all(495+j,3)~=5)|(Results_all(495+j,1)==3&Results_all(495+j,2)~=0) ;     
    end
    %re: correct strategy = 1:cue1/Go  &  3:cue2/NoGo
    for j=1:24
        block12_re(j)=(Results_all(516+j,1)==1&Results_all(516+j,2)~=0)|(Results_all(516+j,1)==3&Results_all(516+j,2)==0&Results_all(516+j,3)~=5)...
                       |(Results_all(516+j,1)==2&Results_all(516+j,2)~=0|(Results_all(516+j,1)==4&Results_all(516+j,2)==0&Results_all(516+j,3)~=5)) ;
    end


    %Align  40 trials

     All_blocks_ac=[block01_ac(end-19:end);block02_ac(end-19:end);block03_ac(end-19:end);block04_ac(end-19:end);block05_ac(end-19:end);block06_ac(end-19:end);...
                    block07_ac(end-19:end);block08_ac(end-19:end);block09_ac(end-19:end);block10_ac(end-19:end);block11_ac(end-19:end);block12_ac(end-19:end)];

     All_blocks_re=[block01_re(1:20);block02_re(1:20);block03_re(1:20);block04_re(1:20);block05_re(1:20);block06_re(1:20);...
                    block07_re(1:20);block08_re(1:20);block09_re(1:20);block10_re(1:20);block11_re(1:20);block12_re(1:20)];

     All_blocks_40trials=[All_blocks_ac,All_blocks_re];
     Mean_blocks_40trials=mean(All_blocks_40trials);

%     %plot individual figure
%     figure1 = figure('Color',[1 1 1]);
%     axes1 = axes('Parent',figure1);
%     hold(axes1,'on');
%     % Create axes
%     x=[1:1:40];
%     y=All_blocks_40trials;
%     %shadedErrorBar(x,y,{@mean,@std},'-r',1);
%     plot(mean(y,1),'LineWidth',2);
%     hold on; plot([20,20],[0,1.2], 'LineWidth',2,'LineStyle','--',...
%         'Color',[0.8 0.3 0]);
%     hold on; plot([0,40],[0.5,0.5], 'LineWidth',1,'LineStyle','--',...
%         'Color',[0 0 0]);
%     title(['Mean behavioral performance']);
%     xlabel('Trial number','FontSize',14)
%     xticklabels({'-20' '-15' '-10' '-5' '0' '5' '10' '15' '20'});
%     ylabel('Proportion of correct strategy','FontSize',14)
%     ylim([0 1.2]);
%     box(axes1,'off');
%     % Set the remaining axes properties
%     set(axes1,'FontSize',12);

    All_sub_40trials(i,:)=Mean_blocks_40trials;
end 

    % plot mean figures
    figure1 = figure('Color',[1 1 1]);
    axes1 = axes('Parent',figure1);
    hold(axes1,'on');
    % Create axes
    x=[1:1:40];
    y=All_sub_40trials;
    %shadedErrorBar(x,y,{@mean,@std},'-r',1);
    shadedErrorBar(x,mean(y,1),std(y)/sqrt(size(y,1)),'g');

    %    plot(mean(All_mean_interpolate,1),'LineWidth',2);
    hold on; plot([20,20],[0,1.1], 'LineWidth',2,'LineStyle','--',...
        'Color',[0.8 0.3 0])
    hold on; plot([0,40],[0.5,0.5], 'LineWidth',1,'LineStyle','--',...
         'Color',[0 0 0]);
    title(['Mean behavioral performance']);
    xlabel('Trial number','FontSize',14)
    xticklabels({'-20' '-15' '-10' '-5' '0' '5' '10' '15' '20'});
    ylabel('Proportion of correct strategy','FontSize',14)
    ylim([0 1.1]);
    box(axes1,'off');
    % Set the remaining axes properties
    set(axes1,'FontSize',12);
    
%% calculate the switch point

id_RN=All_sub_40trials(:,21:30);


