% Parameters
N = 10^5; % Length of the binary sequence
EbN0dB = -20:3:8; % Eb/N0 values in dB
M = 16; % Modulation order (16-QAM)
k = log2(M); % Number of bits per symbol

% Generate random binary sequence
binary_sequence = randi([0, 1], 1, N);

% 16-QAM modulation
qam_symbols = qammod(binary_sequence, M);

% 16-QPSK modulation
qpsk_symbols = pskmod(binary_sequence, 4, 0);

% Initialize arrays to store BER results
ber_qam = zeros(1, length(EbN0dB));
ber_qpsk = zeros(1, length(EbN0dB));

% Simulation loop for different Eb/N0 values
for i = 1:length(EbN0dB)
    % Add noise to the QAM and QPSK symbols
    snr = EbN0dB(i) + 10*log10(k); % Calculate SNR in dB
    noisy_qam_symbols = awgn(qam_symbols, snr, 'measured');
    noisy_qpsk_symbols = awgn(qpsk_symbols, snr, 'measured');

    % Demodulate the noisy symbols
    demodulated_qam_symbols = qamdemod(noisy_qam_symbols, M);
    demodulated_qpsk_symbols = pskdemod(noisy_qpsk_symbols, 4, 0);

    % Calculate the bit error rate for QAM and QPSK
    ber_qam(i) = biterr(binary_sequence, demodulated_qam_symbols) / N;
    ber_qpsk(i) = biterr(binary_sequence, demodulated_qpsk_symbols) / N;
end

% Theoretical BER for 16-QAM
theoretical_ber_qam = (3/2) * (1 - (1/sqrt(M))) * qfunc(sqrt(3 * k / (M - 1) * 10.^(EbN0dB/10)));

% Theoretical BER for 16-QPSK
theoretical_ber_qpsk = qfunc(sqrt(2 * k * 10.^(EbN0dB/10)));

% Plot BER results
figure;
semilogy(EbN0dB, ber_qam, 'b-o', 'DisplayName', '16-QAM (Simulated)');
hold on;
semilogy(EbN0dB, theoretical_ber_qam, 'r--', 'DisplayName', '16-QAM (Theoretical)');
semilogy(EbN0dB, ber_qpsk, 'g-s', 'DisplayName', '16-QPSK (Simulated)');
semilogy(EbN0dB, theoretical_ber_qpsk, 'k--', 'DisplayName', '16-QPSK (Theoretical)');
xlabel('Eb/N0 (dB)');
ylabel('Bit Error Rate (BER)');
title('16-QAM and 16-QPSK Bit Error Rate Analysis');
legend('Location', 'southwest');
grid on;
hold off;
