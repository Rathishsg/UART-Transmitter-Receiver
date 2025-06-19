module uart_rx (
    input  logic       clk,      
    input  logic       rst,       
    input  logic       rx,        
    output logic [7:0] rx_data,   
    output logic       rx_done    
);

    typedef enum logic [1:0] {
        IDLE,
        START,
        RECEIVE,
        DONE
    } state_t;

    state_t current_state, next_state;

    logic [3:0] bit_count;
    logic [7:0] data_buf;
    logic [7:0] rx_shift;


    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end


    always_comb begin
        next_state = current_state;
        case (current_state)
            IDLE:    if (~rx) next_state = START;
            START:   next_state = RECEIVE;
            RECEIVE: if (bit_count == 7) next_state = DONE;
            DONE:    next_state = IDLE;
        endcase
    end


    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            rx_shift  <= 8'd0;
            bit_count <= 0;
            rx_done   <= 0;
            rx_data   <= 8'd0;
        end else begin
            case (current_state)
                IDLE: begin
                    rx_done <= 0;
                end
                START: begin
                    bit_count <= 0;
                end
                RECEIVE: begin
                    rx_shift <= {rx, rx_shift[7:1]};
                    bit_count <= bit_count + 1;
                end
                DONE: begin
                    rx_data <= rx_shift;
                    rx_done <= 1;
                end
            endcase
        end
    end

endmodule

