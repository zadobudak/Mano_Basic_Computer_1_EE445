module controller (
    input clk,
    input [15:0] IR,
    input [15:0] databus,
    input E,
    input IEN,
    input FGI,
    input FGO,

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


  // wire declarations

  wire SC_clear;
  wire SC_increment;
  wire [3:0] SC_count;
  wire [7:0] D;
  wire [15:0] T;
  wire I;
  wire I_set;
  wire I_clear = 0;  // always 0
  wire R;


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

  DFF R_DFF (
      .D(1),
      .clock(clk),
      .clear(0),
      .enable(R_set),
      .Q(R)
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
  wire R_set = ((~T[0]) & (~T[1]) & (~T[2]) & IEN & (FGI | FGO));
  wire R_clear = R & T[2];


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
  assign ar_read = (D[4] & T[4]) | (D[5] & T[5]);
  assign pc_read = (T[0] & (~R)) | (D[5] & T[4]);
  assign dr_read = (D[2] & D[5]) | (D[6] & T[6]);
  assign ac_read = (D[3] & T[4]) | (reg_ref & (IR[4] | IR[5] | IR[6]));
  assign ir_read = T[2];
  assign tr_read = R & T[1];  // always 0 since no interrupt is implemented
  assign no_read = 0;  // no read signal






  assign AR_write = T[0] | T[2] | ind_ref;  // calculation for AR write
  assign AR_clear = 0;  // always 0 since no interrupt is implemented
  assign AR_increment = D[5] & T[4];

  assign PC_write = (D[4] & T[4]) | (D[5] & T[5]);  // calculation for PC write
  assign PC_clear = 0;  // always 0 since no interrupt is implemented
  assign PC_increment = T[1] | (D[6] & T[6] & (databus == 0)) |
                        (reg_ref & ((IR[4] & (~databus[15])) | 
                                    (IR[5] & databus[15]) |
                                    (IR[6] & (databus == 0)) |
                                    (IR[7] & E)));

  assign DR_write = T[4] & (D[0] | D[1] | D[2] | D[6]);  // calculation for DR write
  assign DR_clear = 0;  // always 0 since no interrupt is implemented
  assign DR_increment = D[6] & T[5];
  
  assign AC_write = (T[5] & (D[0] | D[1] | D[2])) | (reg_ref & (IR[6] | IR[7] | IR[9]));  // calculation for AC write
  assign AC_clear = reg_ref & IR[11];  // always 0 since no interrupt is implemented
  assign AC_increment = reg_ref & IR[5];
  
  assign IR_write = (~R) & T[1] ; 
  
  assign TR_write = R & T[0] ; 
  assign TR_increment = 0; 
  assign TR_clear = 0;  





endmodule
