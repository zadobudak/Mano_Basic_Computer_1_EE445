// 8 to 1 multiplexer for W bits

module Mux_8_1 #(
    parameter W = 8
) (
    input [W-1:0] in0,
    input [W-1:0] in1,
    input [W-1:0] in2,
    input [W-1:0] in3,
    input [W-1:0] in4,
    input [W-1:0] in5,
    input [W-1:0] in6,
    input [W-1:0] in7,
    input [2:0] sel,
    output reg [W-1:0] out
);

  // use a case statement to select the output
  // Since we are using a case statement, we need to use a combinational block
  // Synthesis tools will infer a mux for us


  always @(*) begin
    case (sel)
      3'b000:  out = in0;
      3'b001:  out = in1;
      3'b010:  out = in2;
      3'b011:  out = in3;
      3'b100:  out = in4;
      3'b101:  out = in5;
      3'b110:  out = in6;
      3'b111:  out = in7;
      default: out = in0;
    endcase
  end

endmodule
