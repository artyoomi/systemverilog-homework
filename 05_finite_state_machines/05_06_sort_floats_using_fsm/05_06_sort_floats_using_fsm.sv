//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module sort_floats_using_fsm (
    input                          clk,
    input                          rst,

    input                          valid_in,
    input        [0:2][FLEN - 1:0] unsorted,

    output logic                   valid_out,
    output logic [0:2][FLEN - 1:0] sorted,
    output logic                   err,
    output                         busy,

    // f_less_or_equal interface
    output logic      [FLEN - 1:0] f_le_a,
    output logic      [FLEN - 1:0] f_le_b,
    input                          f_le_res,
    input                          f_le_err
);

    // Task:
    // Implement a module that accepts three Floating-Point numbers and outputs them in the increasing order using FSM.
    //
    // Requirements:
    // The solution must have latency equal to the three clock cycles.
    // The solution should use the inputs and outputs to the single "f_less_or_equal" module.
    // The solution should NOT create instances of any modules.
    //
    // Notes:
    // res0 must be less or equal to the res1
    // res1 must be less or equal to the res1
    //
    // The FLEN parameter is defined in the "import/preprocessed/cvw/config-shared.vh" file
    // and usually equal to the bit width of the double-precision floating-point number, FP64, 64 bits.


    enum logic [2:0]
    {
        IDLE,
        WAIT_AB,
        WAIT_BC,
        WAIT_AC
    }
    state, next_state;

    typedef enum logic [0:2]
    {
        ABC = 3'b111,
        ACB = 3'b101,
        BAC = 3'b011,
        BCA = 3'b010,
        CAB = 3'b100,
        CBA = 3'b000
    } sort_result_e;


    logic [0:2][FLEN - 1:0] saved_unsorted;
    logic      [       0:2] sort_results;

    always_comb begin
        next_state = state;

        case (state)
            IDLE:
            begin
                if (valid_in)
                begin
                    err = 1'b0;
                    sort_results = 3'b0;

                    saved_unsorted = unsorted;
                    f_le_a = saved_unsorted[0];
                    f_le_b = saved_unsorted[1];

                    if (f_le_err)
                        err = 1'b1;
                    else
                        sort_results[0] = f_le_res;

                    next_state = WAIT_AB;
                end
            end

            WAIT_AB:
            begin
                next_state = WAIT_BC;

                if (~err)
                begin
                    f_le_a = saved_unsorted[1];
                    f_le_b = saved_unsorted[2];

                    if (f_le_err)
                        err = 1'b1;
                    else
                        sort_results[1] = f_le_res;
                end
            end

            WAIT_BC:
            begin
                next_state = WAIT_AC;

                if (~err)
                begin
                    f_le_a = saved_unsorted[0];
                    f_le_b = saved_unsorted[2];

                    if (f_le_err)
                        err = 1'b1;
                    else
                        sort_results[2] = f_le_res;
                end
            end

            WAIT_AC:
            begin
                next_state = IDLE;
                case (sort_results)
                    ABC: sorted = saved_unsorted;
                    ACB: sorted = { saved_unsorted[0], saved_unsorted[2], saved_unsorted[1] };
                    BAC: sorted = { saved_unsorted[1], saved_unsorted[0], saved_unsorted[2] };
                    BCA: sorted = { saved_unsorted[1], saved_unsorted[2], saved_unsorted[0] };
                    CAB: sorted = { saved_unsorted[2], saved_unsorted[0], saved_unsorted[1] };
                    CBA: sorted = { saved_unsorted[2], saved_unsorted[1], saved_unsorted[0] };

                    // Impossible sort_results value
                    default: err = 1'b1;
                endcase
            end
        endcase
    end

    // State transition logic between different clock cycles
    always_ff @ (posedge clk)
        if (rst)
            state <= IDLE;
        else
            state <= next_state;

    // Logic for setting valid_out signal
    always_ff @ (posedge clk)
        if (state == WAIT_AC)
            valid_out <= 1'b1;
        else
            valid_out <= 1'b0;

    assign busy = (state != IDLE);


endmodule
