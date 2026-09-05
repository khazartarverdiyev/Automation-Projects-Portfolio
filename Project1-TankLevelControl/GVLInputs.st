VAR_GLOBAL
	rLevelRaw : REAL; //Measured level from level transmitter
	rFlowRate : REAL; //Mesaured flow rate from flow trasnmitter
	xInletPumpRunFB : BOOL; //Feedback if inlet pump works
	xOutletPumpRunFB : BOOL; //Feedback if outlet pump works
	xEmergencyStop : BOOL := TRUE; //Emergency Button
END_VAR
