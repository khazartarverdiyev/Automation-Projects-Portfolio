# Flagship Project: Chemical Reactor Batch Process & Safety Interlock System

## Process Overview
This project simulates an industrial chemical reactor batch process built according to IEC 61131-3 engineering standards using CODESYS V3.5. The system automates a multi-step chemical reaction sequence—including precise tank filling, chemical dosing, temperature regulation, mixing, and discharging—integrated with dynamic safety interlocks and HMI visualization.

## Key Technical Features
* **Sequential Batch Control:** Automated state machine managing multi-step recipes (Fill, Add Chemical, Mix, Heat, Drain) with timeout fault diagnostics.
* **Functional Process Safety:** Hardware/Software interlocks monitoring maximum thresholds for temperature, pressure, and tank level with latching fault logic.
* **Visual Safety Interlocks:** Ladder Diagram (LD) logic for emergency stops (`E_StopButton`), vent valve actuation, and manual reset handshaking.
* **Modular Code Architecture:** Structured Text (ST) programs and global variable management (`GVL_Variables`) for scalable industrial control.
* **WebVisu HMI Integration:** Real-time visual monitoring displaying dynamic tank levels, actuator statuses, and alarm messaging.

## Technical Specifications
* **Software Environment:** CODESYS V3.5 (CODESYS Control Win V3)
* **Programming Languages:** Hybrid Architecture — Structured Text (ST) for sequential control algorithms and Ladder Diagram (LD) for safety/interlock logic.

## Safety Cause & Effect Matrix
| Cause (Event) | Active Alarm | Automated Safety Action | Reset Requirement |
| :--- | :--- | :--- | :--- |
| **High Temperature** ($> 90^\circ\text{C}$) | Temp Alarm | Latches `TempFault`, triggers system shutdown (`State 99`) | Fault Cleared + Operator Reset Edge |
| **High Pressure** ($> 6.0\text{ bar}$) | Vent Valve Open | Opens `VentValve` for pressure relief, triggers system fault | Fault Cleared + Operator Reset Edge |
| **High Level** ($> 80\%$) | Level Fault | Forces system into safe fault state (`State 99`) | Fault Cleared + Operator Reset Edge |
| **Emergency Stop Pressed** | Critical System Fault | Immediately de-energizes all actuators, enters fault state | Manual Reset Edge (`ResetButton`) |

## Code Architecture
* `GVL_Variables` (GVL): Global memory map for shared sensor inputs, operation buttons, and safety flags.
* `Interlock` (LD): Visual safety layer executing hardwired-style interlocks and fault latching.
* `PLC_PRG` (ST): Core sequential batch state machine (`CASE` framework) with step timeout monitoring (`StepTimer`).
* `Recipe_Data` (STRUCT): Reusable data structure holding target levels, temperatures, and mixing durations.

## HMI & Process Visualization
![HMI Process Overview](screenshots/hmi-overview.png)
