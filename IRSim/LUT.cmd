stepsize 20
vector Clock Clk
vector Rst Reset
vector Ld Load
vector Sin shift_in
vector Sout shift_out
vector Inp Inp1 Inp2
vector Out outp
ana Clk Reset Load shift_in shift_out Inp1 Inp2 Out

setvector Inp 00
setvector Clock 1
setvector Rst 1
s
setvector Clock 0
setvector Ld 1
setvector Sin 1
s
setvector Clock 1
s
setvector Rst 0
setvector Clock 0
setvector Sin 1
s
setvector Clock 1
s
setvector Sin 0
setvector Clock 0
s
setvector Clock 1
s
setvector Sin 1
setvector Clock 0
s
setvector Clock 1
s
setvector Sin 0
setvector Clock 0
s
setvector Clock 1
s
setvector Sin 1
setvector Clock 0
s
setvector Clock 1
s
setvector Sin 1
setvector Clock 0
s
setvector Clock 1
s
setvector Sin 1
setvector Clock 0
s
setvector Clock 1
s
setvector Sin 0
setvector Clock 0
s
setvector Clock 1
s
setvector Inp 00
setvector Ld 0
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
setvector clock 0
s

