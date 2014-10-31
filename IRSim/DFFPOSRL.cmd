stepsize 5
vector Clock Clk
vector Rst Reset
vector Ld Load
vector Din D
ana Clk Reset Load D Q muxout1 muxout2 testin

setvector Clock 0
setvector Rst 0
setvector Ld 0
setvector Din 0

s
setvector Rst 1
s
setvector Clock 1
s
setvector Clock 0
setvector Rst 0
setvector Ld 0
setvector Din 1
s
setvector Clock 1
s
setvector Clock 0
setvector Din 0
s
setvector Clock 1
s
setvector Clock 0
setvector Din 1
s
setvector Clock 1
s
setvector Clock 0
setvector Din 0
s
setvector Clock 1
s
setvector Clock 0
setvector Rst 1
setvector Ld 0
setvector Din 1
s
setvector Clock 1
s
setvector Clock 0
setvector Din 0
s
setvector Clock 1
s
setvector Clock 0
setvector Din 1
s
setvector Clock 1
s
setvector Clock 0
setvector Din 0
s
setvector Clock 1
s
setvector Clock 0
setvector Rst 0
setvector Ld 1
setvector Din 1
s
setvector Clock 1
s
setvector Clock 0
setvector Din 0
s
setvector Clock 1
s
setvector Clock 0
setvector Din 1
s
setvector Clock 1
s
setvector Clock 0
setvector Din 0
s
setvector Clock 1
s
setvector Clock 0
setvector Rst 1
setvector Ld 1
setvector Din 1
s
setvector Clock 1
s
setvector Clock 0
setvector Din 0
s
setvector Clock 1
s
setvector Clock 0
setvector Din 1
s
setvector Clock 1
s
setvector clock 0
setvector Din 0
s

