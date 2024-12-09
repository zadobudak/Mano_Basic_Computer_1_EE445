module DFF (
    input D,
    clock,
    clear,
    enable,
    output reg Q
);
  initial begin
    Q = 0;
  end

  always @(posedge clock)
    if (clear) begin
      Q <= 0;
    end else if (enable) begin
      Q <= D;
    end
endmodule
