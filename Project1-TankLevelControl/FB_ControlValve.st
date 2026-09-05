FUNCTION_BLOCK FB_ControlValve
VAR_INPUT
	xAutoMode : BOOL; // Auto = true, manual = false
	rAutoValvePosition : REAL; //Auto Valve position by PID
	rManualValvePosition : REAL; // Manual Valve Position by human
	xSafetyClose : BOOL; //IF it is true, force valve to stop
END_VAR
VAR_OUTPUT
	rValvePosition : REAL; //ValvePosition is sent to control Valve
END_VAR
VAR
END_VAR


IF xSafetyClose THEN
	rValvePosition := 0.0; // Closed Valve
ELSIF xAutoMode THEN
	rValvePosition := rAutoValvePosition;
ELSE 
	rValvePosition := rManualValvePosition;
END_IF

//Limit Valve Position
IF rValvePosition > 100.0 THEN
	rValvePosition := 100.0;
ELSIF rValvePosition < 0.0 THEN
	rValvePosition := 0.0;
END_IF
