%https://www.mathworks.com/matlabcentral/answers/41238-turning-numbers-into-letters-based-on-alphabetical-order
%https://www.mathworks.com/matlabcentral/answers/2653-about-null-values
function moves = possible(boards, mover, players)
    ableMoves = ['none';'none'];
    totalMoves = 0;
    if mod(mover, 16) == 1 %king movement logic (todo:test)
        iter = 0;
        row = 0;
        col = 0;
        while (col == 0) || (isnan(col))  %<SM:BOP>
           %this loop finds where the king is
           iter = iter+1;
           [col, row] = find(boards(:,:,iter) == 1);
        end
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
        %todo
    end
    moves = ableMoves;
end