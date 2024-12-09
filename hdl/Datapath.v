// Datapath module

module Datapath(
    input clk,
    input [2:0] BUS_SEL,

    input [2:0] ALU_SEL,

    input MEM_write,

    input AR_write,
    input AR_increment,
    input AR_clear,

    input PC_write,
    input PC_increment,
    input PC_clear,

    input DR_write,
    input DR_increment,
    input DR_clear,

    input AC_write,
    input AC_increment,
    input AC_clear,

    input IR_write,

    input TR_write,
    input TR_increment,
    input TR_clear,

    input OUTR_write,
    
    input IEN_set,
    input IEN_clear,
    
    input E_clear,
    input E_increment,
    output reg [15:0] data_out,

    output [11:0] PC,
    output [11:0] AR,
    output [15:0] IR,
    output [15:0] AC,
    output [15:0] DR ,
    output [15:0] TR,
    output E ,
    output IEN
);


  wire [15:0] MEM;
//   wire [15:0] TR;
  wire [7:0] OUTR;
  wire [7:0] INPR;
  wire [15:0] ALU_RES;


  wire ALU_CO;


  // Memory module instantiation
  Memory MEM_module (
      .clk(clk),
      .write(MEM_write),
      .address(AR),
      .data_in(data_out),
      .data_out(MEM)
  );


  //   TODO : connect needed signals

  // ALU module instantiation
  ALU #(
      .W(16)
  ) Alu_module (
      .AC (AC),
      .DR (DR),
      .E  (E),
      .SEL(ALU_SEL),
      .RES(ALU_RES),
      .CO (ALU_CO),
      .OVF(),
      .N  (),
      .Z  ()
  );

  // E register for ALU
  Register_sync_rw_inc #(
      .W(1)
  ) E_reg (
      .clk(clk),
      .reset(E_clear),
      .write(AC_write),
      .increment(E_increment),
      .DATA(ALU_CO),
      .A(E)
  );

  // IEN register
  Register_sync_rw_inc #(
      .W(1)
  ) IEN_reg (
      .clk(clk),
      .reset(IEN_clear),
      .write(IEN_set),
      .increment(0),
      .DATA(1),
      .A(IEN)
  );

  // Address Register instantiation
  Register_sync_rw_inc #(
      .W(12)
  ) AR_reg (
      .clk(clk),
      .reset(AR_clear),
      .write(AR_write),
      .increment(AR_increment),
      .DATA(data_out[11:0]),
      .A(AR)
  );


  // Program Counter instantiation
  Register_sync_rw_inc #(
      .W(12)
  ) PC_reg (
      .clk(clk),
      .reset(PC_clear),
      .write(PC_write),
      .increment(PC_increment),
      .DATA(data_out[11:0]),
      .A(PC)
  );

  // Data Register instantiation
  Register_sync_rw_inc #(
      .W(16)
  ) DR_reg (
      .clk(clk),
      .reset(DR_clear),
      .write(DR_write),
      .increment(DR_increment),
      .DATA(data_out),
      .A(DR)
  );

  Register_sync_rw_inc #(
      .W(16)
  ) AC_reg (
      .clk(clk),
      .reset(AC_clear),
      .write(AC_write),
      .increment(AC_increment),
      .DATA(ALU_RES),
      .A(AC)
  );

  Register_sync_rw_inc #(
      .W(16)
  ) IR_reg (
      .clk(clk),
      .reset(0),
      .write(IR_write),
      .increment(0),
      .DATA(data_out),
      .A(IR)
  );

  Register_sync_rw_inc #(
      .W(16)
  ) TR_reg (
      .clk(clk),
      .reset(TR_clear),
      .write(TR_write),
      .increment(TR_increment),
      .DATA(data_out),
      .A(TR)
  );


  Register_sync_rw_inc #(
      .W(8)
  ) OUTR_reg (
      .clk(clk),
      .reset(0),
      .write(OUTR_write),
      .increment(0),
      .DATA(),
      .A(OUTR)
  );

  Register_sync_rw_inc #(
      .W(8)
  ) INPR_reg (
      .clk(clk),
      .reset(0),
      .write(0),
      .increment(0),
      .DATA(),
      .A(INPR)
  );





  Mux_8_1 #(
      .W(16)
  ) BUS_mux (
      .in0(16'b0),
      .in1({4'b0000, AR}),
      .in2({4'b0000, PC}),
      .in3(DR),
      .in4(AC),
      .in5(IR),
      .in6(TR),
      .in7(MEM),
      .sel(BUS_SEL),
      .out(data_out)
  );




endmodule
