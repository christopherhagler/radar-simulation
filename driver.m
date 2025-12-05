clc;
clear variables;

radarParams.fc = 450e6;
radarParams.Pt = 200e3;
radarParams.Gt = 630;
radarParams.Gr = 630;
radarParams.Rt = 150000;
radarParams.Rr = 150000;
radarParams.RCS = 10;
radarParams.tau = 40e-6;
radarParams.T = 290;
radarParams.loss = 2.0;
radarParams.NF_dB = 6.0;

% 1). Calculate the recieved signal power at a given target range for a
% bistatic setup.
[SNR_dB, ~] = radarRangeEquation(radarParams);

waveformParams.tau = 40e-6;      % 40 microseconds
waveformParams.PRI = 1.5e-3;     % 1.5 milliseconds (gives ~225km max unambiguous range)
waveformParams.bandwidth = 2e6;  % 2 MHz chirp 
waveformParams.type = 'lfm';     % Linear Frequency Modulation
waveformParams.fs = 6e6;         % 6 MHz sampling rate

% 2). Generate an LFM chirp.
txSig = genWaveform(waveformParams);

% Plot the Real part (Time Domain)
figure(1);
subplot(2,1,1);
t_axis = (0:length(txSig)-1)/waveformParams.fs * 1e6;
plot(t_axis, real(txSig));
xlabel('Time (\mus)'); ylabel('Amplitude');
title('Real Part of UHF Chirp Pulse (40 \mus)');
xlim([0 50]); grid on;

% 3). Propogate the signal
rxSig = propSignal(txSig, SNR_dB, radarParams.Rt, radarParams.Rr, waveformParams.fs);

% Plot the Real part of the propogated signal
figure(2);
subplot(2,1,1);
t_axis = (0:length(rxSig)-1)/waveformParams.fs * 1e6;
plot(t_axis, real(rxSig));
xlabel('Time (\mus)'); ylabel('Amplitude');
title('Real Part of propogated signal');
grid on;