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

module and_gate_using_mux
(
    input  a,
    input  b,
    output o
);

  // Task:
  // Implement and gate using instance(s) of mux,
  // constants 0 and 1, and wire connections

  /*
       _
  0   | \
  ----|  \   o
      |   |---
  b   |   |
  ----|  /
      |_/
       |
       | a
  */

  wire mux_and_output;

  mux mux_and (
    .d0  ( 0               ),
    .d1  ( b               ),
    .sel ( a               ),
    .y   ( mux_and_output )
  );

  assign o = mux_and_output;

endmodule
