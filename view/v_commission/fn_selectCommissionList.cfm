<cfscript>
function fn_ReturnCommissionInterval (interval, intervalType)
{
	var intervalTypePosition = ListFind(Variables.commissionStageIntervalTypeList_value, intervalType);
	var intervalReturn = "";

	if (intervalType is "")
		return "(LAST STAGE)";
	else
		if (intervalTypePosition is 0)
			intervalReturn = interval & " " & intervalType;
		else
			intervalReturn = interval & " " & ListGetAt(Variables.commissionStageIntervalTypeList_label, intervalTypePosition);

		if (interval gt 1)
			intervalReturn = intervalReturn & "s";
		return intervalReturn;
}

function fn_DisplayCommissionAmount (commissionAmount, isDollarOrPercent, isVolume, isVolumeDollarOrQuantity, isVolumeStep)
{
	if (isVolume is 0)
		{
		if (isDollarOrPercent is 0)
			return "$" & Application.fn_LimitPaddedDecimalZerosDollar(commissionAmount);
		else
			return Application.fn_LimitPaddedDecimalZerosDollar(commissionAmount * 100) & "% of revenue";
		}
	else
		{
		return "<div class=SmallText>" 
			& Iif(isVolumeDollarOrQuantity is 1, De("Based on revenue"), De("Based on quantity"))
			& Iif(isVolumeStep is 1, De(""), De(" in steps"))
			& "</div>";
		}
}
</cfscript>
