# vsynth
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

`vsynth` project is aiming to create a 8-bit, MIDI-controlled digital synthesizer for FPGA.

Design assumtions and features to implement:
- [x] 8-bit samples 
- [X] 4-keys polyphony
- [x] Control over MIDI
- [x] MIDI velocity sensitivity
- [x] PPG Wave 2.2 wavetables
- [ ] ADSR envelope generator
- [ ] MIDI pitchbend
- [ ] LFO 
- [ ] at least 2 voice polyphony

## Building the project

Launch Vivado and using TCL console enter the script directory and build the project.

```tcl
cd {path\to\script\directory}
source .\vsynth_create_project.tcl
```

## Hardware
For now all of the tests are running on Digilent Nexys A7 board with Xilinx Artix-7 XC7A50T-1CSG324I with  DAC and MIDI extension board.
The code is written in `verilog` to be possibly most portable and efficient.

*Digilent Nexys A7 with DAC and MIDI interface:*

<img width=50% src=img/vsynth.jpg>
