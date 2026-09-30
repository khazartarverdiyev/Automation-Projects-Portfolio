TYPE Recipe_Data :
STRUCT
	TargetLevelA : REAL := 50.0; //Base liquid level
	TargetAmountB : REAL := 20.0; //Amount of chemical
	MixTime : TIME := T#5S; //How long to mix
	TargetTemp : REAL := 80; //Required Temp
END_STRUCT
END_TYPE
