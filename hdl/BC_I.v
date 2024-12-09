//Don't change the module I/O
module BC_I (
    input clk,
    input FGI,
    output [11:0] PC,
    output [11:0] AR,
    output [15:0] IR,
    output [15:0] AC,
    output [15:0] DR
);


  //Declare your wires here

  wire BUS_sel;
  wire [2:0] ALU_sel;

  wire MEM_write;

  wire AR_write;
  wire AR_increment;
  wire AR_clear;

  wire PC_write;
  wire PC_increment;
  wire PC_clear;

  wire DR_write;
  wire DR_increment;
  wire DR_clear;

  wire AC_write;
  wire AC_increment;
  wire AC_clear;

  wire IR_write;

  wire TR_write;
  wire TR_increment;
  wire TR_clear;

  wire OUTR_write;

  wire IEN_set;
  wire IEN_clear;

  wire [2:0] ALU_SEL;

  wire [2:0] BUS_SEL;

  wire [15:0] BUS;

  wire E;
  wire IEN;



  // Instantiate your datapath and controller here, then connect them.

  Datapath datapath (
      .clk(clk),  //
      .BUS_SEL(BUS_SEL),  //
      .ALU_SEL(ALU_SEL),  //

      .MEM_write(MEM_write),  //

      .AR_write(AR_write),  //
      .AR_increment(AR_increment),  //
      .AR_clear(AR_clear),  //

      .PC_write(PC_write),  //
      .PC_increment(PC_increment),  //
      .PC_clear(PC_clear),  //

      .DR_write(DR_write),  //
      .DR_increment(DR_increment),  //
      .DR_clear(DR_clear),  //

      .AC_write(AC_write),  //
      .AC_increment(AC_increment),  //
      .AC_clear(AC_clear),  //

      .IR_write(IR_write),  //

      .TR_write(TR_write),  //
      .TR_increment(TR_increment),  //
      .TR_clear(TR_clear),  //

      .IEN_set  (IEN_set),   //
      .IEN_clear(IEN_clear), //

      .OUTR_write(OUTR_write),  //
      .data_out(BUS),  //

      .E  (E),   //
      .IEN(IEN), //


      // Outputs for the simulation
      .AC(AC),  //
      .DR(DR),  //
      .IR(IR),  //
      .PC(PC),  //
      .AR(AR)   //


  );


  Controller controller (
      .clk(clk),  //
      .IR(IR),  //
      .databus(BUS),  //
      .E(E),  //
      .IEN(IEN),  //
      .FGI(FGI),  //
      .FGO(0),  // no output functionality

      .MEM_write(MEM_write),  //

      .AR_write(AR_write),  //
      .AR_increment(AR_increment),  //
      .AR_clear(AR_clear),

      .PC_write(PC_write),
      .PC_increment(PC_increment),
      .PC_clear(PC_clear),

      .DR_write(DR_write),
      .DR_increment(DR_increment),
      .DR_clear(DR_clear),

      .AC_write(AC_write),
      .AC_increment(AC_increment),
      .AC_clear(AC_clear),

      .IR_write(IR_write),

      .TR_write(TR_write),
      .TR_increment(TR_increment),
      .TR_clear(TR_clear),

      .OUTR_write(OUTR_write),

      .IEN_set  (IEN_set),
      .IEN_clear(IEN_clear),

      .ALU_SEL(ALU_SEL),

      .BUS_SEL(BUS_SEL)


  );

endmodule
