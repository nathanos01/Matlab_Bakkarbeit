%% Set parameters
v_max = 50000;      % maximum velocity [pps]
max_accel = 10000;  % acceleration [pps^2]
max_decel = 20000;  % deceleration [pps^2]





%% Check if parameters are inside boundries
% v_max
if v_max > 7999774
    v_max = 7999774;
elseif v_max < -7999774
    v_max = -7999774;
end

% max_accel
if max_accel > 7629278
    max_accel = 7629278;
elseif max_accel < 117
    max_accel = 117;
end

% max_decel
if max_decel > 7629278
    max_decel = 7629278;
elseif max_decel < 117
    max_decel = 117;
end



% function to move motor to positon 
 
% ROR Command 
function move_right(nin) 
n = int32(nin); 
 
% generate command 
% byte1 - adress 
byte(1:4) = uint8([1,4,1,0]); 
byte(5)= uint8(bitand(bitshift(n,-24),255) ); 
byte(6)= uint8(bitand(bitshift(n,-16),255) ); 
byte(7)= uint8(bitand(bitshift(n,-8),255) ); 
byte(8)= uint8(bitand(n,255) ); 
byte(9)=uint8(bitand(sum(byte(1:8)),255) ), 
 
% open com port for data transfer 
fid = serial('COM4','BaudRate',9600, 'DataBits', 8, 'Parity', 'none','StopBits', 1, 'FlowControl', 'none'); 
fopen (fid); 
 
%send command 
fwrite(fid,byte); 
pause(10); 
 
%get answer 
answer = fread(fid, 9, 'uint8') 
 
% close com port connection 
fclose(fid); 
 
% when you enter the function " move_right(1, 0.005,0.01)" in your 
% window command, the motor can move. 
end