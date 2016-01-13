function [s,flag] = setupSerial(comPort)
flag = 1;
s = serial(comPort);
set(s,'DataBits',8);
set(s, 'StopBits',1);
set(s, 'BaudRate',9600);
set(s, 'Parity', 'none');
fopen(s);

fprintf(s,'%c','a');

a='b';
while (a ~= 'b')
    a=fread(s,1,'uchar');
end
if (a=='a')
    disp('serial read');
end

    mbox = msgbox('Serial Communication setup.'); uiwait(mbox);
    fscanf(s,'%u');
end