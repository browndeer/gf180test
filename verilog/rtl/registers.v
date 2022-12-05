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
	parameter RBITS = 3;
	parameter NREG = 8;

	reg [BITS-1:0] r1;
	reg [BITS-1:0] r2;
	reg [BITS-1:0] r3;
	reg [BITS-1:0] r4;
	reg [BITS-1:0] r5;
	reg [BITS-1:0] r6;
	reg [BITS-1:0] r7;

	always @ (posedge clk)
	begin
		if (run & we & (rd==3'b001)) 
    	  r1 <= rd_din;
		else 
			r1 <= r1;

		if (run & we & (rd==3'b010)) 
    	  r2 <= rd_din;
		else 
			r2 <= r2;

		if (run & we & (rd==3'b011)) 
    	  r3 <= rd_din;
		else 
			r3 <= r3;

		if (run & we & (rd==3'b100)) 
    	  r4 <= rd_din;
		else 
			r4 <= r4;

		if (run & we & (rd==3'b101)) 
    	  r5 <= rd_din;
		else 
			r5 <= r5;

		if (run & we & (rd==3'b110)) 
    	  r6 <= rd_din;
		else 
			r6 <= r6;

		if (run & we & (rd==3'b111)) 
    	  r7 <= rd_din;
		else 
			r7 <= r7;
	end


	/// read register

	always @ (*)
	begin

		case (rs1)
			3'b000: rs1_dout = 'd0;
			3'b001: rs1_dout = r1;
			3'b010: rs1_dout = r2;
			3'b011: rs1_dout = r3;
			3'b100: rs1_dout = r4;
			3'b101: rs1_dout = r5;
			3'b110: rs1_dout = r6;
			3'b111: rs1_dout = r7;
		endcase

		case (rs2)
			3'b000: rs2_dout = 'd0;
			3'b001: rs2_dout = r1;
			3'b010: rs2_dout = r2;
			3'b011: rs2_dout = r3;
			3'b100: rs2_dout = r4;
			3'b101: rs2_dout = r5;
			3'b110: rs2_dout = r6;
			3'b111: rs2_dout = r7;
		endcase

	end

/*
	always @ (*)
	begin
		case(debug_reg_sel)
			3'b000: debug_reg_dout = 'd0;
			3'b001: debug_reg_dout = r1;
			3'b010: debug_reg_dout = r2;
			3'b011: debug_reg_dout = r3;
			3'b100: debug_reg_dout = r4;
			3'b101: debug_reg_dout = r5;
			3'b110: debug_reg_dout = r6;
			3'b111: debug_reg_dout = r7;
		endcase
	end
*/

endmodule
