//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_1_pipe_aware_fsm
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

    // This structure will work only if N >= 3
    enum logic [2:0]
    {
        IDLE,
        SEND_B,
        SEND_C,
        WAIT_A,
        GET_B,
        GET_C
    }
    state, next_state;

    // State assignment logic
    always_ff @ (posedge clk)
        if (rst) state <= IDLE;
        else     state <= next_state;

    // State transition logic
    always_comb begin
        next_state = IDLE;

        case (state)
            IDLE: if (arg_vld) next_state = SEND_B;
                  else         next_state = IDLE;

            SEND_B: next_state = SEND_C;

            SEND_C: next_state = WAIT_A;

            WAIT_A: if (isqrt_y_vld) next_state = GET_B;
                    else             next_state = WAIT_A;

            GET_B:  next_state = GET_C;

            GET_C:  next_state = IDLE;
        endcase
    end

    // Logic to interfact with external isqrt module
    always_comb begin
        isqrt_x_vld = 1'b0;

        case (state)
            IDLE:   if (arg_vld) begin
                        isqrt_x_vld = 1'b1;
                        isqrt_x     = a;
                    end

            SEND_B:
                    begin
                        isqrt_x_vld = 1'b1;
                        isqrt_x     = b;
                    end

            SEND_C:
                    begin
                        isqrt_x_vld = 1'b1;
                        isqrt_x     = c;
                    end
        endcase
    end

    // Logic to control result
    always_ff @ (posedge clk)
    begin
        res_vld <= 1'b0;
        case (state)
            WAIT_A: if (isqrt_y_vld) res <= isqrt_y;
            GET_B:  res <= res + isqrt_y;
            GET_C:  begin
                        res <= res + isqrt_y;
                        res_vld <= 1'b1;
                    end
        endcase
    end

endmodule
