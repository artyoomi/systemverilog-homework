//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module serial_adder
(
  input  clk,
  input  rst,
  input  a,
  input  b,
  output sum
);

  // Note:
  // carry_d represents the combinational data input to the carry register.

  logic carry;
  wire carry_d;

  assign { carry_d, sum } = a + b + carry;

  always_ff @ (posedge clk)
    if (rst)
      carry <= '0;
    else
      carry <= carry_d;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module serial_adder_using_logic_operations_only
(
  input  clk,
  input  rst,
  input  a,
  input  b,
  output sum
);

  // Task:
  // Implement a serial adder using only ^ (XOR), | (OR), & (AND), ~ (NOT) bitwise operations.
  //
  // Notes:
  // See Harris & Harris book
  // or https://en.wikipedia.org/wiki/Adder_(electronics)#Full_adder webpage
  // for information about the 1-bit full adder implementation.
  //
  // See the testbench for the output format ($display task).

  logic carry_in;
  /* We use wire here because this variable connects two one-bit adders, that
     is, we can say two blocks. */
  wire  carry_out;

  always_ff @ (posedge clk)
    if (rst)
      carry_in <= '0;
    else
      carry_in <= carry_out;

  // This is natural because sum is 1 only when exactly one arguments is 1
  assign sum = a ^ b ^ carry_in;
  /* According to truth table arguments should have at least two 1 to assign
     1 for carry_out:
    a  b  carry_in  carry_out
    0  0     0          0
    0  0     1          0
    0  1     0          0
    0  1     1          1  <- here
    1  0     0          0
    1  0     1          1  <- \
    1  1     0          1  <- | and here
    1  1     1          1  <- /
  */
  assign carry_out = a & b | a & carry_in | b & carry_in;

endmodule
