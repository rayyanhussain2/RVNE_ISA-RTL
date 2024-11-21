module testbench();
    //testbench registers
    reg clk;
    reg reset;
    reg [7:0] DG;
    reg [7:0] DB;
    reg [7:0] DC;
    reg [511:0] rdata; // will be passed to lsu
    wire [511:0] vector; //once updated, will be passed to wvr/svr

    // Output wires
    wire [31:0] wvr_out_r1;
    wire [31:0] wvr_out_r2;
    wire [31:0] wvr_out_r3;
    wire [31:0] wvr_out_r4;
    wire [31:0] wvr_out_r5;
    wire [31:0] wvr_out_r6;
    wire [31:0] wvr_out_r7;
    wire [31:0] wvr_out_r8;
    wire [31:0] wvr_out_r9;
    wire [31:0] wvr_out_r10;
    wire [31:0] wvr_out_r11;
    wire [31:0] wvr_out_r12;
    wire [31:0] wvr_out_r13;
    wire [31:0] wvr_out_r14;
    wire [31:0] wvr_out_r15;
    wire [31:0] wvr_out_r16;

    wire [31:0] svr_out_r1;
    wire [31:0] svr_out_r2;
    wire [31:0] svr_out_r3;
    wire [31:0] svr_out_r4;
    wire [31:0] svr_out_r5;
    wire [31:0] svr_out_r6;
    wire [31:0] svr_out_r7;
    wire [31:0] svr_out_r8;
    wire [31:0] svr_out_r9;
    wire [31:0] svr_out_r10;
    wire [31:0] svr_out_r11;
    wire [31:0] svr_out_r12;
    wire [31:0] svr_out_r13;
    wire [31:0] svr_out_r14;
    wire [31:0] svr_out_r15;
    wire [31:0] svr_out_r16;

    wire [31:0] rpr_out_0;
    wire [31:0] vtr_out_0;
    wire [31:0] ntr_out_0;
    wire [31:0] ntr_out_1;
    wire [31:0] ntr_out_2;
    wire [31:0] ntr_out_3;


    // Instantiate the module
    WVR wvr (
        .clk(clk),
        .reset(reset),
        .A(DC),
        .D(vector), //vector from lsu goes into D as vector
        .wvr_out_r1(wvr_out_r1),
        .wvr_out_r2(wvr_out_r2),
        .wvr_out_r3(wvr_out_r3),
        .wvr_out_r4(wvr_out_r4),
        .wvr_out_r5(wvr_out_r5),
        .wvr_out_r6(wvr_out_r6),
        .wvr_out_r7(wvr_out_r7),
        .wvr_out_r8(wvr_out_r8),
        .wvr_out_r9(wvr_out_r9),
        .wvr_out_r10(wvr_out_r10),
        .wvr_out_r11(wvr_out_r11),
        .wvr_out_r12(wvr_out_r12),
        .wvr_out_r13(wvr_out_r13),
        .wvr_out_r14(wvr_out_r14),
        .wvr_out_r15(wvr_out_r15),
        .wvr_out_r16(wvr_out_r16)
    );

    SVR svr(
        .clk(clk),
        .reset(reset),
        .A(DB),
        .D(vector), //vector goes as D signal into SVR module
        .svr_out_r1(svr_out_r1),
        .svr_out_r2(svr_out_r2),
        .svr_out_r3(svr_out_r3),
        .svr_out_r4(svr_out_r4),
        .svr_out_r5(svr_out_r5),
        .svr_out_r6(svr_out_r6),
        .svr_out_r7(svr_out_r7),
        .svr_out_r8(svr_out_r8),
        .svr_out_r9(svr_out_r9),
        .svr_out_r10(svr_out_r10),
        .svr_out_r11(svr_out_r11),
        .svr_out_r12(svr_out_r12),
        .svr_out_r13(svr_out_r13),
        .svr_out_r14(svr_out_r14),
        .svr_out_r15(svr_out_r15),
        .svr_out_r16(svr_out_r16)
    );
   
   GPRs gpr(
        .clk(clk),
        .reset(reset),
        .A(DG),
        .D(vector),                     //vector goes as D signal into GPRs module
	.rpr_out_0(rpr_out_0),          // RPR: Output for shared refractory period
	.vtr_out_0(vtr_out_0),          // VTR: Output for shared voltage threshold
	.ntr_out_0(ntr_out_0),          // NTR: Output for register 0
	.ntr_out_1(ntr_out_1),          // NTR: Output for register 1
	.ntr_out_2(ntr_out_2),          // NTR: Output for register 2
	.ntr_out_3(ntr_out_3)           // NTR: Output for register 3

);



    VLSU vlsu(
        .clk(clk),
        .rdata(rdata),
        .vector(vector)  // Pass opcode
    );



    always @(posedge reset) begin
        if (reset)begin
            DC = 8'bxxxxxxxx;
            DB = 8'bxxxxxxxx;
            DG = 8'bxxxxxxxx;
            rdata=512'b0;
        end
    end



    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    initial begin
        //Resetting
        clk = 0;
        reset = 1;
        #10;
        reset = 0;

        //WVR Cases
        DC = 8'b00000001; //A = funct (3 bits) + rd (5 bits)
        rdata = 512'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF11111234; // Test data
        #50;reset = 1; #30;reset = 0;

        DC = 8'b00100011; //A = funct (3 bits) + rd (5 bits)
        rdata = 512'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF11111111222222223333333344444444; // Test data
        #50;reset = 1; #30;reset = 0;

        DC = 8'b01000001;
        rdata = 512'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // Test data
        #50;reset = 1; #30;reset = 0;

        //SVR
        DB = 8'b00000001; //A = funct (3 bits) + rd (5 bits)
        rdata = 512'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // Test data
        #50;reset = 1; #30;reset = 0;

        DB = 8'b00100001; //A = funct (3 bits) + rd (5 bits)
        rdata = 512'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // Test data
        #50;reset = 1; #30;reset = 0;

        DB = 8'b01000001;
        rdata = 512'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // Test data
        #50;reset = 1; #30;reset = 0;


        //GPRs
        DG = 8'b00000000; //A = funct (3 bits) + rd (5 bits)
        rdata = 512'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // Test data
        #50;reset = 1; #30;reset = 0;

        DG = 8'b00100000; //A = funct (3 bits) + rd (5 bits)
        rdata = 512'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // Test data
        #50;reset = 1; #30;reset = 0;

        DG = 8'b01000000;
        rdata = 512'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // Test data
        #50;reset = 1; #30;reset = 0;


        $finish;
    end

    initial begin
        $monitor("\nTime = %0d |DA = %b| DB = %b | DC = %b |rdata = %h|GPRs Outputs =%h %h %h %h %h %h  | WVR Outputs = %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h | SVR Outputs = %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h", 
                  $time,DG, DB, DC, rdata,rpr_out_0,vtr_out_0,ntr_out_0,ntr_out_1,ntr_out_2,ntr_out_3,
                  wvr_out_r1, wvr_out_r2, wvr_out_r3, wvr_out_r4, wvr_out_r5, wvr_out_r6, wvr_out_r7, wvr_out_r8, wvr_out_r9, wvr_out_r10, wvr_out_r11, wvr_out_r12, wvr_out_r13, wvr_out_r14, wvr_out_r15, wvr_out_r16,
                  svr_out_r1, svr_out_r2, svr_out_r3, svr_out_r4, svr_out_r5, svr_out_r6, svr_out_r7, svr_out_r8, svr_out_r9, svr_out_r10, svr_out_r11, svr_out_r12, svr_out_r13, svr_out_r14, svr_out_r15, svr_out_r16);
    end

endmodule
