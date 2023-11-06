% Experiment 5 -- by Ravi Patel
% Roll no. - 2101165

% Clear the command window and workspace
clc;
clear all;

N = 1000;              % Number of sequences
Ts = 0.01;            % Sampling interval
fc = 1/Ts;              % Carrier frequency (cycles per unit time)
Es = 1;               % Energy of the signal


A = sqrt(2 * (Es / 1));  % Amplitude

seq = rand(1, N);      % Generate a random sequence
new_Seq = ((seq >= 0.5));  % Convert sequence into a binary sequence


% Generating modulated signals based on the binary sequence

t = 0:1/fc:1;  % Time vector for one period
x_t1 = A * cos(2 * pi * t);   % Carrier signal with positive amplitude
x_t2 = -A * cos(2 * pi * t);  % Carrier signal with negative amplitude


mod_seq1 = [];  % To store the modulated sequence
Transmited_seq = [];

for i = 1:N
    
    if (new_Seq(i) == 0)

        Transmited_seq = [Transmited_seq; x_t2];

    else


        Transmited_seq = [Transmited_seq; x_t1];
    end

end


% Received signal

% My SINR in dB
SINR = [-10, -5, 0, 5, 10, 15, 20];
SINR=-10:3:10;

% Changing SINR into linear scale
SINR_linear = 10.^(SINR/10);

% Now calculating my variance value (E/sigma^2) where E=1;
myVariance = 1 ./ SINR_linear;
mySigma = sqrt(myVariance);

% doing sampling
myfac = 8; % decimation factor

t = 0:1/fc:1;  % Time vector for one period
myl=length(t);
t = downsample(t, myfac);
t = upsample(t, myfac);

t = t(1:myl)';







for i = 1:length(SINR_linear)

    % Received signal
    for j = 1:N
        % Generating noise
        n_t = mySigma(i) * randn(size(t));

        recived_seq(j,:) = Transmited_seq(j,:) + n_t';

    end
    phi_t = sqrt(2/1) * cos(2 * pi * t);

    
       
        


    


    % My p(t)
    p_t = (recived_seq * phi_t)*Ts;
    new_Received = (p_t' > 0)';



    % Calculating error
    error = (new_Received' == new_Seq);
    percentage_error(i) = 1 - sum(error) / N;
    disp('percentage_error ');
    disp(percentage_error(i));
    disp('using Q function');
    inbuilt_calculation(i) = qfunc(sqrt(1 / myVariance(i)));
    disp(qfunc(sqrt(1 / myVariance(i))));
end
% figure(3);
% subplot(1,2,1)
% stem(new_Seq, 'Marker', 'o');
% xlabel('Sample Index');
% ylabel('Amplitude');
% title('Original Binary Sequence');
% subplot(1,2,2)
% stem(new_Received, 'Marker', 's');
% xlabel('Sample Index');
% ylabel('Amplitude');
% title('Received Binary Sequence');


figure(4)
semilogy(SINR,inbuilt_calculation,'--bs','Marker', 's', 'DisplayName', 'Inbuilt Calculation');
hold on
semilogy(SINR,percentage_error,'--rs','Marker', 'o', 'DisplayName', 'Percentage Error');
hold off
figure(5)
plot(SINR, percentage_error, 'Marker', 'o', 'DisplayName', 'Percentage Error');
hold on
plot(SINR, inbuilt_calculation, 'Marker', 's', 'DisplayName', 'Inbuilt Calculation');
xlabel('SINR (dB)');
ylabel('Error Rate');
title('Error Rate vs SINR');
legend('Location', 'best');
