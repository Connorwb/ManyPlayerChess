function gameUpdate (H, E, boards, mover, newplace, frombut, tobut, ppointer)
    col = 0;
    row = 0;
    iter = 0;
    while isempty(col) || (col == 0)  %this loop finds where the peice is
           iter = iter+1;
           [col, row] = find(boards(iter).Value(:,:) == mover);
    end
    boards(iter).Value(col, row) = 0;
    newcol = 1 + newplace(3) - 'A';
    newrow = newplace(4) - '0';
    newplayer = newplace(2) - '0';
    pointGain = alphaZeroPoints(boards(newplayer).Value(newcol, newrow));
    boards(newplayer).Value(newcol, newrow) = mover; %out of bounds errors lead to HUGE memory changes. 
    playerGain = ceil(mover/16);
    ppointer.Value(playerGain) = ppointer.Value(playerGain) + pointgain;
    uiresume();
end