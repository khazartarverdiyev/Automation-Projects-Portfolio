VAR_GLOBAL
	//Sensor value shared by interlock and plc_prg
	CurrentLevel : REAL; //Current Level of Tank
	CurrentTemp : REAL; //Current Temperature of Tank
	CurrentPressure : REAL; //Current Pressure of Tank
	
	//Operatetion Inputs
	E_StopButton : BOOL := TRUE; //Emergency Button
	StartButton : BOOL; //Start Button
	ResetButton : BOOL; //Reset Button
	
	//Safety Status( written by interlock and read by plc_prg)
	SystemFault : BOOL; //General fault flag
	VentValve : BOOL; //if there is high pressure it must be open for releasing pressure
	TempAlarm : BOOL; //Alarm for high temperature
END_VAR
