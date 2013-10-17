<cfscript>
function fn_DisplayPaymentApproved (paymentApproved)
{
switch(paymentApproved)
	{
	case "" : return "<font color=""gold"">Unknown</font>";
	case 0 : return "<font color=""red"">Rejected</font>";
	case 1 : return "<font color=""green"">Approved</font>";
	default : return "";
	}
}
</cfscript>
