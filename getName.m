function chessName = getName(x)
    piece = mod(x,16);
    switch piece
        case 1
            chessName = 'King';
        case 2
            chessName = 'Queen';
        case 3 
            chessName = 'Rook A';
        case 4 
            chessName = 'Rook B';
        case 5
            chessName = 'Black Bishop'; %Left Bishop
        case 6
            chessName = 'White Bishop'; %Right Bishop
        otherwise
            chessName = 'Invalid';
            fprintf('Error 1: Bad piece ID');
    end
end