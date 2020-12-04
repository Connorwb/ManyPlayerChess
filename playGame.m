%https://www.mathworks.com/company/newsletters/articles/introduction-to-object-oriented-programming-in-matlab.html
function playGame(choice, closebox, players)
    scrsz = get(groot,'ScreenSize');
    scrsz(4) = scrsz(4)*.95;
    mainboard = figure('Position', scrsz);
    set(mainboard, 'MenuBar', 'none');
    set(mainboard, 'NumberTitle', 'off');
    set(mainboard, 'Name', 'Infinichess');
    if choice == 2
        %reading an excel file
        %promotedPawns are on the first page - it will be read/wrote differently
        [filename, mypath] = uigetfile('.xlsx'); %<SM:READ>
        filename = [mypath, filename];
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
        close(closebox);
    else
        close(closebox);
        
        %{
        %old input code
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
        %}
        
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
    
    bpointer(1) = libpointer('voidPtr',boards(:,:,1));%pointer to get around annoying GUI problems.
    %hopefully this doesn't count as a global variable
    for n = 2:1:players
        bpointer(n) = libpointer('voidPtr', boards(:,:,n));
    end
    
    points = zeros([1, players]);
    ppointer = libpointer('voidPtr',points);
    
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
    dimensionsx = 3;
    dimensionsy = 4;
    buttonPic = imread('Selector.png');
    for n = 1:1:players
        const = .01;
        xbound = ((mod(n-1,dimensionsx))/dimensionsx)+const;
        ybound = (floor((n-1)/dimensionsx)/dimensionsy)+const;
        bgContainers{n} = axes('units', 'normalized', 'position',...
            [xbound, ybound, (1/dimensionsx)-const, (1/dimensionsy)-const]);
        boardPic = imread('Chess_Board.png');
        cbg{n} = imagesc(boardPic);
        set(bgContainers{n},'handlevisibility','off','visible','off');
        buttons{1,1,n} = uicontrol('enable','off','visible','off');
        butsizex = ((1-const)/(dimensionsx*8))-const;
        butsizey = ((1-const)/(dimensionsy*4))-const;
        for x = 1:1:8
            for y = 1:1:4
                buttons{x,y,n} = uicontrol('Style','PushButton','enable','off','visible','off','Cdata',buttonPic,'units','normalized',...
                    'String',['P',num2str(n),'A' + x - 1,num2str(y)],'Position',[xbound+((x-1)*((1)/(8*dimensionsx))),ybound+((y-1)*(1/(4*dimensionsy))),...
                    butsizex, butsizey]);
                if bpointer(n).Value(x, y) ~= 0
                    if mod(bpointer(n).Value(x, y), 16) == 1
                        imgts = imread('King.png');
                        imgts = imresize(imgts, [butsizex*scrsz(3), butsizey*scrsz(4)]); %<SM:NEWFUN>
                        imgts = myrecolor(imgts, colors(n,:));
                        set(buttons{x, y, n}, 'Cdata', imgts, 'Visible', 'on');
                    elseif mod(bpointer(n).Value(x, y), 16) == 2
                        imgts = imread('Queen.png');
                        imgts = imresize(imgts, [butsizex*scrsz(3), butsizey*scrsz(4)]);
                        imgts = myrecolor(imgts, colors(n,:));
                        set(buttons{x, y, n}, 'Cdata', imgts, 'Visible', 'on');
                    elseif mod(bpointer(n).Value(x, y), 16) == 4 || mod(bpointer(n).Value(x, y), 16) == 3
                        imgts = imread('Rook.png');
                        imgts = imresize(imgts, [butsizex*scrsz(3), butsizey*scrsz(4)]);
                        imgts = myrecolor(imgts, colors(n,:));
                        set(buttons{x, y, n}, 'Cdata', imgts, 'Visible', 'on');
                    elseif mod(bpointer(n).Value(x, y), 16) == 5 || mod(bpointer(n).Value(x, y), 16) == 6
                        imgts = imread('Bishop.png');
                        imgts = imresize(imgts, [butsizex*scrsz(3), butsizey*scrsz(4)]);
                        imgts = myrecolor(imgts, colors(n,:));
                        set(buttons{x, y, n}, 'Cdata', imgts, 'Visible', 'on');
                    elseif mod(bpointer(n).Value(x, y), 16) >  8 || mod(bpointer(n).Value(x, y), 16) == 0
                        imgts = imread('Pawn.png');
                        imgts = imresize(imgts, [butsizex*scrsz(3), butsizey*scrsz(4)]);
                        imgts = myrecolor(imgts, colors(n,:));
                        set(buttons{x, y, n}, 'Cdata', imgts, 'Visible', 'on');
                    elseif mod(bpointer(n).Value(x, y), 16) == 8 || mod(bpointer(n).Value(x, y), 16) == 7
                        imgts = imread('Knight.png');
                        imgts = imresize(imgts, [butsizex*scrsz(3), butsizey*scrsz(4)]);
                        imgts = myrecolor(imgts, colors(n,:));
                        set(buttons{x, y, n}, 'Cdata', imgts, 'Visible', 'on');
                    end
                end
            end
        end
    end
    for n = 1:1:players %Not sure if this loop outside the main nest is needed, but helps with debugging.
        for x = 1:1:8 %relocate after saving
            for y = 1:1:4
                set(buttons{x, y, n}, 'Callback',{@ValidQuery, bpointer, players, buttons, ppointer}); %bookmark
            end
        end
    end
    for x = 1:1:8
        for y = 1:1:4
            if bpointer(1).Value(x, y) ~= 0
                set(buttons{x, y, 1}, 'enable', 'on');
            end
        end
    end
    %
    %save button here
    %
end

function ValidQuery(H,E, boards, players, buttons, ppointer)
    thiscol = H.String(3)-'A'+1;
    thisrow = str2double(H.String(4));
    thisplay = str2double(H.String(2));
    mover = boards(thisplay).Value(thiscol, thisrow);
    possarray = possible(boards, mover, players);
    turnonbut = zeros([3, size(possarray, 1)]);
    if (~strcmpi(possarray(1, 1:4), 'none'))
        for n = 1:1:players
            for x = 1:1:8
                for y = 1:1:4
                    set(buttons{x,y,n}, 'enable', 'off');
                end
            end
        end
        for n = 1:1:size(turnonbut,2)
            turnonbut(1,n) = possarray(n,3) - 'A' + 1; %convert text to xval
            turnonbut(2,n) = str2double(possarray(n,4)); %convert text to yval
            turnonbut(3,n) = str2double(possarray(n,2)); %convert text to playernum
            set(buttons{turnonbut(1,n), turnonbut(2,n), turnonbut(3,n)}, 'visible', 'on', 'enable', 'on',...
                'Callback', {@gameUpdate, boards, mover, buttons{turnonbut(1,n), turnonbut(2,n), turnonbut(3,n)}.String,...
                buttons{thiscol, thisrow, thisplay}, buttons{turnonbut(1,n), turnonbut(2,n), turnonbut(3,n)},...
                ppointer});
        end
        set(buttons{thiscol, thisrow, thisplay}, 'enable', 'on', 'Callback', {@myuiresume});
    else
        set(buttons{thiscol,thisrow,thisplay}, 'enable', 'off');
    end
    uiwait(); %pause till the go-ahead is given after a button is pressed
    buttonSelPic = imread('Selector.png');
    set(buttons{thiscol,thisrow,thisplay}, 'visible', 'off', 'enable', 'off', 'enable', 'off',...
        'Callback', {});
    for n = 1:1:size(turnonbut,2)
        if (buttons{turnonbut(1,n), turnonbut(2,n), turnonbut(3,n)}.CData(24, 21, 1) == buttonSelPic(24, 21, 1) && buttons{turnonbut(1,n), turnonbut(2,n), turnonbut(3,n)}.CData(24, 21, 3) == buttonSelPic(24, 21, 3))
            set(buttons{turnonbut(1,n), turnonbut(2,n), turnonbut(3,n)}, 'visible', 'off', 'enable', 'off',...
                'Callback', {});
        else
            set(buttons{turnonbut(1,n), turnonbut(2,n), turnonbut(3,n)}, 'Callback', {@ValidQuery, boards, players, buttons, ppointer});
        end
    end
    passTurn(buttons, players, boards);
end
function passTurn(buttons, players, bpointer)
    %
    % Check how many kings exist
    %
    yourTurn = 0;
    tester = 0;
    truecoords = zeros([1,3]);
    while truecoords(1) == 0
        tester = tester +1;
        for x = 1:1:8
            for y = 1:1:4
                if strcmpi(buttons{x,y,tester}.Enable, 'on')
                    truecoords = [x,y,tester];
                end
            end
        end
    end
    yourTurn = ceil((bpointer(truecoords(3)).Value(truecoords(1), truecoords(2)))/16);
    if yourTurn == players
        yourTurn = 1;
    else
        yourTurn = yourTurn + 1;
    end
    %
    %use bpointer stuff! glitches. 
    %
    for x = 1:1:8
        for y = 1:1:4
            if bpointer(yourTurn).Value(x, y) ~= 0
                set(buttons{x, y, yourTurn}, 'enable', 'on');
            end
        end
    end
    set(buttons{truecoords(1), truecoords(2), truecoords(3)}, 'visible', 'on', 'enable', 'off');
    %
    %pie graph here
    %
end
function myuiresume(H, E)
    uiresume();
end
function retimage = myrecolor(inpimage, colors)
    for nn = 1:1:3
        inpimage(:,:,nn) = inpimage(:,:,nn) * colors(nn);
    end
    retimage = inpimage;
end
%{    
    
    while kingsExist >= 2 %<SM:ROP> %<SM:WHILE>
        
        
        for turn = 1:players
            
            
            
            %{
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
            %}
            
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
            for n = 1:1:players
                for x = 1:1:8
                    for y = 1:1:4
                        if strcmpi(buttons{x, y, n}.String, mover)
                            buttonfrom = buttons{x, y, n};
                        elseif strcmpi(buttons{x, y, n}.String, moveto)
                            buttonto = buttons{x, y, n};
                        end
                    end
                end
            end
            [boards, pChange, Player] = gameUpdate(boards,mover,moveto,buttonfrom,buttonto);  

            points(Player) = points(Player) + pChange;
            %testpr = flip(boards(:,:,turn)') 
            if sum(points) > 0
                subplot('Position', [0, (dimensionsy-1)/dimensionsy, 1/dimensionsx, 1/dimensionsy]);
                piegraph = pie(points); %<SM:PLOT>
                patchHand = findobj(piegraph, 'Type', 'Patch');
                set(patchHand, {'FaceColor'}, mat2cell(colors, ones(size(colors,1),1), 3))
            end
            
            %{
            %Old display board
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
            %}
        end
    end
end
%}