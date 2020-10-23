function returnb = gameUpdate (boards, mover, newplace)
    col = 0;
    row = 0;
    iter = 0;
    while isempty(col) || (col == 0)  %this loop finds where the peice is
           iter = iter+1;
           [col, row] = find(boards(:,:,iter) == mover);
    end
    boards(col, row, iter) = 0;
    newcol = 1 + newplace(3) - 'A';
    newrow = newplace(4) - '0';
    newplayer = newplace(2) - '0';
    boards(newcol, newrow, newplayer) = mover; %out of bounds errors lead to HUGE memory changes. 
    %todo: check bounds and throw errors if needed to prevent memory problems
    returnb = boards;
end