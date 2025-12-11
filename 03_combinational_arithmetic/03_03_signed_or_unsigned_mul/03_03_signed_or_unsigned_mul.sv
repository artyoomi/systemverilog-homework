//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

// A non-parameterized module
// that implements the signed multiplication of 4-bit numbers
// which produces 8-bit result

module signed_mul_4
(
  input  signed [3:0] a, b,
  output signed [7:0] res
);

  assign res = a * b;

endmodule

// A parameterized module
// that implements the unsigned multiplication of N-bit numbers
// which produces 2N-bit result

module unsigned_mul
# (
  parameter n = 8
)
(
  input  [    n - 1:0] a, b,
  output [2 * n - 1:0] res
);

  assign res = a * b;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module on_bit_multiplier
# (
  parameter n = 8
)
(
  input  [n - 1:0] a,
  input            b,
  output [n - 1:0] o
);

  assign o = a & { n { b } };

endmodule

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


// Task:
//
// Implement a parameterized module
// that produces either signed or unsigned result
// of the multiplication depending on the 'signed_mul' input bit.

module signed_or_unsigned_mul
# (
  parameter n = 8
)
(
  input  [    n - 1:0] a, b,
  input                signed_mul,
  output [2 * n - 1:0] res
);

  logic [2 * n - 1:0] tmp;

  generate
    for (genvar i = 0; i < n; i++) begin
      on_bit_multiplier mult (
        a,
        b[i],
        tmp[i]
      );
    end

  assign res = tmp;

endmodule
