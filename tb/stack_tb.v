`default_nettype none
module stack_tb  ();

localparam data_width = 8 , stack_size = 8;


reg clk , rst , push , pop;
reg [data_width -1 :0] data_in;
wire [stack_size-1 : 0] ptr;
wire  [data_width -1 :0] data_out;
wire full , empty;




stack #(
    .data_width(data_width) ,
    .stack_size(stack_size)
)
stack_inst 
(
    .clk(clk) ,
    .rst(rst) ,
    .push(push) ,
    .pop(pop) ,
    .data_in (data_in) ,
    .data_out (data_out) ,
    .full(full) ,
    .empty(empty) ,
    .ptr(ptr)
);


//wire [7:0] mem_val = stack_inst.mem[ptr];   

initial begin
clk <= 0;
forever begin
    #10
    clk= ~clk;
end
end
initial
        begin            
            $dumpfile("stack_tb.vcd");
            $dumpvars(0,stack_tb);
        end

initial @(negedge clk) begin
    rst=1; push=0 ; pop=0 ; data_in= 8'h00; @(negedge clk) ;

    rst=0; push=1 ; pop=0 ; data_in= 8'h11; @(negedge clk) expect_mem(8'h11);

    rst=0; push=1 ; pop=0 ; data_in= 8'h22; @(negedge clk) expect_mem(8'h22) ;

    rst=0; push=1 ; pop=0 ; data_in= 8'h33; @(negedge clk) expect_mem(8'h33) ;

    rst=0; push=0 ; pop=1 ; data_in= 8'hxx; @(negedge clk) expect_out(8'h33) ;

    rst=0; push=0 ; pop=1 ; data_in= 8'hxx; @(negedge clk) expect_out(8'h22) ;

    rst=0; push=0 ; pop=1 ; data_in= 8'hxx; @(negedge clk) expect_out(8'h11) ;


    rst=0; push=1 ; pop=0 ; data_in= 8'h55; @(negedge clk) expect_mem(8'h55) ;


    rst=0; push=0 ; pop=1 ; data_in= 8'hxx; @(negedge clk) expect_out(8'h55) ;

    repeat (256) 
        begin 
             rst=0; push=1 ; pop=0 ; data_in= 8'hff; @(negedge clk) expect_mem(8'hff); 
        end

    repeat (256)
        begin
                rst=0; push=0 ; pop=1 ; data_in= 8'hxx; @(negedge clk) expect_out(8'hff) ;
        end


        rst=0; push=1 ; pop=0 ; data_in= 8'h11; @(negedge clk) expect_mem(8'h11);


    $display("TEST PASSED");
    $finish;
  end


  task expect_out (input [7:0] exp_out);
    if (data_out !== exp_out) 
    begin
        $display("TEST FAILED");
        $display("Failed => time=%0d: outut value: %h  Expected value : %h  \n ptr: %h  full flag : %b  empty flat : %b \n push : %b  pop : %b",
                 $time, data_out ,exp_out , ptr ,full , empty ,push , pop );
        $finish;
    end
    else
    begin
           $display("Passed => time=%0d: outut value: %h  Expected value : %h  \n ptr: %h  full flag : %b  empty flat : %b \n push : %b  pop : %b",
                 $time, data_out ,exp_out , ptr ,full , empty , push , pop );
    end

  endtask


  task expect_mem (input [7:0] exp_mem);
    if (stack_inst.mem[ptr-1] !== exp_mem) 
    begin
        $display("TEST FAILED");
        $display("Failed => time=%0d: memory value: %h  Expected value : %h  \n ptr: %h  full flag : %b  empty flat : %b  \n push : %b  pop : %b",
                 $time, stack_inst.mem[ptr-1] ,exp_mem , ptr ,full , empty , push , pop );
        $finish;
    end
    else
    begin
           $display("PASSED => time=%0d: memory value: %h  Expected value : %h  \n ptr: %h  full flag : %b  empty flat : %b \n push : %b  pop : %b",
                 $time, stack_inst.mem[ptr-1] ,exp_mem , ptr ,full , empty , push , pop  );
    end

  endtask



endmodule