module testbench();
    //testbench registers
    reg clk;
    reg reset;
    reg [8:0] DA;
    reg [7:0] DB;
    reg [7:0] DC;
    reg [511:0] rdata; // will be passed to lsu
    wire [511:0] vector; //once updated, will be passed to wvr/svr
    wire [511:0] S;
    wire [511:0] W;
    wire [511:0] Cur1; //Current Input
    wire [511:0] Cur2; //Current Output
    wire [511:0] Cur3; //Current Output for Neuron type
    wire [511:0] Cur4; //Current output for Neuron Type parallelism

    // Output wires
    //wvr
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

    //svr
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

    //NSR other
    wire [31:0] rpr_out_0;
    wire [31:0] vtr_out_0;
    wire [31:0] ntr_out_0;
    wire [31:0] ntr_out_1;
    wire [31:0] ntr_out_2;
    wire [31:0] ntr_out_3;

    //NSR current
    wire [31:0] nsr_out_r1;   
    wire [31:0] nsr_out_r2;   
    wire [31:0] nsr_out_r3;    
    wire [31:0] nsr_out_r4;
    wire [31:0] nsr_out_r5;
    wire [31:0] nsr_out_r6;
    wire [31:0] nsr_out_r7;
    wire [31:0] nsr_out_r8;
    wire [31:0] nsr_out_r9;
    wire [31:0] nsr_out_r10;
    wire [31:0] nsr_out_r11;
    wire [31:0] nsr_out_r12;
    wire [31:0] nsr_out_r13;
    wire [31:0] nsr_out_r14;
    wire [31:0] nsr_out_r15;
    wire [31:0] nsr_out_r16;

    // Instantiate the module
    WVR wvr (
        .clk(clk),
        .reset(reset),
        .A(DC),
        .D(vector), //vector from lsu goes into D as vector
        .W(W),

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
        .S(S),

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
   
    NSR nsr(
        .clk(clk),
        .reset(reset),
        .A(DA),
        .D(vector),  
        .Cur(Cur1),
   
                        //vector goes as D signal into GPRs module
        .rpr_out_0(rpr_out_0),          // RPR: Output for shared refractory period
        .vtr_out_0(vtr_out_0),          // VTR: Output for shared voltage threshold
        .ntr_out_0(ntr_out_0),          // NTR: Output for register 0
        .ntr_out_1(ntr_out_1),          // NTR: Output for register 1
        .ntr_out_2(ntr_out_2),          // NTR: Output for register 2
        .ntr_out_3(ntr_out_3),                   // NTR: Output for register 3

        .nsr_out_r1(nsr_out_r1),
        .nsr_out_r2(nsr_out_r2),
        .nsr_out_r3(nsr_out_r3),
        .nsr_out_r4(nsr_out_r4),
        .nsr_out_r5(nsr_out_r5),
        .nsr_out_r6(nsr_out_r6),
        .nsr_out_r7(nsr_out_r7),
        .nsr_out_r8(nsr_out_r8),
        .nsr_out_r9(nsr_out_r9),
        .nsr_out_r10(nsr_out_r10),
        .nsr_out_r11(nsr_out_r11),
        .nsr_out_r12(nsr_out_r12),
        .nsr_out_r13(nsr_out_r13),
        .nsr_out_r14(nsr_out_r14),
        .nsr_out_r15(nsr_out_r15),
        .nsr_out_r16(nsr_out_r16)

);

    VLSU vlsu(
        .clk(clk),
        .rdata(rdata),
        .vector(vector)  // Pass opcode
    );


    SAcc sacc(
        .clk(clk),
        .reset(reset),
        .S(S), // 32 or 128 spikes ()
        .W(W), //32 or 128 weights
        .Cur_Input(Cur1),
        .Cur_Output(Cur2)
    );

    NAcc nacc(
        .clk(clk),
        .reset(reset),
        .S(S), // 32 or 128 spikes ()
        .W(W), //32 or 128 weights
        .Cur_Input(Cur1),
        .Cur_Output(Cur3) // 1 neurons current
    );

    NeuronArray narray(
        .clk(clk),
        .reset(reset),
        .S(S), // 32 or 128 spikes ()
        .W(W), //32 or 128 weights
        .Cur_Input(Cur1),
        .Cur_Output(Cur4) //4 or 16 neurons current
    );

    always @(posedge reset) begin
        if (reset)begin
            DC = 8'bxxxxxxxx;
            DB = 8'bxxxxxxxx;
            DA = 8'bxxxxxxxx;
            rdata = 512'b0;
        end
    end

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    initial begin
        $dumpfile("test.vcd"); // Specifies the name of the VCD file to generate
        $dumpvars(0, testbench);
        
        //Resetting
        clk = 0;
        reset = 1;
        #10;
        reset = 0;

        /*
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


        //Simulating neuron state loading
        DA = 8'b00000000; //A = funct (3 bits) + rd (5 bits)
        rdata = 512'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // Test data
        #50;reset = 1; #30;reset = 0;

        DA = 8'b00100000; //A = funct (3 bits) + rd (5 bits)
        rdata = 512'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // Test data
        #50;reset = 1; #30;reset = 0;

        DA = 8'b01000000;
        rdata = 512'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // Test data
        #50;reset = 1; #30;reset = 0;
        */
        //-----------------------------------------------------------------------------------------------------------------
        //Simulating doth and dota
        //Simulating computation and neuron storing for doth
        //WVR Load, SVR Load, NSR Store
        //WVR DC, SVR DB, NSR DA
        //SVR funct3's
        //011- 32 neurons 1 register 100 - 128 neurons 4 registers
        //WVR funct3's
        //Storing into WVR and SVRs
        rdata = 512'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // Test dat
        DB = 8'b01000000;
        #50;
        DB = 8'bxxxxxxxx;
        rdata = 512'h11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
        DC = 8'b01000000;
        #50;

        //Loading from the WVR and SVR
        DB = 8'b10000000;
        DC = 8'b10000000;
        #100; //let it compute
        DA = 9'b010000000; //storing 128 neurons at a time.     
        rdata = Cur2;
        #50;
        DA = 9'b100100000; //storing 128 neurons at a time.    
        #50;
        $finish;
    end

    initial begin
        $monitor("\nTime = %0d |DA = %h| DB = %h| DC = %h|\nrdata = %h|\nCur1 = %h|\nCur2 = %h|\nCur3 = %h|\nCur4 = %h|\nNSR Other Registers =%h %h %h %h %h %h|\nWVR Reg = %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h|\nSVR Reg = %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h|\nNSR Reg = %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h", 
                  $time,DA, DB, DC, rdata,Cur1, Cur2, Cur3, Cur4, rpr_out_0,vtr_out_0,ntr_out_0,ntr_out_1,ntr_out_2,ntr_out_3,
                  wvr_out_r1, wvr_out_r2, wvr_out_r3, wvr_out_r4, wvr_out_r5, wvr_out_r6, wvr_out_r7, wvr_out_r8, wvr_out_r9, wvr_out_r10, wvr_out_r11, wvr_out_r12, wvr_out_r13, wvr_out_r14, wvr_out_r15, wvr_out_r16,
                  svr_out_r1, svr_out_r2, svr_out_r3, svr_out_r4, svr_out_r5, svr_out_r6, svr_out_r7, svr_out_r8, svr_out_r9, svr_out_r10, svr_out_r11, svr_out_r12, svr_out_r13, svr_out_r14, svr_out_r15, svr_out_r16,
                  nsr_out_r1, nsr_out_r2, nsr_out_r3, nsr_out_r4, nsr_out_r5, nsr_out_r6, nsr_out_r7, nsr_out_r8, nsr_out_r9, nsr_out_r10, nsr_out_r11, nsr_out_r12, nsr_out_r13, nsr_out_r14, nsr_out_r15, nsr_out_r16);
    end

endmodule
