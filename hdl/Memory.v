module Memory (
    input clk,
    input write,
    input [11:0] address,
    input [15:0] data_in,
    output [15:0] data_out
);

  initial begin
    $readmemh("memory.txt", memory);
  end
  reg [15:0] memory[4096];

  always @(posedge clk) begin
    if (write) begin
      memory[address] <= data_in;
    end
  end

  assign data_out = memory[address];


endmodule
