clear all
close all
clc

AVSIM=readmatrix('AC50M.txt');
ORI=readmatrix('OAC50M.txt');
n=length(AVSIM);
AF=zeros(n,7);
AL=zeros(3,1);
AR=zeros(3,1);
O=zeros(3);

for i=2:n
    AL=[AVSIM(i,2)
        AVSIM(i,3)
        AVSIM(i,4)];

    AR=[AVSIM(i,5)
        AVSIM(i,6)
        AVSIM(i,7)];

    O=[ORI(i,2) ORI(i,3) ORI(i,4)
       ORI(i,5) ORI(i,6) ORI(i,7)
       ORI(i,8) ORI(i,9) ORI(i,10)];

    ALF=O*AL;
    ARF=O*AR;

    AF(i,1)=AVSIM(i,1);
    AF(i,2)=ALF(1,1);
    AF(i,3)=ALF(2,1);
    AF(i,4)=ALF(3,1);
    AF(i,5)=ARF(1,1);
    AF(i,6)=ARF(2,1);
    AF(i,7)=ARF(3,1);
end

AF=num2cell(AF);
AF{1,1}='Tempo (s)';
AF{1,2}='ALinearX (m/s^2)';
AF{1,3}='ALinearY (m/s^2)';
AF{1,4}='ALinearZ (m/s^2)';
AF{1,5}='ARotacionalX (rad/s^2)';
AF{1,6}='ARotacionalY (rad/s^2)';
AF{1,7}='ARotacionalZ (rad/s^2)';

writecell(AF,'AC50M.xlsx')