PROGRAM Interlock
VAR
	MaxTempLimit : REAL := 90; //Maximum safe temperature
	MaxPressureLimit : REAL := 6.0; // Maximum Safe pressure in bar unit
	MaxLevelLimit : REAL := 80; //Maximum Safe Level of Tank 
	
	TempFault : BOOL; // Fault for Temperature
	PressureFault : BOOL; // Fault for Pressure
 	LevelFault : BOOL; // Fault for Level
	
	ResetEdge : R_TRIG; //Reset signal for one scycle
	ResetEdge_Q: BOOL;
END_VAR

VAR CONSTANT
END_VAR



![Reactor Interlock Logic](./reactorinterlock-ld.png)
