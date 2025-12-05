function [SNR_dB, noisePower_dB] = radarRangeEquation(radarParams)
    % Simple form of the radar range equaiton to get the recieved signal
    % power for a given bistatic setup.

    k = 1.380649e-23; % Boltzmann constant (J/K)

    Pt_dB = 10*log10(radarParams.Pt);
    Gt_dB = 10*log10(radarParams.Gt);
    Gr_dB = 10*log10(radarParams.Gr);
    lambda_dB = 20*log10(freq2wavelen(radarParams.fc));
    Rt_dB = 20*log10(radarParams.Rt);
    Rr_dB = 20*log10(radarParams.Rr);
    RCS_dBsm = 10*log10(radarParams.RCS);
    loss_dB = 10*log10(radarParams.loss);
    bandwidth = 1/radarParams.tau;
    
    noisePower_dB = 10*log10(k * radarParams.T * bandwidth) + radarParams.NF_dB;
    SNR_dB = Pt_dB + Gt_dB + Gr_dB + lambda_dB + RCS_dBsm - 30*log10(4*pi) - Rt_dB - Rr_dB - loss_dB - noisePower_dB;
end