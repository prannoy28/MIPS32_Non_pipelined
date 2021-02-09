# MIPS32_Non_pipelined

 MIPS32 is a 32-bit processor designed by MIPS Computer Systems in the year 1985. It has RISC based instruction set architecture which has 32 internal general purpose registers R0-R31, each of which has data width of 32-bits or 4 bytes. The data in register R0 is always zero which serves the purpose of moving immediate data to the other registers.

The instruction memory and data memory are kept separate in order to access both memories at the same point of time. This processor supports very few addressing modes. Addressing modes are the ways of specifying the location of the operand through the instructions on which operations are to be done. The various addressing modes available to MIPS32 are: 

1. <b>Register Addressing Mode</b> : The operand is stored in one of the registers among R0-R31.

2. <b>Immediate Addressing Mode</b> : The operand is stored is specified in the instruction itself.

3. <b>Base Indexed Addressing Mode</b> : Here a register with and offset is provided in a single instruction. The content of register is added with the offset to obtain an address in the memory where operand is stored. 

## Types of Instructions

Here two types of instruction formats are specified which have been used in the instruction encoding:


| First Header  | Second Header |
| ------------- | ------------- |
| Content Cell  | Content Cell  |
| Content Cell  | Content Cell  |

1. <b>R-type Instructions<b> : <br>
 | Opcode | Operation |<br>
 | --- | --- |<br>
 | 'ADD' | Adds Rs & Rt and stores in Rd |<br>
 | 'SUB' | Subtracts Rs with Rt and stores in Rd |<br>
 | 'AND' | Performs logical and between Rs & Rt and stores in Rd |<br>
 | 'OR' | Performs logical or between Rs & Rt and stores in Rd |<br>
 | 'SLT' | Sets Rd if Rs<Rt |<br>
 | 'MUL' | Multiplies Rs with Rt and stores in Rd |<br>
 | 'HLT' | Halt |<br>

2. I-type instruction

<img src="reg.png" width="2000">


<i>Following conventions are used in image:</i><br>
(a) <b><i>Rs</i></b> : Source register 1<br>
(b) <b><i>Rt</i></b> : Source register 2<br>
(c) <b><i>Rd</i></b> : Destination register<br>
(d) <b><i>shamt</i></b> : Shift amount<br>
(e) <b><i>funct</i></b> : opcode extension<br>

Examples of R-type instruction : ADD R15,R2,R3; OR R5,R3,R2; MUL R2,R2,R1. <br>
Examples of I-type instruction : ADDI R15,R0,20; LW R20,84(R9) (Load content of memory location (R9)+84 to R20). <br>


## MIPS32 Non-pipelined architecture

<img src="MIPS.png" width="1500">

<i>Credits: Image from taken from Computer Organization and Design: the Hardware/Software Interface (Patterson, Hennessy)</i>
