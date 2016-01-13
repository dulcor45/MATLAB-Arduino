%% 1.Specify COM Port that arduino is connected to.
comPort = 'COM7';
%% 2. Intializes the Serial Port -- setupSerial()
if (~exist('serialFlag', 'var'))
    [upod.s,serialFlag] = setupSerial(comPort);
end

%% 3. Open a new figure - add start stop and close serial buttons
%intializes the figure we will plot in if it does not exist
if(~exist('h','var') || ~ishandle(h))
    h = figure(1);
end
%add a start/stop and close serial button inside the figure
%This button calls the 'stop_call_tempGraph' function everytime it is
%pressed
if(~exist('button', 'var'))
    button = uicontrol('Style', 'pushbutton', 'String', 'Stop',...
        'pos', [0 0 50 25], 'parent',h,...
        'Callback', 'stop_call_tempGraph','UserData',1);
end

%This button calls the 'closeSerial' function everytime it is pressed
if(~exist('button2','var'))
    button2 = uicontrol('Style','pushbutton','String', 'Close Serial Port',...
        'pos',[370 0 150 25], 'parent',h,...
        'Callback','closeSerial','UserData',1);
end


%% 4. Create the surface graphics object
% Intializes the axis if they do not exist
if(~exist('myAxes', 'var'))
    % Initializes plotting vectors
    buf_len = 500; %about 30 seconds of data
    index = 1:buf_len;
    zeroIndex = zeros(size(index));
    CO2data = zeroIndex;
    vocdata = zeroIndex;
    O3data = zeroIndex;
    NO2data = zeroIndex;
    
    limits = [0 100]; %expected range of VOC for plotting and color scaling
    limits1 = [0 800]; %expected range of CO2 for plotting and color scaling
    limits2 = [0 1200]; %Expected range of Ozone
    
    % Set the axes and select a 2D (x,z) view
    myAxes = axes('position', [0.1 0.1 0.35 0.25], 'XLim',[0 buf_len],'YLim',[0 0.1],'Zlim', limits,'CLim',limits);
    view(0,0);
    grid on;
    
    % Create surface graphics object s to display temperature data in (x,z)
    % plane, area color based on temperature readings
    %           'XData''YData'  'ZData'             'CData'
    s = surface(index, [0, 0], [CO2data; zeroIndex], [CO2data; CO2data]);
   
    % Set surface face and edges to fill with CData values, add labels
    set(s, 'EdgeColor', 'flat', 'FaceColor', 'flat', 'Parent', myAxes)
    colorbar
    title('VOCs')
    xlabel('Samples')
    zlabel('ADC Value from VOC Sensor')
    
    myAxes2 = axes('position', [0.55 0.1 0.35 0.25], 'XLim',[0 buf_len],'YLim',[0 0.1],'Zlim', limits1,'CLim',limits1);
    view(0,0);
    grid on;
    
    s1 = surface(index, [0, 0], [vocdata; zeroIndex], [vocdata; vocdata]);
    set(s1, 'EdgeColor', 'flat', 'FaceColor', 'flat', 'Parent', myAxes2)
    colorbar
    title('CO2')
    xlabel('Samples')
    zlabel('ADC Value from CO2 Sensor')
    
    myAxes3 = axes('position', [0.55 0.5 0.35 0.25], 'XLim',[0 buf_len],'YLim',[0 0.1],'Zlim', limits2,'CLim',limits2);
    view(0,0);
    grid on;
    
    s3 = surface(index, [0, 0], [O3data; zeroIndex], [O3data; O3data]);
    set(s3, 'EdgeColor', 'flat', 'FaceColor', 'flat', 'Parent', myAxes3)
    colorbar
    title('Ozone')
    xlabel('Samples')
    zlabel('ADC Value from Ozone Sensor')
    
    myAxes4 = axes('position', [0.1 0.5 0.35 0.25], 'XLim',[0 buf_len],'YLim',[0 0.1],'Zlim', limits1,'CLim',limits1);
    view(0,0);
    grid on;
    
    s4 = surface(index, [0, 0], [NO2data; zeroIndex], [NO2data; NO2data]);
    set(s4, 'EdgeColor', 'flat', 'FaceColor', 'flat', 'Parent', myAxes4)
    colorbar
    title('NO2')
    xlabel('Samples')
    zlabel('ADC Value from NO2 Sensor')
    
    set(h, 'Position', [200 200 890 660])
    drawnow;
    
end

%% 5. Runs a loop that continually reads the sensor values
% The temp sensor data is placed in the variable tc.

mode = 'T';

while(get(button, 'UserData'))
    %read temp sensor output
    [baseLineVOC, CO2, fig1, fig2,e2v_O3, e2v_NO2] = readUPODdata(upod);
    CO2 = [CO2];
    voc = [baseLineVOC];
    fig1 = [fig1];
    fig2 = [fig2];
    O3 = [e2v_O3];
    NO2 = [e2v_NO2];
    %update rolling vector. Append the new reading to the end of the
    %rolling vector data. Drop the first value
    CO2data = [CO2data(2:end), CO2];
    vocdata = [vocdata(2:end), voc];
    O3data = [O3data(2:end), O3];
    NO2data = [NO2data(2:end), NO2];
    
    
    %update plot data and corresponding color
    set(s1,'Zdata',[vocdata; zeroIndex], 'Cdata', [vocdata; vocdata])
    drawnow;
    set(s,'Zdata',[CO2data; zeroIndex], 'Cdata', [CO2data; CO2data])
    %force MATLAB to redraw the figure
    drawnow;
    set(s3,'Zdata',[O3data; zeroIndex], 'Cdata', [O3data; O3data])
    drawnow;
    set(s4,'Zdata',[NO2data; zeroIndex], 'Cdata', [NO2data; NO2data])
    drawnow;
%     subplot(2,2,1)
%     plot(vocdata)
%     title('VOC Data')
%     ylabel ('ADC value')
%     subplot(2,2,2)
%     plot(vocdata)
%     title('CO2 Data 4')
%     ylabel('ADCVALUE')
end
