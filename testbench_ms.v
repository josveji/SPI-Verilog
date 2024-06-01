/* 
Estudiante: Josué María Jiménez Ramírez, C13987 
Profesor: Enrique Coen Alfaro
Curso: Circuitos Digitales II
Periodo: I - 2024

Descripción del archivo: Este es el código encargado de evaluar las pruebas de
"tester.v" en "transmitter_SPI.v" y "receiver_SPI.v". 
*/

`include "tester_ms.v" // Incluyendo archivo de pruebas
`include "transmitter_SPI.v" // Incluyendo Transmisor
`include "receiver_SPI.v" // Incluyendo Receptor

// Decclaración del módulo 

module SPI_tb;
    //Entradas
    reg clk, rst_m, rst_s1, CPH, CKP, strt, MISO; 
    reg [7:0] data_in_m;   // Entradas
    reg [7:0] data_in_s1;  // Data_in de Slave 1

    // Salidas 
    wire CS, MOSI, SCK;

    initial begin 
        $dumpfile("resultados_SPI.vcd"); // Archivo con resultados
        $dumpvars(-1, SPI_tb); 
        $monitor ("clk=%b, rst_m=%b, rst_s1=%b, CPH=%b, CKP=%b, strt=%b, MISO=%b, data_in_m=%b, data_in_s1=%b, CS=%b, MOSI=%b, SCK=%b",
        clk, rst_m, rst_s1, CPH, CKP, strt, MISO, data_in_m, data_in_s1, CS, MOSI, SCK);

    end

    // Para Transmisor
    transmitter_SPI U0 (
        .clk (clk),
        .rst (rst_m),
        .CPH (CPH),
        .CKP (CKP),
        .strt (strt),
        .MISO (MISO),
        .data_in (data_in_m),
        .CS (CS),
        .MOSI (MOSI),
        .SCK (SCK)
    );

    // Para Receptor
    receiver_SPI U1 (
        .clk (clk),
        .rst (rst_s1),
        .CPH (CPH),
        .CKP (CKP),
        .MISO (MISO),
        .data_in (data_in_s1),
        .SS (CS),
        .MOSI (MOSI),
        .SCK (SCK)
    );
    
    // Para tester de Transmisor
    /*tester P0 (
        .clk (clk),
        .rst_m (rst_m),
        .rst_s1 (rst_s1),
        .CPH (CPH),
        .CKP (CKP),
        .strt (strt),
        .MISO (MISO),
        .data_in_m (data_in_m),
        .data_in_s1 (data_in_s1),
        .CS (CS),
        .MOSI (MOSI),
        .SCK (SCK)
    );*/

    // El diseño de las pruebas inicia acá 
    always begin 
        #1 clk = !clk;
    end

    initial begin 
        //------------Prueba 1, modo 10-----------
        data_in_m  = 8'b01010101;
        data_in_s1 = 8'b00000000;
        
        clk = 0;
        rst_m = 0;
        rst_s1 
        CPH = 0;
        strt = 0;
        CKP = 1; 
        #40 rst = 1;

        #4 strt = 1; 
        #4 strt = 0;



    end // Fin de las pruebas

endmodule // Fin del módulo