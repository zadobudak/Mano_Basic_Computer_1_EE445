// Sequence counter module
module SC #(
    parameter W = 4
) (
    input clk,
    input reset,
    input increment,

    output reg [W-1:0] count
);
initial begin
    count = 0;
end


  always @(posedge clk) begin
    if (reset) begin
      count <= 0;
    end else if (increment) begin
      count <= count + 1;
    end
  end

endmodule
