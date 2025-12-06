function [SNR_dB, NP_dB] = radarRangeEquation(radarParams, waveformParams)
    k = 1.380649e-23;

    Pt_dB = 10*log10(radarParams.Pt);
    Gt_dB = 10*log10(radarParams.Gt);
    Gr_dB = 10*log10(radarParams.Gr);
    lambda_dB = 20*log10(freq2wavelen(radarParams.fc));
    Rt_dB = 20*log10(radarParams.Rt);
    Rr_dB = 20*log10(radarParams.Rr);
    RCS_dBsm = 10*log10(radarParams.RCS);
    loss_dB = 10*log10(radarParams.loss);
    bandwidth = waveformParams.bandwidth;
    
    NP_dB = 10*log10(k * radarParams.T * bandwidth) + radarParams.NF_dB;
    SNR_dB = Pt_dB + Gt_dB + Gr_dB + lambda_dB + RCS_dBsm - 30*log10(4*pi) - Rt_dB - Rr_dB - loss_dB - NP_dB;
end