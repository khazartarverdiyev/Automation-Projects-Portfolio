TYPE DUT_Alarms :
STRUCT
		// Alarms setpoint
	rSetPointAlarm_HH : REAL := 90.0;
	rSetPointAlarm_H : REAL := 80.0;
	rSetPointAlarm_L : REAL := 20.0;
	rSetPointAlarm_LL : REAL := 10.0;

	//Alarm Status
	xAlarm_HH : BOOL;
	xAlarm_H : BOOL;
	xAlarm_L : BOOL ;
	xAlarm_LL : BOOL;
	
	//Sensor Fault
	xSensorFault : BOOL;
END_STRUCT
END_TYPE
