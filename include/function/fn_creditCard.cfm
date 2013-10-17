<cfscript>
function fn_IsMod10 (cardNumber) {
	var ccNumReverse = Reverse(ReReplaceNoCase(cardNumber,  "[^0-9]",  "",  "All"));
	var even_list = "";
	var even_numbers = "0";
	var odd_numbers = "0";
	var loop1 = 1;
	var loop2 = 1;

	while (loop1 lte Len(ccNumReverse))
	{
		If ((loop1 mod 2) is 0)
			even_list = even_list & (Mid(ccNumReverse, loop1, 1) * 2);
		Else
			odd_numbers  = (odd_numbers + Mid(ccNumReverse, loop1, 1));
		 loop1 = loop1 + 1;
	}

	while (loop2 lte Len(even_list))
	{
		even_numbers = (even_numbers + Mid(even_list, loop2, 1));
		loop2 = loop2 + 1;
	}

	If ((even_numbers + odd_numbers) mod 10 is 0)
		return True;
	Else
		return False;
}

function fn_IsCreditCardNumberSameAsType (cardNumber, cardType)
{
switch("#Left(cardNumber, 1)#_#cardType#")
	{
	case "3_Amex" : return True;
	case "4_Visa" : return True;
	case "5_MasterCard" : return True;
	case "6_Discover" : return True;
	default : return False;
	}
}
</cfscript>

