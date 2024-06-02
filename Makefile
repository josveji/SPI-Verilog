tarea: testbench_ms.v 	spi.ys SPI_ondas_ordenadas.gtkw
	yosys -s spi.ys
	iverilog testbench_ms.v
	vvp a.out
	gtkwave SPI_ondas_ordenadas.gtkw

