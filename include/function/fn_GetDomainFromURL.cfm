<cfscript>
function fn_GetDomainFromURL (theURL)
{
	if (Not IsDefined("fn_IsValidURL") or Not IsCustomFunction(fn_IsValidURL))
		return "";
	else if (fn_IsValidURL(theURL) is False or Not Find(".", theURL))
		return "";
	else
		return ListGetAt(ListGetAt(theURL, 2, "/"), ListLen(ListGetAt(theURL, 2, "/"), ".") - 1, ".") & "." & ListLast(ListGetAt(theURL, 2, "/"), ".");
}
</cfscript>

