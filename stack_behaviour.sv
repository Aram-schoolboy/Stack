
module stack_behaviour_normal(
    inout wire[3:0] IO_DATA,
    input wire RESET,
    input wire CLK,
    input wire[1:0] COMMAND,
    input wire[2:0] INDEX
    );

    reg [3:0] stack [4:0];
    reg [2:0] ptr;
    reg [3:0] res;

    initial begin
        stack[0] = 4'b0000;
        stack[1] = 4'b0000;
        stack[2] = 4'b0000;
        stack[3] = 4'b0000;
        stack[4] = 4'b0000;
        ptr = 3'b000;
    end

    assign IO_DATA = ((RESET == 1'b0) & (CLK == 1'b1) & (COMMAND == 2'b10 || COMMAND == 2'b11)) ? res : 4'bzzzz;

    always @(posedge CLK or posedge RESET) begin
        if (RESET == 1'b1) begin
            stack[0] = 4'b0000;
            stack[1] = 4'b0000;
            stack[2] = 4'b0000;
            stack[3] = 4'b0000;
            stack[4] = 4'b0000;
            ptr = 3'b000;
        end else if (COMMAND == 2'b01) begin
            if (ptr == 3'b000) begin
                ptr = 3'b100;
            end else begin
                --ptr;
            end
            stack[ptr] = IO_DATA;
        end else if (COMMAND == 2'b10) begin
            res = stack[ptr];
            ptr = (ptr + 1) % 5;
        end else if (COMMAND == 2'b11) begin
            if ((ptr == 3'b100 & INDEX == 3'b100)) begin
                res = stack[3];
            end else begin
                res = stack[(ptr + (INDEX % 5)) % 5];
            end
        end
    end

endmodule;