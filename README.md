# vsynth
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

`vsynth` project is aiming to create a 8-bit, MIDI-controlled digital synthesizer for FPGA.

Design assumtions and features to implement:
- [x] 8-bit samples 
- [X] monophony
- [x] Control over MIDI
- [ ] PPG Wave 2.2 wavetables
- [x] MIDI velocity sensitivity
- [ ] MIDI pitchbend
- [ ] ADSR envelope generator
- [ ] LFO 
- [ ] at least 2 voice polyphony

## Hardware
For now all of the tests are running on Digilent Nexys 3 board with Xilinx Spartan-6 XC6LX16-CSG324 with homemade DAC and MIDI2UART extension board.
The code is written in `verilog` to be possibly most portable and efficient.

<br>*Digilent Nexys 3 with DAC and MIDI interface:*<br>

<img width=50% src=img/vsynth.jpg>
