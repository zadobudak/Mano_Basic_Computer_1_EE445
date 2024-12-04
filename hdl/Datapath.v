// Datapath module

module datapath #(
) (
    input clk,
    input [2:0] sel,

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
    output reg [15:0] data_out
);
  wire [15:0] common_bus;
  wire [11:0] AR;
  wire [11:0] PC;
  wire [15:0] DR;
  wire [15:0] AC;
  wire [15:0] IR;
  wire [15:0] TR;
  wire [7:0] OUTR;
  wire [7:0] INPR;
  wire [15:0] ALU_RES;


  wire ALU_CO;
  wire E;

  ALU #(
      .W(16)
  ) Alu_module (
      .AC (AC),
      .DR (DR),
      .E  (E),
      .SEL(sel),
      .RES(ALU_RES),
      .CO (ALU_CO),
      .OVF(),
      .N  (),
      .Z  ()
  );

  Register_sync_rw_inc #(
      .W(1)
  ) E_reg (
      .clk(clk),
      .reset(0),
      .write(0),
      .increment(0),
      .DATA(ALU_CO),
      .A(E)
  );

  Register_sync_rw_inc #(
      .W(12)
  ) AR_reg (
      .clk(clk),
      .reset(AR_clear),
      .write(AR_write),
      .increment(AR_increment),
      .DATA(common_bus),
      .A(AR)
  );

  Register_sync_rw_inc #(
      .W(12)
  ) PC_reg (
      .clk(clk),
      .reset(PC_clear),
      .write(PC_write),
      .increment(PC_increment),
      .DATA(common_bus),
      .A(PC)
  );


  Register_sync_rw_inc #(
      .W(16)
  ) DR_reg (
      .clk(clk),
      .reset(DR_clear),
      .write(DR_write),
      .increment(DR_increment),
      .DATA(common_bus),
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




endmodule
