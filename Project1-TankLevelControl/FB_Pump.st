FUNCTION_BLOCK FB_Pump
VAR_INPUT
	xAutoMode : BOOL; // Auto = TRUE, Manual = False;
	xAutoStartCmd : BOOL; //Start signal of auto mode
	xManStartCmd : BOOL; //Start signal of manual mode
	xInterlock : BOOL; //If it is true system is okay, there is no fault
	xFeedback : BOOL; //Feedback signal from motor
	tFeedbackDelay : TIME := T#3S; //Allowed time to response
	xReset : BOOL; //If feedback error is handled so press reset button on hmi
END_VAR
VAR_OUTPUT
	xStartCmd : BOOL; //Start signal is sent to Motor
	xRunning : BOOL; // Confirmation of feedback
	xFeedbackError : BOOL; //if in 3 seconds there is no feedback sensor so there is error
	
END_VAR
VAR
	tFeedbackCountDown : TON; //Countdown for feedback signal
END_VAR


// 1. Reset Faults
IF xReset THEN
    xFeedbackError := FALSE;
	tFeedbackCountDown(IN := FALSE); // reset the timer
END_IF

// 2. Feedback Checking
tFeedbackCountDown(IN := (xStartCmd AND NOT xFeedback), PT := tFeedbackDelay);

IF tFeedbackCountDown.Q THEN
    xFeedbackError := TRUE;
END_IF

// 3. Safety & Mode Selection
IF xFeedbackError OR NOT xInterlock THEN
    xStartCmd := FALSE; // Block start command if there is a fault
ELSIF xAutoMode THEN
    xStartCmd := xAutoStartCmd;
ELSE
    xStartCmd := xManStartCmd;
END_IF

// 4. Status Confirmation
xRunning := xFeedback;

