module tb;
  reg clk;
  reg res;

  riscv_multi uut (
    .clk(clk),
    .res(res)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);

    res = 1;
    #15;
    res = 0

    #500; 

    $display("Simulare finalizata la T=%0t", $time);
    $finish;
  end

  initial begin
    $monitor("T=%0t | PC=%h | IR=%h | Opcode=%b | CS=%d", 
              $time, uut.cale_date_inst.PC, uut.cale_date_inst.IR, uut.opcode, uut.cale_control_inst.cs);
  end

endmodule