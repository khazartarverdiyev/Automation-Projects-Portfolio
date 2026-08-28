PROGRAM PLC_PRG
VAR
	// Function Block Instnces
	fbLevelControl : FB_LevelControl;
	fbInletPump : FB_Pump;
	fbOutletPump : FB_Pump;
	fbControlValve : FB_ControlValve;
	
	//Permissive And SafetyClose
	xInletPermissive : BOOL; 
	xOutletPermissive : BOOL;
	xValveSafetyClose : BOOL;
	
	//Inputs
	rSetPointHmi : REAL;
	xResetHMI : BOOL;
	
	//System Mode
	xSystemMode : BOOL := TRUE;
	xAlarm_HH: BOOL;
	xSensorFault: BOOL;
	xAlarm_LL: BOOL;
END_VAR

fbLevelControl(
	xAutoMode := xSystemMode,
	rLevel := GVLInputs.rLevelRaw,
	rSetPoint := rSetPointHmi,
	xResetAlarms := xResetHmi
);


xAlarm_HH := fbLevelControl.stAlarms.xAlarm_HH;
xAlarm_LL := fbLevelControl.stAlarms.xAlarm_LL;
xSensorFault := fbLevelControl.stAlarms.xSensorFault;

ACT_Interlock();

fbInletPump(
	xAutoMode := xSystemMode,
	xAutoStartCmd := (fbLevelControl.rPidOutput > 5.0),
	xManStartCmd := FALSE,
	xInterlock := xInletPermissive,
	xFeedback := GVLInputs.xInletPumpRunFB,
	xReset := xResetHMI,
	xStartCmd => GVLOutputs.xInletPumpStart
);

fbOutletPump(
	xAutoMode := xSystemMode,
	xAutoStartCmd := TRUE,
	xManStartCmd := FALSE,
	xInterlock := xOutletPermissive,
	xFeedback := GVLInputs.xOutletPumpRunFB,
	xReset := xResetHMI,
	xStartCmd => GVLOutputs.xOutletPumpStart
);
fbControlValve(
	xAutoMode := xSystemMode,
	rAutoValvePosition := fbLevelControl.rPidOutput,
	rManualValvePosition := 0.0,
	xSafetyClose := xValveSafetyClose,
	rValvePosition => GVLOutputs.rValvePosition
);
	
	
	
