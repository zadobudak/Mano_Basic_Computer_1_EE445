module memory_4096_16(
input clk,
input write,
input [11:0] address,
input [15:0] data_in,
output [15:0] data_out
);

    reg [15:0] memory [0:4095];
    
    always @(posedge clk) begin
        if(write) begin
            memory[address] <= data_in;
        end
    end
    
    assign data_out = memory[address];

    
endmodule