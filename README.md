# radar-simulation

A compact MATLAB sandbox for monostatic phased-array radar. It builds a planar
antenna array, sizes the signal-to-noise ratio for a target with the radar range
equation, generates an LFM (chirp) pulse train, and propagates it back through
the array with realistic per-channel noise — producing a datacube you can run
detection and beamforming experiments on.

It's a learning and prototyping tool: every step is a short, readable function
rather than a black box.

## What it models

| Stage | File | What it does |
|---|---|---|
| Array geometry | `genPlanarArray.m` | Builds a square planar array (half-wavelength spacing) and orients it |
| Orientation | `rotationXYZExtrinsic.m` | Extrinsic X–Y–Z rotation matrix applied to element positions |
| Link budget | `RREForSNR.m` | Radar range equation → SNR (dB) and noise power for the target |
| Waveform | `genWaveform.m` | Rectangular or LFM chirp pulse, swept symmetrically about DC |
| Propagation | `propSignal.m` | Applies round-trip delay and adds independent complex noise per channel |
| Driver | `driver.m` | Wires it all together and plots the array geometry |

## Quick start

```matlab
>> driver
```

`driver.m` defines the scenario, plots the array, and produces `chanData` —
a `[samples × numPRI × numChannels]` complex datacube ready for processing.

The default scenario:

- **Target** at 50 km range, 200 m/s
- **Array** of 144 elements (12×12 planar grid) at 450 MHz, λ/2 spacing
- **Transmitter** 10 kW peak, with transmit/receive gains, RCS, loss, and
  noise figure feeding the range equation
- **Waveform** LFM chirp — 100 µs pulse, 1.5 ms PRI, 2 MHz bandwidth, 4 pulses

Edit the `targetParams`, `radarParams`, and `waveformParams` structs at the top
of `driver.m` to change the scenario.

## How it works

1. **Array** — `genPlanarArray` lays out a square grid in the E–N–U frame at
   half-wavelength spacing, then rotates it to the desired orientation.
2. **SNR** — `RREForSNR` evaluates the radar range equation in dB, combining
   transmit power, antenna gains, wavelength, RCS, and range against thermal
   noise (`kTB`) and the receiver noise figure.
3. **Waveform** — `genWaveform` builds one PRI: a rectangular gate of width
   `tau`, optionally phase-modulated into an LFM chirp centered at DC.
4. **Propagation** — `propSignal` scales the pulse by the SNR, shifts it by the
   round-trip delay, replicates it across pulses, and adds independent unit-power
   complex Gaussian noise to each of the 144 channels.

## Requirements

- MATLAB
- `freq2wavelen` (MATLAB **Phased Array System Toolbox** / **Radar Toolbox**)

## Notes & next steps

This is a work-in-progress simulation aimed at building intuition. Natural
extensions: angle-dependent steering vectors and beamforming across the array,
matched filtering and pulse compression of the LFM return, and range–Doppler
processing across the PRIs.
