function [ output ] = lp_filter( input, run_time )
% 4-th Order Butterworth LPF

Ts = run_time/length(input);
A_fc = 2;           % cutoff freq
[an,ad] = butter(4, A_fc*2*pi, 's'); % Generate filter coefficients
Q_A = tf(an,ad);    %LPF transfer function
Afilt = tf(1,1) * Q_A;  %Do not multiply by s ==> no derivative

%Convert cont. time TF to discrete time with Tustin transform
Hd = c2d(Afilt,Ts,'tustin');

%Filter coefficients
[num,den] = tfdata(Hd);
num = cell2mat(num);
den = cell2mat(den);
for i = 1:length(num)
   inCoeffs(i) = num(i); 
end

for i=2:length(den)
   outCoeffs(i-1) = -den(i); 
end

% Pre-allocate
output = zeros(length(input),1);

% Apply the filter
unfiltered_indices = [1:5 length(input)-4:length(input)];
for i= unfiltered_indices
    output(i) = input(i);
end
for i= 5 : length(input)-4 % Let the first few datapts go
    
    output(i) = inCoeffs(1)*input(i) +inCoeffs(2)*input(i-1) +inCoeffs(3)*input(i-2) +...
        +inCoeffs(4)*input(i-3) +inCoeffs(5)*input(i-4) +...
        +outCoeffs(1)*output(i-1) +outCoeffs(2)*output(i-2) +outCoeffs(3)*output(i-3) +outCoeffs(4)*output(i-4);
    
end

