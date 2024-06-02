/* 
Estudiante: Josué María Jiménez Ramírez, C13987 
Profesor: Enrique Coen Alfaro
Curso: Circuitos Digitales II
Periodo: I - 2024

Descripción del archivo: Este es el código encargado de evaluar las pruebas de
"tester.v" en "transmitter_SPI.v" y "receiver_SPI.v". 
*/

//`include "tester_ms.v" // Incluyendo archivo de pruebas
`include "transmitter_SPI.v" // Incluyendo Transmisor
`include "receiver_SPI.v" // Incluyendo Receptor

// Declaración del módulo 

module SPI_tb;
    //Entradas
    reg clk, rst_m, rst_s1, rst_s2, CPH, CKP, strt; 
    reg [15:0] data_in_m;   // Data_in de Master
    reg [15:0] data_in_s1;  // Data_in de Slave 1 (s1)
    reg [15:0] data_in_s2;  // Data_in de Slave 2 (s2)

    // Salidas 
    wire CS, MISO, MOSI, SCK; 
    wire MOSI_m_s1;          // Cable que conecta MOSI de master con MOSI s1
    wire MISO_s1_s2;         // Cable que conecta MISO de s1 con MOSI de s2
    wire MISO_s2_m;          // Cable que conecta MISO de s2 con MISO de master


    initial begin 
        $dumpfile("resultados_SPI.vcd"); // Archivo con resultados
        $dumpvars(-1, SPI_tb); 
        $monitor ("clk=%b, rst_m=%b, rst_s1=%b, rst_s2=%b, CPH=%b, CKP=%b, strt=%b, MISO=%b, data_in_m=%b, data_in_s1=%b, data_in_s2=%b, CS=%b, MOSI=%b, SCK=%b",
        clk, rst_m, rst_s1, rst_s2, CPH, CKP, strt, MISO, data_in_m, data_in_s1, data_in_s2, CS, MOSI, SCK);

    end

    // Para Transmisor
    transmitter_SPI Master (
        .clk (clk),
        .rst (rst_m),
        .CPH (CPH),
        .CKP (CKP),
        .strt (strt),
        .MOSI (MOSI_m_s1),       // Se conecta MOSI de master con MOSI de s1
        .MISO (MISO_s2_m),       // Se conecta MISO de s1 con MOSI de s2
        .data_in (data_in_m),
        .CS (CS),
        .SCK (SCK)
    );

    // Para Receptor 1
    receiver_SPI Slave1 (
        .clk (clk),
        .rst (rst_s1),
        .CPH (CPH),
        .CKP (CKP),
        .MOSI (MOSI_m_s1),       // Se conecta MOSI de master con MOSI de s1
        .MISO (MISO_s1_s2),      // Se conecta MISO de s1 con MOSI de s2
        .data_in (data_in_s1),
        .SS (CS),
        .SCK (SCK)
    );
    
    // Para Receptor2
    receiver_SPI Slave2 (
        .clk (clk),
        .rst (rst_s2),
        .CPH (CPH),
        .CKP (CKP),
        .MOSI (MISO_s1_s2),     // Se conecta MISO de s1 con MOSI de s2
        .MISO (MISO_s2_m),      // Se conecta MISO de s2 con MISO de master
        .data_in (data_in_s2),
        .SS (CS),
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
        /*------------Prueba 1, modo 10-----------
        En esta prueba se envía los siguientes datos

        
        */

        data_in_m  = 16'b0101010101010101;
        data_in_s1 = 16'b0000000000000000;
        data_in_s2 = 16'b0000111100001111;
        
        clk = 0;
        rst_m = 0;
        rst_s1 = 0;
        rst_s2 = 0; 

        CPH = 0;
        CKP = 1;
        strt = 0;
    
        #40 rst_m = 1;
        rst_s1 = 1; 
        rst_s2 = 1; 
        
        #4 strt = 1; 
        #4 strt = 0;

        #2000 $finish;


    end // Fin de las pruebas

endmodule // Fin del módulo