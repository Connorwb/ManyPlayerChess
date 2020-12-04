%https://www.mathworks.com/matlabcentral/answers/41238-turning-numbers-into-letters-based-on-alphabetical-order
%https://www.mathworks.com/matlabcentral/answers/2653-about-null-values
function moves = possible(lazyport, mover, players)
    %TODO : import and use promoted pawns
    %TODO : Castling
    %TODO : en passant
    %TODO : fix the Knight
    boards = zeros([8,4,players]);
    for n = 1:1:players
        boards(:,:,n) = lazyport(n).Value(:,:);
    end
    ableMoves = ['none';'none'];
    totalMoves = 0;
    pstart = ((floor(mover/16))*16)+1;
    iter = 0;
    row = 0;
    col = 0; 
    while isempty(col) || (col == 0) 
       %this loop finds where the piece to move is
       iter = iter+1;
       [col, row] = find(boards(:,:,iter) == mover);   
    end
    if mod(mover, 16) == 1 %king movement logic       
        if iter == 1 % think going clockwise
           diter = players;
        else
           diter = iter -1;
        end
        if iter == players % think going counterclockwise
            uiter = 1;
        else
            uiter = iter +1;
        end
        if col ~= 1 %can the king move left?
            if ~(pstart <= boards(col-1, row, iter) && pstart + 15 >= boards(col-1, row, iter))
                %is the peice to the left empty/an enemy?
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col-2)), num2str(row)];
            end
            if row ~= 1 && ~(pstart <= boards(col-1, row-1, iter) && pstart + 15 >= boards(col-1, row-1, iter))
                %can the king move southwest?
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col-2)), num2str(row-1)];
            end
            if row == 4 %northwest on the edge
                    if col == 5%from e4 to other player's e4
                        if ~(pstart <= boards(5, 4, uiter) && pstart + 15 >= boards(5, 4, uiter))
                            totalMoves = totalMoves + 1;
                            ableMoves(totalMoves , :) = ['P', num2str(uiter), 'E', '4'];
                        end
                        if ~(pstart <= boards(5, 4, diter) && pstart + 15 >= boards(5, 4, diter))
                            ableMoves(totalMoves, :) = ['P', num2str(diter), 'E', '4'];
                        end
                    elseif col > 5 && ~(pstart <= boards(10-col, row, uiter) && pstart + 15 >= boards(10-col, row, uiter))
                        totalMoves = totalMoves + 1;
                        ableMoves(totalMoves, :) = ['P', num2str(uiter), char('A'+(9-col)), '4'];
                    elseif ~(pstart <= boards(10-col, row, iter) && pstart + 15 >= boards(10-col, row, iter))
                        totalMoves = totalMoves + 1;
                        ableMoves(totalMoves, :) = ['P', num2str(diter), char('A'+(9-col)), '4'];
                    end
            elseif ~(pstart <= boards(col-1, row+1, iter) && pstart + 15 >= boards(col-1, row+1, iter)) %northwest
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col-2)), num2str(row+1)];
            end
        end
        if col ~= 8 %can the king move right?
            if ~(pstart <= boards(col+1, row, iter) && pstart + 15 >= boards(col+1, row, iter))
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col)), num2str(row)];
            end
            if row ~= 1 && ~(pstart <= boards(col+1, row-1, iter) && pstart + 15 >= boards(col+1, row-1, iter))
                %can the king move southeast?
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col)), num2str(row-1)];
            end
            if row == 4 %northeast on the edge
                    if col == 4 %from d4 to other player's d4
                        if ~(pstart <= boards(4, 4, uiter) && pstart + 15 >= boards(4, 4, uiter))
                            totalMoves = totalMoves + 1;
                            ableMoves(totalMoves - 1, :) = ['P', num2str(uiter), 'D', '4'];
                        end
                        if ~(pstart <= boards(4, 4, diter) && pstart + 15 >= boards(4, 4, diter))
                            ableMoves(totalMoves, :) = ['P', num2str(diter), 'D', '4'];
                        end
                    elseif col > 4 && ~(pstart <= boards(8-col, 4, uiter) && pstart + 15 >= boards(8-col, 4, uiter))
                        totalMoves = totalMoves + 1;
                        ableMoves(totalMoves, :) = ['P', num2str(uiter), char('A'+(7-col)), '4'];
                    elseif ~(col > 4) && ~(pstart <= boards(8-col, 4, diter) && pstart + 15 >= boards(8-col, 4, uiter))
                        totalMoves = totalMoves + 1;
                        ableMoves(totalMoves, :) = ['P', num2str(diter), char('A'+(7-col)), '4'];
                    end
            elseif ~(pstart <= boards(col+1, row+1, iter) && pstart + 15 >= boards(col+1, row+1, iter)) %northeast
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col)), num2str(row+1)];
            end
        end
        if row ~= 1 && ~(pstart <= boards(col, row-1, iter) && pstart + 15 >= boards(col, row-1, iter))
            %can the king move back?
            totalMoves = totalMoves + 1;
            ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col-1)), num2str(row-1)];
        end
        if row == 4 % is the king going to be changing boards walking forward?
            if col < 5 && ~(pstart <= boards(9-col, row, diter) && pstart + 15 >= boards(col, row-1, iter))
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(diter), char('A'+(8-col)), '4'];
            elseif ~(col < 5) && ~(pstart <= boards(9-col, row, uiter) && pstart + 15 >= boards(9-col, row, uiter))
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(uiter), char('A'+(8-col)), '4'];
            end
        elseif ~(pstart <= boards(col, row+1, iter) && pstart + 15 >= boards(col, row+1, iter)) %the king always can move forward (till I check for checks)
            totalMoves = totalMoves + 1;
            ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col-1)), num2str(row+1)];
        end
    elseif (mod(mover, 16) == 4 || mod(mover, 16) == 3) || mod(mover, 16) == 2%rook movement logic
        tcol = col;
        while tcol > 1 && boards(tcol - 1, row, iter) == 0 %is the space to the left of the rook empty?
            tcol = tcol - 1;
            totalMoves = totalMoves + 1;
            ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(tcol-1)), num2str(row)];
        end
        if tcol > 1 && ~(pstart <= boards(tcol - 1, row, iter) && pstart + 15 >= boards(tcol - 1, row, iter))
            %is the peice to the left of the rook the player's?
            tcol = tcol - 1;
            totalMoves = totalMoves + 1;
            ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(tcol-1)), num2str(row)];
        end
        tcol = col;
        while tcol < 8 && boards(tcol + 1, row, iter) == 0 %is the space to the right of the rook empty?
            tcol = tcol + 1;
            totalMoves = totalMoves + 1;
            ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(tcol-1)), num2str(row)];
        end
        if tcol < 8 && ~(pstart <= boards(tcol + 1, row, iter) && pstart + 15 >= boards(tcol + 1, row, iter))
            %is the peice to the left of the rook the player's?
            tcol = tcol + 1;
            totalMoves = totalMoves + 1;
            ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(tcol-1)), num2str(row)];
        end
        trow = row;
        while trow > 1 && boards(col, trow - 1, iter) == 0 %is the space below the rook empty?
            trow = trow - 1;
            totalMoves = totalMoves + 1;
            ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col-1)), num2str(trow)];
        end
        if trow > 1 && ~(pstart <= boards(col, trow - 1, iter) && pstart + 15 >= boards(col, trow - 1, iter))
            %is the peice below the furthest the rook can go the player's?
            trow = trow - 1;
            totalMoves = totalMoves + 1;
            ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col-1)), num2str(trow)];
        end
        trow = row;
        while trow < 4 && boards(col, trow + 1, iter) == 0 %is the space above the rook empty?
            trow = trow + 1;
            totalMoves = totalMoves + 1;
            ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col-1)), num2str(trow)];
        end
        if (trow < 4 || (boards(col, 4, iter) ~= 0 && boards(col, 4, iter) ~= mover))&&...
                ~(pstart <= boards(col, trow + 1, iter) && pstart + 15 >= boards(col, trow + 1, iter)) 
            %is the peice above the furthest the rook can go the player's?
            trow = trow + 1;
            totalMoves = totalMoves + 1;
            ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col-1)), num2str(trow)];
        elseif trow == 4
            oiter = 0;
            if col < 5
                if iter == 1
                    oiter = players;
                else
                    oiter = iter - 1;
                end
            else
                if iter == players
                    oiter = 1;
                else 
                    oiter = iter + 1;
                end
            end
            while trow > 1 && boards(col, trow, oiter) == 0
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(oiter), char('A'+(8-col)), num2str(trow)];
                trow = trow - 1;
            end
            if trow > 0 && ~(pstart <= boards(col, trow, oiter) && pstart + 15 >= boards(col, trow, oiter))
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(oiter), char('A'+(8-col)), num2str(trow)];
            end
        end
        %moving up
    end
    if mod(mover, 16) == 5 || mod(mover, 16) == 6 || mod(mover, 16) == 2 %bishop movement logic
        if iter == 1 % think going clockwise
           diter = players;
        else
           diter = iter -1;
        end
        if iter == players % think going counterclockwise
            uiter = 1;
        else
            uiter = iter +1;
        end
        tempx = col;
        tempy = row;
        while tempx > 1 && tempy > 1 %can the bishop move southwest?
            tempx = tempx - 1;
            tempy = tempy - 1;
            if boards(tempx, tempy, iter) == 0 
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(tempx-1)), num2str(tempy)];
            elseif ~(pstart <= boards(tempx, tempy, iter) && pstart + 15 >= boards(tempx, tempy, iter))
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(tempx-1)), num2str(tempy)];
                tempx = 0;
            else
                tempx = 0;
            end
        end
        tempx = col;
        tempy = row;
        while tempx < 8 && tempy > 1 %can the bishop move southeast?
            tempx = tempx + 1;
            tempy = tempy - 1;
            if boards(tempx, tempy, iter) == 0 
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(tempx-1)), num2str(tempy)];
            elseif ~(pstart <= boards(tempx, tempy, iter) && pstart + 15 >= boards(tempx, tempy, iter))
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(tempx-1)), num2str(tempy)];
                tempx = 9;
            else 
                tempx = 9;
            end
        end
        tempx = col;
        tempy = row;
        while tempx < 8 && tempy < 4 %can the bishop move northeast?
            tempx = tempx + 1;
            tempy = tempy + 1;
            if boards(tempx, tempy, iter) == 0 
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(tempx-1)), num2str(tempy)];
            elseif ~(pstart <= boards(tempx, tempy, iter) && pstart + 15 >= boards(tempx, tempy, iter))
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(tempx-1)), num2str(tempy)];
                tempx = 9;
            else 
                tempx = 9;
            end
        end
        if (8-col + row-1) > 3 && (8-col + row-1) < 8 && tempx ~= 9
            tempx = 8-tempx;
            tempy = 4;
            if boards(tempx, tempy, uiter) == 0
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(uiter), char('A'+(tempx-1)), '4'];
                while tempx > 1 && tempy > 1 %can the bishop move southwest on the other p's board?
                tempx = tempx - 1;
                tempy = tempy - 1;
                    if boards(tempx, tempy, uiter) == 0 
                        totalMoves = totalMoves + 1;
                        ableMoves(totalMoves, :) = ['P', num2str(uiter), char('A'+(tempx-1)), num2str(tempy)];
                    elseif ~(pstart <= boards(tempx, tempy, uiter) && pstart + 15 >= boards(tempx, tempy, uiter))
                        totalMoves = totalMoves + 1;
                        ableMoves(totalMoves, :) = ['P', num2str(uiter), char('A'+(tempx-1)), num2str(tempy)];
                        tempx = 0;
                    else
                        tempx = 0;
                    end
                end
            elseif ~(pstart <= boards(tempx, tempy, uiter) && pstart + 15 >= boards(tempx, tempy, uiter))
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(uiter), char('A'+(7-tempx)), '4'];
            end
        end
        tempx = col;
        tempy = row;
        while tempx > 1 && tempy < 4 %can the bishop move northwest?
            tempx = tempx - 1;
            tempy = tempy + 1;
            if boards(tempx, tempy, iter) == 0 
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(tempx-1)), num2str(tempy)];
            elseif ~(pstart <= boards(tempx, tempy, iter) && pstart + 15 >= boards(tempx, tempy, iter))
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(tempx-1)), num2str(tempy)];
                tempx = 0;
            else
                tempx = 0;
            end
        end
        if (col + row -2) > 3 && (col + row -2) < 8 && tempx ~= 9
            tempx = 10-tempx;
            tempy = 4;
            if boards(tempx, tempy, diter) == 0
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(diter), char('A'+(tempx-1)), '4'];
                while tempx > 1 && tempy > 1 %can the bishop move southeast on the other p's board?
                tempx = tempx + 1;
                tempy = tempy - 1;
                    if boards(tempx, tempy, diter) == 0 
                        totalMoves = totalMoves + 1;
                        ableMoves(totalMoves, :) = ['P', num2str(diter), char('A'+(tempx-1)), num2str(tempy)];
                    elseif ~(pstart <= boards(tempx, tempy, diter) && pstart + 15 >= boards(tempx, tempy, diter))
                        totalMoves = totalMoves + 1;
                        ableMoves(totalMoves, :) = ['P', num2str(diter), char('A'+(tempx-1)), num2str(tempy)];
                        tempx = 0;
                    else
                        tempx = 0;
                    end
                end
            elseif ~(pstart <= boards(tempx, tempy, diter) && pstart + 15 >= boards(tempx, tempy, diter))
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(diter), char('A'+(9-tempx)), '4'];
            end
        end
    elseif mod(mover, 16) > 8 || mod(mover, 16) == 0 %pawn movement logic
        %TODO: Check if the pawn has been made a queen. Make queen movement
        %a function? ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        if iter == ceil((mover)/16)
            if  row == 2
                if boards(col, row+1, iter) == 0
                    totalMoves = totalMoves + 1;
                    ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col-1)), num2str(row+1)];
                    if boards(col, row+2, iter) == 0
                        totalMoves = totalMoves + 1;
                        ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col-1)), num2str(row+2)];
                    end
                end                
            else
                if row == 3
                    if boards(col, row+1, iter) == 0
                        totalMoves = totalMoves + 1;
                        ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col-1)), num2str(row+1)];
                    end
                else %Is the pawn on the edge of the player's board?
                    oiter = 0;
                    if col < 5
                        if iter == 1
                            oiter = players;
                        else
                            oiter = iter - 1;
                        end
                    else
                        if iter == players
                            oiter = 1;
                        else 
                            oiter = iter + 1;
                        end
                    end
                    if boards(col, row, oiter) == 0
                        totalMoves = totalMoves + 1;
                        ableMoves(totalMoves, :) = ['P', num2str(oiter), char('A'+(col-1)), '4'];
                    end
                end
            end
        else
            if boards(col, row-1, iter) == 0 
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col-1)), num2str(row-1)];
            end
            if 0 %can the pawn en passant?
                    %TODO~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                    %maybe leave "residue" after a pawn double moves, like -1.
                    %will have to account for how that effects queen/rook/bishop
            end
        end
    elseif mod(mover, 16) == 8 || mod(mover, 16) == 7 % knight movement logic
        if row > 1 %can the knight move backwards?
            if col > 2 && ~(pstart <= boards(col-2, row-1, iter) && pstart + 15 >= boards(col-2, row-1, iter))
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col-3)), num2str(row-1)];
            end
            if col < 7 && ~(pstart <= boards(col+2, row-1, iter) && pstart + 15 >= boards(col+2, row-1, iter))
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col+1)), num2str(row-1)];
            end
            if row > 2 %can the knight move 2 spaces backwards?
                if col > 2 && ~(pstart <= boards(col-1, row-2, iter) && pstart + 15 >= boards(col-1, row-2, iter))
                    totalMoves = totalMoves + 1;
                    ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col-2)), num2str(row-2)];
                end
                if col < 7 && ~(pstart <= boards(col+1, row-2, iter) && pstart + 15 >= boards(col+1, row-2, iter))
                    totalMoves = totalMoves + 1;
                    ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col)), num2str(row-2)];
                end
            end
        end
        if row > 3
            if iter == 1 % think going clockwise
               diter = players;
            else
               diter = iter -1;
            end
            if iter == players % think going counterclockwise
                uiter = 1;
            else
                uiter = iter +1;
            end
            if col > 4 
                %up 1 left 2
                %up 2 left 1
                if col < 7
                    %up 2 right 1
                    %up 1 right 2
                elseif col < 8
                    %up 2 right 1
                end
                if col == 5 || col == 6
                    if col == 5
                        %left 1 up 2
                        %left 2 up 1
                    end
                end
            else 
                %up 1 right 2
                %up 2 right 1
                if col > 2
                    %up 2 left 1
                    %up 1 left 2
                elseif col > 1
                    %up 2  right 1
                end
                if col == 3 || col == 4
                    if col == 4
                        %right 1 up 2
                        %right 2 up 1
                    end
                end
            end
        elseif row > 2
            if iter == 1 % think going clockwise
               diter = players;
            else
               diter = iter -1;
            end
            if iter == players % think going counterclockwise
                uiter = 1;
            else
                uiter = iter +1;
            end
            if col > 4 
                if col < 8 && ~(pstart <= boards(8-col, '4', uiter) && pstart + 15 >= boards(8-col, '4', uiter))
                %up 2 right 1
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(uiter), char('A'+(7-col)), '4'];
                end
                if col == 5
                    if ~(pstart <= boards(5, 4, uiter) && pstart + 15 >= boards(5, 4, uiter))
                    %up 2 left 1
                    totalMoves = totalMoves + 1;
                    ableMoves(totalMoves, :) = ['P', num2str(uiter), char('A'+(9-col)), '4'];
                    end
                    if ~(pstart <= boards(4, 4, diter) && pstart + 15 >= boards(4, 4, diter))
                        %left 1 up 2
                        totalMoves = totalMoves + 1;
                        ableMoves(totalMoves, :) = ['P', num2str(diter), char('A'+(col)), '4'];
                    end
                else
                    if col < 8 && ~(pstart <= boards(10-col, 4, uiter) && pstart + 15 >= boards(10-col, 4, uiter))
                    %up 2 left 1
                    totalMoves = totalMoves + 1;
                    ableMoves(totalMoves, :) = ['P', num2str(uiter), char('A'+(9-col)), '4'];
                    end
                end
            else
                'remove this' %Left side of the board
            end
            if col < 7 && ~(pstart <= boards(col+2, row+1, iter) && pstart + 15 >= boards(col+2, row+1, iter))
                %up 1 right 2
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col+1)), num2str(row+1)];
            end
            if col > 2 && ~(pstart <= boards(col-2, row+1, iter) && pstart + 15 >= boards(col-2, row+1, iter))
                %up 1 left 2 
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col-3)), num2str(row+1)];
            end
        else
            if col < 8 && ~(pstart <= boards(col+1, row+2, iter) && pstart + 15 >= boards(col+1, row+2, iter))
                %up 2 right 1
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col)), num2str(row+2)];
            end
            if col < 7 && ~(pstart <= boards(col+2, row+1, iter) && pstart + 15 >= boards(col+2, row+1, iter))
                %up 1 right 2
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col+1)), num2str(row+1)];
            end
            if col > 1 && ~(pstart <= boards(col-1, row+2, iter) && pstart + 15 >= boards(col-1, row+2, iter))
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col-2)), num2str(row+2)];
                %up 2 left 1
            end    
            if col > 2 && ~(pstart <= boards(col-2, row+1, iter) && pstart + 15 >= boards(col-2, row+1, iter))
                %up 1 left 2 
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col-3)), num2str(row+1)];
            end
        end
    end
    if strcmpi('none', ableMoves(2,:))
        ableMoves(2, :) = [];
    end
    moves = ableMoves;
end