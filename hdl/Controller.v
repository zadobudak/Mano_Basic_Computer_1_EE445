module controller (
    input clk,
    input [15:0] IR,
    input [15:0] databus,

    output reg MEM_write,

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

    output reg [2:0] ALU_SEL,

    output reg [2:0] BUS,

    output reg [15:0] data_out

);

  // localparam AND = 3'b000;
  // localparam ADD = 3'b001;
  // localparam LDA = 3'b010;
  // localparam STA = 3'b011;
  // localparam BUN = 3'b100;
  // localparam BSA = 3'b101;
  // localparam ISZ = 3'b110;


  // localparam BUS_AR = 3'b001;
  // localparam BUS_PC = 3'b010;
  // localparam BUS_DR = 3'b011;
  // localparam BUS_AC = 3'b100;
  // localparam BUS_IR = 3'b101;
  // localparam BUS_TR = 3'b110;
  // localparam BUS_MEM = 3'b111;


  // localparam ALU_ADD = 3'b000;
  // localparam ALU_AND = 3'b001;
  // localparam ALU_TRANSFER = 3'b010;
  // localparam ALU_COMPLEMENT = 3'b011;
  // localparam ALU_SHIFT_RIGHT = 3'b100;
  // localparam ALU_SHIFT_LEFT = 3'b101;

  // wire declarations

  wire SC_clear;
  wire SC_increment;
  wire [3:0] SC_count;
  wire [7:0] D;
  wire [15:0] T;
  reg I;
  wire I_set;
  wire I_clear = 0;  // always 0


  //module declerations 

  // Sequence Counter

  SC #(
      .W(4)
  ) SC_module (
      .clk(clk),
      .reset(SC_clear),
      .increment(SC_increment),
      .count(SC_count)
  );


  // Decoder for opcode 

  Dec_3_8 Dec_3x8_module (
      .A(IR[14:12]),
      .Y(D)
  );


  // Decoder for 4-bit input to 16-bit output

  Dec_4_16 Dec_4x16_module (
      .A(SC_count),
      .Y(T)
  );

  DFF I_DFF (
      .D(IR[15]),
      .clock(clk),
      .clear(I_clear),
      .enable(I_set),
      .Q(I)
  );

  Enc_8_3 Bus_enc (
      .A(bus_preload),
      .Y(BUS)
  );

  // Combinational Logic for Control Signals
  // assign needed stuff
  // 
  // 


  

  wire reg_ref = D[7] & (~I) & T[3];  // calculation for register reference mode. 
  wire ind_ref = (~D[7]) & I & T[3];  // calculation for indirect reference mode
  

  // Different read signals for BUS 
  wire no_read;
  wire ar_read;
  wire pc_read;
  wire dr_read;
  wire ac_read;
  wire ir_read;
  wire tr_read;
  wire mem_read;

  wire [7:0] bus_preload = {
    mem_read, tr_read, ir_read, ac_read, dr_read, pc_read, ar_read, no_read
  };
  

  // ----- Read signals for BUS -----
  assign mem_read = T[1] & ind_ref | ((D[0] | D[1] | D[2] | D[6]) & T[4]);
  assign ar_read  = (D[4] & T[4]) | (D[5] & T[5]);
  assign pc_read  = T[0] | (D[5] & T[4]);
  assign dr_read  = (D[2] & D[5]) | (D[6] & T[6]);
  assign ac_read  = D[3] & T[4];
  assign ir_read  = T[2];
  assign tr_read  = 0;  // always 0 since no interrupt is implemented
  assign no_read  = 0;  // no read signal






  assign AR_write = T[0] | T[2] | ind_ref;  // calculation for AR write
  assign AR_clear = 0;  // always 0 since no interrupt is implemented
  assign AR_increment = D[5] & T[4];
  


























endmodule
