/* pyramiden_core.v
 *
 * Copyright (c) 2022 Brown Deer Technology, LLC.  (www.browndeertechnology.com)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    https://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/* DAR */

module pyramiden_core(

//	input in_clk,

	input [18:0] io_in,
	output [18:0] io_out

//	output [BITS-3:0] debug_pc,
//	output [IBITS-1:0] debug_instr,
//
//	input [RBITS-1:0] debug_reg_sel,
//	output [BITS-1:0] debug_reg_dout

);

	wire in_clk; // ZZZ


	///////////////////////////////////////////////////////////////////////////

	////////////////////////////////
	////////// Parameters //////////
	////////////////////////////////

	parameter BITS = 16;
	parameter IBITS = 21;
	parameter RBITS = 4;
	parameter NREG = 16;


	///////////////////////////////////////////////////////////////////////////

	//////////////////////////////////
	////////// Declarations //////////
	//////////////////////////////////

	/// pipeline control
	wire stall;
	wire stall3;
	wire stall_dmem_bsy;
	wire ack3;
	wire inval0;
	wire valid_out0;

	wire inval1;
	wire valid_out1;

	wire valid_out2;

	reg valid_out3;

	wire stall_imem;

	/// flow control
	reg [BITS-3:0] pc;
	reg [BITS-3:0] pc_1;
	reg [BITS-3:0] pc_2;
	wire pc_jump;
	reg [BITS-3:0] rel_addr;
	reg [BITS-3:0] jump_addr;

	/// instr
	reg [IBITS-1:0] instr;
	reg [IBITS-1:0] instr_2;

	/// hazard
	reg [NREG-1:0] ldr_hzd;

	/// DMEM interface
	wire mem_we;

	/// reg control
	wire [RBITS-1:0] rd;
	wire [RBITS-1:0] rs1;
	wire [RBITS-1:0] rs2;
	wire reg_we;
	wire reg_we_arb;
	reg [BITS-1:0] nxt_rd_din;
	reg [BITS-1:0] rd_din;
	reg [RBITS-1:0] rd_sel_arb;
	reg [BITS-1:0] rd_din_arb;
	reg [BITS-1:0] rs1_dout;
	reg [BITS-1:0] rs2_dout;
	reg [RBITS-1:0] rd_3;

	/// imm operand
	wire ri;
	reg [5:0] imm6;
	reg [BITS-1:0] imm;

	/// reg dependency
	wire use_rd_e1;
	wire use_rd_e2;
	wire use_rs1;
	wire use_rs2;

	/// IALU
	reg [3:0] op;
	reg [BITS-1:0] op_result;
	wire cc_zero;
	wire cc_neg;
	wire cc_v;

	/// ins_
	wire reg_wen;
	wire ins_br;
	wire ins_jal;
	wire ins_jalr;
	wire ins_str;
	wire ins_ldr;
	wire ins_halt;
	wire ins_lui;
	wire ins_auipc;
	reg ins_ldr_3;
	reg ri_3;

	/// bits alias probably not necessary
	wire [2:0] funct3;
	wire [2:0] funct7;
	wire [2:0] opcode;

	///////////////////////////////////////////////////////
	////////// Declarations PIPELINE_STAGE_0_ILR //////////
	///////////////////////////////////////////////////////

	// pipeline control
	wire stall0;
	reg nxt_valid0;

	// flow control
	reg [BITS-3:0] pc0;
	reg [BITS-3:0] nxt_pc, nxt_pc0;

	reg valid0;

	///////////////////////////////////////////////////////
	/////////// Declarations PIPELINE STAGE 1 IL //////////
	///////////////////////////////////////////////////////

	reg [IBITS-1:0] nxt_instr;
	reg valid1;

	///////////////////////////////////////////////////////////////////////////
	////////// Declarations PIPELINE STAGE 2 ID ///////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	wire en2;

	reg valid2;

	///////////////////////////////////////////////////////////////////////////
	////////// Pipeline Stage 3 E1 Declarations ///////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	reg [BITS-1:0] arg0;
	reg [BITS-1:0] arg1;

	reg stall_ldr;

	reg ben;

	wire stall2;
			
	///////////////////////////////////////////////////////////////////////////
	////////// Pipeline Stage 4 E2 Declarations ///////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	wire rdy;
	wire en4;

	/// registers ///

	reg [BITS-1:0] r[0:NREG-1];	

	//////////////////////////////////////////////
	////////// ISA Decoder Declarations //////////
	//////////////////////////////////////////////

	wire rv_itype, rv_stype, rv_btype;

	wire [15:6] s;

	wire rv_op, rv_op_imm;

	///////////////////////////////////////
	////////// IALU Declarations //////////
	///////////////////////////////////////

	reg [BITS-1:0] a_result_sub;
	reg [BITS-1:0] a_result_srl;
	reg [BITS-1:0] a_result;
	reg [1:0] a_result_sel;
	wire a_s;
	reg [7:0] a_s8;
	reg [7:0] a_sx;
	reg [BITS-1:0] a_sign_extend;
	wire [3:0] a_shamt;

   /////////////////////////
   ////////// DES //////////
   /////////////////////////

   wire des_clk_out;
   wire [12:0] des_sin;
   wire [15:0] des_sout;
   wire [63:0] des_din;
   wire [51:0] des_dout;

   //////////////////////////
   ////////// core //////////
   //////////////////////////

   wire clk; 
   wire rst; 
   wire run;
   reg halt; 
   reg [BITS-3:0] imem_addr; 
	wire imem_rdy;
   wire [IBITS-1:0] imem_dout; 
   wire [BITS-1:0] dmem_addr; 
	wire dmem_bsy;
	wire dmem_rdy;
   wire [BITS-1:0] dmem_din; 
   wire [BITS-1:0] dmem_dout; 
   wire dmem_we; 
   wire dmem_en; 
 

   ///////////////////////////////////////////////////////////////////////////

   ///////////////////////////////////////////////////////////////////////////
	//////////   IO   /////////////////////////////////////////////////////////
   ///////////////////////////////////////////////////////////////////////////

	assign in_clk 				= io_in[0]; // ZZZ
	assign rst 				= io_in[1];
	assign run 				= io_in[2];
	assign imem_rdy 		= io_in[3];
	assign dmem_bsy 		= io_in[4];
	assign dmem_rdy 		= io_in[5];
	assign des_sin			= io_in[18:6];

	assign io_out[0]		= halt;
	assign io_out[1] 		= dmem_we;
	assign io_out[2] 		= dmem_en;
	assign io_out[18:3]	= des_sout;


   ///////////////////////////////////////////////////////////////////////////
   //////////   DES   ////////////////////////////////////////////////////////
   ///////////////////////////////////////////////////////////////////////////

   des des(
      .in_clk (in_clk),
      .rst (rst),
      .des_sin (des_sin),
      .des_sout (des_sout),
      .des_din (des_din),
      .des_dout (des_dout),
		.des_clk_out (des_clk_out)
   );

	assign clk = des_clk_out;

   assign imem_dout	= des_dout[20:0];
   assign dmem_dout	= des_dout[36:21];

   assign des_din[13:0]		= imem_addr;
   assign des_din[31:16]	= dmem_addr;
   assign des_din[47:32]	= dmem_din;


	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	//////////   PIPELINE STAGE 0 (ILR)   /////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	/// pipeline control ///

	assign stall0 = stall | stall_imem;
	assign valid_out0 = valid0 & ~ inval0;

	always @ (posedge clk)
	begin
		if (rst) begin
			valid0 <= 0;
		end
		else if (run) begin
			if (stall0) 
				valid0 <= valid0 & ~ inval0;
			else
				valid0 <= 1;
		end
		else begin
			valid0 <= valid0 & ~ inval0;
		end
	end


	/// flow control ///

	always @ (*)
	begin
		if (pc_jump) begin
			imem_addr = jump_addr;
			nxt_pc0 = jump_addr;
			nxt_pc = jump_addr + 1;
		end
		else if (stall0) begin
			imem_addr = pc0;
			nxt_pc0 = pc0;
			nxt_pc = pc;
		end
		else begin
			imem_addr = pc;
			nxt_pc0 = pc;
			nxt_pc = pc + 1;
		end
	end

	always @ (posedge clk)
	begin
		if (rst) begin
			pc0 <= 0;
			pc <= 0;
		end
		else if (run) begin
			pc0 <= nxt_pc0;
			pc <= nxt_pc;
		end
		else begin
			pc0 <= pc0;
			pc <= pc;
		end
	end

	assign stall_imem = (~ imem_rdy) & valid_out0;


	///////////////////////////////////////////////////////////////////////////
	//////////   PIPELINE STAGE 1 (IL)   //////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	/// pipeline control ///

	assign valid_out1 = valid1 & ~ inval1;

	always @ (posedge clk)
	begin
		if (rst) begin
			valid1 <= 0;
			pc_1 <= 0;
		end
		else if (run & ~ stall) begin
			valid1 <= valid_out0;
			pc_1 <= pc;
		end
		else begin
			valid1 <= valid1 & ~ inval1;
			pc_1 <= pc_1;
		end
	end


	/// generate instruction ///

	always @ (*)
	begin
		if (imem_rdy)
			nxt_instr = imem_dout[IBITS-1:0];
		else
			nxt_instr = 21'h1fffff;
	end

	always @ (posedge clk)
	begin
		if (rst) 
			instr <= 0;
		else if (run & valid_out0 & ~ stall) 
			instr <= nxt_instr;
		else 
			instr <= instr;
	end


	///////////////////////////////////////////////////////////////////////////
	//////////   PIPELINE STAGE 2 (ID)   //////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	/// pipeline control ///

	assign en2 = valid_out1;
	assign valid_out2 = valid2;

	always @ (posedge clk)
	begin
		if (rst) begin
			valid2 <= 0;
		end
		else if (run & ~ stall) begin
			valid2 <= valid_out1;
		end
		else begin
			valid2 <= valid2;
		end
	end


	/// pc, instr data flow

	always @ (posedge clk)
	begin
		if (rst) begin
			pc_2 <= 0;
			instr_2 <= 0;
		end
		else if (run & ~ stall) begin
			pc_2 <= pc_1;
			if (valid_out1)
				instr_2 <= instr;
			else
				instr_2 <= 21'h1fffff;
		end
		else begin
			pc_2 <= pc_2;
			instr_2 <= instr_2;
		end
	end


	///////////////////////////////////////////////////////////////////////////
	//////////   PIPELINE STAGE 3 (E1)   //////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	assign stall = stall2;

	always @ (posedge clk)
	begin
		if (rst)
			valid_out3 <= 0;
		else if (run & ~ stall2)
			valid_out3 <= valid_out2;
		else if (run & ack3)
			valid_out3 <= 0;
		else
			valid_out3 <= valid_out3;
	end

///////////////////////


	assign opcode = instr_2[2:0];
	assign rd = instr_2[6:3];
	assign funct3 = instr_2[9:7];
	assign rs1 = instr_2[13:10];
	assign rs2 = instr_2[17:14];
	assign funct7 = instr_2[20:18];

	assign rv_op_imm 		= (opcode == 3'b001);
	assign rv_op	 		= (opcode == 3'b011);
	assign ins_ldr 		= ((opcode == 3'b000) & (~ funct3[2]));
	assign ins_br	 		= (opcode == 3'b010);
	assign ins_jal		 	= (opcode == 3'b110);
	assign ins_jalr	 	= (opcode == 3'b100);
	assign ins_str 		= ((opcode == 3'b000) & funct3[2]);
	assign ins_halt 		= (opcode == 3'b000) & (funct3 == 3'b000);
	assign ins_lui	 		= (opcode == 3'b111);
	assign ins_auipc 		= (opcode == 3'b101);

	assign reg_wen = rv_op | rv_op_imm;

	assign use_rd_e1 = reg_wen | ins_jal | ins_jalr | ins_lui | ins_auipc;

	assign use_rd_e2 = (~ funct3[2]) & ins_ldr;

	assign use_rs1 = ins_ldr | reg_wen | ins_jalr | ins_br | ins_str;

	assign use_rs2 = (reg_wen & ~ ri_3) | ins_br | ins_str;


	always @ (*)
	begin
		if (ins_str | ins_ldr | ins_br | ins_auipc)
			op[2:0] = 3'b000;
		else 
			op[2:0] = funct3;

		op[3] = ins_br | ((rv_op | ( rv_op_imm & funct3[2])) & funct7[1]);
	end

	assign rv_itype = ins_ldr | rv_op_imm | ins_jalr;
	assign rv_stype = ins_str;
	assign rv_btype = ins_br;

	assign ri = rv_itype | rv_stype;

	assign s[15] = instr_2[20];
	assign s[14] = instr_2[20];
	assign s[13] = instr_2[20];
	assign s[12] = instr_2[20];
	assign s[11] = instr_2[20];
	assign s[10] = instr_2[20];
	assign s[9] = instr_2[20];
	assign s[8] = instr_2[20];
	assign s[7] = instr_2[20];
	assign s[6] = instr_2[20];

   always @ (*)
   begin
      if (rv_itype)
         imm6 = { instr_2[19:14] };
      else
         imm6 = { instr_2[20:18], instr_2[5:3] };
   end

	always @ (*)
	begin
		if (rv_itype|rv_stype|rv_btype)
			imm = { s[15:6], imm6 };
		else
			imm = { s[15:12], instr_2[18:7] };
	end


///////////////////////

	assign reg_we = valid_out2
		& (reg_wen|ins_jal|ins_jalr|ins_lui|ins_auipc) & ~ stall2;

	assign mem_we = valid_out2 & ins_str & ~ stall2;

	always @ (*)
	begin
		if (ins_auipc) begin
			arg0 = { 2'b00, pc_2 };
		end
		else
			arg0 = rs1_dout;
	end

	always @ (*)
	begin
		if (ins_auipc) 
			arg1 = { imm[BITS-6:0], 5'd0};
		else if (ri) 
			arg1 = imm[BITS-1:0];
		else
			arg1 = rs2_dout;
	end


	/// IALU ///

	assign a_shamt = arg1[3:0];

	always @ (*)
	begin
		a_result_sub = arg0 - arg1;
	end

	always @ (*)
	begin
		a_result_srl = arg0 >> a_shamt;
	end

	assign a_s = arg0[BITS-1];

	always @ (*)
	begin
		case (arg1[2:0])
			3'b000: a_sx = { 8'b00000000 };
			3'b001: a_sx = { a_s, 7'b0000000 };
			3'b010: a_sx = { a_s, a_s, 6'b000000 };
			3'b011: a_sx = { a_s, a_s, a_s, 5'b00000 };
			3'b100: a_sx = { a_s, a_s, a_s, a_s, 4'b0000 };
			3'b101: a_sx = { a_s, a_s, a_s, a_s, a_s, 3'b000 };
			3'b110: a_sx = { a_s, a_s, a_s, a_s, a_s, a_s, 2'b00 };
			3'b111: a_sx = { a_s, a_s, a_s, a_s, a_s, a_s, a_s, 1'b0 };
		endcase
		a_s8 = { a_s, a_s, a_s, a_s, a_s, a_s, a_s, a_s };
	end

	always @ (*)
	begin
		case (arg1[4:3])
			2'b00: a_sign_extend = { a_sx, 8'd0 };
			2'b01: a_sign_extend = { a_s8, a_sx };
			2'b10: a_sign_extend = { a_s8, a_s8 };
			2'b11: a_sign_extend = { a_s8, a_s8 };
		endcase
	end

	always @ (*)
	begin
		case (op[2:0])

			3'b000: begin

				if (op[3]) 
					a_result = a_result_sub;
				else
					a_result = arg0 + arg1;

				a_result_sel = 2'b00;

			end

			3'b001: begin
				a_result = arg0 << a_shamt; // sll
				a_result_sel = 2'b00;
			end

			3'b010: begin
				a_result = a_result_sub; // slt
				a_result_sel = 2'b01;
			end

			3'b011: begin
				a_result = a_result_sub; // sltu
				a_result_sel = 2'b10;
			end

			3'b100: begin
				a_result = arg0 ^ arg1; // xor
				a_result_sel = 2'b00;
			end

			3'b101: begin

				if (op[3])
					a_result = a_sign_extend | a_result_srl; // sra
				else
					a_result = a_result_srl; // srl

				a_result_sel = 2'b00;

			end

			3'b110: begin
				a_result = arg0 | arg1;
				a_result_sel = 2'b00;
			end

			3'b111: begin
				a_result = arg0 & arg1;
				a_result_sel = 2'b00;
			end

		endcase
	end

	assign cc_neg = a_result[BITS-1];

	assign cc_zero = (a_result == 0);

	assign cc_v = ( cc_neg & ~(arg0[BITS-1] ^ arg1[BITS-1])) 
		| ((~arg0[BITS-1]) & arg1[BITS-1] );

	always @ (*)
	begin
		case (a_result_sel)
			2'b00: op_result = a_result;
			2'b01: op_result = { 15'd0, cc_neg };
			2'b10: op_result = { 15'd0, cc_v};
			2'b11: op_result = 16'hffff; // unused
		endcase
	end


	assign dmem_addr = { op_result[BITS-1:0] };
	assign dmem_din[BITS-1:0] = rs2_dout;	// XXX
	assign dmem_we = mem_we;
	assign dmem_en = (ins_str | ins_ldr) & valid_out2 & ~ stall2;

	always @ (*)
	begin
		if (ins_lui)
			rd_din = { imm[BITS-6:0], 5'd0 };
		else if (ins_jal|ins_jalr) begin
			rd_din = { 2'b00, pc_2 };
		end
		else
			rd_din = op_result;
	end

	always @ (*)
	begin
		case(funct3) 
			3'b000 : ben = ins_br & cc_zero;	// eq
			3'b001 : ben = ins_br & (~cc_zero); // ne
			3'b010 : ben = 0;
			3'b011 : ben = 0;
			3'b100 : ben = ins_br & cc_neg; // lt
			3'b101 : ben = ins_br & (cc_zero | (~cc_neg)); // ge
			3'b110 : ben = ins_br & cc_v; // ltu
			3'b111 : ben = ins_br & (cc_zero | (~cc_v)); // geu
		endcase
	end


	always @ (*)
	begin

		if (ins_jalr)
			jump_addr = op_result[BITS-3:0];
		else
			jump_addr = pc_2 + { imm[BITS-3:0] };
	end
	assign pc_jump = valid_out2 & (ben | ins_jal | ins_jalr);

	assign inval0 = pc_jump & (~ stall2);
	assign inval1 = pc_jump & (~ stall2);

	always @ (posedge clk)
	begin
		if (rst) begin
			halt <= 0;
		end
		else if (run & valid_out2 & ~ stall2) begin
			halt <= ins_halt;
		end
		else begin
			halt <= halt;
		end
	end

	always @ (posedge clk)
	begin
		if (rst) begin
			ins_ldr_3 <= 0;
			rd_3 <= 0;
			ri_3 <= 0;
		end
		else if (run & ~ stall2) begin
			ins_ldr_3 <= ins_ldr;
			rd_3 <= rd;
			ri_3 <= ri;
		end
		else begin
			ins_ldr_3 <= ins_ldr_3;
			rd_3 <= rd_3;
			ri_3 <= ri_3;
		end
	end

	always @ (*)
	begin
	
		if ( ldr_hzd == 'd0 )
			stall_ldr = 0;
		else if ( (use_rs1 & ldr_hzd[rs1]) | (use_rs2 & ldr_hzd[rs2])) // RAW HZD
			stall_ldr = 1;
		else if ( (use_rd_e2 & ldr_hzd[rd]) | (use_rd_e1) ) // WAW conflict
			stall_ldr = 1;
		else 
			stall_ldr = 0;

	end
	assign stall_dmem_bsy = ((ins_str | ins_ldr) & dmem_bsy);
	assign stall2 = stall_ldr | stall3 | stall_dmem_bsy;


	///////////////////////////////////////////////////////////////////////////
	//////////   PIPELINE STAGE 4 (E2)   //////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

  	assign en4 = valid_out3 & (ins_ldr_3 ) & rdy;

   always @ (*)
   begin

      if (en4 & ins_ldr_3) begin
         rd_sel_arb = rd_3;
         rd_din_arb = dmem_dout[BITS-1:0];
      end
      else begin
         rd_sel_arb = rd;
         rd_din_arb = rd_din;
      end

   end
	assign reg_we_arb = reg_we | (en4 & ins_ldr_3);


	assign rdy = ( (~ins_ldr_3) | (ins_ldr_3 & dmem_rdy) );
	assign stall3 = valid_out3 & (~rdy);
	assign ack3 = en4;


	///////////////////////////////////////////////////////////////////////////
	////////// REGISTERS //////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

   always @ (*)
   begin
         if (en4 & ins_ldr_3) begin
           nxt_rd_din = dmem_dout[BITS-1:0];
        end
        else begin
           nxt_rd_din = rd_din;
        end
   end

   registers registers(
      .clk (clk),
      .run (run),
      .we (reg_we_arb),
      .rd (rd_sel_arb),
      .rs1 (rs1),
      .rs2 (rs2),
      .rd_din (nxt_rd_din),
      .rs1_dout (rs1_dout),
      .rs2_dout (rs2_dout)

//      .debug_reg_sel (debug_reg_sel),
//      .debug_reg_dout (debug_reg_dout)
   );


	///////////////////////////////////////////////////////////////////////////

	/////////////////////////////
	////////   Hazard   ////////
	/////////////////////////////

	always @ (posedge clk)
	begin
		if (rst) begin
			ldr_hzd <= 0;
		end
		else if (run & (~ stall3) & (~ stall_dmem_bsy))
			if (( ~(rd==0)) & (ins_ldr )  & ~ stall) 
				ldr_hzd <= ('d1 << rd);
			else
				ldr_hzd <= 0;
		else begin
			ldr_hzd <= ldr_hzd;
		end
	end

	
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////
	////////   DEBUG   ////////
	///////////////////////////

//	assign debug_pc = pc_2;
//	assign debug_instr = instr_2;

endmodule
