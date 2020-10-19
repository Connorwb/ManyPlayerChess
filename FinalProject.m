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
%}
clear;
clc;

players = input('How many players are there?');
colors = ['000000'; '000000'];
for setup = 1:players %set up random colors for GUI
    r = randi([0, 16777215]); %<SM:RANDGEN>
    r = dec2hex(r);
    for cloop = (strlength(r)+1):1:6
        r(cloop) = '0';
    end
    colors(setup, :) = r; %<SM:RANDUSE>
end
boards = zeros(8, 4, players); %NOTE: ARRAY INDEXES START AT 1!!!
for setup = 1:players %only king and rook set up for now
    boards(5, 1, setup) = 1 + ((setup -1)*16); % King's ID is 1
    boards(1, 1, setup) = 3 + ((setup -1)*16); % Rook A's ID is 3;
end
kingsExist = players;
while 1 %kingsExist >= 2 %<SM:ROP>
    for turn = 1:players
        %Todo : list available
        fprintf('player %d, what piece do you want to move? (give ID number)', turn);
        fprintf('\n(for now, try moving player 1''s king horizontally- its ID is 1.) ');
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
        boards = gameUpdate(boards,mover,moveto); %actually updates the board in memory
        boards(:,:,turn) %the way boards are printed right now. This will be removed.
    end
    kingsExist = 0; %force exit until win conditions are made.
end
