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

module not_gate_using_mux
(
    input  i,
    output o
);

  // Task:
  // Implement not gate using instance(s) of mux,
  // constants 0 and 1, and wire connections

  /*
       _
  1   | \
  ----|  \   o
      |   |---
  0   |   |
  ----|  /
      |_/
       |
       | i
  */

  wire mux_not_output;

  mux mux_not (
    .d0  ( 1               ),
    .d1  ( 0               ),
    .sel ( i               ),
    .y   ( mux_not_output )
  );

  assign o = mux_not_output;

endmodule
