%https://www.mathworks.com/matlabcentral/answers/41238-turning-numbers-into-letters-based-on-alphabetical-order
%https://www.mathworks.com/matlabcentral/answers/2653-about-null-values
function moves = possible(boards, mover, players)
    ableMoves = ['none';'none'];
    totalMoves = 0;
    pstart = floor(mover/16);
    iter = 0;
    row = 0;
    col = 0; 
    while isempty(col) || (col == 0) %<SM:BOP>
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
            totalMoves = totalMoves + 1;
            ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col-2)), num2str(row)];
            if row ~= 1 %can the king move southwest?
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col-2)), num2str(row-1)];
            end
            if row == 4 %northwest on the edge
                    if col == 5 %from e4 to other player's e4
                        totalMoves = totalMoves + 2;
                        ableMoves(totalMoves - 1, :) = ['P', num2str(uiter), 'E', '4'];
                        ableMoves(totalMoves, :) = ['P', num2str(diter), 'E', '4'];
                    elseif col > 5 
                        totalMoves = totalMoves + 1;
                        ableMoves(totalMoves, :) = ['P', num2str(uiter), char('A'+(9-col)), '4'];
                    else
                        totalMoves = totalMoves + 1;
                        ableMoves(totalMoves, :) = ['P', num2str(diter), char('A'+(9-col)), '4'];
                    end
            else %northwest
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col-2)), num2str(row+1)];
            end
        end
        if col ~= 8 %can the king move right?
            totalMoves = totalMoves + 1;
            ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col)), num2str(row)];
            if row ~= 1 %can the king move southeast?
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col)), num2str(row-1)];
            end
            if row == 4 %northeast on the edge
                    if col == 4 %from d4 to other player's d4
                        totalMoves = totalMoves + 2;
                        ableMoves(totalMoves - 1, :) = ['P', num2str(uiter), 'D', '4'];
                        ableMoves(totalMoves, :) = ['P', num2str(diter), 'D', '4'];
                    elseif col > 4
                        totalMoves = totalMoves + 1;
                        ableMoves(totalMoves, :) = ['P', num2str(uiter), char('A'+(7-col)), '4'];
                    else
                        totalMoves = totalMoves + 1;
                        ableMoves(totalMoves, :) = ['P', num2str(diter), char('A'+(7-col)), '4'];
                    end
            else %northeast
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col)), num2str(row+1)];
            end
        end
        if row ~= 1 %can the king move back?
            totalMoves = totalMoves + 1;
            ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col-1)), num2str(row-1)];
        end
        if row == 4 % is the king going to be changing boards walking forward?
            totalMoves = totalMoves + 1;
            if col < 5
                ableMoves(totalMoves, :) = ['P', num2str(diter), char('A'+(col-1)), '4'];
            else
                ableMoves(totalMoves, :) = ['P', num2str(uiter), char('A'+(col-1)), '4'];
            end
        else %the king always can move forward (till I check for checks)
            totalMoves = totalMoves + 1;
            ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col-1)), num2str(row+1)];
        end
    elseif (mod(mover, 16) == 4 || mod(mover, 16) == 3) %rook movement logic 
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
        while trow < 4 && boards(col, trow + 1, iter) == 0
            trow = trow + 1;
            totalMoves = totalMoves + 1;
            ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col-1)), num2str(trow)];
        end
        if (trow < 4 || boards(col, 4, iter) ~= 0) && ~(pstart <= boards(col, trow - 1, iter) && pstart + 15 >= boards(col, trow - 1, iter)) 
            trow = trow + 1;
            totalMoves = totalMoves + 1;
            ableMoves(totalMoves, :) = ['P', num2str(iter), char('A'+(col-1)), num2str(trow)];
        else
            oiter = 0;
            if row > 4
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
                ableMoves(totalMoves, :) = ['P', num2str(oiter), char('A'+(col-1)), num2str(trow)];
                trow = trow - 1;
            end
            if trow > 0 && ~(pstart <= boards(col, trow, oiter) && pstart + 15 >= boards(col, trow, oiter))
                totalMoves = totalMoves + 1;
                ableMoves(totalMoves, :) = ['P', num2str(oiter), char('A'+(col-1)), num2str(trow)];
            end
        end
        %moving up
    elseif mod(mover, 16) > 8  %pawn movement logic
        
    end
    moves = ableMoves;
end