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




  // case statement to select the operation
  always @(*) begin
    case (SEL)

      ADD: begin
        // Add the two inputs Then put them in {CO, RES}
        {CO, RES} = AC + DR;
        // since we are using 2's complement, we need to check for overflow
        // if the sign of the two inputs is the same and the sign of the result is different
        // then we have an overflow
        OVF = (AC[W-1] == DR[W-1]) && (AC[W-1] != RES[W-1]);

      end
      AND: begin
        RES = AC & DR;
        CO = 0;
        OVF = 0;
      end
      TRANSFER: begin
        RES = DR;
        CO = 0;
        OVF = 0;
      end
      COMPLEMENT: begin
        RES = ~DR;
        CO = 0;
        OVF = 0;
      end
      SHIFT_RIGHT: begin
        RES = AC >> 1;
        RES[W-1] = E;
        CO = 0;
        OVF = 0;
      end
      SHIFT_LEFT: begin
        RES = AC << 1;
        RES[0] = E;
        CO = 0;
        OVF = 0;
      end
    // Not sure if they are needed default case is added
    //   3'b110: begin
    //     RES = AC;
    //     CO = 0;
    //   end
    //   3'b111: begin
    //     RES = AC;
    //     CO = 0;
    //   end
      default: begin
        RES = AC;
        CO = 0;
        OVF = 0;
      end
    endcase

    // Set the flags
  end
  
assign Z = (RES == 0);
assign N = (RES[W-1] == 1);







endmodule
