function cb_NewGameButton(H, K, edit_box)
    playSelect = uicontrol(edit_box, 'Style', 'PopUpMenu', 'Units', 'Normalized');
    set(playSelect, 'Position', [0.22, 0.35, 0.16, 0.10], 'String', {'Number of Players','2','3','4','5','6','7','8','9'})
    set(playSelect, 'Callback', {@cb_NumPlayers, edit_box})
end
function cb_NumPlayers(H, K, edit_box) 
    if H.Value == 1
    else
        playGame(1, edit_box, H.Value)
    end
end