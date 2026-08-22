module AkshayAc (
    input wire hclk,
    input wire hresetn,
    input wire [31:0] paddr_temp,
    input wire [31:0] pwdata_temp,
    input wire pwrite_temp,
    input wire psel_temp,
    input wire penable_temp,
    output reg hreadyout_temp,
    output reg [31:0] paddr_out,
    output reg [31:0] pwdata_out,
    output reg pwrite_out,
    output reg psel_out,
    output reg penable_out,
    input wire pready
);

    localparam S_IDLE   = 2'b00;
    localparam S_SETUP  = 2'b01;
    localparam S_ACCESS = 2'b10;

    reg [1:0] state, next_state;

    // FSM State Register
    always @(posedge hclk or negedge hresetn) begin
        if (!hresetn)
            state <= S_IDLE;
        else
            state <= next_state;
    end

    // Next State Logic
    always @(*) begin
        next_state = state;
        case (state)
            S_IDLE: begin
                if (psel_temp && penable_temp)
                    next_state = S_SETUP;
            end
            S_SETUP: begin
                next_state = S_ACCESS;
            end
            S_ACCESS: begin
                if (pready)
                    next_state = S_IDLE;
            end
            default: next_state = S_IDLE;
        endcase
    end

    // Output Control Logic
    always @(posedge hclk or negedge hresetn) begin
        if (!hresetn) begin
            paddr_out      <= 32'h00000000;
            pwdata_out     <= 32'h00000000;
            pwrite_out     <= 1'b0;
            psel_out       <= 1'b0;
            penable_out    <= 1'b0;
            hreadyout_temp <= 1'b0;
        end
        else begin
            case (state)
                S_IDLE: begin
                    hreadyout_temp <= 1'b0;
                    penable_out    <= 1 meb0;
                    if (psel_temp && penable_temp) begin
                        paddr_out  <= paddr_temp;
                        pwdata_out <= pwdata_temp;
                        pwrite_out <= pwrite_temp;
                        psel_out   <= 1'b1;
                    end
                end
                S_SETUP: begin
                    penable_out <= 1'b1;
                end
                S_ACCESS: begin
                    if (pready) begin
                        hreadyout_temp <= 1'b1;
                        psel_out       <= 1'b0;
                        penable_out    <= 1'b0;
                    end
                end
                default: ;
            endcase
        end
    end

endmodule
