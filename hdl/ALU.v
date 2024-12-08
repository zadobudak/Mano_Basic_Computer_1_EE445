module ALU #(
    parameter W = 16
) (
    input [W-1:0] AC,  // W bit input
    input [W-1:0] DR,  // W bit input
    input E,  // 1 bit input for CO 
    input [2:0] SEL,  // 3 bit operation select
    output reg [W-1:0] RES,  // W bit output result
    output reg CO,  // 1 bit output CO carry out
    output reg OVF,  // 1 bit output OVF overflow
    output reg N,  // 1 bit output Negative N
    output reg Z  // 1 bit output Zero Z
);

  localparam ADD = 3'b000;
  localparam AND = 3'b001;
  localparam TRANSFER = 3'b010;
  localparam COMPLEMENT = 3'b011;
  localparam SHIFT_RIGHT = 3'b100;
  localparam SHIFT_LEFT = 3'b101;

  reg [W:0] temp;
  // case statement to select the operation
  always @(*) begin
    case (SEL)

      ADD: temp = AC + DR;
      AND: temp[W-1:0] = AC & DR;
      TRANSFER: temp[W-1:0] = DR;
      COMPLEMENT: temp[W-1:0] = ~AC;
      SHIFT_RIGHT: temp[W-1:0] = {E, AC[W-1:1]};
      SHIFT_LEFT: temp[W-1:0] = {AC[W-1:1], E};
      default: temp = 17'b0;
    endcase

    // Set the flags
  end
  assign CO  = (SEL == ADD) & temp[W];  // carry out if ADD operation and temp[W] is 1 else 0
  assign OVF = (SEL == ADD) & (AC[W-1] == DR[W-1]) && (AC[W-1] != RES[W-1]);
  assign Z   = (RES == 0);
  assign N   = (RES[W-1] == 1);
  assign RES = temp[W-1:0];







endmodule
