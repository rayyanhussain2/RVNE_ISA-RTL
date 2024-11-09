module WVR (
    input wire clk,                  // Clock signal
    input wire reset,                // Reset signal

    input wire [7:0] A,
         
    input wire [511:0] D,  

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
                

                3'b010: begin     // Load all 16 registers with 512 bits of D
                    wvr_memory_bank[0]  <= D[31:0];
                    wvr_memory_bank[1]  <= D[63:32];
                    wvr_memory_bank[2]  <= D[95:64];
                    wvr_memory_bank[3]  <= D[127:96];
                    wvr_memory_bank[4]  <= D[159:128];
                    wvr_memory_bank[5]  <= D[191:160];
                    wvr_memory_bank[6]  <= D[223:192];
                    wvr_memory_bank[7]  <= D[255:224];
                    wvr_memory_bank[8]  <= D[287:256];
                    wvr_memory_bank[9]  <= D[319:288];
                    wvr_memory_bank[10] <= D[351:320];
                    wvr_memory_bank[11] <= D[383:352];
                    wvr_memory_bank[12] <= D[415:384];
                    wvr_memory_bank[13] <= D[447:416];
                    wvr_memory_bank[14] <= D[479:448];
                    wvr_memory_bank[15] <= D[511:480];
                end
                

                default: begin
                    // No operation for other funct values
                end

             endcase
            
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
    end

endmodule

module SVR (
    input wire clk,                  // Clock signal
    input wire reset,                // Reset signal

    input wire [7:0] A,         
    input wire [511:0] D,               

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
                    svr_memory_bank[0]  <= D[31:0];
                    svr_memory_bank[1]  <= D[63:32];
                    svr_memory_bank[2]  <= D[95:64];
                    svr_memory_bank[3]  <= D[127:96];
                    svr_memory_bank[4]  <= D[159:128];
                    svr_memory_bank[5]  <= D[191:160];
                    svr_memory_bank[6]  <= D[223:192];
                    svr_memory_bank[7]  <= D[255:224];
                    svr_memory_bank[8]  <= D[287:256];
                    svr_memory_bank[9]  <= D[319:288];
                    svr_memory_bank[10] <= D[351:320];
                    svr_memory_bank[11] <= D[383:352];
                    svr_memory_bank[12] <= D[415:384];
                    svr_memory_bank[13] <= D[447:416];
                    svr_memory_bank[14] <= D[479:448];
                    svr_memory_bank[15] <= D[511:480];
                end
                

                default: begin
                    // No operation for other funct values
                end

             endcase
            
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
    end

endmodule



module VLSU (
    input wire [511:0] rdata,        // Input data to the VLSU
    input wire clk,                  // Clock signal
    output reg [511:0] vector        // Output vector data
);

    always @(posedge clk) begin
        vector <= rdata;             // Pass the input data directly to the output vector
    end

endmodule
