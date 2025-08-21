module testbench;
    reg clk, reset;
    wire [31:0] pc, instr, alu_result;

    risc_v_core cpu (.clk(clk), .reset(reset), .pc(pc), .instr(instr), .alu_result(alu_result));

    wire [31:0] reg_x5 = cpu.registers[5];
    wire [31:0] reg_x6 = cpu.registers[6];
    wire [31:0] reg_x7 = cpu.registers[7];
    wire [31:0] reg_x8 = cpu.registers[8];
    wire [31:0] mem_5 = cpu.memory[5];

    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench);


        clk = 0;
        reset = 1;
        #20 reset = 0;

        cpu.memory[0] = 32'h00500293; // ADDI x5, x0, 5
        cpu.memory[1] = 32'h00600313; // ADDI x6, x0, 6
        cpu.memory[2] = 32'h006283b3; // ADD x7, x5, x6
        cpu.memory[3] = 32'h0072a023; // SW x7, 0(x5)
        cpu.memory[4] = 32'h0002a403; // LW x8, 0(x5)

        #20;
        @(posedge clk); @(posedge clk); #2 $display("After ADDI x5: Reg x5 = %h", cpu.registers[5]);
        @(posedge clk); @(posedge clk); #2 $display("After ADDI x6: Reg x6 = %h", cpu.registers[6]);
        @(posedge clk); @(posedge clk); #2 $display("After ADD x7: Reg x7 = %h", cpu.registers[7]);
        @(posedge clk); @(posedge clk); #2 $display("After SW: Mem[5] = %h", cpu.memory[5]);
        @(posedge clk); @(posedge clk); #2 $display("After LW: Reg x8 = %h", cpu.registers[8]);

        #20 $display("Final: PC = %h, Instr = %h, ALU Result = %h, Reg x5 = %h, Reg x6 = %h, Reg x7 = %h, Reg x8 = %h, Mem[5] = %h",
                     pc, instr, alu_result, cpu.registers[5], cpu.registers[6], cpu.registers[7], cpu.registers[8], cpu.memory[5]);
        #10 $finish;
    end
endmodule
