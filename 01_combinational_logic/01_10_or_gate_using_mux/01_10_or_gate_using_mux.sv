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

module or_gate_using_mux
(
    input  a,
    input  b,
    output o
);

  // Task:

  // Implement or gate using instance(s) of mux,
  // constants 0 and 1, and wire connections


    /*
       _
  b   | \
  ----|  \   o
      |   |---
  1   |   |
  ----|  /
      |_/
       |
       | a
  */

  wire mux_or_output;

  mux mux_or (
    .d0  ( b               ),
    .d1  ( 1               ),
    .sel ( a               ),
    .y   ( mux_or_output )
  );

  assign o = mux_or_output;


endmodule
