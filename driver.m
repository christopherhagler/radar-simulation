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
radarParams.numChan = 64;
radarParams.fs = 6e6;

waveformParams.tau = 100e-6;      % 100 microseconds
waveformParams.PRI = 1.5e-3;     % 1.5 milliseconds
waveformParams.bandwidth = 2e6;  % 2 MHz chirp 
waveformParams.type = 'lfm';     % Linear Frequency Modulation
waveformParams.numPRI = 4;       % number of PRIs

% 1). Calculate the recieved signal power for a given target range
[SNR_dB, ~] = radarRangeEquation(radarParams);

% 2). Generate an LFM chirp.
txSig = genWaveform(radarParams.fs, waveformParams);

% 3). Propogate the signal
rxSig = propSignal(txSig, SNR_dB, radarParams, waveformParams.numPRI);



% Plot the Real part (Time Domain)
figure(1);
subplot(2,1,1);
t_axis = (0:length(txSig)-1)/radarParams.fs * 1e6;
plot(t_axis, real(txSig));
xlabel('Time (\mus)'); ylabel('Amplitude');
title('Real Part of UHF Chirp Pulse (100 \mus)');
xlim([0 120]); grid on;

% Plot the Real part of the propogated signal
figure(2);
subplot(2,1,1);
t_axis = (0:length(rxSig)-1)/radarParams.fs * 1e6;
plot(t_axis, real(rxSig));
xlabel('Time (\mus)'); ylabel('Amplitude');
title('Real Part of propogated signal');
grid on;