module risc_v_core (
    input clk,
    input reset,
    output reg [31:0] pc,
    output reg [31:0] instr,
    output reg [31:0] alu_result
);
    reg [31:0] memory [0:255];
    reg [31:0] registers [0:31];
    reg [31:0] next_pc;
    reg halt;

    wire [6:0] opcode = instr[6:0];
    wire [4:0] rd = instr[11:7];
    wire [4:0] rs1 = instr[19:15];
    wire [4:0] rs2 = instr[24:20];
    wire [2:0] funct3 = instr[14:12];
    wire [31:0] imm = {{20{instr[31]}}, instr[31:20]};

    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1)
            memory[i] = 0;
        for (i = 0; i < 32; i = i + 1)
            registers[i] = 0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 0;
            instr <= 0;
            alu_result <= 0;
            halt <= 0;
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 0;
        end else if (!halt) begin
            pc <= next_pc;
            instr <= memory[pc >> 2];
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            alu_result <= 0;
        end else if (!halt) begin
            case (opcode)
                7'b0010011: begin // ADDI
                    if (funct3 == 3'b000) begin
                        alu_result <= registers[rs1] + imm;
                        if (rd != 0) registers[rd] <= registers[rs1] + imm;
                    end
                end
                7'b0110011: begin // ADD, SUB
                    if (funct3 == 3'b000) begin
                        alu_result <= instr[30] ? registers[rs1] - registers[rs2] : registers[rs1] + registers[rs2];
                        if (rd != 0) registers[rd] <= instr[30] ? registers[rs1] - registers[rs2] : registers[rs1] + registers[rs2];
                    end
                end
                7'b0000011: begin // LW
                    if (funct3 == 3'b010) begin
                        alu_result <= memory[registers[rs1]];
                        if (rd != 0) registers[rd] <= memory[registers[rs1]];
                        if (pc == 32'h10) halt <= 1; // Halt after LW
                    end
                end
                7'b0100011: begin // SW
                    if (funct3 == 3'b010)
                        memory[registers[rs1]] <= registers[rs2];
                end
                default: alu_result <= 0;
            endcase
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset)
            next_pc <= 0;
        else if (!halt)
            next_pc <= pc + 4;
    end
endmodule
