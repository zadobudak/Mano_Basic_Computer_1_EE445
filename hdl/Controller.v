module Controller (
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
    
    output reg E_clear,
    output reg E_increment,

    output reg OUTR_write,

    output reg IEN_set,
    output reg IEN_clear,

    output reg [2:0] ALU_SEL,

    output reg [2:0] BUS_SEL

);

  localparam ALU_ADD = 3'b000;
  localparam ALU_AND = 3'b001;
  localparam ALU_TRANSFER = 3'b010;
  localparam ALU_COMPLEMENT = 3'b011;
  localparam ALU_SHIFT_RIGHT = 3'b100;
  localparam ALU_SHIFT_LEFT = 3'b101;


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
      .Y(BUS_SEL)
  );

  // Combinational Logic for Control Signals
  // assign needed stuff
  wire reg_ref = D[7] & (~I) & T[3];  // calculation for register reference mode. 
  wire ind_ref = (~D[7]) & I & T[3];  // calculation for indirect reference mode
  wire in_out = D[7] & I & T[3];  // calculation for input/output mode
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


  // Connect each read signal to the corresponding bit in bus_preload
  wire [7:0] bus_preload;
  assign bus_preload[0] = no_read;
  assign bus_preload[1] = ar_read;
  assign bus_preload[2] = pc_read;
  assign bus_preload[3] = dr_read;
  assign bus_preload[4] = ac_read;
  assign bus_preload[5] = ir_read;
  assign bus_preload[6] = tr_read;
  assign bus_preload[7] = mem_read;


  // ----- Read signals for BUS -----
  assign mem_read = (ind_ref) | (T[1] & (~R)) | ((D[0] | D[1] | D[2] | D[6]) & T[4]);
  assign ar_read = (D[4] & T[4]) | (D[5] & T[5]);
  assign pc_read = (T[0] & (~R)) | (D[5] & T[4]);
  assign dr_read = (D[2] & D[5]) | (D[6] & T[6]);
  assign ac_read = (D[3] & T[4]) | (reg_ref & (IR[4] | IR[5] | IR[6]));
  assign ir_read = T[2];
  assign tr_read = R & T[1];  // always 0 since no interrupt is implemented
  assign no_read = 0;  // no read signal




  // write clear and increment signals for different registers

  assign AR_write = ((~R) & T[0]) | ((~R) & T[2]) | ind_ref;  // calculation for AR write
  assign AR_clear = 0;  // always 0 since no interrupt is implemented
  assign AR_increment = D[5] & T[4];

  assign PC_write = (D[4] & T[4]) | (D[5] & T[5]);  // calculation for PC write
  assign PC_clear = 0;  // always 0 since no interrupt is implemented
  assign PC_increment = (T[1] & (~R)) |
                        (D[6] & T[6] & (databus == 16'd0)) |
                        (reg_ref & ((IR[4] & (~databus[15])) |
                                    (IR[3] & databus[15]) |
                                    (IR[2] & (databus == 0)) |
                                    (IR[1] & ~E)));

  assign DR_write = T[4] & (D[0] | D[1] | D[2] | D[6]);  // calculation for DR write
  assign DR_clear = 0;  // always 0 since no interrupt is implemented
  assign DR_increment = D[6] & T[5];

  assign AC_write = (T[5] & (D[0] | D[1] | D[2])) | (reg_ref & (IR[6] | IR[7] | IR[9]));  // calculation for AC write
  assign AC_clear = reg_ref & IR[11];  
  assign AC_increment = reg_ref & IR[5];
  
  assign E_clear = reg_ref & IR[10];
  assign E_increment = reg_ref & IR[8];

  assign IR_write = (~R) & T[1];

  assign TR_write = R & T[0];
  assign TR_increment = 0;
  assign TR_clear = 0;

  assign MEM_write = (R & T[1]) | (D[3] & T[4]) | (D[5] & T[5]) | (D[6] & T[6]);

  assign ALU_SEL = (D[0]&T[5]) ? ALU_AND :
                     (D[1]&T[5]) ? ALU_ADD :
                     (D[2]&T[5]) ? ALU_TRANSFER :
                     (reg_ref & IR[9]) ? ALU_COMPLEMENT :
                     (reg_ref & IR[7]) ? ALU_SHIFT_RIGHT :
                     (reg_ref & IR[6]) ? ALU_SHIFT_LEFT :
                     3'b111;

  assign IEN_set = in_out & IR[7];
  assign IEN_clear = in_out & IR[6];
  assign SC_increment = 1;
  assign SC_clear = (reg_ref & T[2]) |
                                    (D[0] & T[5]) |
                                    (D[1] & T[5]) |
                                    (D[2] & T[5]) |
                                    (D[3] & T[4]) |
                                    (D[4] & T[4]) |
                                    (D[5] & T[5]) |
                                    (D[6] & T[6]) |
                                    reg_ref |
                                    in_out ;
  assign OUTR_write = 0;  //since no I/O is implemented
  
  assign I_set = (~R) & T[2];
  assign I_clear = 0;

  always @(posedge clk) begin


    // $display("T: %b", T);
    // $display("D: %b", D);
    // $display("databus: %b", databus);
    // 


    // Display the microinstructions as DxTx 
    $display("D:%d", IR[14:12]);
    $display("T:%d", SC_count);




    // display ALU select and BUS select with their values and operations
    $display("ALU_SEL: %b", ALU_SEL);
    // display What ALU_SEL is doing
    case (ALU_SEL)
      ALU_ADD: $display("ALU_ADD");
      ALU_AND: $display("ALU_AND");
      ALU_TRANSFER: $display("ALU_TRANSFER");
      ALU_COMPLEMENT: $display("ALU_COMPLEMENT");
      ALU_SHIFT_RIGHT: $display("ALU_SHIFT_RIGHT");
      ALU_SHIFT_LEFT: $display("ALU_SHIFT_LEFT");
      default: $display("ALU default");
    endcase

    $display("BUS_SEL: %b", BUS_SEL);
    // display What BUS_SEL is doing

    case (BUS_SEL)
      3'b000:  $display("BUS_SEL: empty");
      3'b001:  $display("BUS_SEL: AR");
      3'b010:  $display("BUS_SEL: PC");
      3'b011:  $display("BUS_SEL: DR");
      3'b100:  $display("BUS_SEL: AC");
      3'b101:  $display("BUS_SEL: IR");
      3'b110:  $display("BUS_SEL: TR");
      3'b111:  $display("BUS_SEL: MEM");
      default: $display("BUS_SEL: default");
    endcase

    $display("MEM_write: %b", MEM_write);
    $display("AR_write: %b", AR_write);
    $display("AR_increment: %b", AR_increment);
    $display("AR_clear: %b", AR_clear);
    $display("PC_write: %b", PC_write);
    $display("PC_increment: %b", PC_increment);
    $display("PC_clear: %b", PC_clear);
    $display("DR_write: %b", DR_write);
    $display("DR_increment: %b", DR_increment);
    $display("DR_clear: %b", DR_clear);
    $display("AC_write: %b", AC_write);
    $display("AC_increment: %b", AC_increment);
    $display("AC_clear: %b", AC_clear);
    $display("IR_write: %b", IR_write);
    $display("TR_write: %b", TR_write);
    $display("TR_increment: %b", TR_increment);
    $display("TR_clear: %b", TR_clear);
    $display("OUTR_write: %b", OUTR_write);
    $display("IEN_set: %b", IEN_set);
    $display("IEN_clear: %b", IEN_clear);
    $display("IR: %h", IR);
    $display("databus: %h", databus);
    $display("E: %b", E);
    $display("IEN: %b", IEN);
    $display("FGI: %b", FGI);
    $display("FGO: %b", FGO);
    $display("SC_clear: %b", SC_clear);
    $display("SC_increment: %b", SC_increment);
    $display("R: %b", R);
    $display("I: %b", I);


  end

endmodule
