module tb_NPU;

	logic clk, rst, enable;
	logic [15:0] raw_in [4];
	logic [15:0] raw_out [4];
	logic done;
	logic [3:0] countOut;

	NPU uut (
		.clk(clk),
		.rst(rst),
		.enable(enable),
		.raw_in(raw_in),
		.raw_out(raw_out),
		.done(done),
		.countOut(countOut)
	);

	// Clock generator
	initial clk = 0;
	always #5 clk = ~clk;  // 100 MHz clk -> periodo = 10ns

	// Test sequence
	initial begin
		$display("Inicio del test...");
		
		// Inicialización
		rst = 1;
		enable = 0;
		raw_in[0] = 16'd1;
		raw_in[1] = 16'd2;
		raw_in[2] = 16'd3;
		raw_in[3] = 16'd4;

		#10;

		// PRUEBA 1: Reset activo (bajarlo)
		rst = 0;
		#10;
		rst = 1;
		#10;

		// PRUEBA 2: Activar enable por 12 ciclos
		enable = 1;
		repeat (12) begin
			#10;
			$display("Cycle %0t | count=%0d | done=%0b | out = %0d %0d %0d %0d", $time, countOut, done, raw_out[0], raw_out[1], raw_out[2], raw_out[3]);
		end
		enable = 0;

		// PRUEBA 3: Cambiar entradas y repetir
		raw_in[0] = 16'd10;
		raw_in[1] = 16'd20;
		raw_in[2] = 16'd30;
		raw_in[3] = 16'd40;
		rst = 0;
		#10 rst = 1;
		#10;

		enable = 1;
		repeat (10) begin
			#10;
			$display("Cycle %0t | count=%0d | done=%0b | out = %0d %0d %0d %0d", $time, countOut, done, raw_out[0], raw_out[1], raw_out[2], raw_out[3]);
		end
		enable = 0;

		// PRUEBA 4: Validar done en ciclo 8
		if (done)
			$display("✅ DONE signal activa correctamente en count == 8");
		else
			$display("❌ ERROR: DONE no se activó como se esperaba");

		// PRUEBA 5: Todos ceros
		raw_in[0] = 16'd0;
		raw_in[1] = 16'd0;
		raw_in[2] = 16'd0;
		raw_in[3] = 16'd0;
		rst = 0;
		#10 rst = 1;
		#10;

		enable = 1;
		repeat (10) begin
			#10;
			$display("Cycle %0t | count=%0d | done=%0b | out = %0d %0d %0d %0d", $time, countOut, done, raw_out[0], raw_out[1], raw_out[2], raw_out[3]);
		end
		enable = 0;

		// PRUEBA 6: Alternancia de valores
		raw_in[0] = 16'hAAAA;
		raw_in[1] = 16'h5555;
		raw_in[2] = 16'hAAAA;
		raw_in[3] = 16'h5555;
		rst = 0;
		#10 rst = 1;
		#10;

		enable = 1;
		repeat (10) begin
			#10;
			$display("Cycle %0t | count=%0d | done=%0b | out = %0d %0d %0d %0d", $time, countOut, done, raw_out[0], raw_out[1], raw_out[2], raw_out[3]);
		end
		enable = 0;

		$display("Fin del test.");
		$finish;
	end

endmodule
