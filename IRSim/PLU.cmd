stepsize 20
vector Clock Clk
vector Rst Reset
vector Cfg Config
vector T Test
vector Sin lut_shift_in mux_ctrl_shift_in
vector Sout lut_shift_out mux_ctrl_shift_out
vector Inp Inp1 Inp2
vector Out outp
ana Clk Reset Config lut_shift_in mux_ctrl_shift_in Inp1 Inp2 Out lut_shift_out mux_ctrl_shift_out

setvector Inp 00
setvector Clock 1
setvector Rst 1
setvector T 0
s
setvector Clock 0
setvector Cfg 1
setvector Sin 00
s
setvector Clock 1
s
setvector Rst 0
setvector Clock 0
setvector Sin 10
s
setvector Clock 1
s
setvector Sin 10
setvector Clock 0
s
setvector Clock 1
s
setvector Sin 00
setvector Clock 0
s
setvector Clock 1
s
setvector Inp 00
setvector Cfg 0
setvector Clock 0
setvector Sin 00
s
setvector Clock 1
s
setvector Inp 01
setvector Clock 0
s
setvector Clock 1
s
setvector Inp 10
setvector Clock 0
s
setvector Clock 1
s
setvector Inp 11
setvector Clock 0
s
setvector Clock 1
s
setvector Inp 00
setvector Clock 0
s
setvector Clock 1
s
setvector Inp 11
setvector Clock 0
s
setvector Clock 1
s
setvector Inp 01
setvector Clock 0
s
setvector Clock 1
s
setvector Inp 10
setvector Clock 0
s

