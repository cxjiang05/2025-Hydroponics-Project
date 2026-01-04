function Char1 = pHservo4App(pHservo1, Char1)
%This function dips a pH test strip into the water and lifts it up

writePosition(pHservo1, 1);
pause(4)
writePosition(pHservo1, 0);
pause(1)

Char1{end+1} = char(sprintf('pH test strip ready to read \n'));

end