function start(action)
global t k
switch(action)
case 'start',
    t = 1; 
case 'stop',
    t = 0;    
otherwise,
    t = t;  
    k = k;
end 