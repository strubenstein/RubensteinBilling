<cfscript>
function fn_EncryptString (stringToEncrypt)
{
	if (Trim(stringToEncrypt) is "")
		return '';
	else
		return Encrypt(stringToEncrypt, Application.billingEncryptionCode);
}

function fn_DecryptString (stringToDecrypt)
{
	if (Trim(stringToDecrypt) is "")
		return '';
	else
		return Decrypt(stringToDecrypt, Application.billingEncryptionCode);
}

function fn_HashString (stringToHash)
{
	if (Trim(stringToHash) is "")
		return "";
	else
		return Hash(stringToHash, "SHA-512");
}
</cfscript>

<cflock Scope="Application" Timeout="5">
	<cfset Application.fn_EncryptString = fn_EncryptString>
	<cfset Application.fn_DecryptString = fn_DecryptString>
	<cfset Application.fn_HashString = fn_HashString>
</cflock>
