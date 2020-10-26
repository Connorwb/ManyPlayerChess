function chessName = getName(x)
    if x == 0
        chessName = '';
    else
        piece = mod(x,16);
        switch piece
            case 1
                chessName = 'K';
            case 2
                chessName = 'Q';
            case 3 
                chessName = 'R';
            case 4 
                chessName = 'R';
            case 5
                chessName = 'B'; %Left Bishop
            case 6
                chessName = 'B'; %Right Bishop
            case 7
                chessName = 'K';
            case 8
                chessName = 'K';
            otherwise
                chessName = 'P';
        end
    end
end