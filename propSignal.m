function sigMatOut = propSignal(sigMat, SNR_dB, Rt, Rr, fs)
    c = 3e8;

    scaleFactor = 10^(SNR_dB / 20); 
    sigMatScaled = sigMat * scaleFactor;

    delay_sec = (Rt + Rr) / c;
    delay_samples = round(delay_sec * fs);

    if delay_samples >= length(sigMat)
        % Target is too far, signal is completely off the screen
        sigMatOut = zeros(size(sigMat));
    else
        % Create column of zeros for the delay
        zeroPad = zeros(delay_samples, 1);
        
        % Prepend zeros, remove excess from end
        sigMatOut = [zeroPad; sigMatScaled(1:end-delay_samples)];
    end
end