stepsize 50
vector Clock Clk
vector Rst Reset
vector C Cfg
vector T Test
vector In In8 In7 In6 In5 In4 In3 In2 In1 In0
vector Out Out8 Out7 Out6 Out5 Out4 Out3 Out2 Out1 Out0

ana Clk Cfg Test Reset In8 In7 In6 In5 In4 In3 In2 In1 In0 Out8 Out7 Out6 Out5 Out4 Out3 Out2 Out1 Out0

ana lut_out0 lut_out1 lut_out2 lut_out3 lut_out4 lut_out5 lut_out6 lut_out7 lut_out8 lut_out9 lut_out10 lut_out11 lut_out12 lut_out13 lut_out14 lut_out15 lut_out16 lut_out17 lut_out18 lut_out19

| ana t0 output1 output2 output3 output4 output5 t6 output7 output8 output9 t10 t11 output12 output13 output14 output15 t16 output17 output18 output19

| ana in8_D0 in8_D1 in7_D0 in7_D1 in6_D0 in6_D1 in5_D0 in5_D1 in4_D0 in4_D1 in3_D0 in3_D1 in2_D0 in2_D1 in1_D0 in1_D1 in0_D0 in0_D1 Test_or_config

setvector Clock 1
s
setvector T 0
setvector C 0
setvector Rst 1
setvector In 001100111
| setvector In 001100010
setvector Clock 0
s
setvector Clock 1
s
setvector Rst 0
setvector C 1
setvector In 001100000
| setvector In 000000110
setvector Clock 0
s
setvector Clock 1
s
setvector In 000000111
| setvector In 001100100
setvector Clock 0
s
setvector Clock 1
s
setvector In 000000000
| setvector In 000000000
setvector Clock 0
s
setvector Clock 1
s
setvector In 001100111
| setvector In 001000101
setvector Clock 0
s
setvector Clock 1
s
setvector In 001100000
| setvector In 001000001
setvector Clock 0
s
setvector Clock 1
s
setvector In 000000111
| setvector In 000000100
setvector Clock 0
s
setvector Clock 1
s
setvector In 000000000
| setvector In 000000000
setvector Clock 0
s
setvector Clock 1
s
setvector In 001100111
| setvector In 000000001
setvector Clock 0
s
setvector Clock 1
s
setvector In 001100000
| setvector In 001000101
setvector Clock 0
s
setvector Clock 1
s
setvector In 000000111
| setvector In 001000100
setvector Clock 0
s
setvector Clock 1
s
setvector In 000000000
| setvector In 000000000
setvector Clock 0
s
setvector Clock 1
s
setvector In 001100111
| setvector In 000000000
setvector Clock 0
s
setvector Clock 1
s
setvector In 001100000
| setvector In 001100111
setvector Clock 0
s
setvector Clock 1
s
setvector In 000000111
| setvector In 001100111
setvector Clock 0
s
setvector Clock 1
s
setvector In 000000000
| setvector In 000000000
setvector Clock 0
s
setvector Clock 1
s
setvector Clock 0
s
setvector Clock 1
s
setvector C 0
setvector Clock 0
s
setvector Clock 1
s
setvector Clock 0
s
setvector Clock 1
s
setvector Clock 0
s
setvector Clock 1
s
setvector Clock 0
s
setvector Clock 1
s
setvector Clock 0
s
setvector Clock 1
s
setvector Clock 0
s
setvector Clock 1
s
setvector Clock 0
s
setvector Clock 1
s
setvector Clock 0
s
setvector Clock 1
s
setvector Clock 0
s
setvector Clock 1
s
setvector Clock 0
s
setvector Clock 1
s
setvector Clock 0
s
setvector Clock 1
s
setvector Clock 0
s
setvector Clock 1
s
setvector Clock 0
s
setvector Clock 1
s
setvector Clock 0
s
setvector Clock 1
s
setvector Clock 0
s
