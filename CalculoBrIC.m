clear all
close all
clc

ORI=readmatrix('OF5V60V2.txt');
VEL=readmatrix('VF5V60V2.txt');
n=length(VEL);
O=zeros(3);
V=zeros(3,1);
BrIC=zeros(n,1);
for i=2:n
    V=[VEL(i,1)
        VEL(i,2)
        VEL(i,3)];

    O=[ORI(i,2) ORI(i,3) ORI(i,4)
       ORI(i,5) ORI(i,6) ORI(i,7)
       ORI(i,8) ORI(i,9) ORI(i,10)];

    VF=O*V;
    BrIC(i,1)=sqrt((VF(1,1)/66.25)^2+(VF(2,1)/56.45)^2+(VF(3,1)/42.87)^2);
end

BrICF=max(BrIC)