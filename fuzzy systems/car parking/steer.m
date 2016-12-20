function steer(action)
global sa
switch(action)
case 'right',
    sa = sa - 2;
    if sa < -40
        sa = -40;
    end
case 'left',
    sa = sa + 2;
    if sa > 40
        sa = 40;
    end
otherwise,
    sa = sa;  
end
%---