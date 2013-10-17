<cfscript>
function fn_convertSecondsToHMS (numSeconds)
{
	var intervalHours = 0;
	var intervalMinutes = 0;
	var intervalSeconds = 0;

	if (Not IsNumeric(numSeconds))
		return "0,0,0";
	else if (numSeconds lte 0)
		return "0,0,0";
	else
		{
		intervalHours = numSeconds \ (60 * 60);
		intervalMinutes = (numSeconds - (intervalHours * 60 * 60)) \ 60;
		intervalSeconds = numSeconds - (intervalHours * 60 * 60) - (intervalMinutes * 60);

		return "#intervalHours#,#intervalMinutes#,#intervalSeconds#";
		}
}

function fn_displaySecondsAsHMS (numSeconds, separator)
{
	var intervalList = fn_convertSecondsToHMS(numSeconds);
	var intervalHours = ListFirst(intervalList);
	var intervalMinutes = ListGetAt(intervalList, 2);
	var intervalSeconds = ListLast(intervalList);

	var returnDisplay = "";
	if (intervalHours is 1)
		returnDisplay = "1 hour" & separator;
	else if (intervalHours gt 1)
		returnDisplay = intervalHours & " hours" & separator;

	if (intervalMinutes is 1)
		returnDisplay = returnDisplay & "1 minute" & separator;
	else if (intervalMinutes gt 1)
		returnDisplay = returnDisplay & intervalMinutes & " minutes" & separator;

	if (intervalSeconds is 1)
		returnDisplay = returnDisplay & "1 second" & separator;
	else if (intervalSeconds gt 1)
		returnDisplay = returnDisplay & intervalSeconds & " seconds" & separator;

	return returnDisplay;
}
</cfscript>
