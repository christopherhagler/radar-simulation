function sigMatOut = propSignal(txSig, SNR_dB, radarParams, numPRI)
    c = 3e8;

    scaleFactor = 10^(SNR_dB / 20); 
    sigMatScaled = txSig * scaleFactor;

    delay_sec = (radarParams.Rt + radarParams.Rr) / c;
    delay_samples = round(delay_sec * radarParams.fs);

    if delay_samples >= length(txSig)
        % Target is too far, signal is completely off the screen
        sigMatScaled = zeros(size(txSig));
    else
        % Create column of zeros for the delay
        zeroPad = zeros(delay_samples, 1);
        
        % Prepend zeros, remove excess from end
        sigMatScaled = [zeroPad; sigMatScaled(1:end-delay_samples)];
    end

    sigMatScaled = repmat(sigMatScaled, [numPRI 1]);

    % repliate the signal and generate noise per channel
    sigMatOut = zeros(size(sigMatScaled, 1), radarParams.numChan);
    for ch=1:radarParams.numChan
        % apply guassian white noise
        noiseI = randn(size(sigMatScaled));
        noiseQ = 1j * randn(size(sigMatScaled));
        totalNoise = (noiseI + noiseQ)/sqrt(2);
        sigMatOut(:,ch) = sigMatScaled .* totalNoise;
    end
end