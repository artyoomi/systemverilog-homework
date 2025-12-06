//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module add
(
  input  [3:0] a, b,
  output [3:0] sum
);

  assign sum = a + b;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module full_adder
(
  input  a, b,
  input  carry_in,
  output sum,
  output carry_out
);

  assign sum       = a ^ b ^ carry_in;
  assign carry_out = a & b | a & carry_in | b & carry_in;

endmodule


module signed_add_with_overflow #(parameter N = 4)
(
  input  [N - 1:0] a, b,
  output [N - 1:0] sum,
  output           overflow
);

  // Task:
  //
  // Implement a module that adds two signed numbers
  // and detects an overflow.
  //
  // By "signed" we mean "two's complement numbers".
  // See https://en.wikipedia.org/wiki/Two%27s_complement for details.
  //
  // The 'overflow' output bit should be set to 1
  // when the resulting sum (either positive or negative)
  // of two input arguments is greater or less than
  // 4-bit maximum or minimum signed number.
  //
  // Otherwise the 'overflow' should be set to 0.

  logic [N    :0] carry;
  logic [N - 1:0] curr_sum;

  // Carry initially must be 0
  assign carry[0] = '0;

  generate
    for (genvar i = 0; i < N; i++) begin : fa_chain
      full_adder fa (
        .a         (a[i]       ),
        .b         (b[i]       ),
        .carry_in  (carry[i]   ),
        .sum       (curr_sum[i]),
        .carry_out (carry[i+1] )
      );
    end
  endgenerate

  assign sum      = curr_sum;
  assign overflow = (a[N - 1] == b[N - 1]) & (curr_sum[N - 1] != a[N - 1]);

endmodule
