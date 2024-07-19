clear all
close all
clc
%DATA
g=9.81; %m/s^2;
%DATA READ FROM EXCEL
t=xlsread('AC5.xlsx',1,'A2:A2501');
a_z_t=xlsread('AC5.xlsx',1,'D2:D2501')/g;
a_y_t=xlsread('AC5.xlsx',1,'C2:C2501')/g;
a_x_t=xlsread('AC5.xlsx',1,'B2:B2501')/g;
%RESULTING DECELERATION
a_tot=sqrt((a_x_t).^2+(a_y_t).^2+(a_z_t).^2);
%MAX g
Max_g=(max(a_tot));
%ALLOCATE NAN TO ALL CELLS OF MATRIX
HIC = nan(length(a_tot));
%SCALE FACTOR TO USE INDEXES AS A NUMBER
s_f = 0.001;
% HIC COMPUTATION
for i = 1:length(t)
 for j = 1:length(t)
 HIC(i,j)=((((trapz(a_tot(i:j)))/((j-i+1)))^2.5).*((((j-i+1)*s_f))));
 end
end
[HIC_max,I]=max(HIC(:));
[T_1,T_2]=(ind2sub(size(HIC),I));
T1=T_1*(s_f*1000); %millisecondi
T2=T_2*(s_f*1000); %millisecondi
dt_HIC_max =(T2-T1); %millisecondi
%CALCULATE HIC 15
% for i = 1:length(t)
%  for j = 1:length(t)
%  if (j-i+1)==150
%  HIC_15(i,j)=HIC(i,j);
%  end
%  end
% end
% HIC_max_15=max(HIC_15);
% [HIC_max_15,I]=max(HIC_15(:));
% [T1__15,T2__15]=ind2sub(size(HIC_15),I);
% T1_15=T1__15*(s_f*1000);%millisecondi
% T2_15=T2__15*(s_f*1000);%millisecondi
% Outputs
disp(['HIC max: ', num2str(HIC_max)])
disp(['Delta-t HIC max: ', num2str(dt_HIC_max),' ms'])
disp(['T1 HIC MAX: ',num2str(T1), ' ms'])
disp(['T2 HIC MAX: ',num2str(T2), ' ms'])
% disp(['HIC 15: ',num2str(HIC_max_15)])
% disp(['T1 15: ',num2str(T1_15), ' ms'])
% disp(['T2 15: ',num2str(T2_15), ' ms'])
disp(['Max g: ', num2str(Max_g), ' g'])