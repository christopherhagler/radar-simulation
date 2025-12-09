clc;
close all;
clear variables;

% Target's range and velocity
targetParams.targetState = [50e3, 200];

% Simple monostatic planar array
radarParams.fc = 450e6;
radarParams.Pt = 10e3;
radarParams.Gt = 630;
radarParams.Gr = 630;
radarParams.Rt = targetParams.targetState(:,1);
radarParams.Rr = targetParams.targetState(:,1);
radarParams.RCS = 10;
radarParams.T = 290;
radarParams.loss = 2.0;
radarParams.NF_dB = 6.0;
radarParams.numChan = 144;
radarParams.fs = 6e6;
radarParams.elemenPos_ENU = genPlanarArray(radarParams.numChan, freq2wavelen(radarParams.fc)/2, deg2rad(45));

waveformParams.tau = 100e-6;
waveformParams.PRI = 1.5e-3;
waveformParams.bandwidth = 2e6;
waveformParams.type = 'lfm';
waveformParams.numPRI = 4;

% Plot the array geometry to confirm setup
elementSpacing = freq2wavelen(radarParams.fc)/2;
figure(1);
X = radarParams.elemenPos_ENU(:,1);
Y = radarParams.elemenPos_ENU(:,2);
Z = radarParams.elemenPos_ENU(:,3);
scatter3(X,Y,Z, 'filled');
title(sprintf('8x8 Planar Array, Spacing: %2.3fm', elementSpacing));
xlim([-1.5 1.5]);
ylim([-1.5 1.5]);
zlim([-1.5 1.5]);

% 1). Calculate the recieved signal power for a given target
[SNR_dB, ~] = RREForSNR(radarParams, waveformParams);

% 2). Generate an LFM chirp.
txSig = genWaveform(radarParams.fs, waveformParams);

% 3). Propogate the signal
chanData = propSignal(txSig, SNR_dB, radarParams, waveformParams.numPRI);