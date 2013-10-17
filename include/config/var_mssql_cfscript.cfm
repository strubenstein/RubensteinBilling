<cfscript>
function fn_convertCFdatepartToSQL (datePart)
{
	switch(datePart)
		{
		case "h" : return "hh";
		case "d" : return "d";
		case "ww" : return "wk";
		case "m" : return "m";
		case "q" : return "q";
		case "yyyy" : return "yy";
		default : return "d";
	}
}
</cfscript>
