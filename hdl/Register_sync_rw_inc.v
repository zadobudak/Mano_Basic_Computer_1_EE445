module Register_sync_rw_inc #(
    parameter W = 4
) (
    input clk,
    reset,
    write,
	increment,
    input [W-1:0] DATA,
    output reg [W-1:0] A
);
initial begin
    A = 0;

end

  always @(posedge clk) begin
    case (reset)
      1'b0: begin
        if (write == 1'b1) A <= DATA;
		else if (increment == 1'b1) A <= A + 1;
		else A <= A;
      end
      1'b1: A <= 0;
      default: A <= 0;
    endcase

  end

endmodule
