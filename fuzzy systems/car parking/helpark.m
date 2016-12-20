function helpark(action)
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