//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_2_fsm
(
    input               clk,
    input               rst,

    input               arg_vld,
    input        [31:0] a,
    input        [31:0] b,
    input        [31:0] c,

    output logic        res_vld,
    output logic [31:0] res,

    // isqrt interface

    output logic        isqrt_x_vld,
    output logic [31:0] isqrt_x,

    input               isqrt_y_vld,
    input        [15:0] isqrt_y
);
    // Task:
    // Implement a module that calculates the formula from the `formula_2_fn.svh` file
    // using only one instance of the isqrt module.
    //
    // Design the FSM to calculate answer step-by-step and provide the correct `res` value
    //
    // You can read the discussion of this problem
    // in the article by Yuri Panchul published in
    // FPGA-Systems Magazine :: FSM :: Issue ALFA (state_0)
    // You can download this issue from https://fpga-systems.ru/fsm

    enum logic [1:0]
    {
        IDLE,
        WAIT_C,
        WAIT_B,
        WAIT_A
    }
    state, next_state;

    logic [31:0] sum;

    always_comb
    begin
        next_state = state;

        isqrt_x_vld = 1'b0;
        res_vld     = 1'b0;

        case (state)
            IDLE:
            begin
                if (arg_vld)
                begin
                    isqrt_x_vld = 1'b1;
                    isqrt_x     = c;

                    next_state = WAIT_C;
                end
            end

            WAIT_C:
            begin
                if (isqrt_y_vld)
                begin
                    sum = b + 32' (isqrt_y);

                    isqrt_x_vld = 1'b1;
                    isqrt_x     = sum;

                    next_state = WAIT_B;
                end
            end

            WAIT_B:
            begin
                if (isqrt_y_vld)
                begin
                    sum = a + 32' (isqrt_y);

                    isqrt_x_vld = 1'b1;
                    isqrt_x     = sum;

                    next_state = WAIT_A;
                end
            end

            WAIT_A:
            begin
                if (isqrt_y_vld)
                begin
                    res_vld = 1'b1;
                    res     = 32' (isqrt_y);

                    next_state = IDLE;
                end
            end
        endcase
    end

    always_ff @ (posedge clk)
        if (rst)
            state <= IDLE;
        else
            state <= next_state;

endmodule
