module controller (
    input clk,
    input [15:0] IR , 
    input [15:0] databus,
    
    output reg AR_write,
    output reg AR_increment,
    output reg AR_clear,

    output reg PC_write,
    output reg PC_increment,
    output reg PC_clear,

    output reg DR_write,
    output reg DR_increment,
    output reg DR_clear,

    output reg AC_write,
    output reg AC_increment,
    output reg AC_clear,

    output reg IR_write,

    output reg TR_write,

    output reg TR_increment,
    output reg TR_clear,

    output reg OUTR_write,

    output reg [15:0] data_out


);















endmodule