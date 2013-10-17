<cfscript>
function fn_IsInteger (value)
{
	if (Not IsNumeric(value))
		return False;
	else if (value is not Int(value))
		return False;
	else
		return True;
}

function fn_IsIntegerPositive (value)
{
	if (Not IsNumeric(value) or value lte 0)
		return False;
	else if (value is not Int(value))
		return False;
	else
		return True;
}

function fn_IsIntegerNonNegative (value)
{
	if (Not IsNumeric(value) or value lt 0)
		return False;
	else if (value is not Int(value))
		return False;
	else
		return True;
}

function fn_IsIntegerList (value)
{
	if (Trim(value) is "" or REFind("[^0-9,-]", value))
		return False;
	else if (Left(value, 1) is "," or Right(value, 1) is "," or Find(",,", value))
		return False;
	else
		return True;
}

function fn_ConvertBooleanToNumeric (booleanValue)
{
	if (Trim(booleanValue) is "")
		return "";
	else if (ListFindNoCase("t,true,1,y,yes", booleanValue))
		return 1;
	else if (ListFindNoCase("f,false,0,n,no", booleanValue))
		return 0;
	else
		return "";
}
</cfscript>

<cflock Scope="Application" Timeout="5">
	<cfset Application.fn_IsInteger = fn_IsInteger>
	<cfset Application.fn_IsIntegerPositive = fn_IsIntegerPositive>
	<cfset Application.fn_IsIntegerNonNegative = fn_IsIntegerNonNegative>
	<cfset Application.fn_IsIntegerList = fn_IsIntegerList>
	<cfset Application.fn_ConvertBooleanToNumeric = fn_ConvertBooleanToNumeric>
</cflock>
