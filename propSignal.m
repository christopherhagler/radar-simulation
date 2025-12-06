function sigMatOut = propSignal(txSig, SNR_dB, radarParams, numPRI)
    c = 3e8;
    numChan = radarParams.numChan;

    SNR_linear = 10^(SNR_dB / 20); 
    sigMatScaled = txSig * SNR_linear;

    % Get the delay time and samples it takes for the signal to travel from
    % transmitter->target and then from target->receiver
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
    
    signalSamples = size(sigMatScaled, 1);
    sigMatOut = zeros([signalSamples, numPRI, numChan]);

    sigMatIdeal = repmat(sigMatScaled, [1 numPRI]);
    % repliate the signal and generate noise per channel
    for ch=1:numChan
        totalSamples = size(sigMatIdeal, 1);
        channelNoise = (randn(totalSamples, numPRI) + ...
             1j*randn(totalSamples, numPRI)) / sqrt(2);

        sigMatOut(:, :, ch) = sigMatIdeal + channelNoise;
    end
end