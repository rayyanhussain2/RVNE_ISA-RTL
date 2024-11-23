module VLSU (
    input wire [511:0] rdata,        // Input data to the VLSU
    input wire clk,                  // Clock signal
    output reg [511:0] vector        // Output vector data
);

    always @(posedge clk) begin
        vector <= rdata;             // Pass the input data directly to the output vector
    end

endmodule

//Assumption: 1 Weight = 4 bits
module WVR (
    input wire clk,                  // Clock signal
    input wire reset,                // Reset signal

    input wire [8:0] A,              //A Signal: 4 bits (funct) + 5 bits (rd)
    input wire [511:0] D,

    output reg [511: 0] W,           //Output Weights Vector Wire

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

    //Internal memory bank for storing weights of max 128 neurons
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
                4'b0000: begin  //Store 8 Neurons' (1register) weights onto rd
                    wvr_memory_bank[A[4:0]] <= D[31:0];
                end
                
                4'b0001: begin  //Store 32 Neurons' (4 consecutive registers) weights onto rd to rd + 3
                    wvr_memory_bank[A[4:0] % 16]   <= D[31:0];
                    wvr_memory_bank[(A[4:0]+1) % 16] <= D[63:32];
                    wvr_memory_bank[(A[4:0]+2) % 16] <= D[95:64];
                    wvr_memory_bank[(A[4:0]+3) % 16] <= D[127:96];
                end

                4'b0010: begin  //Store all 128 Neurons' (16 registers) weights
                    for (i = 0; i < 16; i = i + 1) begin
                        wvr_memory_bank[i] <= D[i * 32 +: 32];
                    end
                end

                4'b0011: begin //Load weights of 32 Neurons (4 Register) onto the first 128 lines of the output bus (convh/doth)
                    W[31:0]  <= wvr_memory_bank[A[4:0] % 16];
                    W[63:32] <= wvr_memory_bank[(A[4:0]+1) % 16];
                    W[95:64] <= wvr_memory_bank[(A[4:0]+2) % 16] ;
                    W[127:96] <= wvr_memory_bank[(A[4:0]+3) % 16];
                end

                4'b0100: begin //Load weights of 128 Neurons (16 Register) onto all lines of the output bus (convh/doth)
                    for (i = 0; i < 16; i = i + 1) begin
                        W[i * 32 +: 32] <= wvr_memory_bank[i];
                    end
                end
                

                default: begin
                    // No operation for other funct values
                end

            endcase
            
            
        end
            
            //Updating status for the sake of monitoring
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
module SVR (
    input wire clk,                  // Clock signal
    input wire reset,                   // Reset signal
    
    input wire [8:0] A,         
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
            4'b0000: begin //Store 32 Neurons' (1register) Spikes onto rd
                svr_memory_bank[A[4:0]] <= D[31:0];
            end

            4'b0001: begin //Store 128 Neurons' (4 consecutive registers) spikes onto rd to rd + 3
                svr_memory_bank[A[4:0] % 16]   <= D[31:0];
                svr_memory_bank[(A[4:0]+1) % 16] <= D[63:32];
                svr_memory_bank[(A[4:0]+2) % 16] <= D[95:64];
                svr_memory_bank[(A[4:0]+3) % 16] <= D[127:96];
            
            end
            

            4'b0010: begin //Store all 512 Neurons' (16 registers) spikes
                for (i = 0; i < 16; i = i + 1) begin
                    svr_memory_bank[i] <= D[i * 32 +: 32]; 
                end
            end
            
            4'b0011: begin //Load weights of 32 Neurons (1 Register) onto the first 32 lines of the output bus (convh/doth)
                S[31:0]  <= svr_memory_bank[A[4:0] % 16];
            end

            4'b0100: begin //Load weights of 128 Neurons (4 Registers) onto 128 of the output bus (convh/doth)
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


//NTR - 1 neuron = 4 bits (similar to current)
module NSR (
    input wire clk,                       // Clock signal
    input wire reset,                     // Reset signal
    input wire [8:0] A,                   // Address input (register index selector) and opcode
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
    reg [31:0] current_registers [0:15];  // NSR (10x32 bits)

    integer i, j;
    real temp;

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
        case (A[8:5])
            4'b0000: begin //Refactory Period which is a 32-bit number
                rpr <= D[31:0];
            end

            4'b0001: begin //Voltage threshold (VTR) register, which is a 32 bit number
                vtr <= D[31:0];
            end

            4'b0010: begin //Load neuron types into NTR registers for 32 neurons
                for (i = 0; i < 4; i = i + 1) begin
                    ntr[i] <= D[i * 32 +: 32]; 
                end
            end

            4'b0011: begin //Store Current of 32 Neurons onto rd to rd + 4 (doth/convh)
                current_registers[A[4:0] % 16]   <= D[31:0];
                current_registers[(A[4:0]+1) % 16] <= D[63:32];
                current_registers[(A[4:0]+2) % 16] <= D[95:64];
                current_registers[(A[4:0]+3) % 16] <= D[127:96];
                Cur <= D;
            end
            
            4'b0100: begin //Store Current of 128 Neurons onto all rd's (dota/conva)
                    for (i = 0; i < 16; i = i + 1) begin
                        current_registers[i] <= D[i  * 32 +: 32]; 
                    end
                    Cur <= D;
            end
            
            4'b0101: begin //Storing Current of one neuron (first four bits of rd) (convh/conva)
                current_registers[A[4 : 0]][4 : 0] <= D[4 : 0]; // extract current from 128 neurons (4 bits each) and store in current_registers
                Cur <= D;
            end

            4'b0110: begin //Storing Current of 4 neurons (first 16 bits of rd) (convmh)
                current_registers[A[4 : 0]][15:0] <= D[15:0];
                Cur <= D;
            end

            4'b0111: begin //Storing current of 16 neurons (rd, rd + 1) (convma)
                current_registers[A[4 : 0]] <=  D[31 : 0];
                current_registers[(A[4 : 0] + 1) % 16] <= D[63 : 32];

                Cur <= D;
            end

            4'b1000: begin //upds - Updating states of 8 Neurons in a register
                if (rpr == 32'h00000000) begin //if refactory period expires
                    for (i = 0; i < 8; i = i + 1) begin
                        temp = current_registers[A[4:0]][i * 4 +: 4]; //extract current from those bits
                        temp = temp * 0.04 + 0.01; //I * Resistance + Rest Potential * ()
                        if (temp >= 0) begin
                            ntr[A[4:0]][i * 4 +: 4] = 4'b1111;
                        end
                    end
                end
                else begin
                    rpr -= 1;
                end
            end 

            4'b1001: begin //updg - Updating states of 32 Neurons in a register
                if (rpr == 32'h00000000) begin //if refactory period expires
                    for (j = 0; j < 4; j = j + 1) begin
                        for (i = 0; i < 8; i = i + 1) begin
                            temp = current_registers[i][i * 4 +: 4]; //extract current from those bits
                            temp = temp * 0.04 + 0.01; //I * Resistance + Rest Potential * (rest formula)
                            if (temp >= 0) begin
                                ntr[i][i * 4 +: 4] = 4'b1111;
                            end
                        end
                    end
                end
                
                else begin
                    rpr -= 1;
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
    input wire [511:0] S, //Input Wire from SVR 
    input wire [511:0] W, //Input Wire from WVR
    input wire [511:0] Cur_Input, //Input Wire of NSR

    input wire clk,
    input wire reset,

    output reg [511:0] Cur_Output // Output Wire
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
                Cur_Output[i * 4 +: 4] <= (S[0] & W[i * 4 +: 4]) + Cur_Input[i * 4 +: 4]; //and operation between 1 neuron's synapse (1bits) and 1 neuron's weights  (4bits)
            end
        end
    end
endmodule

module NAcc (
    input wire [511:0] S,         //Input Wire from SVR
    input wire [511:0] W,         //Input Wire from WVR
    input wire [511:0] Cur_Input, //Input Wire of NSR

    input wire clk,
    input wire reset,

    output reg [511:0] Cur_Output // Current output
);
    integer j;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Cur_Output <= 512'b0;
        end 
        
        else begin
            for (j = 0; j < 128; j = j + 1) begin
                Cur_Output[3:0] <= Cur_Output[3:0] + (S[j] & W[j * 4 +: 4]);
            end
            // Add current input for neuron i
            Cur_Output[3:0] = Cur_Output[3:0]  + Cur_Input[3 : 0]; //only using the first , even if im using it to store half of it
        end
    end
endmodule

module NeuronArray ( 
    input wire [511:0] S,         // 32 or 128 spikes
    input wire [511:0] W,         // 32 or 128 weights
    input wire [511:0] Cur_Input, // Current inputs

    input wire clk,
    input wire reset,

    output reg [511:0] Cur_Output // Current output
);
    integer i, j;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Cur_Output <= 512'b0;
        end 
        
        else begin
            // Compute summation for each of the 4 neurons
            for (i = 0; i < 16; i = i + 1) begin                
                // Weighted summation for neuron i
                for (j = 0; j < 128; j = j + 1) begin
                    Cur_Output[i * 4 +: 4] <= Cur_Output[i * 4 +: 4] + (S[j] & W[j * 4 +: 4]);
                end

                // Add current input for neuron i
                Cur_Output[i * 4 +: 4] = Cur_Output[i * 4 +: 4] + Cur_Input[i * 4 +: 4];
            end
        end
    end
endmodule