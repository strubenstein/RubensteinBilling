<cfscript>
function fn_IsValidIPaddress (IPaddress)
{
	if (
		Trim(IPaddress) is ""
			or REFind("[^0-9.]", IPaddress)
			or ListLen(IPaddress, ".") is not 4
			or ListGetAt(IPaddress, 1, ".") gt 255
			or ListGetAt(IPaddress, 2, ".") gt 255
			or ListGetAt(IPaddress, 3, ".") gt 255
			or ListGetAt(IPaddress, 4, ".") gt 255
	   )
		return False;
	else
		return True;
}

function fn_IsIPaddressInRange (IPmin, IPmax, IPcheck)
{
	var IPisInRange = True;
	if (Not fn_IsValidIPaddress(IPmin) or Not fn_IsValidIPaddress(IPmax) or Not fn_IsValidIPaddress(IPcheck))
		IPisInRange = False;
	else
		{
		for (x = 1; x lte 4; x = x + 1)
			{
			if (ListGetAt(IPmin, x, ".") gt ListGetAt(IPcheck, x, ".") or ListGetAt(IPmax, x, ".") lt ListGetAt(IPcheck, x, "."))
				IPisInRange = False;
				break;
			}
		}
	return IPisInRange;
}
</cfscript>

