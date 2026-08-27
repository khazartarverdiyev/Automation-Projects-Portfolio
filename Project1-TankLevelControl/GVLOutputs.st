VAR_GLOBAL
	xInletPumpStart : BOOL; //It is inlet pump start signal, if its contactor gets 24V DC from PLC, it will run
	xOutletPumpStart : BOOL; //It is outlet pump start signal, if its contactor gets 24V DC from PLC, it will run
	rValvePosition : REAL; //It is valve position which is decided by PID or an operator
END_VAR
