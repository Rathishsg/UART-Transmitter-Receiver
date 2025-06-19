module uart_tx (
    input  logic       clk,        
    input  logic       rst,        
    input  logic       tx_start, 
    input  logic [7:0] tx_data,    
    output logic       tx,         
    output logic       tx_done     
);

    
    typedef enum logic [1:0] {
        IDLE,
        START,
        SEND,
        DONE
    } state_t;

    state_t current_state, next_state;

   
    logic [9:0] shift_reg;
    logic [3:0] bit_count;

    
    always @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    
    always @(*) begin
        next_state = current_state;
        case (current_state)
            IDLE:   if (tx_start) next_state = START;
            START:  next_state = SEND;
            SEND:   if (bit_count == 9) next_state = DONE;
            DONE:   next_state = IDLE;
        endcase
    end

   
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 10'b1111111111;
            bit_count <= 0;
            tx        <= 1;
            tx_done   <= 0;
        end else begin
            case (current_state)
                IDLE: begin
                    tx      <= 1;
                    tx_done <= 0;
                end
                START: begin
                    shift_reg <= {1'b1, tx_data, 1'b0}; 
                    bit_count <= 0;
                end
                SEND: begin
                    tx        <= shift_reg[0];
                    shift_reg <= shift_reg >> 1;
                    bit_count <= bit_count + 1;
                end
                DONE: begin
                    tx_done <= 1;
                    tx      <= 1;
                end
            endcase
        end
    end

endmodule
