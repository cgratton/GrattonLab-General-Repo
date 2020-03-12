function flanker
sca; %Closes any open Psychtoolbox windows 
close all; %closes any other matlab windows
clearvars; %clear all variables 

rng('shuffle'); %shuffle RNG generator

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
taskFolder = [subFolder '/Flanker'];
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

stimTime = .5; %Time stimli on screne
ITI = 1.5; %Secs between stimili
responseTime = stimTime+ITI; %Secs to respond 


% numArrows = 5;
numTrialStims = 4; %[<<<<<, >>>>>, <<><<, >><>>]

leftKey = KbName('LeftArrow');
rightKey = KbName('RightArrow');

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
    tmpImg = imread([num2str(img) '.png']);
    pictures(img) = Screen('MakeTexture', window, tmpImg);
end

[imgX, imgY, ~] = size(tmpImg);
arrowSize = .2; %mulitplier for img size


%Set positions for arrows

arrowRect = [xCenter-(imgY*arrowSize)/2; yCenter-(imgX*arrowSize)/2; ...
             xCenter+(imgY*arrowSize)/2; yCenter+(imgX*arrowSize)/2];


stimOrder = Shuffle(repmat(1:4, 1, trials/numTrialStims));
%Trial Types
% 1 = <<<<<
% 2 = >>>>>
% 3 = <<><<
% 4 = >><>>

%--------------------------------------------------------------------------       
%                        Instructions/Key Bindings 
%--------------------------------------------------------------------------
DrawFormattedText(window, 'In this task, you will be show a group of arrows.', 'center', yCenter-100, white);
DrawFormattedText(window, 'Press left or right to indicate which way the CENTER arrow is pointing', 'center', yCenter, white);
DrawFormattedText(window, 'You should work as quickly and as accurately as possible.', 'center', yCenter+100, white);
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


%--------------------------------------------------------------------------       
%                           Experimental Loop
%--------------------------------------------------------------------------
startTime = clock;
block = 1;
for itrial = 1:trials
    if stimOrder(itrial) == 1 || stimOrder(itrial) == 2
        trialType = 'CONGRUENT';
    else
        trialType = 'INCONGRUENT';
    end
    
    %Draw arrows to correct spots 
    Screen('DrawTexture', window, pictures(stimOrder(itrial)), [], arrowRect);
    Screen('Flip', window);
    
    %Response
    fixflicker = 0;
    response = NaN;
    RT = NaN;
    tic;
    while toc < responseTime
        [~,~, keyCode] = KbCheck;
        if keyCode(leftKey) 
            response = 'LEFT'; 
            RT = toc;
        elseif keyCode(rightKey)
            response = 'RIGHT'; 
            RT = toc;
        end
        if toc > stimTime
%             Screen('Flip', window);
            if fixflicker == 0
                Screen('DrawLines', window, fixAllCoords,...
                lineWidthPix, white, [xCenter, yCenter], 2); %Draw fixation
                Screen('Flip', window);
                fixflicker = 1; %Stops cross from flickering 
            end
        end
    end
    
    
   if stimOrder(itrial) == 1 || stimOrder(itrial) == 4 % <<<<< or >><>>
       if strcmp(response, 'LEFT') % Left response 
           trialacc = 1;
       else 
           trialacc =0;
       end
   elseif stimOrder(itrial) == 2 || stimOrder(itrial) == 3 % >>>>> or <<><<
       if strcmp(response, 'RIGHT') %Right response 
           trialacc = 1;
       else
           trialacc = 0;
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
allData{1, 6} = startTime(4:6); %Start time
allData{1, 7} = startTime(1:3); %Date
allData{trials, 6} = endTime(4:6); %#ok<NASGU> %End time

save(fullfile(taskFolder, ['run' num2str(run) '.mat']), 'allData');

sca;
end