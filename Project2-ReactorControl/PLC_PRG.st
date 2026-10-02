PROGRAM PLC_PRG
VAR
	CurrentState : INT := 0; //0 : Idle, 1: Fill Tank , 2: Add Chemical, 3: Mix, 4: Heat, 5: Drain , 99: Fault;
	Active_Recipe : Recipe_Data; //Reusable recipe data
	
	ValveA : BOOL; //Valve for filling
	ValveB : BOOL; //Valve for chemical
	MixerOn : BOOL; //MixerMotor
	HeaterOn : BOOL; //Heater
	DrainValve : BOOL; //Discharge Valve
	
	MixerTimer : TON; //Timer for mixer
	StepTimer : TON ; //Counter for each step
	StepTimerPT : TIME := T#10S; //Time of Counter
	StepFault : BOOL; //there will be fault if it take too long than needed to complete each step
	LevelThreshold : REAL := 0.5; //If level less than this drain valve must be closed
	MinLevelLimit : REAL := 10.0; ////Minimum level to run mixer and heater
	
	StartEdge : R_TRIG; //It prevent auto-restart
	ResetEdge : R_TRIG; //Reset FOR one cycle
	
	CurrentStateText : STRING(50); //It is for hmi, because number without explaining can be complicated and confusing
	AlarmMessage : STRING(50); //Alarm Message
END_VAR

StartEdge(CLK := GVL_Variables.StartButton); //It prevent auto-restart
ResetEdge(CLK := GVL_Variables.ResetButton); //Reset for one cycle

Interlock(); //Safety logic


IF GVL_Variables.SystemFault OR StepFault THEN
		ValveA := FALSE;
		ValveB := FALSE;
		MixerOn := FALSE;
	 	HeaterOn := FALSE;
		DrainValve := FALSE;
		MixerTimer(IN := FALSE);
		StepTimer(IN := FALSE);
		CurrentState := 99;
END_IF
CASE CurrentState OF
	0: //Idle-Wait for start
		ValveA := FALSE;
		ValveB := FALSE;
		MixerOn := FALSE;
	 	HeaterOn := FALSE;
		DrainValve := FALSE;
		StepTimer(IN := FALSE);
		IF StartEdge.Q THEN
			CurrentState := 1;
		END_IF
	
	1: //Fill Tank
		ValveA := TRUE;
		StepTimer(IN := TRUE, PT:= StepTimerPT);
		IF GVL_Variables.CurrentLevel >= Active_Recipe.TargetLevelA then
			ValveA := FALSE;
			StepTimer(IN:= FALSE);
			CurrentState := 2;
		ELSIF StepTimer.Q THEN
			StepFault := TRUE;
			CurrentState := 99;
		END_IF
	
	2 : //Add Chemical
		ValveB := TRUE;
		StepTimer(IN := TRUE, PT := StepTimerPT);
		IF GVL_Variables.CurrentLevel >= ( Active_Recipe.TargetLevelA + Active_Recipe.TargetAmountB) THEN
			ValveB := FALSE;
			StepTimer(IN:=FALSE);
			CurrentState := 3;
		ELSIF StepTimer.Q THEN
			StepFault := TRUE;
			CurrentState := 99;
		END_IF
	
	3 : //Mix ingredients
    	IF GVL_Variables.CurrentLevel < MinLevelLimit THEN
        	StepFault := TRUE;
        	CurrentState := 99;
   	 	ELSE
        	MixerOn := TRUE;
       		MixerTimer(IN := TRUE, PT := Active_Recipe.MixTime);
        	IF MixerTimer.Q THEN
            	MixerOn := FALSE;
            	MixerTimer(IN := FALSE);
            	CurrentState := 4;
        	END_IF
    END_IF
		
	4: //Heater
		HeaterOn := TRUE;
		StepTimer(IN := TRUE, PT := StepTimerPT);
		IF GVL_Variables.CurrentTemp >= Active_Recipe.TargetTemp THEN
			HeaterOn := FALSE;
			StepTimer(IN := FALSE);
			CurrentState := 5;
		ELSIF StepTimer.Q THEN
			StepFault := TRUE;
			CurrentState := 99;
		END_IF
		
	5: //Discharge Valve
		DrainValve := TRUE;
		StepTimer(IN := TRUE, PT := StepTimerPT);
		IF GVL_Variables.CurrentLevel < LevelThreshold THEN
			DrainValve := FALSE;
			StepTimer (IN := FALSE);
			CurrentState := 0; // Back to idle
		ELSIF StepTimer.Q THEN
			StepFault := TRUE;
			CurrentState := 99;
		END_IF
		
	99 : //FAULT State
		ValveA := FALSE;
		ValveB := FALSE;
		MixerOn := FALSE;
	 	HeaterOn := FALSE;
		DrainValve := FALSE;
		MixerTimer(IN := FALSE);
		StepTimer(IN := FALSE);
		IF ResetEdge.Q THEN
			StepFault := FALSE;
		END_IF
		IF NOT GVL_Variables.SystemFault AND NOT StepFault THEN
			CurrentState := 0;
		END_IF
END_CASE


CASE CurrentState OF
    0: CurrentStateText := 'State 0: Idle - Waiting for Start';
    1: CurrentStateText := 'State 1: Filling Tank (Valve A)';
    2: CurrentStateText := 'State 2: Adding Chemical (Valve B)';
    3: CurrentStateText := 'State 3: Mixing Ingredients';
    4: CurrentStateText := 'State 4: Heating Reactor';
    5: CurrentStateText := 'State 5: Draining Tank';
    99: CurrentStateText := 'FAULT ACTIVE - Check Alarms';
END_CASE;

IF GVL_Variables.SystemFault OR StepFault THEN
    AlarmMessage := 'CRITICAL SYSTEM FAULT!';
ELSE
    AlarmMessage := 'System Normal';
END_IF;
