FUNCTION_BLOCK FB_LevelControl
VAR_INPUT
	xAutoMode : BOOL; // TRUE = Auto FALSE = MANUAL
	rLevel : REAL; //Input from GVLInputs
	rSetPoint : REAL; //Target Level
	rKp : REAL := 2.0; // Proportianl time in seconds;
	rTn : REAL := 10.0; //Integral time in seconds;
	rTv : REAL := 0.0;// DerivativeTime in seconds
	xResetAlarms : BOOL; //Reset after error is removed
END_VAR
VAR_OUTPUT
	rPidOutput : REAL;
	stAlarms : DUT_Alarms;
	xResetPulse : BOOL;
END_VAR
VAR
	PID : UTIL.PID;
	fbResetTrigger : R_TRIG; //Function block for reset
END_VAR



// 1. Reset for one cycle
fbResetTrigger ( CLK := xResetAlarms, Q => xResetPulse);

// 2. Sensor Fault Detection & Latched Reset
IF (rLevel < -2.0) OR (rLevel > 102.0) THEN
    stAlarms.xSensorFault := TRUE; // Latch Sensor Fault
ELSIF xResetPulse AND (rLevel >= 0.0) AND (rLevel <= 100.0) THEN
    stAlarms.xSensorFault := FALSE; // Reset Fault ONLY on 1-scan pulse AND safe level
END_IF

// 3. Latched High-High Alarm
IF (rLevel >= stAlarms.rSetPointAlarm_HH) OR stAlarms.xSensorFault THEN
    stAlarms.xAlarm_HH := TRUE;
ELSIF xResetPulse AND (rLevel < stAlarms.rSetPointAlarm_HH) THEN
    stAlarms.xAlarm_HH := FALSE;
END_IF

// 4. Latched Low-Low Alarm
IF (rLevel <= stAlarms.rSetPointAlarm_LL) OR stAlarms.xSensorFault THEN
    stAlarms.xAlarm_LL := TRUE;
ELSIF xResetPulse AND (rLevel > stAlarms.rSetPointAlarm_LL) THEN
    stAlarms.xAlarm_LL := FALSE;
END_IF

// 5. Non-Latched Warning Alarms
stAlarms.xAlarm_H := (rLevel >= stAlarms.rSetPointAlarm_H);
stAlarms.xAlarm_L := (rLevel <= stAlarms.rSetPointAlarm_L);
//PID tuning parameters
PID(
	Actual := rLevel,
	SET_POINT := rSetPoint,
	Reset := xResetAlarms,
	KP := rKp,
	TN := rTn,
	TV := rTv,
	Y_MIN := 0.0,
	Y_MAX := 100.0,
	Y => rPidOutput
);

//Checking Auto Mode
IF NOT xAutoMode OR stAlarms.xSensorFault THEN
	rPidOutput := 0.0;
END_IF
