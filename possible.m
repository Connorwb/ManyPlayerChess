%https://www.mathworks.com/matlabcentral/answers/41238-turning-numbers-into-letters-based-on-alphabetical-order
%https://www.mathworks.com/matlabcentral/answers/2653-about-null-values
function moves = possible(boards, mover)
    ableMoves = ['test';'test'];
    totalMoves = 0;
    if mod(mover, 16) == 1 %king movement logic
        iter = 0;
        row = 0;
        col = 0;
        while (col == 0) || (isnan(col))  %<SM:BOP>
           %this loop finds where the king is
           iter = iter+1;
           [col, row] = find(boards(:,:,iter) == 1);
        end
        if col ~= 1 %can the king move left?
            totalMoves = totalMoves + 1;
            ableMoves(totalMoves, 1) = 'P';
            ableMoves(totalMoves, 2) = num2str(iter);
            ableMoves(totalMoves, 3) = char('A'+(col-2));
            ableMoves(totalMoves, 4) = num2str(row);
        end
        if col ~= 8 %can the king move right?
            totalMoves = totalMoves + 1;
            ableMoves(totalMoves, 1) = 'P';
            ableMoves(totalMoves, 2) = num2str(iter);
            ableMoves(totalMoves, 3) = char('A'+(col));
            ableMoves(totalMoves, 4) = num2str(row);
        end
    elseif (mod(mover, 16) == 4 || mod(mover, 16) == 3) %rook movement logic 
        %todo
    end
    moves = ableMoves;
end