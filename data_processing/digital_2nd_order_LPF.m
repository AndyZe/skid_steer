%Generate digital filter coefficients for a LPF

clc; close all; clear all;
format compact;
format long g;

A_fc = 5; %LPF cutoff freq  (Hz)
Ts = 1/200; %sampling period

[an,ad] = butter(2,A_fc*2*pi, 's'); %generate LPF coeffs, 2nd-order Butterworth. 's' for analog filter
Q_A = tf(an,ad);                    %LPF transfer function based on the filter coefficients
Afilt = tf([0 1], 1) * Q_A;

%Convert continuous time transfer function to discrete time with Tustin transform
Hd = c2d(Afilt,Ts,'tustin');

%print digital filter coefficients
[num,den] = tfdata(Hd);
num = cell2mat(num);
den = cell2mat(den);
for i = 1:length(num)
    inCoeffs(i) = num(i);
end
for i = 2:length(den)
    outCoeffs(i-1) = -den(i);
end
disp('input coefficients * (n n-1 n-2 ... n-m)' )
inCoeffs
disp('output coefficients * (n-1 n-2 ... n-m)')
outCoeffs
%X in the numerator represents current and previous data samples. V in denom represents
%previous derivatives
disp('v(n) = IN_COEFF1*data(n) + IN_COEFF2*data(n-1) + IN_COEFF3*data(n-2) + OUT_COEFF1*output(n-1) + OUT_COEFF2*output(n-2)')

%Test the filter with a sine wave
f_test = 10; % Hz

for t=1:100
    data(t)= sin(2*3.142*f_test*(t/100));
end

filtered_data=zeros(length(data),1);

for i= 3: length(data)-2    
    filtered_data(i)= inCoeffs(1)*data(i) +inCoeffs(2)*data(i-1) +inCoeffs(3)*data(i-2)...
        +outCoeffs(1)*filtered_data(i-1) +outCoeffs(2)*filtered_data(i-2);
end

plot(data,'b')
hold on
plot(filtered_data,'r')
legend('Data','Filtered Data')