<!---
Input: number
Objective: Pad with at least 2 decimal places.
If zero or one decimal place, pad with 2.
If more than 2 decimal places, keep but without padded zeros.
--->

<cfscript>
function fn_LimitPaddedDecimalZerosDollar (value)
{
var newValue = value + 0;
var decimalValue = ListLast(newValue, ".");

if (ListLen(newValue, ".") is 1 or Len(decimalValue) lte 2 or decimalValue is 0)
	return Replace(DecimalFormat(newValue), ",", "", "ALL");
else
	while (Right(newValue, 1) is 0 and Right(newValue, 3) is not ".00")
		{
		newValue = Left(newValue, Len(newValue) - 1);
		}
	return newValue;
}

function fn_LimitPaddedDecimalZerosQuantity (value)
{
var newValue = value + 0;
var decimalValue = ListLast(newValue, ".");

if (ListLen(newValue, ".") is 1 or decimalValue is 0)
	return newValue;
else
	while (Right(newValue, 1) is 0 and Right(newValue, 3) is not ".00")
		{
		newValue = Left(newValue, Len(newValue) - 1);
		}
	return newValue;
}

function fn_setDecimalPrecision (value, precision)
{
var newDecimal = 0;
var oldDecimal = 0;
if (ListLen(value, ".") is 2)
	oldDecimal = ListGetAt(value, 2, ".");

if (Len(oldDecimal) lte precision)
	newDecimal = oldDecimal;
else if (Mid(oldDecimal, precision + 1, 1) lt 5)
	newDecimal = Left(oldDecimal, precision);
else if (precision is 1)
	newDecimal = IncrementValue(Mid(oldDecimal, precision, 1));
else
	newDecimal = Left(oldDecimal, precision - 1) & IncrementValue(Mid(oldDecimal, precision, 1));

return ListFirst(value, ".") & "." & newDecimal;
}

function fn_displayDateDifference (date1, date2)
{
var days = DateDiff("d", date1, date2);
var hours = DateDiff("h", date1, date2) - (24 * days);
var minutes = DateDiff("n", date1, date2) - (24 * 60 * days) - (60 * hours);
var seconds = DateDiff("s", date1, date2) - (24 * 60 * 60 * days) - (60 * 60 * hours) - (60 * minutes);
var dateTimeDifference = "";

if (days is not 0) dateTimeDifference = ListAppend(dateTimeDifference, days & " days ");
if (hours is not 0) dateTimeDifference = ListAppend(dateTimeDifference, hours & " hours ");
if (minutes is not 0) dateTimeDifference = ListAppend(dateTimeDifference, minutes & " minutes ");
if (seconds is not 0) dateTimeDifference = ListAppend(dateTimeDifference, seconds & " seconds ");

return Trim(dateTimeDifference);
}
</cfscript>

<cflock Scope="Application" Timeout="5">
	<cfset Application.fn_LimitPaddedDecimalZerosDollar = fn_LimitPaddedDecimalZerosDollar>
	<cfset Application.fn_LimitPaddedDecimalZerosQuantity = fn_LimitPaddedDecimalZerosQuantity>
	<cfset Application.fn_setDecimalPrecision = fn_setDecimalPrecision>
	<cfset Application.fn_displayDateDifference = fn_displayDateDifference>
</cflock>
