/* 
Estudiante: Josué María Jiménez Ramírez, C13987 
Profesor: Enrique Coen Alfaro
Curso: Circuitos Digitales II
Periodo: I - 2024

Descripción del archivo: Este es el código encargado de evaluar las pruebas de
"tester.v" en "ATM_controller.v". 
*/

`include "tester.v" // Incluyendo archivo de pruebas
`include "transmitter_SPI.v" // Incluyendo Transmisor

// Decclaración del módulo 

module SPI_tb;
    //Entradas
    wire clk, rst, CPH, CKP, strt, MISO; 
    wire [7:0] data_in;   // Entradas

    // Salidas 
    wire CS, MOSI, SCK;

    initial begin 
        $dumpfile("resultados_SPI.vcd"); // Archivo con resultados
        $dumpvars(-1, SPI_tb); 
        $monitor ("clk=%b, rst=%b, CPH=%b, CKP=%b, strt=%b, MISO=%b, data_in=%b, CS=%b, MOSI=%b, SCK=%b",
        clk, rst, CPH, CKP, strt, MISO, data_in, CS, MOSI, SCK);

    end

    // Para Transmisor
    transmitter_SPI U0 (
        .clk (clk),
        .rst (rst),
        .CPH (CPH),
        .CKP (CKP),
        .strt (strt),
        .MISO (MISO),
        .data_in (data_in),
        .CS (CS),
        .MOSI (MOSI),
        .SCK (SCK)
    );
    
    // Para tester de Transmisor
    tester P0 (
        .clk (clk),
        .rst (rst),
        .CPH (CPH),
        .CKP (CKP),
        .strt (strt),
        .MISO (MISO),
        .data_in (data_in),
        .CS (CS),
        .MOSI (MOSI),
        .SCK (SCK)
    );   

endmodule // Fin del módulo