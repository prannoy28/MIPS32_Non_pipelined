# MIPS32_Non_pipelined

 MIPS32 is a 32-bit processor designed by MIPS Computer Systems in the year 1985. It has RISC based instruction set architecture which has 32 internal general purpose registers R0-R31, each of which has data width of 32-bits or 4 bytes. The data in register R0 is always zero which serves the purpose of moving immediate data to the other registers.

The instruction memory and data memory are kept separate in order to access both memories at the same point of time. This processor supports very few addressing modes. Addressing modes are the ways of specifying the location of the operand through the instructions on which operations are to be done. The various addressing modes available to MIPS32 are: 

1. <b>Register Addressing Mode</b> : The operand is stored in one of the registers among R0-R31.

2. <b>Immediate Addressing Mode</b> : The operand is stored is specified in the instruction itself.

3. <b>Base Indexed Addressing Mode</b> : Here a register with and offset is provided in a single instruction. The content of register is added with the offset to obtain an address in the memory where operand is stored. 

## Types of Instructions

Here two types of instruction formats are specified which have been used in the instruction encoding:

1. R-type Instruction
2. I-type instruction

![](reg.png=500x500)
