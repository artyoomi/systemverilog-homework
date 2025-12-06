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

module signed_add_with_saturation #(parameter N = 4)
(
  input  [N - 1:0] a, b,
  output [N - 1:0] sum
);

  // Task:
  //
  // Implement a module that adds two signed numbers with saturation.
  //
  // "Adding with saturation" means:
  //
  // When the result does not fit into 4 bits,
  // and the arguments are positive,
  // the sum should be set to the maximum positive number.
  //
  // When the result does not fit into 4 bits,
  // and the arguments are negative,
  // the sum should be set to the minimum negative number.

  logic [N    :0] carry;
  logic [N - 1:0] curr_sum;

  logic [N - 1:0] negative_saturation = {1'b1, {(N - 1) { 1'b0 }}};
  logic [N - 1:0] positive_saturation = {1'b0, {(N - 1) { 1'b1 }}};

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

  // Need to perform saturation if overflow detected
  assign sum = (a[N - 1] == b[N - 1]) && (curr_sum[N - 1] != a[N - 1]) ?
               (a[N - 1] ? negative_saturation : positive_saturation)  :
               curr_sum;

endmodule
