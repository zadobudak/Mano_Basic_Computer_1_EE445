module Dec_4_16 (
    input  [ 3:0] A,
    output [15:0] Y
);

assign Y[0]  = (A == 4'b0000) ? 1'b1 : 1'b0;
assign Y[1]  = (A == 4'b0001) ? 1'b1 : 1'b0;
assign Y[2]  = (A == 4'b0010) ? 1'b1 : 1'b0;
assign Y[3]  = (A == 4'b0011) ? 1'b1 : 1'b0;
assign Y[4]  = (A == 4'b0100) ? 1'b1 : 1'b0;
assign Y[5]  = (A == 4'b0101) ? 1'b1 : 1'b0;
assign Y[6]  = (A == 4'b0110) ? 1'b1 : 1'b0;
assign Y[7]  = (A == 4'b0111) ? 1'b1 : 1'b0;
assign Y[8]  = (A == 4'b1000) ? 1'b1 : 1'b0;
assign Y[9]  = (A == 4'b1001) ? 1'b1 : 1'b0;
assign Y[10] = (A == 4'b1010) ? 1'b1 : 1'b0;
assign Y[11] = (A == 4'b1011) ? 1'b1 : 1'b0;
assign Y[12] = (A == 4'b1100) ? 1'b1 : 1'b0;
assign Y[13] = (A == 4'b1101) ? 1'b1 : 1'b0;
assign Y[14] = (A == 4'b1110) ? 1'b1 : 1'b0;
assign Y[15] = (A == 4'b1111) ? 1'b1 : 1'b0;




endmodule
