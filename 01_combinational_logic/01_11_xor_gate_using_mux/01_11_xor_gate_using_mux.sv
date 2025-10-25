//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module mux
(
  input  d0, d1,
  input  sel,
  output y
);

  assign y = sel ? d1 : d0;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

`include "01_08_not_gate_using_mux.sv"
module xor_gate_using_mux
(
    input  a,
    input  b,
    output o
);

  // Task:
  // Implement xor gate using instance(s) of mux,
  // constants 0 and 1, and wire connections

  /*
               _
          b   | \
       _  ----|  \   o
  1   | \     |   |---
  ----|  \    |   |
      |   |---|  /
  0   |   |   |_/
  ----|  /     |
      |_/      | a
       |
       | b
  */

  wire not_b, mux_xor_output;

  not_gate_using_mux mux_gate (
    .i ( b     ),
    .o ( not_b )
  );

  mux mux_xor (
    .d0  ( b              ),
    .d1  ( not_b          ),
    .sel ( a              ),
    .y   ( mux_xor_output )
  );

  assign y = mux_xor_output;

endmodule
