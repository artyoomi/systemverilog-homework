//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_2_pipe_using_fifos
(
    input         clk,
    input         rst,

    input         arg_vld,
    input  [31:0] a,
    input  [31:0] b,
    input  [31:0] c,

    output        res_vld,
    output [31:0] res
);
    // Task:
    //
    // Implement a pipelined module formula_2_pipe_using_fifos that computes the result
    // of the formula defined in the file formula_2_fn.svh.
    //
    // The requirements:
    //
    // 1. The module formula_2_pipe has to be pipelined.
    //
    // It should be able to accept a new set of arguments a, b and c
    // arriving at every clock cycle.
    //
    // It also should be able to produce a new result every clock cycle
    // with a fixed latency after accepting the arguments.
    //
    // 2. Your solution should instantiate exactly 3 instances
    // of a pipelined isqrt module, which computes the integer square root.
    //
    // 3. Your solution should use FIFOs instead of shift registers
    // which were used in 06_04_formula_2_pipe.sv.
    //
    // You can read the discussion of this problem
    // in the article by Yuri Panchul published in
    // FPGA-Systems Magazine :: FSM :: Issue ALFA (state_0)
    // You can download this issue from https://fpga-systems.ru/fsm

    localparam isqrt_latency = 16;

    wire [31:0] fifo1_out;

    wire [31:0] fifo2_out;

    wire        isqrt1_out_vld;
    wire [15:0] isqrt1_out;

    wire        isqrt2_out_vld;
    wire [15:0] isqrt2_out;

    wire        isqrt3_out_vld;
    wire [15:0] isqrt3_out;

    logic        sum1_vld;
    logic [31:0] sum1;

    logic        sum2_vld;
    logic [31:0] sum2;

    flip_flop_fifo_with_counter # (
        .width(32), .depth(isqrt_latency)
    ) fifo1 (
        .clk        ( clk            ),
        .rst        ( rst            ),
        .push       ( arg_vld        ),
        .pop        ( isqrt1_out_vld ),
        .write_data ( b              ),
        .read_data  ( fifo1_out      ),
        .empty      (                ),
        .full       (                )
    );

    flip_flop_fifo_with_counter # (
        .width(32), .depth(2 * isqrt_latency + 1)
    ) fifo2 (
        .clk        ( clk            ),
        .rst        ( rst            ),
        .push       ( arg_vld        ),
        .pop        ( isqrt2_out_vld ),
        .write_data ( a              ),
        .read_data  ( fifo2_out      ),
        .empty      (                ),
        .full       (                )
    );

    isqrt isqrt1
    (
        .clk   ( clk            ),
        .rst   ( rst            ),
        .x_vld ( arg_vld        ),
        .x     ( c              ),
        .y_vld ( isqrt1_out_vld ),
        .y     ( isqrt1_out     )
    );

    isqrt isqrt2
    (
        .clk   ( clk                ),
        .rst   ( rst                ),
        .x_vld ( sum1_vld           ),
        .x     ( sum1               ),
        .y_vld ( isqrt2_out_vld     ),
        .y     ( isqrt2_out         )
    );

    isqrt isqrt3
    (
        .clk   ( clk                ),
        .rst   ( rst                ),
        .x_vld ( sum2_vld           ),
        .x     ( sum2               ),
        .y_vld ( isqrt3_out_vld     ),
        .y     ( isqrt3_out         )
    );

    always_ff @ (posedge clk)
        if (isqrt1_out_vld) begin
            sum1_vld <= 1'b1;
            sum1     <= fifo1_out + 32'(isqrt1_out);
        end else begin
            sum1_vld <= 1'b0;
        end

    always_ff @ (posedge clk)
        if (isqrt2_out_vld) begin
            sum2_vld <= 1'b1;
            sum2     <= fifo2_out + 32'(isqrt2_out);
        end else begin
            sum2_vld <= 1'b0;
        end

    assign res_vld = isqrt3_out_vld;
    assign res     = 32' (isqrt3_out);

endmodule
