<!--- or REFindNoCase("[^A-Za-z0-9_:?=/.-]", theURL) or REFindNoCase("[^A-Za-z]", Right(theURL, 1)) --->
<cfscript>
function fn_IsValidURL (theURL)
{
	if (Trim(theURL) is "")
		return False;
	else if (Find(" ", theURL) or (Left(theURL, 7) is not "http://" and Left(theURL, 8) is not "https://"))
		return False;
	else
		return True;
}

function fn_IsValidImageURL (imageURL)
{
	if (fn_IsValidURL(imageURL) is False)
		return False;
	else if (Right(imageURL,4) is not ".gif"
			and Right(imageURL,4) is not ".bmp"
			and Right(imageURL,4) is not ".png"
			and Right(imageURL,4) is not ".jpg"
			and Right(imageURL,5) is not ".jpeg")
		return False;
	else
		return True;
}
</cfscript>
