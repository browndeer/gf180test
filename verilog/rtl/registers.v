/* registers.v
 *
 * Copyright (c) 2022 Brown Deer Technology, LLC. (www.browndeertechnology.com)
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

module registers(
	input clk,
	input run,
	input we,
	input [RBITS-1:0] rd,
	input [RBITS-1:0] rs1,
	input [RBITS-1:0] rs2,
	input [BITS-1:0] rd_din,
	output reg [BITS-1:0] rs1_dout,
	output reg [BITS-1:0] rs2_dout

//	input [RBITS-1:0] debug_reg_sel,
//	output reg [BITS-1:0] debug_reg_dout
);

	parameter BITS = 16;
	parameter RBITS = 4;
	parameter NREG = 16;

	reg [BITS-1:0] r1;
	reg [BITS-1:0] r2;
	reg [BITS-1:0] r3;
	reg [BITS-1:0] r4;
	reg [BITS-1:0] r5;
	reg [BITS-1:0] r6;
	reg [BITS-1:0] r7;
	reg [BITS-1:0] r8;
	reg [BITS-1:0] r9;
	reg [BITS-1:0] r10;
	reg [BITS-1:0] r11;
	reg [BITS-1:0] r12;
	reg [BITS-1:0] r13;
	reg [BITS-1:0] r14;
	reg [BITS-1:0] r15;

	always @ (posedge clk)
	begin
		if (run & we & (rd==4'b0001)) 
    	  r1 <= rd_din;
		else 
			r1 <= r1;

		if (run & we & (rd==4'b0010)) 
    	  r2 <= rd_din;
		else 
			r2 <= r2;

		if (run & we & (rd==4'b0011)) 
    	  r3 <= rd_din;
		else 
			r3 <= r3;

		if (run & we & (rd==4'b0100)) 
    	  r4 <= rd_din;
		else 
			r4 <= r4;

		if (run & we & (rd==4'b0101)) 
    	  r5 <= rd_din;
		else 
			r5 <= r5;

		if (run & we & (rd==4'b0110)) 
    	  r6 <= rd_din;
		else 
			r6 <= r6;

		if (run & we & (rd==4'b0111)) 
    	  r7 <= rd_din;
		else 
			r7 <= r7;

		if (run & we & (rd==4'b1000)) 
    	  r8 <= rd_din;
		else 
			r8 <= r8;

		if (run & we & (rd==4'b1001)) 
    	  r9 <= rd_din;
		else 
			r9 <= r9;

		if (run & we & (rd==4'b1010)) 
    	  r10 <= rd_din;
		else 
			r10 <= r10;

		if (run & we & (rd==4'b1011)) 
    	  r11 <= rd_din;
		else 
			r11 <= r11;

		if (run & we & (rd==4'b1100)) 
    	  r12 <= rd_din;
		else 
			r12 <= r12;

		if (run & we & (rd==4'b1101)) 
    	  r13 <= rd_din;
		else 
			r13 <= r13;

		if (run & we & (rd==4'b1110)) 
    	  r14 <= rd_din;
		else 
			r14 <= r14;

		if (run & we & (rd==4'b1111)) 
    	  r15 <= rd_din;
		else 
			r15 <= r15;
	end


	/// read register

	always @ (*)
	begin

		case (rs1)
			4'b0000: rs1_dout = 'd0;
			4'b0001: rs1_dout = r1;
			4'b0010: rs1_dout = r2;
			4'b0011: rs1_dout = r3;
			4'b0100: rs1_dout = r4;
			4'b0101: rs1_dout = r5;
			4'b0110: rs1_dout = r6;
			4'b0111: rs1_dout = r7;
			4'b1000: rs1_dout = r8;
			4'b1001: rs1_dout = r9;
			4'b1010: rs1_dout = r10;
			4'b1011: rs1_dout = r11;
			4'b1100: rs1_dout = r12;
			4'b1101: rs1_dout = r13;
			4'b1110: rs1_dout = r14;
			4'b1111: rs1_dout = r15;
		endcase

		case (rs2)
			4'b0000: rs2_dout = 'd0;
			4'b0001: rs2_dout = r1;
			4'b0010: rs2_dout = r2;
			4'b0011: rs2_dout = r3;
			4'b0100: rs2_dout = r4;
			4'b0101: rs2_dout = r5;
			4'b0110: rs2_dout = r6;
			4'b0111: rs2_dout = r7;
			4'b1000: rs2_dout = r8;
			4'b1001: rs2_dout = r9;
			4'b1010: rs2_dout = r10;
			4'b1011: rs2_dout = r11;
			4'b1100: rs2_dout = r12;
			4'b1101: rs2_dout = r13;
			4'b1110: rs2_dout = r14;
			4'b1111: rs2_dout = r15;
		endcase

	end

/*
	always @ (*)
	begin
		case(debug_reg_sel)
			4'b0000: debug_reg_dout = 'd0;
			4'b0001: debug_reg_dout = r1;
			4'b0010: debug_reg_dout = r2;
			4'b0011: debug_reg_dout = r3;
			4'b0100: debug_reg_dout = r4;
			4'b0101: debug_reg_dout = r5;
			4'b0110: debug_reg_dout = r6;
			4'b0111: debug_reg_dout = r7;
			4'b1000: debug_reg_dout = r8;
			4'b1001: debug_reg_dout = r9;
			4'b1010: debug_reg_dout = r10;
			4'b1011: debug_reg_dout = r11;
			4'b1100: debug_reg_dout = r12;
			4'b1101: debug_reg_dout = r13;
			4'b1110: debug_reg_dout = r14;
			4'b1111: debug_reg_dout = r15;
		endcase
	end
*/

endmodule
