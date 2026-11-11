# Traffic Light Control System Using CODESYS

## Project Overview

This project is a simulated traffic light control system designed for a four-way intersection.

It was developed using CODESYS V3.5, with WebVisu for HMI visualization. The entire control program was implemented using Ladder Diagram (LD).

The system uses timer-based sequencing to control traffic-light transitions.

## Key Features

- Automatic traffic-light sequencing using timer-based control.
- Two-second All-Red clearance intervals between traffic phases.
- Pedestrian request handling using R_TRIG and a latched request.
- 10-second pedestrian crossing period.
- Emergency mode with a blinking red light.
- Reset of normal traffic states and timer inputs during emergency mode.

## Technologies Used

- CODESYS V3.5
- Ladder Diagram (LD)
- WebVisu (HMI)
- TON and TP timer function blocks
- R_TRIG (rising-edge detection)
- SET and RESET instructions

## Traffic-Light Sequence

The system follows this automatic sequence:

| Phase | Duration |
|---|---:|
| NS Green | 10 seconds |
| NS Yellow | 3 seconds |
| All-Red 1 | 2 seconds |
| EW Green | 10 seconds |
| EW Yellow | 3 seconds |
| All-Red 2 | 2 seconds |

The controller includes a 2-second All-Red clearance interval between traffic phases. This provides time for vehicles to clear the intersection before traffic starts moving in the other direction.

## Pedestrian Control

## Pedestrian Control

The pedestrian button uses an R_TRIG function block to detect a button press. The request is stored in a latched BOOL variable called `PedestrianRequest`.

After the normal traffic-light sequence completes one cycle, the controller checks for a pending request. If a request exists, pedestrian crossing starts for 10 seconds.

During pedestrian crossing:
- NS Red and EW Red signals remain ON.
- All vehicle green and yellow signals remain OFF.
- The pedestrian crossing state remains active for 10 seconds.

After the crossing period finishes, the pedestrian request and crossing state are reset. The red signals are turned OFF, and normal traffic operation resumes with NS Green.

New pedestrian requests during an active crossing are ignored by the current control logic.

## Emergency Mode

When emergency mode is activated, all normal traffic-light states are reset and the normal timer inputs become FALSE.

The system activates a blinking red light using TP and TON timer function blocks:

- TP controls the 1-second ON period.
- TON controls the 1-second OFF interval.

When emergency mode is deactivated, the emergency red light turns OFF immediately. The normal traffic sequence remains stopped. The operator can resume normal operation by pressing the Start button. No additional Reset command is required.

## Human-Machine Interface (HMI)

The HMI was developed using CODESYS WebVisu. It provides the following controls and indicators:

- Start button to begin normal operation.
- Emergency button to activate emergency mode.
- Pedestrian button to request pedestrian crossing.
- Traffic-light indicators to display the current signal states.

## Testing

The project was tested using CODESYS PLC simulation and WebVisu.

The following functions were tested:

- Normal traffic-light sequence and phase timing.
- Two-second All-Red clearance intervals.
- Pedestrian request handling and crossing.
- Emergency mode and blinking red light.
- Starting normal operation after emergency deactivation.

## Project Documentation

### Ladder Logic

The complete Ladder Diagram implementation is available in the following PDF:

[View Ladder Logic PDF](TrafficLightLadderLogic.pdf)

### HMI Demonstration

The following video demonstrates the traffic-light controller operating through the CODESYS WebVisu HMI.

[Watch HMI Demonstration](Traffic-light-simulation.mp4)

## Limitations

This project is an educational simulation developed for learning and demonstrating PLC programming concepts. It is not designed or certified for controlling real-world traffic intersections.
