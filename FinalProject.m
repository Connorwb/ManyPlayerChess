%{
Connor Bramhall
email: bramhalc@my.erau.edu
date: 9/21/2020
EGR 115 - Section 15DB
Assignment: Final Project V0.1
Program Description: My final project will be a program that allows any
number of people to play chess with a custom GUI. The first draft is a
proof of concept with only basic infrastructure setup, with all interaction
done in the command window.
Worked With: Online references are commented at the start of function
files, or below here if they were used in the main script.
https://www.mathworks.com/matlabcentral/answers/515880-how-can-i-change-the-colours-of-segmentation-on-a-chart-pie
%https://www.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/15877/versions/3/previews/html/heatmapdemo.html
%}
clear;
clc;
close all;

players = input('How many players are there?');
colors = [0 0 0; 0 0 0];
for setup = 1:players %set up random colors for GUI    
    r = rand([1,3]); %<SM:RANDGEN>
    colors(setup, :) = r;
end
supercolors = ones([(players*16)+1, 3]);
for setup = 1:players
    for n = 1:1:16
        supercolors(1+n+((setup-1)*16), :) = colors(setup, :);
    end
end
points = zeros([1, players]);
boards = zeros(8, 4, players); %NOTE: ARRAY INDEXES START AT 1!!!
for setup = 1:players %only king and rook set up for now
    boards(5, 1, setup) = 1 + ((setup -1)*16); % King's ID is 1
    boards(1, 1, setup) = 3 + ((setup -1)*16); % Rook A's ID is 3
    boards(8, 1, setup) = 4 + ((setup -1)*16); % Rook B's ID is 4
    for n = 9:1:16
       boards(n-8, 2, setup) = n + ((setup -1)*16); %Pawns have IDs 9-16 
    end
end
kingsExist = players;
dimensions = ceil(sqrt(players+1));
while 1 %kingsExist >= 2 %<SM:ROP>
    for turn = 1:players
        %Todo : list available
        fprintf('player %d, what piece do you want to move? (give ID number)', turn);
        mover = input('');
        movesArray = possible(boards, mover, players); %<SM:BOP> 
        [possMoves, ~] = size(movesArray); %Get number of possible moves
        for ind = 1:(possMoves-1) %<SM:NEST>
            fprintf(movesArray(ind, :));
            fprintf(', ');
        end
        fprintf(movesArray(possMoves, :));
        fprintf('\n');
        m = input('which space do you want to move to? (type the # in the order shown)');
        moveto = movesArray(m,:);
        [boards, pChange, Player] = gameUpdate(boards,mover,moveto); %actually updates the board in memory
        points(Player) = points(Player) + pChange;
        %testpr = flip(boards(:,:,turn)') %the way boards are printed right now. This will be removed.
        if sum(points) > 0
            subplot(dimensions, dimensions, 1);
            piegraph = pie(points); 
            patchHand = findobj(piegraph, 'Type', 'Patch');
            set(patchHand, {'FaceColor'}, mat2cell(colors, ones(size(colors,1),1), 3))
        end
        for n = 1:1:players
            subplot(dimensions, dimensions, n+1); 
            imagesc(flip(boards(:,:,n)'), [0,(16*players)]);
            colormap(supercolors);%<SM:RANDUSE>
            textHandles = zeros([4,8]);
            for i = 1:4 
                for j = 1:8
                    textHandles(j,i) = text(j,i,char(getName(boards(j,5-i,n)), num2str(boards(j,5-i,n))),'horizontalAlignment','center');
                end
            end
        end
    end
    kingsExist = 0; %force exit until win conditions are made.
end
