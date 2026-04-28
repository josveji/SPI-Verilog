# SPI - Verilog

## Project Description

This repository contains a Verilog implementation of a basic SPI interface focused on the transmitter (master) module. The code includes a testbench that generates stimuli for the transmitter and stores simulation results for visualization in GTKWave.

## Contents

* `transmitter_SPI.v`

  * Implements the main module `transmitter_SPI`, which acts as an SPI transmitter.
  * Handles waiting, start, and transfer states.
  * Generates `SCK`, `MOSI`, and `CS` based on the `clk` signal, the `strt` signal, and the mode parameters `CPH`/`CKP`.
  * Transfers and receives 8-bit data using an internal shift register.

* `tester.v`

  * Generates test signals for simulation: `clk`, `rst`, `CPH`, `CKP`, `strt`, `MISO`, and `data_in`.
  * Initializes the `data_in` vector with a test pattern.

* `testbench.v`

  * Instantiates the `transmitter_SPI` module and the `tester` module.
  * Configures simulation output to a VCD file (`resultados_SPI.vcd`).
  * Monitors the main signals during execution.

* `SPI_ondas_ordenadas.gtkw`

  * GTKWave configuration file for visualizing simulation signals.

* `trasmitter_SPI.v`

  * Preliminary/incomplete version of the SPI transmitter.
  * Contains comments and a draft of the state logic but is not fully functional.

* `receiver_SPI.v`

  * Currently empty and does not contain an implementation.

## How the SPI Transmitter Works

The `transmitter_SPI` module implements a small state machine with the following stages:

1. `WAITING`

   * Waits for the `strt` signal to begin the transfer.
   * Keeps `CS` deactivated (high).

2. `START`

   * Activates `CS` low to initiate communication.
   * Sets the initial polarity of the `SCK` clock according to `CKP`.
   * Loads the input data `data_in` into an internal register.

3. `TRANSFER`

   * Generates an `SCK` clock derived from an internal divider counter.
   * Sends bits through `MOSI` and receives bits through `MISO` on the appropriate edge according to `CPH`.
   * Increments the bit counter until the transmission is complete.

## Simulation

To simulate the design, use a compatible Verilog simulator (for example, Icarus Verilog):

```sh
iverilog -o SPI_tb.vvp testbench.v transmitter_SPI.v tester.v
vvp SPI_tb.vvp
```

Then open the generated VCD file in GTKWave:

```sh
gtkwave resultados_SPI.vcd SPI_ondas_ordenadas.gtkw
```

## Important Notes

* The file `transmitter_SPI.v` is the main implementation of the SPI transmitter.
* The file `trasmitter_SPI.v` is a draft with incomplete logic. It is not used in the current simulation.
* `receiver_SPI.v` does not include code at this time.
* The `MISO` signal in `tester.v` is not explicitly changed after initialization, so for more complete testing it would be advisable to define receiver behavior or add an SPI receiver model.

## Recommendations

* Complete `receiver_SPI.v` to simulate a full master-slave exchange.
* Review and adjust `tester.v` to test different SPI modes (`CPH` / `CKP`) and data patterns.
* Verify the bit-counting logic if extending the transfer beyond 8 bits.
