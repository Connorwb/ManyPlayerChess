function playGame(choice, closefig)
    close(closefig);
    if choice == 2
        %reading an excel file
        %promotedPawns are on the first page - it will be read/wrote differently
        [filename, mypath] = uigetfile('.xlsx'); %<SM:READ>
        filename = [mypath, filename];
        fprintf('Reading ... ');
        boards(:, :, 1) = xlsread(filename, 1);
        [~, sheets] = xlsfinfo(filename);
        players = size(sheets, 2);
        if size(boards, 1) == 9
            promotedPawns = boards(9, 2:size(boards, 2, 1));
            promotedPawns(promotedPawns == 0) = [];
        else
            promotedPawns = [];
        end
        for n = 2:1:players %<SM:FOR>
            boards(:, :, n) = xlsread(filename, n);
        end
        boards(:, :, 1) = boards(1:8, 1:4, 1);
        fprintf('Done.\n');
    else
        players = input('How many players are there? (2-9)', 's');
        players = str2double(players);
        while isnan(players) || isempty(players) || players < 2 || mod(players, 1) ~= 0
            if players < 2
                fprintf('There must be 2 or more players. Please note the game may be buggy with 2 players right now.\n');
            else
                fprintf('Invalid input.\n');
            end
            players = input('How many players are there? ', 's');
            players = str2double(players);
        end
        boards = zeros(8, 4, players); %NOTE: ARRAY INDEXES START AT 1!!!
        for setup = 1:players %only king and rook set up for now
            promotedPawns = [];
            boards(5, 1, setup) = 1 + ((setup -1)*16); %<SM:REF> % King's ID is 1
            boards(4, 1, setup) = 2 + ((setup -1)*16); % Queen's ID is 2
            boards(1, 1, setup) = 3 + ((setup -1)*16); % Rook A's ID is 3
            boards(8, 1, setup) = 4 + ((setup -1)*16); % Rook B's ID is 4
            boards(3, 1, setup) = 5 + ((setup -1)*16); % Bishop A's ID is 5
            boards(6, 1, setup) = 6 + ((setup -1)*16); % Bishop B's ID is 6
            boards(2, 1, setup) = 7 + ((setup -1)*16); % Knight A's ID is 7
            boards(7, 1, setup) = 8 + ((setup -1)*16); % Knight B's ID is 8
            for n = 9:1:16
               boards(n-8, 2, setup) = n + ((setup -1)*16); %Pawns have IDs 9-16 
            end
        end %Replacing the arrays with objects would allow for more variability.
    end

    points = zeros([1, players]);
    colors = [0 0 0; 0 0 0];
    for setup = 1:players %set up random colors for GUI    
        r = rand([1,3]); %<SM:RANDGEN>
        colors(setup, :) = r; %<SM:AUG>
    end
    supercolors = ones([(players*16)+1, 3]);
    for setup = 1:players
        for n = 1:1:16
            supercolors(1+n+((setup-1)*16), :) = colors(setup, :); %<SM:SLICE>
        end
    end

    kingsExist = players;
    dimensions = ceil(sqrt(players+1));
    while kingsExist >= 2 %<SM:ROP> %<SM:WHILE>
        for turn = 1:players
            %Todo : list available
            pLowRange = 1 + ((turn-1)*16);
            pHighRange = 16 + ((turn-1)*16);
            fprintf('player %d, what piece do you want to move? (give an ID number between %.0f and %.0f)', turn, pLowRange, pHighRange);
            mover = input('', 's');
            mover = str2double(mover); %<SM:PDF_PARAM>
            while isempty(mover) || isnan(mover) || mover < 1 || mod(mover,1) ~= 0%<SM:BOP>
                %this allows for moving pieces outside the player's control,
                %for debug purposes.
                fprintf('Invalid input.\n');
                fprintf('player %d, what piece do you want to move? (give an ID number between %.0f and %.0f)', turn, pLowRange, pHighRange);
                mover = input('', 's');
                mover = str2double(mover); %<SM:PDF_PARAM>
            end
            movesArray = possible(boards, mover, players); %<SM:PDF_CALL>
            while strcmpi('none', movesArray(1, :)) %<SM:STRING>
                fprintf('that piece has no valid moves.\n');
                fprintf('player %d, what piece do you want to move? (give an ID number between %.0f and %.0f)', turn, pLowRange, pHighRange);
                mover = input('', 's');
                mover = str2double(mover);
                while isempty(mover) || isnan(mover) || mover < 1 || mod(mover,1) ~= 0
                    %this allows for moving pieces outside the player's control,
                    %for debug purposes.
                    fprintf('Invalid input.\n');
                    fprintf('player %d, what piece do you want to move? (give an ID number between %.0f and %.0f)', turn, pLowRange, pHighRange);
                    mover = input('', 's');
                    mover = str2double(mover); 
                end
                movesArray = possible(boards, mover, players);
            end
            %Make sure to add promotions!
            [possMoves, ~] = size(movesArray); %<SM:PDF_RETURN>
            %Get number of possible moves
            for ind = 1:(possMoves-1) %<SM:NEST>
                fprintf(movesArray(ind, :));
                fprintf(', ');
            end
            fprintf(movesArray(possMoves, :));
            fprintf('\n');
            m = input('which space do you want to move to? (type the # in the order shown)');
            moveto = movesArray(m,:);

            %actually updates the game board
            [boards, pChange, Player] = gameUpdate(boards,mover,moveto);  

            points(Player) = points(Player) + pChange;
            %testpr = flip(boards(:,:,turn)') %the way boards are printed right now. This will be removed.
            if sum(points) > 0
                subplot(dimensions, dimensions, 1);
                piegraph = pie(points); %<SM:PLOT>
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
                        %<SM:SWITCH> see in getName()
                        textHandles(j,i) = text(j,i,char(getName(boards(j,5-i,n)), num2str(boards(j,5-i,n))),'horizontalAlignment','center');
                    end
                end
            end
        end
    end
end
