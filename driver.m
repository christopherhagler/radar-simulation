clc;
clear variables;

radarParams.fc = 450e6;
radarParams.Pt = 10e3;
radarParams.Gt = 630;
radarParams.Gr = 630;
radarParams.Rt = 150e3;
radarParams.Rr = 150e3;
radarParams.RCS = 10;
radarParams.T = 290;
radarParams.loss = 2.0;
radarParams.NF_dB = 6.0;
radarParams.numChan = 64;
radarParams.fs = 6e6;

waveformParams.tau = 100e-6;     % 100 microseconds
waveformParams.PRI = 1.5e-3;     % 1.5 milliseconds
waveformParams.bandwidth = 2e6;  % 2 MHz chirp
waveformParams.type = 'lfm';     % Linear Frequency Modulation
waveformParams.numPRI = 4;       % number of PRIs

% 1). Calculate the recieved signal power for a given target range
[SNR_dB, ~] = radarRangeEquation(radarParams, waveformParams);

% 2). Generate an LFM chirp.
txSig = genWaveform(radarParams.fs, waveformParams);

% 3). Propogate the signal
chanData = propSignal(txSig, SNR_dB, radarParams, waveformParams.numPRI);