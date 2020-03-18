function GoNoGo
%384 trials with 96 trials per block each trial being 1,500ms Prime = 200ms blank = 33ms Probe = 200ms fix = 1067ms% 
sca; %Closes any open Psychtoolbox windows 
close all; %closes any other matlab windows
clearvars; %clear all variables 

rng('shuffle'); %shuffle RNG generator
%2=AA 4=BB 6=AB 8=BA; 1=YY 3=ZZ 5=YZ 7=ZY%
load('subtrialsGood.mat'); %Get trial orders
%--------------------------------------------------------------------------
%                        Participant Setup
%--------------------------------------------------------------------------
%Enter participant ID in command window
prompt = 'Participant #: ';
subID = input(prompt, 's');

current = pwd();
subFolder = [current '/ParticipantInfo/' subID];
%Create Participant folder (if new)
if ~isfolder(subFolder)
    mkdir(subFolder)
end
taskFolder = [subFolder '/GoNoGo'];
%Make Flanker folder (if 1st run)
if ~isfolder(taskFolder)
    mkdir(taskFolder)
end

%Check if run exists to prevent accidental overwrite
overwrite = 0;
while overwrite == 0
    prompt = 'Run #: ';
    run = input(prompt);
    cd(taskFolder)
    if isfile(['run' num2str(run) '.mat'])
        prompt = 'Run already exists. Overwirte? (y/n): ';
        ow = input(prompt, 's');
        if strcmpi(ow, 'y')
            overwrite = 1;
        end
    else
        break
    end
end

cd(current)

%Gives option for practice block
% prompt = 'Practice? (y/n): ';
% practice = input(prompt, 's');
% 
% if practice == 'y'
%     practice = 1;
% else
%     practice = 0;
% end

%--------------------------------------------------------------------------
%                       Change Variables here
%--------------------------------------------------------------------------
trials = 400; %Number of total trials
blocks = 2;
trialsperblock = trials/blocks; %Number of tirals in each block
%Make trial order%

stimTime = .3; %Time stimli on screne
ITI = .7; %Secs between stimili
responseTime = stimTime+ITI; %Secs to respond
totstimTime=stimTime+ITI; %Total stimulus time

% numArrows = 5;
numTrialStims = 12; %['X','C','D','F','G','H','J','K','M','N','P','S','T','V','W','Z','blank']
stimNames={'X','B','C','F','G','H','J','K','P','T','Z','blank'};

XKey = KbName('x');

allData = cell(trials, 5);

%--------------------------------------------------------------------------
%                              Screen Setup
%--------------------------------------------------------------------------

% Skip sync tests to avoid error
Screen('Preference', 'SkipSyncTests', 1);

PsychDefaultSetup(2);

screens = Screen('Screens'); 
screenNumber = max(screens);

white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
% grey = white/2;

[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);
% [screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Center of Screen
[xCenter, yCenter] = RectCenter(windowRect);

HideCursor();

Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

%Screen Text 
Screen('TextFont', window, 'Helvetica');
Screen('TextSize', window, 36); %Font size for instructions

%Fixation cross
fixCrossDimPix = 15;
lineWidthPix = 3;
fixXCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
fixYCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
fixAllCoords = [fixXCoords; fixYCoords];
%--------------------------------------------------------------------------
%                            Stimuli Setup
%--------------------------------------------------------------------------

%Load arrrow pics and make textures 
pictures = zeros(trials, 1);
for img = 1:numTrialStims
    tmpImg = imread([char(stimNames(img)) '.png']);
    pictures(img) = Screen('MakeTexture', window, tmpImg);
end

[imgX, imgY, ~] = size(tmpImg);
arrowSize = .2; %mulitplier for img size


%Set positions for arrows

arrowRect = [xCenter-(imgY*arrowSize)/2; yCenter-(imgX*arrowSize)/2; ...
             xCenter+(imgY*arrowSize)/2; yCenter+(imgX*arrowSize)/2];


stimOrder=[];
for ordermaker=1:blocks;
    NotXstimcases={'B','C','F','G','H','J','K','P','T','Z'};
    Xcase={'X'};
    NoGonum=(.2*trialsperblock)/length(NotXstimcases);
    Xnum=.8*trialsperblock;
    Noset=repmat(NotXstimcases,1,NoGonum);
    Xset=repmat(Xcase,1,Xnum);
    allstim=cat(2,Xset,Noset);
    stimOrder=[stimOrder,Shuffle(allstim)];
end
%Make PracOrder%
Pracforshuffle=[repmat(Xcase,1,16),NotXstimcases(randperm(10,4))];
pracTrialOrder=Shuffle(Pracforshuffle);
% stimOrder = Shuffle(repmat(1:4, 1, trials/numTrialStims));
%Trial Types
% 1 = <<<<<
% 2 = >>>>>
% 3 = <<><<
% 4 = >><>>
%2=AA 4=BB 6=AB 8=BA; 1=YY 3=ZZ 5=YZ 7=ZY%
% This should be the order used in pictures only care about 1 to 4 {'A','B','Y','Z','blank'}
FirstStimOrder=[3,1,4,2,3,1,4,2];   %{'Y','A','Z','B','Y','A','Z','B'};
SecondStimOrder=[3,1,4,2,4,2,3,1];  %{'Y','A','Z','B','Z','B','Y','A'};
%--------------------------------------------------------------------------       
%                        Instructions/Key Bindings 
%--------------------------------------------------------------------------
DrawFormattedText(window, 'On each trial you will see a single letter on the screen.', 'center', yCenter-300, white);
DrawFormattedText(window, 'You should ONLY RESPOND to X and withhold responses to other letters.', 'center', yCenter-200, white);
DrawFormattedText(window, 'Respond using the X Key.', 'center', yCenter-100, white);
DrawFormattedText(window, 'You should work as quickly and as accurately as possible.', 'center', yCenter, white);



DrawFormattedText(window, 'Press ANY KEY to start', 'center', yCenter+300, white);

Screen('Flip', window)
WaitSecs(.5);
KbWait;
Screen('DrawLines', window, fixAllCoords,...
        lineWidthPix, white, [xCenter, yCenter], 2); %Draw fixation
Screen('Flip', window);
WaitSecs(ITI);

%--------------------------------------------------------------------------
%                             Practice
%--------------------------------------------------------------------------
numPracTrials = 20;
startTime = clock;
block = 1;
for ptrial = 1:numPracTrials
    if strcmp(pracTrialOrder(ptrial),'X');
        trialType = 'GO';
    else
        trialType = 'NOGO';
    end
    
    
    %Draw arrows to correct spots 
    Screen('DrawTexture', window, pictures(find(strcmp(stimNames,pracTrialOrder(ptrial)))), [], arrowRect); %The loop number itrial acts as the index of stimOrder and the value of stimOrder at that index is to get FirststimOrder value at an index equal to the value of stimOrder and this value is used as the index of pictures%
    Screen('Flip', window);
    
    %Response
    fixflicker = 0;
    fixflickerB = 0;
    fixflickerS = 0;
    response = 'None';
    RT = NaN;
    tic;
    while toc < responseTime
        [~,~, keyCode] = KbCheck;
        if keyCode(XKey) 
            response = 'X'; 
            RT = toc;
        end
        if toc > stimTime 
            if fixflickerB == 0
                Screen('DrawTexture', window, pictures(12), [], arrowRect); %Blank Period%
                Screen('Flip', window);
                fixflickerB = 1;
            end 
        end
    end
    
    
   if strcmp(pracTrialOrder(ptrial),'X');
       if strcmp(response, 'X') %X response 
           trialacc = 1;
       else 
           trialacc =0;
       end
   else
       if strcmp(response, 'None') %No response 
           trialacc = 1;
       else 
           trialacc =0;
       end
   end
   %Accuracy 
    acc = trialacc==1;
    
    
    if acc == 1
        message = 'Correct!';
    else
        message = 'Incorrect';
    end
    
    
    Screen('TextSize', window, 36);
    DrawFormattedText(window, message, 'center', yCenter-100, white);
    DrawFormattedText(window, 'Press ANY KEY to continue', 'center', yCenter+300, white);
    Screen('TextSize', window, 28)
    DrawFormattedText(window, 'Hit X if You See X', 'center', yCenter+400, white);
    Screen('Flip', window);
    WaitSecs(.5);
    KbWait;
    DrawFormattedText(window, 'Hit X if You See X', 'center', yCenter+400, white);
    Screen('Flip', window);
    WaitSecs(1); %Look into this
%     %Back to fix%
%     Screen('DrawLines', window, fixAllCoords,...
%     lineWidthPix, white, [xCenter, yCenter], 2); %Draw fixation
%     Screen('Flip', window);
%     WaitSecs(.5); %Look into this
end
    %Ending Prac Below%
    Screen('TextSize', window, 36);
    DrawFormattedText(window, 'Practice complete!', 'center', yCenter-100, white)
    DrawFormattedText(window, 'During the actual task, you will not receive feedback until the end of the block.',...
                        'center', 'center', white)
    DrawFormattedText(window, 'Press ANY KEY to begin actual task', 'center', yCenter+300, white);
    Screen('Flip', window)
    WaitSecs(.5);
    KbWait
    Screen('Flip', window);
    WaitSecs(2);
%--------------------------------------------------------------------------       
%                           Experimental Loop
%--------------------------------------------------------------------------
startTime = clock;
block = 1;
for itrial = 1:trials
    if strcmp(stimOrder(itrial),'X');;
        trialType = 'GO';
    else
        trialType = 'NOGO';
    end
    

    %Draw arrows to correct spots 
    Screen('DrawTexture', window, pictures(find(strcmp(stimNames,stimOrder(itrial)))), [], arrowRect); %The loop number itrial acts as the index of stimOrder and the value of stimOrder at that index is to get FirststimOrder value at an index equal to the value of stimOrder and this value is used as the index of pictures%
    Screen('Flip', window);
    
    %Response
    fixflicker = 0;
    fixflickerB = 0;
    fixflickerS = 0;
    response = 'None';
    RT = NaN;
    tic;
    while toc < responseTime
        [~,~, keyCode] = KbCheck;
        if keyCode(XKey) 
            response = 'X'; 
            RT = toc;
        end
        if toc > stimTime 
            if fixflickerB == 0
                Screen('DrawTexture', window, pictures(12), [], arrowRect); %Blank Period%
                Screen('Flip', window);
                fixflickerB = 1;
            end 
        end
    end
    
    
   if strcmp(stimOrder(itrial),'X');
       if strcmp(response, 'X') %X response 
           trialacc = 1;
       else 
           trialacc =0;
       end
   else
       if strcmp(response, 'None') %No response 
           trialacc = 1;
       else 
           trialacc =0;
       end
   end
    
   allData(itrial, :) = {trialType, stimOrder(itrial), response, trialacc, RT};
   
   %Feedback
   if mod(itrial, trialsperblock) == 0
        blockRT = nanmean(cell2mat(allData(trialsperblock*(block-1)+1:trialsperblock*block, 5)));
        blockAcc = nanmean(cell2mat(allData(trialsperblock*(block-1)+1:trialsperblock*block, 4)));
        Accmessage = ['This block, you got ' num2str(blockAcc*100) '% correct.'];
        RTmessage = ['Your average reaction time was ' num2str(blockRT) ' seconds.'];
        DrawFormattedText(window, Accmessage, 'center', yCenter-100, white);
        DrawFormattedText(window, RTmessage, 'center', yCenter+100, white);
        Screen(window, 'Flip')
        WaitSecs(5);
        block = block + 1;
        
        %Fixation
        Screen('DrawLines', window, fixAllCoords,...
            lineWidthPix, white, [xCenter, yCenter], 2); %Draw fixation
        Screen('Flip', window);
        WaitSecs(ITI);
   end
   
end  
endTime = clock;

%--------------------------------------------------------------------------
%                              Save Data
%--------------------------------------------------------------------------
allData{1, 7} = startTime(4:6); %Start time
allData{2, 7} = startTime(1:3); %Date
allData{trials, 6} = endTime(4:6); %#ok<NASGU> %End time

save(fullfile(taskFolder, ['run' num2str(run) '.mat']), 'allData');

sca;
end