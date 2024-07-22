n_psd = 2^16;
target = (130 + 0.5)/256;
fs = 1e9;
%first order
os_bin = load('sdm_data_first_order.txt');
os_bin = os_bin(2^10:end)-1;
error = os_bin - target + 0*randn(size(os_bin));
[pn,fx] = pwelch(error, hann(n_psd), n_psd/2, n_psd, fs, 'onesided'); 
pn = pn/2;
figure;
semilogx(fx, 10*log10(pn));
%second order
os_bin = load('sdm_data.txt');
error = os_bin -1 - target + 0*randn(size(os_bin));
[pn,fx] = pwelch(error, hann(n_psd), n_psd/2, n_psd, fs, 'onesided'); 
pn = pn/2;
hold on;
semilogx(fx, 10*log10(pn));
% Add title
title('SDM Noise Transfer Function');

% Optionally, you can add labels and a legend
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
legend('First Order SDM', 'Second Order SDM');
