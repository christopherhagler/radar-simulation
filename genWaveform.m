function sigMat = genWaveform(waveformParams)
    tau = waveformParams.tau;
    PRI = waveformParams.PRI;
    fs = waveformParams.fs;
    
    t = (0:1/fs:PRI).';
    sigMat = zeros(length(t), 1);
    idx = t < tau;
    sigMat(idx) = 1;
    if isfield(waveformParams, 'type') && isequal(waveformParams.type, 'lfm')
        t_pulse = t(idx);
        t_centered = t_pulse - (tau/2);
        lfm = exp(1j * pi * (waveformParams.bandwidth/tau) * t_centered.^2);
        sigMat(idx) = sigMat(idx) .* lfm;
    end
end