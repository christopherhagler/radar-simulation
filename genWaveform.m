function sigMat = genWaveform(fs, waveformParams)
    tau = waveformParams.tau;
    PRI = waveformParams.PRI;
    
    t = (0:1/fs:PRI).';
    sigMat = zeros(length(t), 1);

    % Generate an unmodulated pulse
    idx = t < tau;
    sigMat(idx) = 1;

    % Generate an LFM Chirp using the unmodulate pulse
    if isfield(waveformParams, 'type') && isequal(waveformParams.type, 'lfm')
        t_pulse = t(idx);

        % Center the frequency sweep at DC
        t_centered = t_pulse - (tau/2);
        lfm = exp(1j * pi * (waveformParams.bandwidth/tau) * t_centered.^2);
        sigMat(idx) = sigMat(idx) .* lfm;
    end
end