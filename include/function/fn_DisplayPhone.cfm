<cfscript>
function fn_DisplayPhone (areaCode, number, extension)
{
	var phoneDisplay = "";

	if (Len(qry_selectPhoneList.phoneNumber) is 7)
		phoneDisplay = Left(number, 3) & "-" & Right(number, 4);
	else
		phoneDisplay = number;

	if (extension is not "")
		phoneDisplay = phoneDisplay & " x" & extension;
}
</cfscript>
