module VLSU (
    input wire [511:0] rdata,        // Input data to the VLSU
    input wire clk,                  // Clock signal
    output reg [511:0] vector        // Output vector data
);

    always @(posedge clk) begin
        vector <= rdata;             // Pass the input data directly to the output vector
    end

endmodule

//1 Weight = 4 bits
//8 / 32 / 128
module WVR (
    input wire clk,                  // Clock signal
    input wire reset,                // Reset signal

    input wire [7:0] A, //first 5 bits are rd/rs, last 3 are opcode
    input wire [511:0] D,

    output reg [511: 0] W,

    //Output registers for the sake of monitoring
    output reg [31:0] wvr_out_r1,   
    output reg [31:0] wvr_out_r2,    
    output reg [31:0] wvr_out_r3,    
    output reg [31:0] wvr_out_r4,
    output reg [31:0] wvr_out_r5,
    output reg [31:0] wvr_out_r6,
    output reg [31:0] wvr_out_r7,
    output reg [31:0] wvr_out_r8,
    output reg [31:0] wvr_out_r9,
    output reg [31:0] wvr_out_r10,
    output reg [31:0] wvr_out_r11,
    output reg [31:0] wvr_out_r12,
    output reg [31:0] wvr_out_r13,
    output reg [31:0] wvr_out_r14,
    output reg [31:0] wvr_out_r15,
    output reg [31:0] wvr_out_r16
);

    
    reg [31:0] wvr_memory_bank [0:15];  
    
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 16; i = i + 1) begin
                wvr_memory_bank[i] <= 32'b0;
            end
            
            W <= 512'b0;
            
            wvr_out_r1  <= 32'b0;
            wvr_out_r2  <= 32'b0;
            wvr_out_r3  <= 32'b0;
            wvr_out_r4  <= 32'b0;
            wvr_out_r5  <= 32'b0;
            wvr_out_r6  <= 32'b0;
            wvr_out_r7  <= 32'b0;
            wvr_out_r8  <= 32'b0;
            wvr_out_r9  <= 32'b0;
            wvr_out_r10 <= 32'b0;
            wvr_out_r11 <= 32'b0;
            wvr_out_r12 <= 32'b0;
            wvr_out_r13 <= 32'b0;
            wvr_out_r14 <= 32'b0;
            wvr_out_r15 <= 32'b0;
            wvr_out_r16 <= 32'b0;
        end
        else begin
            case (A[7:5])
                3'b000: begin     // Load only the first 32 bits of D into one register
                    wvr_memory_bank[A[4:0]] <= D[31:0];
                end
                
                3'b001: begin     // Load 128 bits into 4 consecutive registers
                    wvr_memory_bank[A[4:0] % 16]   <= D[31:0];
                    wvr_memory_bank[(A[4:0]+1) % 16] <= D[63:32];
                    wvr_memory_bank[(A[4:0]+2) % 16] <= D[95:64];
                    wvr_memory_bank[(A[4:0]+3) % 16] <= D[127:96];
                end

                3'b010: begin   // Load all 16 registers with 512 bits of D
                    for (i = 0; i < 16; i = i + 1) begin
                        wvr_memory_bank[i] <= D[i * 32 +: 32]; // Extract 32 bits for each NTR register
                    end
                end

                3'b011: begin //convh/doth, 32 weights on to first 128 lines of the bus, using as source
                    W[31:0]  <= wvr_memory_bank[A[4:0] % 16];
                    W[63:32] <= wvr_memory_bank[(A[4:0]+1) % 16];
                    W[95:64] <= wvr_memory_bank[(A[4:0]+2) % 16] ;
                    W[127:96] <= wvr_memory_bank[(A[4:0]+3) % 16];
                end

                3'b100: begin //conva/dota, using as source
                    for (i = 0; i < 16; i = i + 1) begin
                        W[i * 32 +: 32] <= wvr_memory_bank[i]; // Extract 32 bits for each NTR register
                    end
                end
                

                default: begin
                    // No operation for other funct values
                end

            endcase
            
            
        end
// !!Updating status for the sake of monitoring
            wvr_out_r1  <= wvr_memory_bank[0];
            wvr_out_r2  <= wvr_memory_bank[1];
            wvr_out_r3  <= wvr_memory_bank[2];
            wvr_out_r4  <= wvr_memory_bank[3];
            wvr_out_r5  <= wvr_memory_bank[4];
            wvr_out_r6  <= wvr_memory_bank[5];
            wvr_out_r7  <= wvr_memory_bank[6];
            wvr_out_r8  <= wvr_memory_bank[7];
            wvr_out_r9  <= wvr_memory_bank[8];
            wvr_out_r10 <= wvr_memory_bank[9];
            wvr_out_r11 <= wvr_memory_bank[10];
            wvr_out_r12 <= wvr_memory_bank[11];
            wvr_out_r13 <= wvr_memory_bank[12];
            wvr_out_r14 <= wvr_memory_bank[13];
            wvr_out_r15 <= wvr_memory_bank[14];
            wvr_out_r16 <= wvr_memory_bank[15];
    end

endmodule

//1 weight = 1 bit
//32 / 128 / 512
module SVR (
    input wire clk,                  // Clock signal
    input wire reset,                   // Reset signal
    
    input wire [7:0] A,         
    input wire [511:0] D,               

    output reg [511: 0] S,

    //Output registers for the sake of monitoring
    output reg [31:0] svr_out_r1,   
    output reg [31:0] svr_out_r2,    
    output reg [31:0] svr_out_r3,    
    output reg [31:0] svr_out_r4,
    output reg [31:0] svr_out_r5,
    output reg [31:0] svr_out_r6,
    output reg [31:0] svr_out_r7,
    output reg [31:0] svr_out_r8,
    output reg [31:0] svr_out_r9,
    output reg [31:0] svr_out_r10,
    output reg [31:0] svr_out_r11,
    output reg [31:0] svr_out_r12,
    output reg [31:0] svr_out_r13,
    output reg [31:0] svr_out_r14,
    output reg [31:0] svr_out_r15,
    output reg [31:0] svr_out_r16
);

    
    reg [31:0] svr_memory_bank [0:15];  
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 16; i = i + 1) begin
                svr_memory_bank[i] <= 32'b0;
            end

            S <= 512'b0;

            svr_out_r1  <= 32'b0;
            svr_out_r2  <= 32'b0;
            svr_out_r3  <= 32'b0;
            svr_out_r4  <= 32'b0;
            svr_out_r5  <= 32'b0;
            svr_out_r6  <= 32'b0;
            svr_out_r7  <= 32'b0;
            svr_out_r8  <= 32'b0;
            svr_out_r9  <= 32'b0;
            svr_out_r10 <= 32'b0;
            svr_out_r11 <= 32'b0;
            svr_out_r12 <= 32'b0;
            svr_out_r13 <= 32'b0;
            svr_out_r14 <= 32'b0;
            svr_out_r15 <= 32'b0;
            svr_out_r16 <= 32'b0;
        end

        else begin
        case (A[7:5])
            3'b000: begin     // Load only the first 32 bits of D into one register
                svr_memory_bank[A[4:0]] <= D[31:0];
            end

            3'b001: begin     // Load 128 bits into 4 consecutive registers
                svr_memory_bank[A[4:0] % 16]   <= D[31:0];
                svr_memory_bank[(A[4:0]+1) % 16] <= D[63:32];
                svr_memory_bank[(A[4:0]+2) % 16] <= D[95:64];
                svr_memory_bank[(A[4:0]+3) % 16] <= D[127:96];
            
            end
            

            3'b010: begin 
                for (i = 0; i < 16; i = i + 1) begin
                    svr_memory_bank[i] <= D[i * 32 +: 32]; // Extract 32 bits for each NTR register
                end
            end
            
            3'b011: begin //convh/doth, 32 spikes onto first 32 lines of the bus
                S[31:0]  <= svr_memory_bank[A[4:0] % 16];
            end

            3'b100: begin //conva/dota is only 128 spikes which is 4 registers
                S[31:0]   <= svr_memory_bank[A[4:0] % 16];
                S[63:32] <= svr_memory_bank[(A[4:0]+1) % 16];
                S[95:64] <= svr_memory_bank[(A[4:0]+2) % 16] ;
                S[127:96] <= svr_memory_bank[(A[4:0]+3) % 16];
            end

            default: begin
                // No operation for other funct values
            end

            endcase
            
            
        end
            // !!Updating status for the sake of monitoring
            svr_out_r1  <= svr_memory_bank[0];
            svr_out_r2  <= svr_memory_bank[1];
            svr_out_r3  <= svr_memory_bank[2];
            svr_out_r4  <= svr_memory_bank[3];
            svr_out_r5  <= svr_memory_bank[4];
            svr_out_r6  <= svr_memory_bank[5];
            svr_out_r7  <= svr_memory_bank[6];
            svr_out_r8  <= svr_memory_bank[7];
            svr_out_r9  <= svr_memory_bank[8];
            svr_out_r10 <= svr_memory_bank[9];
            svr_out_r11 <= svr_memory_bank[10];
            svr_out_r12 <= svr_memory_bank[11];
            svr_out_r13 <= svr_memory_bank[12];
            svr_out_r14 <= svr_memory_bank[13];
            svr_out_r15 <= svr_memory_bank[14];
            svr_out_r16 <= svr_memory_bank[15];
    end

endmodule


//these are gprs of which used in to hold values of neuron state along with thersold voltage and refratory period 
module NSR (
    input wire clk,                       // Clock signal
    input wire reset,                     // Reset signal
    input wire [7:0] A,                   // Address input (register index selector) and opcode
    input wire [511:0] D,                 // Data input for parameter loading

    // Individual Output Signals for Monitoring
    output reg [31:0] rpr_out_0,          // RPR: Output for shared refractory period
    output reg [31:0] vtr_out_0,          // VTR: Output for shared voltage threshold
    output reg [31:0] ntr_out_0,          // NTR: Output for register 0
    output reg [31:0] ntr_out_1,          // NTR: Output for register 1
    output reg [31:0] ntr_out_2,          // NTR: Output for register 2
    output reg [31:0] ntr_out_3,           // NTR: Output for register 3
    
    output reg [31:0] nsr_out_r1,
    output reg [31:0] nsr_out_r2,
    output reg [31:0] nsr_out_r3,
    output reg [31:0] nsr_out_r4,
    output reg [31:0] nsr_out_r5,
    output reg [31:0] nsr_out_r6,
    output reg [31:0] nsr_out_r7,
    output reg [31:0] nsr_out_r8,
    output reg [31:0] nsr_out_r9,
    output reg [31:0] nsr_out_r10,
    output reg [31:0] nsr_out_r11,
    output reg [31:0] nsr_out_r12,
    output reg [31:0] nsr_out_r13,
    output reg [31:0] nsr_out_r14,
    output reg [31:0] nsr_out_r15,
    output reg [31:0] nsr_out_r16,
    
    //need a wire to output current
    output reg [511:0] Cur
);

    // Internal Registers
    reg [31:0] rpr;                       // Shared Refractory Period Register (32 bits)
    reg [31:0] vtr;                       // Shared Voltage Threshold Register (32 bits)
    reg [31:0] ntr [0:3];                 // Neuron Type Registers (4x32 bits)
    reg [31:0] current_registers [0:15];                 // NSR (10x32 bits)

    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all registers
            rpr <= 32'b0;
            vtr <= 32'b0;
            Cur <= 512'b0;

            for (i = 0; i < 4; i = i + 1) begin
                ntr[i] <= 32'b0;
            end

            for (i = 0; i < 16; i = i + 1) begin
                current_registers[i] <= 32'b0;
            end

            nsr_out_r1  <= 32'b0;
            nsr_out_r2  <= 32'b0;
            nsr_out_r3  <= 32'b0;
            nsr_out_r4  <= 32'b0;
            nsr_out_r5  <= 32'b0;
            nsr_out_r6  <= 32'b0;
            nsr_out_r7  <= 32'b0;
            nsr_out_r8  <= 32'b0;
            nsr_out_r9  <= 32'b0;
            nsr_out_r10 <= 32'b0;
            nsr_out_r11 <= 32'b0;
            nsr_out_r12 <= 32'b0;
            nsr_out_r13 <= 32'b0;
            nsr_out_r14 <= 32'b0;
            nsr_out_r15 <= 32'b0;
            nsr_out_r16 <= 32'b0;


    end 
        else begin
        case (A[7:5])
            3'b000: begin // Load shared refractory period (RPR) register
                rpr <= D[31:0];
            end

            3'b001: begin // Load shared voltage threshold (VTR) register
                vtr <= D[31:0];
            end

            3'b010: begin // Load neuron types into NTR registers
                for (i = 0; i < 4; i = i + 1) begin
                    ntr[i] <= D[i * 32 +: 32]; // Extract 32 bits for each NTR register
                end
            end

            //more opcodes to store for convh
            3'b011: begin //32 neurons storing indexed convh/doth
                current_registers[A[4:0] % 16]   <= D[31:0];
                current_registers[(A[4:0]+1) % 16] <= D[63:32];
                current_registers[(A[4:0]+2) % 16] <= D[95:64];
                current_registers[(A[4:0]+3) % 16] <= D[127:96];
            end
            
            3'b100: begin //conva/dota, using as rd
                    for (i = 0; i < 16; i = i + 1) begin
                        current_registers[i] <= D[i  * 32 +: 32]; // extract current from 128 neurons (4 bits each) and store in current_registers
                    end
                end
            
            default: begin
                // No operation for unsupported funct values
            end
            endcase  
    end

        rpr_out_0 = rpr;
        vtr_out_0 = vtr;
        ntr_out_0 = ntr[0];
        ntr_out_1 = ntr[1];
        ntr_out_2 = ntr[2];
        ntr_out_3 = ntr[3];

        nsr_out_r1  <= current_registers[0];
        nsr_out_r2  <= current_registers[1];
        nsr_out_r3  <= current_registers[2];
        nsr_out_r4  <= current_registers[3];
        nsr_out_r5  <= current_registers[4];
        nsr_out_r6  <= current_registers[5];
        nsr_out_r7  <= current_registers[6];
        nsr_out_r8  <= current_registers[7];
        nsr_out_r9  <= current_registers[8];
        nsr_out_r10 <= current_registers[9];
        nsr_out_r11 <= current_registers[10];
        nsr_out_r12 <= current_registers[11];
        nsr_out_r13 <= current_registers[12];
        nsr_out_r14 <= current_registers[13];
        nsr_out_r15 <= current_registers[14];
        nsr_out_r16 <= current_registers[15];
    end

endmodule

module SAcc (
    input wire [511:0] S, // 32 or 128 spikes ()
    input wire [511:0] W, //32 or 128 weights
    input wire [511:0] Cur_Input,

    input wire clk,
    input wire reset,

    output reg [511:0] Cur_Output
);
    integer i;

    always @(posedge clk or posedge reset) begin //reset the output wires/reg
        if (reset) begin
            Cur_Output <= 512'b0;
        end
        else begin
            //do automatically -
            for (i = 0; i < 128; i = i + 1) begin
                //take first bit and do and with all weights
                //then add up with all the currents
                Cur_Output[i * 4 +: 4] <= (S[i] & W[i * 4 +: 4]) + Cur_Input[i * 4 +: 4]; //and operation between 1 neuron's synapse (1bits) and 1 neuron's weights  (4bits)
            end
        end
    end
endmodule


