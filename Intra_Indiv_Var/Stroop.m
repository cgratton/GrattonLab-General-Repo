function Stroop
sca;
close all;
clearvars;

rng('shuffle');

%--------------------------------------------------------------------------
%                        Participant Setup
%--------------------------------------------------------------------------

prompt = 'Participant #: ';
subID = input(prompt, 's');

current = pwd();
subFolder = [current '/ParticipantInfo/' subID];
%Create Participant folder (if new)
if ~isfolder(subFolder)
    mkdir(subFolder)
end
taskFolder = [subFolder '/STROOP'];
%Make AnitSaccade folder (if 1st run)
if ~isfolder(taskFolder)
    mkdir(taskFolder)
end


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

prompt = 'Practice? (y/n): ';
practice = input(prompt, 's');

if practice == 'y'
    practice = 1;
else
    practice = 0;
end
%--------------------------------------------------------------------------
%                       Change Variables here
%--------------------------------------------------------------------------

blocks = 4; 
trialsPerBlock = 36;
trials = blocks*trialsPerBlock; %Words per trial; (4 runs of 36 DIV BY 12) or (4 runs of 30 DIV BY 10) DIV by NUMCOLORS
trialBreakdown = [(6/12), (5/12), (1/12)]; %[ast, diff, same] Original [(6/12), (5/12), (1/12)] or [.5 .4 .1]

ITI = 1; %Secs between words
timeLimit = 2; %Time limit to answer 

numColors = 4;
% numColors = 6;

allRGB = zeros(numColors, 3);
allRGB(1, :) = [1 0 0]; %Red
allRGB(2, :) = [1 1 0]; %Yellow
allRGB(3, :) = [0 1 0]; %Green
allRGB(4, :) = [0 0 1]; %Blue

% allRGB(5, :) = [1 .5 0]; %Orange
% allRGB(6, :) = [.5 0 1]; %Purple

allNames = {'RED', 'YELLOW', 'GREEN', 'BLUE'};
% allNames = {'RED', 'GREEN', 'BLUE', 'YELLOW', 'ORANGE', 'PURPLE'};
% allAst = {'***', '****', '*****', '******'}; %Match length of words
otherWords = {'HORSE', 'BIRD', 'CAT','DOG'}; 


oneKey = KbName('1!');
twoKey = KbName('2@');
threeKey = KbName('3#');
fourKey = KbName('4$');


allData = cell(trials, 6);
oldBlockRT = 2;
block = 1;

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

HideCursor()

Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

%Screen Text 
Screen('TextFont', window, 'Helvetica');
Screen('TextSize', window, 36); %Font size for instructions 

%Fixation cross 
fixCrossDimPix = 15;
lineWidthPix = 2;
xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
allCoords = [xCoords; yCoords];



%--------------------------------------------------------------------------
%                          Word Setup
%--------------------------------------------------------------------------
asterisks = zeros(trialBreakdown(1)*trials, 1);
differents = ones(trialBreakdown(2)*trials, 1);
sames = ones(trialBreakdown(3)*trials, 1) *2;

trialOrder = Shuffle(vertcat(asterisks, differents, sames));

%No condition more than 3 in a row 
fixed = 0;
while ~fixed
    for i = 4:trials
        if trialOrder(i) == trialOrder(i-1) && trialOrder(i) == trialOrder(i-2) && trialOrder(i) == trialOrder(i-3)
            trialOrder = Shuffle(trialOrder);
            break
        elseif i == trials
            fixed = 1;
            break
        end
    end
end

% ---For only 4 colors ------
colorOrder = datasample(1:numColors, trials);
wordOrder = NaN(trials, 1);

for word = 1:trials
    if trialOrder(word) == 0 %asterisks/other word
        wordOrder(word) = 0;
    elseif trialOrder(word) == 1 %Different
        wordOrder(word) = randi(numColors);
        while wordOrder(word) == colorOrder(word)
            wordOrder(word) = randi(numColors);
        end
    else %Same
        wordOrder(word) = colorOrder(word);
    end
end

% -------No relation to previous trial (for 5+ colors)------
% 
% colorOrder = zeros(trials, 1);
% wordOrder = NaN(trials, 1);

% %set 1st trial 
% colorOrder(1) = randi(numColors);
% if trialOrder(1) == 0 %asterisks
%     wordOrder(1) = 0;
% elseif trialOrder(1) == 1 %Different 
%     wordOrder(1) = randi(numColors);
% else %Same
%     wordOrder(1) = colorOrder(1);
% end
% %All other trials 
% for word = 2:trials
%     if trialOrder(word) == 0 %asterisks
%         wordOrder(word) = 0;
%         colorOrder(word) = randi(numColors);
%         while colorOrder(word) == colorOrder(word-1)
%             colorOrder(word) = randi(numColors);
%         end
%     elseif trialOrder(word) == 1 %Different 
%         wordOrder(word) = randi(numColors);
%         colorOrder(word) = randi(numColors);
%         while wordOrder(word) == colorOrder(word) ||...
%                   wordOrder(word) == wordOrder(word-1) || ...
%                   colorOrder(word) == colorOrder(word-1) || ...
%                   wordOrder(word) == colorOrder(word-1) || ...
%                   colorOrder(word) == wordOrder(word-1)
%             wordOrder(word) = randi(numColors);
%             colorOrder(word) = randi(numColors);
%         end
%     else %Same
%         wordOrder(word) = randi(numColors);
%         while wordOrder(word) == wordOrder(word-1) ||...
%                 wordOrder(word) == colorOrder(word-1)
%             wordOrder(word) = randi(numColors);
%         end
%         colorOrder(word) = wordOrder(word);
%     end
% end


%--------------------------------------------------------------------------       
%                        Instructions/Key Bindings 
%--------------------------------------------------------------------------

DrawFormattedText(window, 'You will see a word appear in a color that may or may not match the word.', 'center', yCenter-300, white);
DrawFormattedText(window, 'You should respond with the COLOR the word is written in, NOT the word itself.', 'center', yCenter-200, white);
DrawFormattedText(window, 'Respond using the number of the color.', 'center', yCenter-100, white);
DrawFormattedText(window, 'You should work as quickly and as accurately as possible.', 'center', yCenter, white);

DrawFormattedText(window, '1=RED      2=YELLOW      3=GREEN      4=BLUE', 'center', yCenter+100, white);

DrawFormattedText(window, 'Press ANY KEY to start', 'center', yCenter+300, white);

Screen('Flip', window)
WaitSecs(.5);
KbWait;

Screen('DrawLines', window, allCoords,...
    lineWidthPix, white, [xCenter, yCenter], 2);
Screen('TextSize', window, 28);
DrawFormattedText(window, '1=RED      2=YELLOW      3=GREEN      4=BLUE', 'center', yCenter+400, white);
Screen('Flip', window);

WaitSecs(2); %Wait for time 

if practice == 1 %check for practice 
    
%--------------------------------------------------------------------------
%                          Practice
%--------------------------------------------------------------------------
pracTrialOrder = [0 0 0 0 0 0 2 2 0 2 0 2 0 0 2 1 1 1 2 0 2 1 0 1 1];
numPracTrials = 25;
pracColors = randi(numColors, numPracTrials, 1);
pracWords = NaN(numPracTrials, 1);

for word = 1:numPracTrials
    if pracTrialOrder(word) == 0 %Other word
        pracWords(word) = 0;
    elseif pracTrialOrder(word) == 1 % different 
        pracWords(word) = randi(numColors);
        while pracWords(word) == pracColors(word)
            pracWords(word) = randi(numColors);
        end
    else %Same 
        pracWords(word) = randi(numColors);
    end
end

% numPracTrials = 5;
% pracTrialOrder = [0 2 1 0 1 1];
% pracColors = [1 5 3 2 6 4];
% pracWords = {'****', 'BLUE', 'RED', '******', 'YELLOW', 'ORANGE'};


for pracTrial = 1:numPracTrials
    trialColor = allRGB(pracColors(pracTrial), :);
%     trialWord = pracWords{pracTrial};
    Screen('TextSize', window, 48);
        trialCenter = yCenter+24;
    if pracTrialOrder(pracTrial) == 0
        trialWord = cell2mat(datasample(otherWords, 1));
%         Screen('TextSize', window, 100);
%         trialCenter = yCenter+60;
    else
        trialWord = allNames{pracWords(pracTrial)};
    end
    
    DrawFormattedText(window, trialWord, 'center', trialCenter, trialColor);
    Screen('TextSize', window, 28)
    DrawFormattedText(window, '1=RED      2=YELLOW      3=GREEN      4=BLUE', 'center', yCenter+400, white);
    Screen('Flip', window);
    
    while 1
       [~ ,~, keyCode] = KbCheck;
        if keyCode(oneKey)
            response = 1; %Red
            break
        elseif keyCode(twoKey)
            response = 2; %Yellow
            break
        elseif keyCode(threeKey)
            response = 3; %Green
            break
        elseif keyCode(fourKey)
            response = 4; %Blue
            break
        end
    end
    
%     while 1
%         [keyIsDown,secs, keyCode] = KbCheck;
%         if keyIsDown
%             answerKey = find(keyCode);
%             response = upper(KbName(answerKey));
%             break
%         end
%     end
%     
%     %Convert color to number 
%     if response == 'R'
%         response = 1;
%     elseif response == 'O'
%         response = 2;
%     elseif response == 'Y'
%         response = 3;
%     elseif response == 'G'
%         response = 4;
%     elseif response == 'B'
%         response = 5;
%     elseif response == 'P'
%         response = 6;
%     else
%         response = 0; %Other key
%     end
    
    %Accuracy 
    acc = response == pracColors(pracTrial);
    
    
    if acc == 1
        message = ['Correct! The word is printed in ' allNames{pracColors(pracTrial)}];
    else
        message = ['Incorrect. The word is printed in ' allNames{pracColors(pracTrial)}];
    end
    
    
    Screen('TextSize', window, 36);
    DrawFormattedText(window, message, 'center', yCenter-100, white);
    DrawFormattedText(window, trialWord, 'center', trialCenter, trialColor);
    DrawFormattedText(window, 'Press ANY KEY to continue', 'center', yCenter+300, white);
    Screen('TextSize', window, 28)
    DrawFormattedText(window, '1=RED      2=YELLOW      3=GREEN      4=BLUE', 'center', yCenter+400, white);
    Screen('Flip', window);
    WaitSecs(.5);
    KbWait;
    DrawFormattedText(window, '1=RED      2=YELLOW      3=GREEN      4=BLUE', 'center', yCenter+400, white);
    Screen('DrawLines', window, allCoords,...
        lineWidthPix, white, [xCenter, yCenter], 2);
    Screen('Flip', window);
    WaitSecs(ITI);
    
end

Screen('TextSize', window, 36);
DrawFormattedText(window, 'Practice complete!', 'center', yCenter-100, white)
DrawFormattedText(window, 'During the actual task, you will not receive feedback.',...
                        'center', 'center', white)
DrawFormattedText(window, 'Press ANY KEY to begin actual task', 'center', yCenter+300, white);
Screen('Flip', window)
WaitSecs(.5);
KbWait
Screen('Flip', window);
WaitSecs(2);


end
%--------------------------------------------------------------------------       
%                           Experimental Loop
%--------------------------------------------------------------------------
startTime = clock;
for itrial = 1:trials
    trialColor = allRGB(colorOrder(itrial), :);
    
    trialCenter = yCenter+24;
    Screen('TextSize', window, 56);
    
    if trialOrder(itrial) == 0
        trialWord = cell2mat(datasample(otherWords, 1));
%         Screen('TextSize', window, 100);
%         trialCenter = yCenter+60;
    else
        trialWord = allNames{wordOrder(itrial)};
    end
    
    DrawFormattedText(window, trialWord, 'center', trialCenter, trialColor);
    Screen('TextSize', window, 28)
    DrawFormattedText(window, '1=RED      2=YELLOW      3=GREEN      4=BLUE', 'center', yCenter+400, white);
    Screen('Flip', window);
    
% Record response, 
    
    %------Full Word---------------
%     tic;
%     response = upper(input(' ', 's'));
%     RT = toc;
%     Screen('Flip', window);

    %------First letter of color------
%     tic;
%     while 1
%         [keyIsDown,secs, keyCode] = KbCheck;
%         if keyIsDown
%             answerKey = find(keyCode);
%             response = upper(KbName(answerKey));
%             RT = toc;
%             break
%         end
%     end
%     
%     %Convert color to number 
%     if response == 'R'
%         response = 1;
%     elseif response == 'G'
%         response = 2;
%     elseif response == 'B'
%         response = 3;
%     elseif response == 'Y'
%         response = 4;
%     elseif response == 'O'
%         response = 5;
%     elseif response == 'P'
%         response = 6;
%     else
%         response = 0; %Other key
%     end


    %Number - color matching 
    tic;
    while toc < timeLimit
        [~,~, keyCode] = KbCheck;
        if keyCode(oneKey)
            response = 1; %Red
            RT = toc;
            break
        elseif keyCode(twoKey)
            response = 2; %Yellow
            RT = toc;
            break
        elseif keyCode(threeKey)
            response = 3; %Green
            RT = toc;
            break
        elseif keyCode(fourKey)
            response = 4; %Blue
            RT = toc;
            break
        end
    end
    
    
    %Accuracy 
    acc = response == colorOrder(itrial);
    
    Screen('DrawLines', window, allCoords,...
        lineWidthPix, white, [xCenter, yCenter], 2);
    Screen('TextSize', window, 28)
    DrawFormattedText(window, '1=RED      2=YELLOW      3=GREEN      4=BLUE', 'center', yCenter+400, white);
    Screen('Flip', window);
    WaitSecs(ITI);
    
    allData(itrial, :) = {trialWord, colorOrder(itrial), trialOrder(itrial), response, RT, acc};
    
    %Block Break 
    if mod(itrial, trialsPerBlock) == 0
        blockScore = mean(cell2mat(allData(itrial-trialsPerBlock+1:itrial, 6)))*100;
        
        if blockScore == 100
            blockMessage = 'Great Job! Keep it up!';
        else
            blockMessage = 'Try to improve on the next block!';
        end
        
        newBlockRT = nanmean(cell2mat(allData(itrial-trialsPerBlock+1:itrial, 5)));
        if newBlockRT > oldBlockRT
            RTmessage = 'You were SLOWER on this block than the last block';
        elseif newBlockRT < oldBlockRT
            RTmessage = 'You were FASTER on this block than the last block';
        end
        
        Screen('TextSize', window, 36);
        DrawFormattedText(window, ['Block Score: ' num2str(blockScore) '%'], 'center', yCenter-200, white);
        DrawFormattedText(window, blockMessage, 'center', yCenter-100, white);
        
        if block >1
            DrawFormattedText(window, RTmessage, 'center', yCenter-10, white);
        end
        
        DrawFormattedText(window, 'Take a short break.', 'center', yCenter+100, white);
        Screen('Flip', window, [], 1);
        WaitSecs(15); %Wait at least X seconds before they're allowed to move on
        DrawFormattedText(window, 'Press ANY KEY to continue.', 'center', yCenter+300, white);
        Screen('Flip', window);
        WaitSecs(.5);
        KbWait;
        Screen('DrawLines', window, allCoords,...
            lineWidthPix, white, [xCenter, yCenter], 2);
        Screen('TextSize', window, 28)
        DrawFormattedText(window, '1=RED      2=YELLOW      3=GREEN      4=BLUE', 'center', yCenter+400, white);
        Screen('Flip', window);
        WaitSecs(2);
        
        oldBlockRT = newBlockRT;
        block = block +1;
        
        WaitSecs(ITI);
    end
    
    
end
endTime= clock;

%--------------------------------------------------------------------------
%                          Feedback
%--------------------------------------------------------------------------
score = (sum(cell2mat(allData(:, 6)))/trials)*100;

Screen('TextSize', window, 48); %Font size
DrawFormattedText(window, ['Score: ' num2str(score) '%'], ...
            'center', yCenter-100, white);
DrawFormattedText(window, 'Task complete. Thank you!', 'center', 'center', white);
% if score >= 90
%     message = 'Great Job! Keep it up!';
% else
%     message = 'Try to do better next time!';
% end
% DrawFormattedText(window, message, 'center', 'center', white);

Screen('Flip', window);
WaitSecs(5);

%--------------------------------------------------------------------------
%                          Save Data
%--------------------------------------------------------------------------
allData{1, 7} = startTime(4:6);%Start time
allData{1, 8} = startTime(1:3); %Date
allData{trials, 7} = endTime(4:6); %End time 
        
save(fullfile(taskFolder, ['run' num2str(run) '.mat']), 'allData');


sca;
end
