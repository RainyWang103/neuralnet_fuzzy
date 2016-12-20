function speed(action)
global h A
switch(action)
case 'speed',
    if h == 0.1
        h = 0.05;
        A = strvcat('medium');
    elseif h == 0.05
        h = 0.02;
        A = strvcat('slow');
    elseif h == 0.02
        h = 0.01;
        A = strvcat('very slow');    
    elseif h == 0.01
        h = 0.5;
        A = strvcat('very fast');
    elseif h == 0.5
        h = 0.1;
        A = strvcat('fast');
    end   
otherwise,
    h = h;
    A = A;
end