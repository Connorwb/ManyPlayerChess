function points = alphaZeroPoints (killed)
    if killed == 0
        points = 0;
    elseif mod(killed, 16) == 0 || mod(killed, 16) > 8 % took a pawn
        points = 1;
    elseif mod(killed, 16) == 3 || mod(killed, 16) == 4 % took a rook
        points = 5.63;
    elseif mod(killed, 16) == 2 % took a queen
        points = 9.50;
    elseif mod(killed, 16) == 5 || mod(killed, 16) == 6 % took a bishop
        points = 3.33;
    else % took a knight
        points = 3.05;
    end
end