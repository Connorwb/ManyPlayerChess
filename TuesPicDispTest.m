clc
clear
close all

z = imread('test.jpg');

L2R = 0

W = .05
H = .05

for x = 1:10
    B2T = 0
        L2R = L2R + 0.075;
    for y = 1:10

    B2T = B2T + 0.075;
    
    XY = [num2str(x),' ',num2str(y)]
    
    buttons{x,y} = uicontrol('Style','PushButton','enable','on','visible','on','Cdata',z,'units','normalized','String',XY,'Position',[L2R B2T W H]);
    
    end
end

for x = 1:10

    for y = 1:10

 
    
    set(buttons{x,y},'Callback',{@PressButton,buttons});
    
    end
end




function PressButton(H,E,buttons)

H
buttons
ZZZZ = H.String

ZZZZ2 = get(H,'String')

TEST2 = imread('pexels-sebastian-voortman-411207.jpg');

set(H,'Cdata',TEST2)

set(buttons{1,1},'Cdata',TEST2)


end