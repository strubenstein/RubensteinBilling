<cfscript>
function fn_EmailFrom (emailFromName, emailFromEmail)
{
	if (Trim(emailFromName) is "")
		return '"#emailFromEmail#" <#emailFromEmail#>';
	else
		return '"#emailFromName#" <#emailFromEmail#>';
}

function fn_EmailType (isEmailHtml)
{
	if (isEmailHtml is 1)
		return 'html';
	else
		return 'text';
}
</cfscript>

