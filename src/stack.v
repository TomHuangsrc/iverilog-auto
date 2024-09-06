`default_nettype none
module stack #(
parameter data_width = 8 ,
parameter stack_size = 8
 )

(
input wire clk , rst , push , pop,
input wire [data_width -1 : 0 ] data_in ,
output reg [data_width -1 : 0 ] data_out ,
output reg full, empty,
output reg [7:0] ptr
);

reg [data_width -1 :0] mem [2**stack_size -1 :0];


always @(*) begin
if (push & !full ) begin

    empty =0;
    
    if (ptr == 2**stack_size -1)
        full=1;
end

if (pop & ! empty) begin
    
    full = 0;
end

if( ptr==0)
    empty=1;


end


always @ ( posedge clk ) begin
 
if (rst) begin
    ptr<=0;
    full<=0;
    empty<=1;
    end
else if (push & !full) begin
    mem[ptr] <= data_in;
    ptr<=ptr+1;
    
    
    end

else if (pop & ! empty) begin
    ptr<=ptr-1;
    data_out<=mem[ptr-1];
    //$display ("entered the decrement pointer code \n");
end

end

endmodule





