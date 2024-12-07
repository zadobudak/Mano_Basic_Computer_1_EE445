// Decodes a 3-bit input to an 8-bit output
module Dec_3_8 (
    input  [2:0] A,
    output [7:0] Y
);

  assign Y[0] = (A == 3'b000) ? 1'b1 : 1'b0;
  assign Y[1] = (A == 3'b001) ? 1'b1 : 1'b0;
  assign Y[2] = (A == 3'b010) ? 1'b1 : 1'b0;
  assign Y[3] = (A == 3'b011) ? 1'b1 : 1'b0;
  assign Y[4] = (A == 3'b100) ? 1'b1 : 1'b0;
  assign Y[5] = (A == 3'b101) ? 1'b1 : 1'b0;
  assign Y[6] = (A == 3'b110) ? 1'b1 : 1'b0;
  assign Y[7] = (A == 3'b111) ? 1'b1 : 1'b0;

endmodule
