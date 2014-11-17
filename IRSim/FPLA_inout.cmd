stepsize 20
vector Clock Clk
vector Rst Reset
vector C Cfg
vector T Test
vector In In8 In7 In6 In5 In4 In3 In2 In1 In0
vector Tin inp1_3 inp2_17 inp1_14 inp1_5 inp1_1

ana Clk Cfg Test Reset In8 In7 In6 In5 In4 In3 In2 In1 In0 Out8 Out7 Out6 Out5 Out4 Out3 Out2 Out1 Out0

| ana in8_D0 in8_D1 in7_D0 in7_D1 in6_D0 in6_D1 in5_D0 in5_D1 in4_D0 in4_D1 in3_D0 in3_D1 in2_D0 in2_D1 in1_D0 in1_D1 in0_D0 in0_D1 Test_or_config

setvector Clock 1
s
setvector Tin 00000
setvector T 0
setvector C 0
setvector Rst 1
setvector In 000000000
setvector Clock 0
s
setvector Clock 1
s
setvector Rst 0
setvector C 1
setvector In 001100010
setvector Clock 0
s
setvector Clock 1
s
setvector In 000000110
setvector Clock 0
s
setvector Clock 1
s
setvector In 001100100
setvector Clock 0
s
setvector Clock 1
s
setvector In 000000000
setvector Clock 0
s
setvector Clock 1
s
setvector In 001000101
setvector Clock 0
s
setvector Clock 1
s
setvector In 001000001
setvector Clock 0
s
setvector Clock 1
s
setvector In 000000100
setvector Clock 0
s
setvector Clock 1
s
setvector In 000000000
setvector Clock 0
s
setvector Clock 1
s
setvector In 000000001
setvector Clock 0
s
setvector Clock 1
s
setvector In 001000101
setvector Clock 0
s
setvector Clock 1
s
setvector In 001000100
setvector Clock 0
s
setvector Clock 1
s
setvector In 000000000
setvector Clock 0
s
setvector Clock 1
s
setvector In 000000000
setvector Clock 0
s
setvector Clock 1
s
setvector In 001100111
setvector Clock 0
s
setvector Clock 1
s
setvector In 001100111
setvector Clock 0
s
setvector Clock 1
s
setvector In 000000000
setvector Clock 0
s
setvector Clock 1
s
setvector C 0
setvector Clock 0
s
setvector Clock 1
s
setvector In 101011110
setvector Clock 0
s
setvector Clock 1
s
setvector In 110100010
setvector Clock 0
s
setvector Clock 1
s
setvector In 111111111
setvector Clock 0
s
setvector Clock 1
s
setvector In 101010101
setvector Clock 0
s
setvector Clock 1
s
setvector In 011011001
setvector Clock 0
s
setvector Clock 1
s
setvector In 000001110
setvector Clock 0
s
setvector Clock 1
s
setvector In 011001000
setvector Clock 0
s
setvector Clock 1
s
setvector In 000010000
setvector Clock 0
s
setvector Clock 1
s
setvector In 110010111
setvector Clock 0
s
setvector Clock 1
s
setvector In 001111111
setvector Clock 0
s
setvector Clock 1
s
setvector In 110000011
setvector Clock 0
s
setvector Clock 1
s
setvector In 010000000
setvector Clock 0
s
setvector Clock 1
s
setvector In 010001000
setvector Clock 0
s
setvector Clock 1
s
setvector In 010010001
setvector Clock 0
s
