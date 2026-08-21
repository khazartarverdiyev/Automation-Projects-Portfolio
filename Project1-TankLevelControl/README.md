# Flagship Project: Tank Level Control & Process Safety System

## Process Overview
This project simulates an industrial tank level control system built according to IEC 61131-3 engineering standards using CODESYS V3.5. The system integrates PID feedback control, dynamic safety interlocks, automated fault diagnostics, and human-machine interface (HMI) visual controls.

## Key Technical Features
* **PID Process Control:** Continuously regulates liquid level to match operator setpoints and prevent system cycling.
* **Functional Process Safety:** Automated interlocks for overfill protection and pump dry-run prevention.
* **Sensor Diagnostics:** Detects signal fault and wire-break conditions (4–20 mA loop monitoring).
* **Modular Code Design:** Reusable Function Blocks (FBs) and structured data types (DUTs) for scalable architecture.
* **WebVisu HMI Integration:** Real-time visual monitoring, trend log tracking, and manual alarm reset controls.

## Technical Specifications
* **Software Environment:** CODESYS V3.5
* **Programming Languages:** Hybrid Architecture — Structured Text (ST) for control algorithms; Ladder Diagram (LD) for visual safety interlocks.

## Safety Cause & Effect Matrix
| Cause (Event) | Active Alarm | Automated Safety Action | Reset Requirement |
| :--- | :--- | :--- | :--- |
| High-High Level (≥ 90%) | HH Alarm | Closes inlet control valve, stops inlet pump | Level Normal + Operator Manual Reset |
| Low-Low Level (≤ 10%) | LL Alarm | Trips outlet pump (prevents cavitation) | Level Normal + Operator Manual Reset |
| Sensor Fault (< -2%) | Signal Error | Forces control valve to safe state (0%) and trips pumps | Fault Cleared + Operator Manual Reset |

## Code Architecture
* `DUT_TankAlarms` (STRUCT): Grouped alarm setpoints and status boolean flags.
* `FB_LevelControl` (ST): Evaluates sensor integrity and executes PID calculations.
* `FB_Pump` & `FB_ControlValve` (ST): Reusable actuator blocks with command feedback timers.
* `ACT_Interlock` (LD): Visual safety permissives and emergency shutdown chain.

## HMI & Process Visualization
![HMI Process Overview](hmi_overview.png)
