function sigMatOut = propSignal(txSig, SNR_dB, radarParams, numPRI)
    c = 3e8;

    scaleFactor = 10^(SNR_dB / 20); 
    sigMatScaled = txSig * scaleFactor;

    % apply guassian white noise
    noiseI = randn(size(txSig));
    noiseQ = 1j * randn(size(txSig));
    totalNoise = (noiseI + noiseQ)/sqrt(2);
    sigMatOut = sigMatScaled .* totalNoise;

    delay_sec = (radarParams.Rt + radarParams.Rr) / c;
    delay_samples = round(delay_sec * radarParams.fs);

    if delay_samples >= length(txSig)
        % Target is too far, signal is completely off the screen
        sigMatOut = zeros(size(txSig));
    else
        % Create column of zeros for the delay
        zeroPad = zeros(delay_samples, 1);
        
        % Prepend zeros, remove excess from end
        sigMatOut = [zeroPad; sigMatOut(1:end-delay_samples)];
    end

    sigMatOut = repmat(sigMatOut, numPRI);
end