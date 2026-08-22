module ahb_slave_interface(
    input HCLK,
    input HRESETn,
    input HSEL,
    input HWRITE,
    input [31:0] HADDR,
    input [31:0] HWDATA,
    input [1:0] HTRANS,
    output reg [31:0] addr_reg,
    output reg [31:0] data_reg,
    output reg write_reg,
    output reg valid_transfer
);

    always @(posedge HCLK or negedge HRESETn) begin
        if (!HRESETn) begin
            addr_reg       <= 32'd0;
            data_reg       <= 32'd0;
            write_reg      <= 1'b0;
            valid_transfer <= 1'b0;
        end
        else begin
            if (HSEL && HTRANS[1]) begin
                addr_reg       <= HADDR;
                data_reg       <= HWDATA;
                write_reg      <= HWRITE;
                valid_transfer <= 1'b1;
            end
            else begin
                valid_transfer <= 1'b0;
            end
        end
    end

endmodule
