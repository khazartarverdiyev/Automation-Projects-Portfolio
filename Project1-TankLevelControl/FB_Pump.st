FUNCTION_BLOCK FB_Pump
VAR_INPUT
	xAutoMode : BOOL; // Auto = TRUE, Manual = False;
	xAutoStartCmd : BOOL; //Start signal of auto mode
	xManStartCmd : BOOL; //Start signal of manual mode
	xInterlock : BOOL; //If it is true system is okay, there is no fault
	xFeedback : BOOL; //Feedback signal from motor
	tFeedbackDelay : TIME := T#3S; //Allowed time to response
END_VAR
VAR_OUTPUT
	xStartCmd : BOOL; //Start signal is sent to Motor
	xRunning : BOOL; // Confirmation of feedback
	xFeedbackError : BOOL; //if in 3 seconds there is no feedback sensor so there is error
	
END_VAR
VAR
	tFeedbackCountDown : TON; //Countdown for feedback signal
END_VAR


// 1.Mode Selection
IF xAutoMode THEN
	xStartCmd := xAutoStartCmd AND xInterlock;
ELSE
	xStartCmd := xManStartCmd AND xInterlock;
END_IF

// 2. FeedbackChecking
tFeedbackCountDown(IN := (xStartCmd AND NOT xFeedback), PT:= tFeedbackDelay);

IF tFeedbackCountDown.Q THEN
	xFeedbackError := TRUE;
END_IF

// 3. Safety 
IF xFeedbackError OR NOT xInterlock THEN
	xStartCmd := FALSE;
END_IF

//Confirmation
xRunning := xFeedback;
