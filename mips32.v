module mips32(clk);

input clk;

reg [31:0] PC, IR, NPC, EX_IR,ID_IR,WB_IR;
reg [31:0] A, B, Imm;
reg [2:0] itype;
reg 	   cond;
reg [31:0] ALUOut, LMD;
reg [31:0] Reg [0:31]; //Reg bank 32x32
reg [31:0] Mem [0:1023]; //1024x32 memory


parameter ADD =6'b000000, SUB=6'b000001,
		AND =6'b000010, OR =6'b000011,
		SLT =6'b000100, MUL =6'b000101,
		HLT =6'b111111, LW =6'b001000,
		SW =6'b001001, ADDI =6'b001010,
		SUBI =6'b001011, SLTI =6'b001100,
		BNEQZ =6'b001101, BEQZ =6'b001110;
		
parameter RR_ALU =3'b000, RM_ALU =3'b001,
		LOAD =3'b010, STORE =3'b011,
		BRANCH =3'b100, HALT =3'b101;
		
reg HALTED;
reg TAKEN_BRANCH;

always@(posedge clk)															//IF stage
	begin
		if(HALTED==0)
			begin
						if(TAKEN_BRANCH==1)
							begin
								PC	<=	 ALUOut;
								IR	<=  Mem[ALUOut];
								NPC	<=	 ALUOut+1;
							end
						else		
							begin
								IR	<=  Mem[PC];
								NPC	<=  PC+1;
							end
			end
		end	
		
always@(negedge clk)
		begin
			if(HALTED==0)
			begin
				ID_IR <= IR;
				
				if(IR[25:21]==5'b00000)		A <=0;								//ID stage
				else 	A <=  Reg[IR[25:21]];		//rs
				
				if(IR[20:16]==5'b00000)		B <=0;
				else 	B <=  Reg[IR[20:16]];		//rt
				
				Imm <=  {{16{IR[15]}},IR[15:0]};
				
				case(IR[31:26])
				ADD, SUB, AND, OR, SLT, MUL : itype <=  RR_ALU;
				ADDI, SUBI, SLTI			: itype <=  RM_ALU;
				LW							: itype <=  LOAD;
				SW							: itype <=  STORE;
				BNEQZ, BEQZ					: itype <=  BRANCH;
				HLT							: itype <=  HALT;
				//default						: itype <=  HALT;
				endcase
			end
		end	
		
always@(posedge clk)					//EX stage
		begin
			if(HALTED==0)
			begin
			
				EX_IR <= IR;
				TAKEN_BRANCH <=  1'b0;
				
				
				case(itype)
				RR_ALU : begin
							case(IR[31:26])	//opcode
								ADD : ALUOut <=  A + B;
								SUB	: ALUOut <=  A - B;
								AND	: ALUOut <=  A & B;
								OR	: ALUOut <=  A | B;
								SLT	: ALUOut <=  A < B;
								MUL	: ALUOut <=  A * B;
								default: ALUOut <=  32'hxxxxxxxx;
							endcase
							
							end	

				RM_ALU : begin
							case(IR[31:26])	//opcode
								ADDI : ALUOut <=  A + Imm;
								SUBI : ALUOut <=  A - Imm;
								SLTI : ALUOut <=  A < Imm;
								default: ALUOut <=  32'hxxxxxxxx;
							endcase
						 end
				
				LOAD, STORE :
						begin
							ALUOut =  A + Imm;
							LMD	=  Mem[ALUOut];
							
						end	
						
				BRANCH :
						begin
							ALUOut <=  NPC + Imm;
							cond	  <=  (A == 0)?1:0;
							
						/*	if(((EX_IR[31:26]==BEQZ)&&
									(cond==1))||
								((EX_IR[31:26]==BNEQZ)&&
									(cond==0)))
							begin
								//IR			 <=  Mem[ALUOut];
								//PC			 <=	 ALUOut;
								TAKEN_BRANCH <=  1'b1;
								//NPC 	 	 <=  ALUOut + 1;

							end
							else TAKEN_BRANCH <=  1'b0;*/
							
						end	
				endcase		
			
				case(itype)
				//RR_ALU, RM_ALU	: PC	<=  NPC;
				LOAD		 	: begin
									//PC 	<=  NPC;
									//LMD	<=  Mem[ALUOut];
									
								  end
			/*	STORE			: if(TAKEN_BRANCH==0)	//Disable write
									begin
									 Mem[ALUOut] <=  B;
									 PC	<=  NPC;  
									 end
				BRANCH			:	begin
									if(cond) begin	PC <=  ALUOut;   end
									else begin		PC	<=  NPC;     end
									
									end*/
				endcase			

			end
			
			

	end	

always@(negedge clk)
begin	
		case(itype)					//Branch Execution at negedge
		BRANCH :
						begin
							
							if(((EX_IR[31:26]==BEQZ)&&
									(cond==1))||
								((EX_IR[31:26]==BNEQZ)&&
									(cond==0)))
							begin
								//IR			 <=  Mem[ALUOut];
								//PC			 <=	 ALUOut;
								TAKEN_BRANCH <=  1'b1;
								//NPC 	 	 <=  ALUOut + 1;

							end
							
							
						end	
		endcase		
		
		
			if(TAKEN_BRANCH==0)	//Disable write if branch taken
			begin
				case(itype)
				RR_ALU	: begin Reg[EX_IR[15:11]] <=  ALUOut;	//rd	
								PC	<=  NPC; 
						  end
				RM_ALU	: begin Reg[EX_IR[20:16]]	<=  ALUOut;	//rt
								PC	<=  NPC; 
							 end
				LOAD	: begin 
								
								Reg[EX_IR[20:16]]	<=  LMD;		//rt
								PC	<=  NPC;  
						  end	
						  
				STORE			: //if(TAKEN_BRANCH==0)	//Disable write
									begin
									 Mem[ALUOut] <=  B;
									 PC	<=  NPC;  
									 end
				HALT	: HALTED <=  1'b1;
				endcase
			end	
	end
	
	endmodule