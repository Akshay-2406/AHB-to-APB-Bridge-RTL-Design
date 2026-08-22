module bridge_top (
    input wire HCLK,
    input wire HRESETn,
    input wire HSEL,
    input wire HWRITE,
    input wire [31:0] HADDR,
    input wire [31:0] HWDATA,
    input wire [1:0] HTRANS,
    input wire PREADY,
    
    output wire [31:0] PADDR,
    output wire [31:0] PWDATA,
    output wire PWRITE,
    output wire PSEL,
    output wire PENABLE,
    output wire HREADYOUT
);

    wire [31:0] addr_reg;
    wire [31:0] data_reg;
    wire write_reg;
    wire valid_transfer;

    // Instantiate AHB Slave Interface
    ahb_slave_interface ahb_slave (
        .HCLK(HCLK),
        .HRESETn(HRESETn),
        .HSEL(HSEL),
        .HWRITE(HWRITE),
        .HADDR(HADDR),
        .HWDATA(HWDATA),
        .HTRANS(HTRANS),
        .addr_reg(addr_reg),
        .data_reg(data_reg),
        .write_reg(write_reg),
        .valid_transfer(valid_transfer)
    );

    // Instantiate APB Controller
    AkshayAc apb_ctrl (
        .hclk(HCLK),
        .hresetn(HRESETn),
        .paddr_temp(addr_reg),
        .pwdata_temp(data_reg),
        .pwrite_temp(write_reg),
        .psel_temp(valid_transfer),
        .penable_temp(valid_transfer),
        .pready(PREADY),
        .hreadyout_temp(HREADYOUT),
        .paddr_out(PADDR),
        .pwdata_out(PWDATA),
        .pwrite_out(PWRITE),
        .psel_out(PSEL),
        .penable_out(PENABLE)
    );

endmodule
