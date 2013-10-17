<cfscript>
function fn_DisplayPriceAmount (normalPrice, newPrice, isDollarOrPercent, isNewOrDeduction, isVolume, isVolumeDollarOrQuantity, isVolumeStep)
{
	if (IsNumeric(normalPrice))
		isDisplayNewPrice = True;
	else
		isDisplayNewPrice = False;
	
	if (isVolume is 0)
		{
		switch("#isDollarOrPercent#_#isNewOrDeduction#_#isDisplayNewPrice#")
			{
			case "0_0_True" : return "$" & Application.fn_LimitPaddedDecimalZerosDollar(newPrice);
			case "0_0_False" : return "$" & Application.fn_LimitPaddedDecimalZerosDollar(newPrice);
			case "0_1_False" : return "$" & Application.fn_LimitPaddedDecimalZerosDollar(newPrice) & "off";
			case "1_0_False" : return Application.fn_LimitPaddedDecimalZerosDollar(newPrice * 100) & "% of normal price";
			case "0_1_True" :
				{
				if (normalPrice is 0)
					return "$" & Application.fn_LimitPaddedDecimalZerosDollar(newPrice) & "off";
				else
					return "$" & Application.fn_LimitPaddedDecimalZerosDollar(newPrice) & "off" & "<br>= $" & Application.fn_LimitPaddedDecimalZerosDollar(normalPrice - newPrice);
				}
			case "1_0_True" :
				{
				if (normalPrice is 0)
					return Application.fn_LimitPaddedDecimalZerosDollar(newPrice * 100) & "% of normal price";
				else
					return Application.fn_LimitPaddedDecimalZerosDollar(newPrice * 100) & "% of normal price" & "<br>= $" & fn_LimitPaddedDecimalZerosDollar(normalPrice * newPrice);
				}
			case "1_1_True" :
				{
				if (normalPrice is 0)
					return Application.fn_LimitPaddedDecimalZerosDollar(newPrice * 100) & "% off normal price";
				else
					return Application.fn_LimitPaddedDecimalZerosDollar(newPrice * 100) & "% off normal price" & "<br>= $" & Application.fn_LimitPaddedDecimalZerosDollar(normalPrice * (1 - newPrice));
				}
			default : return Application.fn_LimitPaddedDecimalZerosDollar(newPrice * 100) & "% off";
			}
		}
	else
		{
		return "<div class=SmallText>" 
			& Iif(isVolumeDollarOrQuantity is 0, De("Based on $ value"), De("Based on Quantity"))
			& Iif(isVolumeStep is 0, De(""), De(" in steps"))
			& "</div>";
		}
}

function fn_DisplayVolumePriceAmount (normalPrice, newPrice, isDollarOrPercent, isNewOrDeduction, isVolume, isVolumeDollarOrQuantity, isVolumeStep)
{
	switch("#isDollarOrPercent#_#isNewOrDeduction#")
		{
		case "0_0" : return "$" & Application.fn_LimitPaddedDecimalZerosDollar(newPrice);
		case "0_1" : return "$" & Application.fn_LimitPaddedDecimalZerosDollar(newPrice) & "off";
		case "1_0" : return Application.fn_LimitPaddedDecimalZerosDollar(newPrice * 100) & "% of normal price";
		default : return Application.fn_LimitPaddedDecimalZerosDollar(newPrice * 100) & "% off";
		}
}

function fn_DisplayVolumePriceCustom (normalPrice, newPrice, isDollarOrPercent, isNewOrDeduction, isVolume, isVolumeDollarOrQuantity, isVolumeStep)
{
	switch("#isDollarOrPercent#_#isNewOrDeduction#")
		{
		case "0_0" : return "$" & Application.fn_LimitPaddedDecimalZerosDollar(newPrice);
		case "0_1" : return "$" & Application.fn_LimitPaddedDecimalZerosDollar(normalPrice - newPrice);
		case "1_0" : return "$" & Application.fn_LimitPaddedDecimalZerosDollar(normalPrice * newPrice);
		default : return "$" & Application.fn_LimitPaddedDecimalZerosDollar(normalPrice * (1 - newPrice));
		}
}

function fn_ReturnPriceInterval (interval, intervalType)
{
	var intervalTypePosition = ListFind(Variables.priceStageIntervalTypeList_value, intervalType);
	var intervalReturn = "";

	if (intervalType is "")
		return "(LAST STAGE)";
	else
		if (intervalTypePosition is 0)
			intervalReturn = interval & " " & intervalType;
		else
			intervalReturn = interval & " " & ListGetAt(Variables.priceStageIntervalTypeList_label, intervalTypePosition);

		if (interval gt 1)
			intervalReturn = intervalReturn & "s";
		return intervalReturn;
}
</cfscript>
