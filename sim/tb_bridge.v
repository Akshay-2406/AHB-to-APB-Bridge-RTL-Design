module tb_bridge;

    reg HCLK;
    reg HRESETn;
    reg HSEL;
    reg HWRITE;
    reg [31:0] HADDR;
    reg [31:0] HWDATA;
    reg [1:0] HTRANS;
    reg PREADY;

    wire [31:0] PADDR;
    wire [31:0] PWDATA;
    wire PWRITE;
    wire PSEL;
    wire PENABLE;
    wire HREADYOUT;

    // Instantiate Top-Level Module
    bridge_top uut (
        .HCLK(HCLK),
        .HRESETn(HRESETn),
        .HSEL(HSEL),
        .HWRITE(HWRITE),
        .HADDR(HADDR),
        .HWDATA(HWDATA),
        .HTRANS(HTRANS),
        .PREADY(PREADY),
        .PADDR(PADDR),
        .PWDATA(PWDATA),
        .PWRITE(PWRITE),
        .PSEL(PSEL),
        .PENABLE(PENABLE),
        .HREADYOUT(HREADYOUT)
    );

    // Clock Generation
    always #5 HCLK = ~HCLK;

    initial begin
        HCLK = 0;
        HRESETn = 0;
        HSEL = 0;
        HWRITE = 0;
        HADDR = 0;
        HWDATA = 0;
        HTRANS = 0;
        PREADY = 0;

        #15 HRESETn = 1;
        
        // Write Cycle Simulation
        #10;
        HSEL = 1;
        HTRANS = 2'b10;
        HWRITE = 1;
        HADDR = 32'hA000_1234;
        HWDATA = 32'hDEAD_BEEF;

        #10;
        PREADY = 1;

        #20;
        $finish;
    end

endmodule
