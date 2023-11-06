% Experiment 3 --by Ravi Patel
% Roll no. - 2101165

% Clear the command window and workspace
clc;
clear all;

N = 15;              % Number of sequences
Ts = 0.01;           % Sampling interval
fc = 1 / Ts;         % Carrier frequency (cycles per unit time)
Es = 1;              % Energy of the signal
t = (ones(1, N) * Ts);  % Time vector with intervals Ts

A = sqrt(2 * (Es / Ts));  % Amplitude

seq = rand(1, N);   % Generate a random sequence
new_Seq = ((seq >= 0.4));  % Convert sequence into a binary sequence

% Plotting the original random sequence
subplot(3, 1, 1);
stem(seq);
xlabel('Sample Index');
ylabel('Amplitude');
title('Original Random Sequence');

% Plotting the binary sequence with cumulative time
subplot(3, 1, 2);
stem(cumsum(t), new_Seq);
xlabel('Time');
ylabel('Amplitude');
title('Binary Sequence with Cumulative Time');

% Generating modulated signals based on the binary sequence
subplot(3, 1, 3);
t = 0:1/fc:1;  % Time vector for one period
x_t1 = A * cos(2 * pi * t);   % Carrier signal with positive amplitude
x_t2 = -A * cos(2 * pi * t);  % Carrier signal with negative amplitude

mod_seq1 = [];  % To store the modulated sequence

hold on;
for i = 1:N
    if (new_Seq(i) == 0)
       plot(t, x_t2, 'Color', 'blue', 'LineWidth', 2);

        mod_seq1 = [mod_seq1, -A];
    else
        plot(t, x_t1, 'Color', 'red');
        mod_seq1 = [mod_seq1, A];
    end
    t = t + 1;  % Shift time for the next period
end
hold off;

xlabel('Time');
ylabel('Amplitude');
title('Modulated Signals');
legend('Bit 1', 'Bit 0');

% Scatter plot of the modulated sequence
figure(2);
scatter(mod_seq1, zeros(size(mod_seq1)), 'filled');
grid on;
axis on;
xlabel('Amplitude');
title('Scatter Plot of Modulated Sequence');
