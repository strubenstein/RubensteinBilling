<cfscript>
function fn_IsValidEmail (email)
{
	if (
		Not REFindNoCase("([\w._]+)\@([\w_-]+(\.[\w_]+)+)", email)
			or REFindNoCase("[^A-Za-z0-9_.@-]", email)
			or Find(".@", email)
			or Find("@.", email)
			or Find("..", email)
			or Not Find(".", email)
			or Not Find("@", email)
			or REFindNoCase("[^A-Za-z]", Right(email, 1))
			or REFindNoCase("[^A-Za-z0-9]", Left(email, 1))
			or ListLen(email, "@") gt 2
			or REFindNoCase("[^A-Za-z0-9]", Left(email, 1))
		)
		return False;
	else
		return True;
}
</cfscript>
