/* des.v
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

module des(
	input in_clk,
	input rst,

   input [15:0] des_sin,
   output reg [15:0] des_sout,

   input [63:0] des_din,
   output reg [63:0] des_dout,

	output reg des_clk_out
);

   reg [2:0] des_counter;

   always @ (posedge in_clk, posedge rst)
   begin
      if (rst) 
         des_counter <= 3'b111;
      else if (des_counter == 3'b111) 
         des_counter <= 3'b000;
      else 
         des_counter <= des_counter + 1;
   end

   always @ (posedge(in_clk), posedge(rst))
   begin
      if (rst == 1'b1)
         des_clk_out <= 0;
      else if (des_counter[1:0] == 2'b11)
         des_clk_out <= ~ des_clk_out;
      else
         des_clk_out <= des_clk_out;
   end

   always @ (posedge in_clk)
   begin
      case (des_counter)
         3'b000: des_dout[15:0] <= des_sin;
         3'b001: des_dout[31:16] <= des_sin;
         3'b010: des_dout[47:32] <= des_sin;
         3'b011: des_dout[63:48] <= des_sin;
         3'b100: begin end
         3'b101: begin end
         3'b110: begin end
         3'b111: begin end
      endcase
   end

   always @ (*)
   begin
      case (des_counter[1:0])
         2'b00: des_sout = des_din[15:0];
         2'b01: des_sout = des_din[31:16];
         2'b10: des_sout = des_din[47:32];
         2'b11: des_sout = des_din[63:48];
      endcase
   end

endmodule
