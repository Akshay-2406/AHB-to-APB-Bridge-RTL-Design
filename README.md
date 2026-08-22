# 🌉 AHB-to-APB-Bridge-RTL-Design

An ARM AMBA-compliant **AHB-to-APB Bridge** module written in Verilog HDL. This design bridges a high-speed Advanced High-performance Bus (AHB) with a low-power Advanced Peripheral Bus (APB) in System-on-Chip (SoC) architectures, translating AHB transactions into APB transactions.

---

## 📌 Project Overview

In ARM AMBA-based SoC designs, high-performance units (processors, memory) communicate over the AHB bus, while low-power peripherals (UART, Timers, Keypads, PIO) run on the APB bus. This AHB-to-APB Bridge functions as an interface master/slave wrapper to pass address, control, and data signals efficiently across both bus domains.

### Core Submodules
* **`ahb_slave_interface`:** Interfaces with the AHB bus master, capturing address (`HADDR`), write data (`HWDATA`), and control signals (`HWRITE`, `HTRANS`) upon valid selection.
* **`AkshayAc` (APB Controller):** Executes a Finite State Machine (FSM) to handle APB protocol timing, driving `PSEL`, `PENABLE`, `PADDR`, `PWRITE`, and `PWDATA` to target peripherals.

---

## 🔀 FSM Controller State Machine

The APB Controller module manages transfer cycles through a 3-state Finite State Machine:

* **`S_IDLE` (`2'b00`):** Default state. Waits for active transfer requests from the AHB interface.
* **`S_SETUP` (`2'b01`):** Asserts peripheral select (`PSEL`), driving target address and write data.
* **`S_ACCESS` (`2'b10`):** Asserts `PENABLE` to execute the data phase, holding state until `PREADY` is driven HIGH by the slave.

---

## ⚡ Interface Signals

### AHB Interface Signals
| Signal Name | Source / Type | Description |
| :--- | :--- | :--- |
| `HCLK` | Clock Source | Rising-edge system clock |
| `HRESETn` | System | Active-LOW reset signal |
| `HSEL` | Decoder | Active-HIGH slave select signal |
| `HWRITE` | Master | Read/Write direction (HIGH = Write, LOW = Read) |
| `HTRANS[1:0]` | Master | Transfer type indicator |
| `HADDR[31:0]` | Master | 32-bit AHB system address bus |
| `HWDATA[31:0]` | Master | 32-bit AHB write data bus |

### APB Interface Signals
| Signal Name | Source / Type | Description |
| :--- | :--- | :--- |
| `pclk` / `PCLK` | Clock Source | Peripheral clock timing signal |
| `hresetn` / `PRESETn` | System | Active-LOW peripheral reset |
| `paddr_out[31:0]` | Bridge Output | 32-bit APB target address bus |
| `pwdata_out[31:0]` | Bridge Output | 32-bit APB write data bus |
| `pwrite_out` | Bridge Output | Bus direction control signal |
| `psel_out` | Bridge Output | Target APB peripheral select signal |
| `penable_out` | Bridge Output | APB enable strobe signal |
| `pready` | APB Slave Input | Peripheral ready signal to extend transfer cycles |
| `hreadyout_temp` | Bridge Output | Transfer completion handshake back to AHB |

---

## 💻 Verification & Synthesis

* **Simulation Tool:** ModelSim
* **Functional Verification:** Verified read and write transactions with wave simulation waveforms, confirming accurate address translation and setup/enable strobe timings.
* **Synthesis:** Netlist generation verified proper structural port bindings between the `ahb_slave_interface` and `AkshayAc` submodules.

---

## 📂 Repository Structure

```text
AHB-to-APB-Bridge-RTL-Design/
├── rtl/
│   ├── ahb_slave_interface.v   # AHB Slave Interface Verilog Module
│   ├── APB_controller.v        # APB Controller FSM Verilog Module (AkshayAc)
│   └── bridge_top.v            # Top-level Integrated Bridge Module
├── sim/
│   └── tb_bridge.v             # Simulation Testbench
└── README.md                   # Repository Documentation
