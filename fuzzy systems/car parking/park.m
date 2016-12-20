function fig = park(init_state,outfile)
% park([x y phi],outfile)
% Version 2003
% Input Arguments:
% x,y = initial position of midpt of the back side of the car
% phi = orientation of the car
% outfile is a string variable containing the name of a file for outputting data.
% e.g. If you type the command:
% > park([10 30 -45],'iodata')
% a window will pop up showing a car placed at initial position (x,y)=(10,30) 
% with front facing northeast direction. Results are written to the file 'iodata.mat'
%
% The program simulates and animates the backward motion of a car. You can steer
% the angle 'theta' of front wheel of the car in 'manual' mode by clicking the
% 'left' or 'right' buttons in the animation window using the mouse. The variables
% x, y, phi and theta are displayed to the right of the animation window while
% the car is moving along its trajectory. The program can be switched to an
% 'auto' mode under the control of a fuzzy system stored in a file named
% 'parkcar.fis'.
%  
% There are 5 possible settings of speed: very slow; slow, medium, fast & very fast.
% You may set the speed by clicking on the speed button to cycle through the settings. 
%
%
% If the car is parked successfully (i.e. the final x position is within +/-2 and the
% orientation is within +/-20 degrees from the vertical, the outcome 'Success' will be
% displayed.
% Otherwise, if the car crashes into the walls surrounding the displayed area, the
% message 'Crashed' will be displayed. If the car is parked successfully, the data
% can be saved to the output file specified. If the file does not exist, it will be
% created. If it does exist, current data will be appended to old data stored
% in 'outfile' without deleting them.

% File name for this program: park.m
% Written by H.B. Chan Nov 2000; modified 23/10/2001;
% Last modified by Y.S. Hung 8/11/2003.

load park

%----------------------------------------------------------------------------------
global k h x y o t result sa n A
sa = 0;						    % initial value of manual steering
x = init_state(1);              % get the input parameters of initial position
y = init_state(2);
o = init_state(3)-90;  
result = [];				    % empty matrix for storing the result
k = 1;						    % k = 1, program runs, k = 0 ,program terminated
h = 0.02;						% h defines the step size of the car, i.e. speed
deltaT=0.01;                    % real time (in sec) for one iteration through simulation loop
s = 0;						    % initial value of fuzzy control steering
t = 0;						    % parameter to pause (t = 0) or to restore (t = 1) car motion	
A = strvcat('slow');		    % A is the string to show status of speed, fast/slow, (default is slow)
loop_num = 1;                   % count number of loops
takesample = 50;                % take only one sample for every 50 loops (to reduce amount of data)
i=0;                            % index for input data in iodata, initial value is 0
iodata = [];                    % initial iodata
%----------------------------------------------------------------------------------
%Define the graphical interface                        

h0 = figure('Color',[0.8 0.8 0.8], ...
	'Colormap',mat0, ...
	'FileName','C:\NewFuzzy\park1.m', ...
	'PaperPosition',[18 180 576 432], ...
	'PaperUnits','points', ...
	'Position',[234 107 560 438], ...
	'Tag','Fig1', ...
	'ToolBar','none');
h1 = axes('Parent',h0, ...
	'CameraUpVector',[0 1 0], ...
	'CameraUpVectorMode','manual', ...
	'Color',[1 1 1], ...
	'ColorOrder',mat1, ...
	'DataAspectRatioMode','manual', ...
	'NextPlot','add', ...
	'PlotBoxAspectRatio',[40 40 1], ...
	'PlotBoxAspectRatioMode','manual', ...
	'Position',[0.0625 0.2261904761904762 0.5625 0.7404761904761905], ...
	'Tag','Axes1', ...
	'WarpToFill','off', ...
	'WarpToFillMode','manual', ...
	'XColor',[0 0 0], ...
	'XLim',[-20 20], ...
	'XLimMode','manual', ...
	'YColor',[0 0 0], ...
	'YLim',[0 40], ...
	'YLimMode','manual', ...
	'ZColor',[0 0 0], ...
	'ZLimMode','manual');
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[-0.127388535031848 -2.99363057324841 283.3869031963126], ...
	'Tag','Axes1Text4', ...
	'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[-23.18471337579618 19.80891719745224 283.3869031963126], ...
	'Rotation',90, ...
	'Tag','Axes1Text3', ...
	'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Position',[-24.5859872611465 42.35668789808918 283.3869031963126], ...
	'Tag','Axes1Text2', ...
	'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[-0.127388535031848 40.82802547770702 283.3869031963126], ...
	'Tag','Axes1Text1', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
h2 = line('Parent',h1, ...
	'Color',[0 0 1], ...
	'EraseMode','xor', ...
	'Tag','Axes1Line6', ...
	'XData',mat2, ...
	'YData',[28 32 32 28 28]);
h2 = line('Parent',h1, ...
	'Color',[0 0 1], ...
	'EraseMode','xor', ...
	'Tag','Axes1Line5', ...
	'XData',[-9.100000000000014 -9.100000000000014 -7.100000000000014 -7.100000000000014 -9.100000000000014], ...
	'YData',[27.75 28.25 28.25 27.75 27.75]);
h2 = line('Parent',h1, ...
	'Color',[0 0 1], ...
	'EraseMode','xor', ...
	'Tag','Axes1Line4', ...
	'XData',[-9.100000000000014 -9.100000000000014 -7.100000000000014 -7.100000000000014 -9.100000000000014], ...
	'YData',[31.75 32.25 32.25 31.75 31.75]);
h2 = line('Parent',h1, ...
	'Color',[0 0 1], ...
	'EraseMode','xor', ...
	'Tag','Axes1Line3', ...
	'XData',[-5.100000000000014 -5.100000000000014 -3.100000000000014 -3.100000000000014 -5.100000000000014], ...
	'YData',[27.75 28.25 28.25 27.75 27.75]);
h2 = line('Parent',h1, ...
	'Color',[0 0 1], ...
	'EraseMode','xor', ...
	'Tag','Axes1Line2', ...
	'XData',[-5.100000000000014 -5.100000000000014 -3.100000000000014 -3.100000000000014 -5.100000000000014], ...
	'YData',[31.75 32.25 32.25 31.75 31.75]);
h2 = line('Parent',h1, ...
	'Color',[0 0 1], ...
	'EraseMode','xor', ...
	'Tag','Axes1Line1', ...
	'XData',[-7.100000000000014 -7.100000000000014 -3.100000000000014 -3.100000000000014 -7.100000000000014], ...
	'YData',[28.66666666666667 31.33333333333333 31.33333333333333 28.66666666666667 28.66666666666667]);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'Callback','start stop', ...
	'ListboxTop',0, ...
	'Position',[176.25 26.25 45 15], ...
	'String','stop', ...
	'Tag','Pushbutton1');
closeh = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'Callback','close(gcbf)', ...
	'ListboxTop',0, ...
	'Position',[326.25 26.25 45 15], ...
	'String','close', ...
	'Tag','Pushbutton2');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'Callback','helpark info', ...
	'ListboxTop',0, ...
	'Position',[276.25 26.25 45 15], ...
	'String','info', ...
	'Tag','Pushbutton3');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'Callback','steer right', ...
	'ListboxTop',0, ...
	'Position',[126.25 26.25 45 15], ...
	'String','right', ...
	'Tag','Pushbutton6');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'Callback','steer left', ...
	'ListboxTop',0, ...
	'Position',[76.25 26.25 45 15], ...
	'String','left', ...
   'Tag','Pushbutton7');
%----------------------------------------------------------------------------------
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontWeight','bold', ...
	'ListboxTop',0, ...
	'Position',[286.5 115.5 90 15], ...
	'String','Outcome', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontWeight','bold', ...
	'ListboxTop',0, ...
	'Position',[286.5 155.5 90 15], ...
	'String','Orientation', ...
	'Style','text', ...
	'Tag','StaticText2');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontWeight','bold', ...
	'ListboxTop',0, ...
	'Position',[286.5 195.5 90 15], ...
	'String','Y - Position', ...
	'Style','text', ...
	'Tag','StaticText3');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontWeight','bold', ...
	'ListboxTop',0, ...
	'Position',[286.5 235.5 90 15], ...
	'String','X-Position', ...
	'Style','text', ...
	'Tag','StaticText4');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontWeight','bold', ...
	'ListboxTop',0, ...
	'Position',[286.5 275.5 90 15], ...
	'String','Steer Angle', ...
	'Style','text', ...
   'Tag','StaticText5');
%----------------------------------------------------------------------------------
resulth = uicontrol('Parent',h0, ...
	'Units','points', ...
	'ListboxTop',0, ...
	'Position',[286.5 95.5 90 15], ...
   'Style','text', ...
   'String',result,...
	'Tag','StaticText6');
orie = uicontrol('Parent',h0, ...
	'Units','points', ...
	'ListboxTop',0, ...
	'Position',[286.5 135.5 90 15], ...
   'Style','text', ...
   'String',num2str(round(o)+90),...
	'Tag','StaticText7');
ypos = uicontrol('Parent',h0, ...
	'Units','points', ...
	'ListboxTop',0, ...
	'Position',[286.5 175.5 90 15], ...
   'Style','text', ...
   'String',num2str(round(y*10)/10),...
	'Tag','StaticText8');
xpos = uicontrol('Parent',h0, ...
	'Units','points', ...
	'ListboxTop',0, ...
	'Position',[286.5 215.5 90 15], ...
   'Style','text', ...
   'String',num2str(round(x*10)/10),...
	'Tag','StaticText9');
steehd = uicontrol('Parent',h0, ...
	'Units','points', ...
	'ListboxTop',0, ...
	'Position',[286.5 255.5 90 15], ...
   'Style','text', ...
   'String',num2str(round(s)),...
   'Tag','StaticText10');
%----------------------------------------------------------------------------------
mode = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'ListboxTop',0, ...
	'Position',[286.5 55.5 90 15], ...
	'String',mat3, ...
	'Style','popupmenu', ...
   'Tag','PopupMenu1', ...
   'Value',1);
% for mode('Value') = 1, manual control, if it is 2, auto mode
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'Callback','start start', ...
	'ListboxTop',0, ...
	'Position',[26.25 26.25 45 15], ...
	'String','start', ...
	'Tag','Pushbutton4');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontWeight','bold', ...
	'ListboxTop',0, ...
	'Position',[286.5 75.5 90 15], ...
	'String','Mode', ...
	'Style','text', ...
	'Tag','StaticText11');
spd = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'Callback','speed speed', ...
	'ListboxTop',0, ...
	'Position',[227.25 26.25 45 15], ...
	'String',A, ...
	'Tag','Pushbutton5');
if nargout > 0, fig = h0; end
%----------------------------------------------------------------------------------
% define axis
cla;  
axis manual;
axis equal;
axis([-20 20 0 40]);
hold on;

% Plot the initial car position

% define range of orientation
if o > 90
    o = o - 360;
elseif o < -270
    o = o + 360;
end

% calculate outline parameters of the car
car = plotb([x y (o/180*pi)], (s/180*pi), [4 8]);
   
% plot central parking line
plot([0 0],[0 40]);

% plot car in Erasemode       
aa = plot([car(1,1:5)],[car(2,1:5)]);
bb = plot([car(1,6:10)],[car(2,6:10)]);
cc = plot([car(1,11:15)],[car(2,11:15)]);
dd = plot([car(1,16:20)],[car(2,16:20)]);
ee = plot([car(1,21:25)],[car(2,21:25)]);
ff = plot([car(1,26:30)],[car(2,26:30)]);

set(aa,'EraseMode','xor');
set(bb,'EraseMode','xor');
set(cc,'EraseMode','xor');
set(dd,'EraseMode','xor');
set(ee,'EraseMode','xor');
set(ff,'EraseMode','xor');

% return values on text boxes
set(xpos,'String', num2str(round(x*10)/10));
set(ypos,'String', num2str(round(y*10)/10));
set(orie,'String', num2str(round(o)+90));
set(steehd,'String', num2str(round(s)));
set(spd,'String',A);
          
while   k == 1 & x > -20 & x < 20 & y > 0.5 & y < 40
    
    if o > 90
        o = o - 360;
    elseif o < -270
        o = o + 360;
    end
      
    if get(mode,'Value')== 1,	%manual mode
        s = sa;
    elseif get(mode,'Value')== 2,	%auto mode
   		fismat = readfis('parkcar');
	   	s = evalfis([x (o+90)], fismat);
    end
    tic; while toc < deltaT, end
 
    if t == 1  % continue 
        % take one sample for every takesample loops
        if mod(loop_num,takesample)==0 % 1st data recorded at loop_num=takesample
            i=i+1;    
       	    % loop until desire postion is obtained
   	        % tic; while toc < deltaT, end
            % delay looping time
     	    iodata(i,:) = [round(x*10)/10 round(y*10)/10 (round(o*10)/10+90) round(s*10)/10]; 
        end
        % store the results [x y o s] into iodata
        xdot = cos((o+s)/180*pi) + ((sin(s/180*pi))*(sin(o/180*pi)));     % motion of the car
        ydot = sin((o+s)/180*pi) - ((sin(s/180*pi))*(cos(o/180*pi)));
        odot = asin((2*(sin(s/180*pi)))/4);

        x = x + h*xdot;         %renew the states
        y = y + h*ydot;
        o = o - h*odot/pi*180;
        
   	    car = plotb([x y (o/180*pi)], (s/180*pi), [4 8]);
        % calculate parameters of the car
        drawnow;
        set(aa,'XData',[car(1,1:5)],'YData',[car(2,1:5)]);
        set(bb,'XData',[car(1,6:10)],'YData',[car(2,6:10)]);
        set(cc,'XData',[car(1,11:15)],'YData',[car(2,11:15)]);
        set(dd,'XData',[car(1,16:20)],'YData',[car(2,16:20)]);
        set(ee,'XData',[car(1,21:25)],'YData',[car(2,21:25)]);
        set(ff,'XData',[car(1,26:30)],'YData',[car(2,26:30)]);

        % return values on text boxes
        set(xpos,'String', num2str(round(x*10)/10));
        set(ypos,'String', num2str(round(y*10)/10));
        set(orie,'String', num2str(round(o)+90));
        set(steehd,'String', num2str(round(s)));
        set(spd,'String',A);
        drawnow;
    elseif t == 0 % bypass following commands when car moving
        while t == 0
        % Show how the steering angle changes when the car stops       
            s = sa;
          	tic; while toc < deltaT, end
            car = plotb([x y (o/180*pi)], (s/180*pi), [4 8]);
            % calculate parameters of the car
            drawnow;
     		set(aa,'XData',[car(1,1:5)],'YData',[car(2,1:5)]);
    		set(bb,'XData',[car(1,6:10)],'YData',[car(2,6:10)]);
    		set(cc,'XData',[car(1,11:15)],'YData',[car(2,11:15)]);
    		set(dd,'XData',[car(1,16:20)],'YData',[car(2,16:20)]);
    		set(ee,'XData',[car(1,21:25)],'YData',[car(2,21:25)]);
    		set(ff,'XData',[car(1,26:30)],'YData',[car(2,26:30)]);

          	%return values on text boxes
    		set(xpos,'String', num2str(round(x*10)/10));
    		set(ypos,'String', num2str(round(y*10)/10));
    		set(orie,'String', num2str(round(o)+90));
            set(steehd,'String', num2str(round(s)));
            set(spd,'String', A);
    		drawnow;
        end
    end
    
loop_num = loop_num + 1;
end 

% check how the car was parked
if x > -2 & x < 2 & y > -1 & y < 1 & o > -100 & o < -80 
   result = 'Success';
elseif x > -18 & x < 18 & y > 1 & y < 38
   result = 'Car Stopped';
else
   result = 'Crashed';
end

% return string of result to result text box 
set(resulth,'String', result);

% If the result is success, store the result, otherwise ignore the result
if strcmp(result,'Success'); 
   filname = [outfile  '.mat'];
   fid = fopen(filname,'r+');
   y=1;n=0;
   % If file already exists, add results to join the previous results
   % If it does not exist, create one
   if fid ~= -1
      sans = input('Save data in existing file? y/n ');
      if sans == 1
          iodata1 = iodata;
          eval(['load ' outfile ' iodata ']);
          iodata = [iodata1; iodata];
          eval([' save ' outfile ' iodata ']);
      elseif sans == 0
          disp('File not saved');
      end
   elseif fid == -1
      sans = input('Save data? y/n ');
      if sans == 1
          eval([' save ' outfile ' iodata ']);
      elseif sans == 0
          disp('File not saved');
      end
   end
end

disp('Press any key to continue');
pause;close(gcf);

%----------------------------------------------------------------------------------
function helpark(action) % stored in file helpark.m
switch(action)
case 'info',
    
  ttlStr='park([x y phi],outfile)';
    hlpStr= ...                                              
       {'Version 2003'
       'Input Arguments:'
       'x,y = initial position of midpt of the back side of the car'
       'phi = orientation of the car'
       'outfile = string containing the file name for outputting data.'
       '   '
        'This program simulates the backward motion of a car. The back'
        'of the car should be parked at the origin facing the y-axis.'
        'You can steer the front wheel of the car by clicking the buttons'
        '''left'' or ''right''. You should steer the front wheels to an angle ready '
        'to move before starting the car.'
        '  '
        'There are 5 speed modes: very slow, slow, medium, fast & very fast. You'
        'can change the speed by clicking the button to cycles among the 5 modes.'
        '  '
        'If the car is parked successfully, the word ''Success'' will be displayed.'
        'Otherwise, if the car crashes into the walls surrounding the displayed'
        'area, the word ''Crashed'' will be displayed.'
        'If the car is parked successfully, the data can be saved to the'
        'output file specified. If the file does not exist, it will be created.'
        'If the file already exists, new data will be appended to old date'
        'without delecting them.'};
    
    helpwin(hlpStr,ttlStr);                                
end
%----------------------------------------------------------------------------------
function [car] = plotb(state, steer_angle, car_size); % stored in file plotb.m
% [car]=plotb(state,steer_angle,car_size)
% plotb is a function to find out the outline of a car together 
% with the steered front wheels and back wheels
% inputs:
% state=[x,y,o] indicates the position (x,y) of the car and its 
%               orientation o relative to the x-axis
% steer_angle   is the angle of the front wheels relative to the
%               car's centre line
% car_size=[cw,cl] defines the width and length of the car
hold on;
carxy = [state(1,1) state(1,2)]';
cw = car_size(1); 
cl = car_size(2);
x = state(1,1);
y = state(1,2);
caror = state(1,3) + pi/2;   % +pi/2 because different definition of orientation between the MATLAB system and the source
frontleftwheelcen = [-cw/2; 3*(cl/4)];
frontrightwheelcen = [cw/2; 3*(cl/4)];
backleftwheelcen = [-cw/2; cl/4];
backrightwheelcen = [cw/2; cl/4];

initcar = [-cw/2 cw/2 cw/2 -cw/2 -cw/2; cl cl 0 0 cl]; 
initcar1 = [-cw/3 cw/3 cw/3 -cw/3 -cw/3; 5*(cl/8) 5*(cl/8) cl/8 cl/8 5*(cl/8)]; 

shape = [-cw/2 cw/2 cw/2 -cw/2 -cw/2; cl/2 cl/2 -cl/2 -cl/2 cl/2]; 

%vectors of outline of a rectangle
wheel = [ shape(1,:)/8 ; shape(2,:)/4 ]; %vectors of outline of a wheel
rotwheel = rotat(wheel,steer_angle);
leftwheel = rotwheel + frontleftwheelcen*ones(1,5);
rightwheel = rotwheel + frontrightwheelcen*ones(1,5);
backleftwheel = wheel + backleftwheelcen*ones(1,5);
backrightwheel = wheel + backrightwheelcen*ones(1,5);
dum = rotat([initcar leftwheel rightwheel backleftwheel backrightwheel initcar1],caror);

car = dum + carxy*ones(1,30);
%----------------------------------------------------------------------------------
function [rxy]=rotat(xy,theta) % stored in file rotat.m

% [rxy]=rotat(xy,theta);
% 'rotat' rotates the (x,y) coordinates of N points given in
% 'xy' through an angle 'theta'
% inputs:
% xy = 2xN matrices defining the points to be rotated
% theta = angle of rotation
% output:
% rxy = 2xN matrices containing the rotated points

R=[cos(theta) -sin(theta); sin(theta) cos(theta)];
rxy=R*xy;

%----------------------------------------------------------------------------------
function start(action) % stored in file start.m
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
%----------------------------------------------------------------------------------
% function to change the steer angle  
function steer(action) % stored in file steer.m
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
%----------------------------------------------------------------------------------
 %function to change the speed 
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