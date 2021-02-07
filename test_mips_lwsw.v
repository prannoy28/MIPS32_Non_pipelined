module test_mips;

reg clk;
integer k;

mips32 nmips(clk);

	initial
		begin
			clk=0;
			repeat(80)		
			begin
				#5 clk=1;	#5 clk=0;
			end	
		end	
	
	initial
		begin
			for(k=0;k<31;k++)
				nmips.Reg[k]=k;
				
			nmips.Mem[0]	= 32'h28010078;		//ADDI R1,R0,120
			nmips.Mem[1]	= 32'h20220000;		//LW R2,0(R1)
			nmips.Mem[2]	= 32'h0c631800;		//OR R3,R3,R3
			nmips.Mem[3]	= 32'h2842002d;		//ADDI R2,R2,45
			nmips.Mem[4]	= 32'h0c631800;		//OR R3,R3,R3
			nmips.Mem[5]	= 32'h24220001;		//SW R2,1(R1)
			nmips.Mem[6]	= 32'hfc000000;		//HLT
			
			nmips.Mem[120]	= 85;
			
			
			nmips.HALTED =0;
			nmips.PC=0;
			nmips.TAKEN_BRANCH=0;
			
			#1000
			
				$display("Mem[120] : %4d \n Mem[121] :%4d \n LMD :",nmips.Mem[120],nmips.Mem[121],nmips.LMD);
				
				for(k=0;k<6;k++)
				$display("R%1d - %2d",k ,nmips.Reg[k]);
		end
		
		
	initial
		begin
			$dumpfile("mips.vcd");
			$dumpvars(0,test_mips);
			#1200 $finish;
		end
		
endmodule		
