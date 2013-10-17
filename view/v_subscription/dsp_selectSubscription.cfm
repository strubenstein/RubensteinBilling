<!--- regionID, subscriptionID_trend, subscriptionID_parent, authorUserID_custom, cancelUserID_custom, --->
<cfoutput>
<script language="JavaScript">
function toggle(target)
{ obj=(document.all) ? document.all[target] : document.getElementById(target);
  obj.style.display=(obj.style.display=='none') ? 'inline' : 'none';
}

var clicks = 0;
function ChangeText(obj, originalText, clickText)
{
	if(clicks == 0)
	{
		obj.innerHTML = clickText;
		clicks = 1;
	}
	else
	{
		obj.innerHTML = originalText;
		clicks = 0;
	}	
}
</script>

<p>
<table border="0" cellspacing="2" cellpadding="2" class="TableText">
<tr>
	<td>Completed: </td>
	<td><cfif qry_selectSubscription.subscriptionCompleted is 1>Subscription has not yet completed.<cfelse>Subscription has completed.</cfif></td>
</tr>
<tr>
	<td>Last Processed: </td>
	<td><cfif Not IsDate(qry_selectSubscription.subscriptionDateProcessLast)>n/a<cfelse>#DateFormat(qry_selectSubscription.subscriptionDateProcessLast, "dddd, mmmm dd, yyyy")#</cfif></td>
</tr>
<tr>
	<td>Next Processed: </td>
	<td><cfif Not IsDate(qry_selectSubscription.subscriptionDateProcessNext)>n/a<cfelse>#DateFormat(qry_selectSubscription.subscriptionDateProcessNext, "dddd, mmmm dd, yyyy")#</cfif></td>
</tr>
<tr valign="top">
	<td>Contact User(s): </td>
	<td>
		<cfif qry_selectSubscriptionUser.RecordCount is 0>
			(no specified contact user)
		<cfelse>
			<cfloop Query="qry_selectSubscriptionUser">
				#qry_selectSubscriptionUser.lastName#, #qry_selectSubscriptionUser.firstName#
				<cfif ListFind(Variables.permissionActionList, "viewUser")> (<a href="index.cfm?method=user.viewUser&userID=#qry_selectSubscriptionUser.userID#" class="plainlink">go</a>)</cfif><br>
			</cfloop>
		</cfif>
	</td>
</tr>
<tr valign="top">
	<td>Product: </td>
	<td>
		<cfif qry_selectSubscription.productID is 0>
			(Custom product)
		<cfelse>
			<cfif qry_selectSubscriptionList.productID_custom[1] is not "">#qry_selectSubscriptionList.productID_custom[1]#. </cfif>#qry_selectSubscriptionList.productName[1]#
			<cfif ListFind(Variables.permissionActionList, "viewProduct")> (<a href="index.cfm?method=product.viewProduct&productID=#qry_selectSubscriptionList.productID[1]#" class="plainlink">go</a>)</cfif><br>
			<cfif qry_selectSubscriptionList.productCode[1] is not "">Code: #qry_selectSubscription.productCode[1]#<br></cfif>
			Price: $#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectSubscriptionList.productPrice[1])#<br>
		</cfif>
	</td>
</tr>
<cfif qry_selectSubscription.categoryID is not 0>
	<tr>
		<td>Category: </td>
		<td>
			<cfloop Index="catID" List="#qry_selectCategory.categoryID_parentList#">
				<cfset Variables.categoryRow = ListFind(ValueList(qry_selectCategoryList.categoryID), catID)>
				<cfif Variables.categoryRow is not 0>#qry_selectCategoryList.categoryTitle[Variables.categoryRow]# | </cfif>
			</cfloop>
			#qry_selectCategory.categoryTitle#
		</td>
	</tr>
</cfif>
<cfif Application.fn_IsIntegerPositive(qry_selectSubscriptionList.vendorID[1])>
	<tr>
		<td>Vendor: </td>
		<td>
			<cfif qry_selectVendor.vendorID_custom is not "">#qry_selectVendor.vendorID_custom#. </cfif>
			#qry_selectVendor.vendorName#
			<cfif ListFind(Variables.permissionActionList, "viewVendor")> (<a href="index.cfm?method=vendor.viewVendor&vendorID=#qry_selectSubscriptionList.vendorID[1]#" class="plainlink">go</a>)</cfif>
			<cfif qry_selectVendor.vendorCode is not "">Code: #qry_selectVendor.vendorCode#<br></cfif>
		</td>
	</tr>
</cfif>
</table>

<!--- Custom status and custom fields --->
<cfinvoke component="#Application.billingMapping#control.c_status.ViewStatusHistory" method="viewStatusHistory" returnVariable="isStatusHistoryViewed">
	<cfinvokeargument name="primaryTargetKey" value="subscriptionID">
	<cfinvokeargument name="targetID" value="#URL.subscriptionID#">
</cfinvoke>

<cfinvoke component="#Application.billingMapping#control.c_customField.ViewCustomFieldValue" method="viewCustomFieldValues" returnVariable="isCustomFieldValuesViewed">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="subscriptionID">
	<cfinvokeargument name="targetID" value="#URL.subscriptionID#">
</cfinvoke>
</p>

<cfif qry_selectSubscription.subscriptionID_rollup is not 0 and qry_selectSubscription_rollup.RecordCount is 1>
	<p class="MainText">This subscription rolls up to another subscription:<br>
	#qry_selectSubscription_rollup.subscriptionOrder#. #qry_selectSubscription_rollup.subscriptionName# 
	(<a href="index.cfm?method=subscription.viewSubscription&subscriberID=#qry_selectSubscription.subscriberID#&subscriptionID=#qry_selectSubscription.subscriptionID_rollup#" class="plainlink">go</a>)</p>
<cfelseif qry_selectSubscription.subscriptionIsRollup is 1 and qry_selectSubscriptionList_rollup.RecordCount is not 0>
	<form method="get" action="index.cfm">
	<input type="hidden" name="method" value="subscription.viewSubscription">
	<input type="hidden" name="subscriberID" value="#qry_selectSubscription.subscriberID#">
	<p class="MainText">This subscription has other subscriptions that roll up to it:<br>
	<select name="subscriptionID" size="1">
	<cfloop Query="qry_selectSubscriptionList_rollup">
		<option value="#qry_selectSubscriptionList_rollup.subscriptionID#">#qry_selectSubscriptionList_rollup.subscriptionOrder#. #HTMLEditFormat(qry_selectSubscriptionList_rollup.subscriptionName)#</option>
	</cfloop>
	</select> <input type="submit" value="Go"></p>
	</form>
</cfif>

<cfparam Name="URL.showDetails" Default="False">
<cfif URL.showDetails is False>
	<cfset Variables.showText = "Show Details">
	<cfset Variables.hideText = "Hide Details">
<cfelse>
	<cfset Variables.showText = "Hide Details">
	<cfset Variables.hideText = "Show Details">
</cfif>
<!--- 
<div class="MainText">
[<a href="index.cfm?method=subscription.viewSubscription&subscriberID=#URL.subscriberID#&subscriptionID=#URL.subscriptionID#&showDetails=True" class="plainlink"><cfif URL.showDetails is True><b>Show All Details</b><cfelse>Show All Details</cfif></a>] 
[<a href="index.cfm?method=subscription.viewSubscription&subscriberID=#URL.subscriberID#&subscriptionID=#URL.subscriptionID#&showDetails=False" class="plainlink"><cfif URL.showDetails is False><b>Hide All Details</b><cfelse>Hide All Details</cfif></a>]
</div>
--->

<cfloop Query="qry_selectSubscriptionList">
	<p class="MainText">
	<b>
	#DateFormat(qry_selectSubscriptionList.subscriptionDateCreated, "mm/dd/yyyy")# thru 
	<cfif qry_selectSubscriptionList.subscriptionStatus is 1>Present<cfelse>#DateFormat(qry_selectSubscriptionList.subscriptionDateUpdated, "mm/dd/yyyy")#</cfif> -- 
	<cfif qry_selectSubscriptionList.subscriptionID_custom is not "">#qry_selectSubscriptionList.subscriptionID_custom#. </cfif>#qry_selectSubscriptionList.subscriptionName# - 
	[<a href="javascript:void(0);" class="plainlink" onClick="toggle('subscription#CurrentRow#');ChangeText(this,'#Variables.showText#', '#Variables.hideText#');">#Variables.showText#</a>]<br>
	</b>

	<table border="1" cellspacing="2" cellpadding="2" class="TableText" id="subscription#CurrentRow#"<cfif URL.showDetails is False> style="display:none;"</cfif>>
	<tr>
		<td>Status: </td>
		<td><cfif qry_selectSubscriptionList.subscriptionStatus is 1>Active<cfelse>Inactive</cfif></td>
	</tr>
	<tr>
		<td>Added: </td>
		<td>
			#DateFormat(qry_selectSubscriptionList.subscriptionDateCreated, "dddd, mmmm dd yyyy")# at #TimeFormat(qry_selectSubscriptionList.subscriptionDateCreated, "hh:mm tt")#
			<cfif qry_selectSubscriptionList.userID_author is not 0> by #qry_selectSubscriptionList.authorFirstName# #qry_selectSubscriptionList.authorLastName#</cfif>
		</td>
	</tr>
	<cfif qry_selectSubscriptionList.subscriptionStatus is 0>
		<tr>
			<td>Cancelled/Updated By: </td>
			<td>
				#DateFormat(qry_selectSubscriptionList.subscriptionDateUpdated, "dddd, mmmm dd yyyy")# at #TimeFormat(qry_selectSubscriptionList.subscriptionDateUpdated, "hh:mm tt")#
				<cfif qry_selectSubscriptionList.userID_cancel is not 0> by #qry_selectSubscriptionList.cancelFirstName# #qry_selectSubscriptionList.cancelLastName#</cfif>
			</td>
		</tr>
	</cfif>
	<!--- 
	<tr>
		<td>Internal ID: </td>
		<td>#qry_selectSubscriptionList.subscriptionID#</td>
	</tr>
	<cfif qry_selectSubscriptionList.subscriptionID_custom is not "">
		<tr>
			<td>Custom ID: </td>
			<td>#qry_selectSubscriptionList.subscriptionID_custom#</td>
		</tr>
	</cfif>
	<tr>
		<td>Subscription Name: </td>
		<td>#qry_selectSubscriptionList.subscriptionName#</td>
	</tr>
	--->

	<cfif qry_selectSubscriptionParameterList.RecordCount is not 0>
		<cfset Variables.parameterRow = ListFind(ValueList(qry_selectSubscriptionParameterList.subscriptionID), qry_selectSubscriptionList.subscriptionID)>
		<cfif Variables.parameterRow is not 0>
			<tr valign="top">
				<td>Product Parameters: </td>
				<td>
					<cfset Variables.thisSubscriptionID = qry_selectSubscriptionList.subscriptionID>
					<cfloop Query="qry_selectSubscriptionParameterList" StartRow="#Variables.parameterRow#">
						<cfif Variables.qry_selectSubscriptionParameterList.subscriptionID is not Variables.thisSubscriptionID><cfbreak></cfif>
						<cfset Variables.parameterTextRow = ListFind(ValueList(qry_selectProductParameterOption.productParameterOptionID), qry_selectSubscriptionParameterList.productParameterOptionID)>
						<cfif Variables.parameterTextRow is not 0>
							#qry_selectProductParameterOption.productParameterText[Variables.parameterTextRow]#: #qry_selectProductParameterOption.productParameterOptionLabel[Variables.parameterTextRow]#<br>
						</cfif>
					</cfloop>
					<cfif qry_selectSubscriptionList.productParameterExceptionID is not 0>
						<cfset Variables.exceptionRow = ListFind(ValueList(qry_selectProductParameterException.productParameterExceptionID), qry_selectSubscriptionList.productParameterExceptionID)>
						<cfif Variables.exceptionRow is not 0>
							<br>Exception: #qry_selectProductParameterExceptionList.productParameterExceptionText[Variables.exceptionRow]#
						</cfif>
					</cfif>
				</td>
			</tr>
		</cfif>
	</cfif>
	<tr>
		<td>Quantity: </td>
		<td>#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectSubscriptionList.subscriptionQuantity)# <cfif qry_selectSubscriptionList.subscriptionQuantityVaries is 1>(Varies)</cfif></td>
	</tr>

	<cfif qry_selectSubscriptionList.priceID is 0>
		<tr>
			<td>Unit Price: </td>
			<td>$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectSubscriptionList.subscriptionPriceUnit)#</td>
		</tr>
	<cfelse>
		<cfset Variables.priceRow = ListFind(ValueList(qry_selectPrice.priceID), qry_selectSubscriptionList.priceID)>
		<tr valign="top">
			<td>Custom Price: </td>
			<td>
				<cfif Variables.priceRow is 0>
					?
				<cfelse>
					<cfset Variables.subscriptionPriceID = qry_selectSubscriptionList.priceID>
					<cfset Variables.subscriptionPriceStageID = qry_selectSubscriptionList.priceStageID>
					<cfset Variables.subscriptionPriceNormal = qry_selectSubscriptionList.subscriptionPriceNormal>
					<cfset Variables.subscriptionProductID = qry_selectSubscriptionList.productID>

					<cfif qry_selectPrice.priceCode[Variables.priceRow] is not "">#qry_selectPrice.priceCode[Variables.priceRow]#. </cfif>#qry_selectPrice.priceName[Variables.priceRow]#
					<cfif ListFind(Variables.permissionActionList, "listPrices")> (<a href="index.cfm?method=price.listPrices&priceID=#qry_selectSubscriptionList.priceID#" class="plainlink">go</a>)</cfif><br>

					<table border="1" cellspacing="0" cellpadding="2">
					<tr class="TableHeader" valign="bottom">
						<th>Stage</th>
						<th>Interval</th>
						<th>Price</th>
						<cfif Variables.displayCustomPriceVolumeDiscount is True>
							<th>Volume Discount Options</th>
						</cfif>
					</tr>
					<cfloop Query="qry_selectPrice" StartRow="#Variables.priceRow#">
						<cfif qry_selectPrice.priceID is not Variables.subscriptionPriceID><cfbreak></cfif>
						<tr class="TableText" valign="top"<cfif qry_selectPrice.priceStageID is Variables.subscriptionPriceStageID and qry_selectPrice.priceHasMultipleStages is 1> bgcolor="66FF99"<cfelseif (qry_selectPrice.CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
						<cfif qry_selectPrice.priceHasMultipleStages is 0>
							<td colspan="2">(Price has only one stage.)</td>
						<cfelse>
							<td>
								###qry_selectPriceListForTarget.priceStageOrder#. <cfif qry_selectPrice.priceStageText is not "">#qry_selectPrice.priceStageText#</cfif>
								<cfif qry_selectPrice.priceStageID is Variables.subscriptionPriceStageID> <b>(Current Stage)</b></cfif>
							</td>
							<td>#fn_ReturnPriceInterval(qry_selectPrice.priceStageInterval, qry_selectPrice.priceStageIntervalType)#</td>
						</cfif>
						<td>#fn_DisplayPriceAmount(Variables.subscriptionPriceNormal, qry_selectPrice.priceStageAmount, qry_selectPrice.priceStageDollarOrPercent, qry_selectPrice.priceStageNewOrDeduction, qry_selectPrice.priceStageVolumeDiscount, qry_selectPrice.priceStageVolumeDollarOrQuantity, qry_selectPrice.priceStageVolumeStep)#</td>
						<cfset Variables.currentPriceStageID = qry_selectPrice.priceStageID>
						<cfif Variables.displayCustomPriceVolumeDiscount is True>
							<cfset Variables.volumeDiscountRowStart = ListFind(ValueList(qry_selectPriceVolumeDiscount.priceStageID), Variables.currentPriceStageID)>
						<cfelse>
							<cfset Variables.volumeDiscountRowStart = 0>
						</cfif>
						<cfif Variables.volumeDiscountRowStart is 0 and Variables.displayCustomPriceVolumeDiscount is True>
							<td>&nbsp;</td>
						<cfelseif Variables.volumeDiscountRowStart gt 0>
							<cfset Variables.volumeDollarOrQuantity = qry_selectPrice.priceStageVolumeDollarOrQuantity>
							<cfset Variables.volumeStep = qry_selectPrice.priceStageVolumeStep>
							<cfset Variables.dollarOrPercent = qry_selectPrice.priceStageDollarOrPercent>
							<cfset Variables.newOrDeduction = qry_selectPrice.priceStageNewOrDeduction>

							<cfif Variables.subscriptionProductID is not 0 and (Variables.dollarOrPercent is 1 or Variables.newOrDeduction is 1)>
								<cfset Variables.displayCustomPriceCalc = True>
							<cfelse>
								<cfset Variables.displayCustomPriceCalc = False>
							</cfif>
							<cfif Variables.subscriptionProductID is not 0 and Variables.volumeStep is 1 and Variables.dollarOrPercent is 0 and Variables.newOrDeduction is 0>
								<cfset Variables.displayIsTotalPrice = True>
							<cfelse>
								<cfset Variables.displayIsTotalPrice = False>
							</cfif>

							<td>
								<table border="1" cellspacing="2" cellpadding="2">
								<tr valign="bottom" class="TableHeader">
									<th>Min. <cfif Variables.volumeDollarOrQuantity is 0>Order ($)<cfelse>Qty (##)</cfif></th>
									<th><cfswitch expression="#Variables.dollarOrPercent#_#Variables.newOrDeduction#"><cfcase value="0_0">Custom Price ($)</cfcase><cfcase value="0_1">$ Discount</cfcase><cfcase value="1_0">% of Normal Price</cfcase><cfdefaultcase><!--- 1_1 --->% Discount</cfdefaultcase></cfswitch></th>
									<cfif Variables.displayCustomPriceCalc is True><th>Custom Price</th></cfif>
									<cfif Variables.displayIsTotalPrice is True><th>Total Price?</th></cfif>
								</tr>
								<cfloop Query="qry_selectPriceVolumeDiscount" StartRow="#Variables.volumeDiscountRowStart#">
									<cfif qry_selectPriceVolumeDiscount.priceStageID is not Variables.currentPriceStageID><cfbreak></cfif>
									<tr class="TableText" valign="top" align="center">
									<td><cfif Variables.volumeDollarOrQuantity is 0>$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum)#<cfelse>#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum)#</cfif></td>
									<td><cfif Variables.dollarOrPercent is 0>$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount)#<cfelse>#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount * 100)#%</cfif><br></td>
									<cfif Variables.displayCustomPriceCalc is True><td>#fn_DisplayVolumePriceCustom(Form.subscriptionPriceNormal, qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount, Variables.dollarOrPercent, Variables.newOrDeduction, 0, Variables.volumeDollarOrQuantity, Variables.volumeStep)#</td></cfif>
									<cfif Variables.displayIsTotalPrice is True><td align="center"><cfif qry_selectPriceVolumeDiscount.priceVolumeDiscountIsTotalPrice is 1>Yes<cfelse>-</cfif></td></cfif>
									</tr>
								</cfloop>
								</table>
							</td>
						</cfif>
						</tr>
					</cfloop>
					</table>
				</cfif>
			</td>
		</tr>
	</cfif>

	<cfif qry_selectSubscriptionList.subscriptionPriceNormal is not qry_selectSubscriptionList.subscriptionPriceUnit>
		<tr>
			<td>Normal Price: </td>
			<td>$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectSubscriptionList.subscriptionPriceNormal)#</td>
		</tr>
	</cfif>
	<tr>
		<td>Sub-Total: </td>
		<td>#DollarFormat(qry_selectSubscriptionList.subscriptionQuantity * qry_selectSubscriptionList.subscriptionPriceUnit)#</td>
	</tr>
	<cfif qry_selectSubscriptionList.subscriptionDiscount is not 0>
		<tr>
			<td>Discount: </td>
			<td>($#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectSubscriptionList.subscriptionDiscount)#)</td>
		</tr>
	</cfif>
	<tr>
		<td>Total: </td>
		<td>#DollarFormat((qry_selectSubscriptionList.subscriptionQuantity * qry_selectSubscriptionList.subscriptionPriceUnit) - qry_selectSubscriptionList.subscriptionDiscount)#</td>
	</tr>

	<tr>
		<td>## Times Applied: </td>
		<td>#qry_selectSubscriptionList.subscriptionAppliedCount#</td>
	</tr>
	<cfset Variables.intervalTypePosition = ListFind(Variables.subscriptionIntervalTypeList_value, qry_selectSubscriptionList.subscriptionIntervalType)>
	<tr>
		<td>Process Interval: </td>
		<td>#qry_selectSubscriptionList.subscriptionInterval# <cfif Variables.intervalTypePosition is 0>#qry_selectSubscriptionList.subscriptionIntervalType#<cfelse>#ListGetAt(Variables.subscriptionIntervalTypeList_label, Variables.intervalTypePosition)#</cfif><cfif qry_selectSubscriptionList.subscriptionInterval gt 1>s</cfif></td>
	</tr>
	<tr>
		<td>Pro-Rate: </td>
		<td>
			<cfif qry_selectSubscriptionList.subscriptionProRate is 1>
				Yes, pro-rate subscription for partial billing periods, i.e., charge partial subscription amount based on number of days used.<br>
			<cfelse>
				No, charge full subscription for all billing periods, even partial billing periods.<br>
			</cfif>
		</td>
	</tr>	
	<tr>
		<td>Begin/End Dates: </td>
		<td>
			#DateFormat(qry_selectSubscriptionList.subscriptionDateBegin, "dddd, mmmm dd yyyy")# thru 
			<cfif Not IsDate(qry_selectSubscriptionList.subscriptionDateEnd)>(<i>no end date</i>)<cfelse>#DateFormat(qry_selectSubscriptionList.subscriptionDateEnd, "dddd, mmmm dd yyyy")#</cfif>
		</td>
	</tr>
	<tr>
		<td>End Method: </td>
		<td>
			<cfif qry_selectSubscriptionList.subscriptionEndByDateOrAppliedMaximum is "">
				Continues Indefinitely.
			<cfelseif qry_selectSubscriptionList.subscriptionEndByDateOrAppliedMaximum is 1>
				#qry_selectSubscriptionList.subscriptionAppliedMaximum# time(s).
			<cfelse>
				End date.
			</cfif>
			<cfif ListFind("0,1", qry_selectSubscriptionList.subscriptionEndByDateOrAppliedMaximum) and qry_selectSubscriptionList.subscriptionContinuesAfterEnd is 1>
				 Continues until cancelled.
			</cfif>
		</td>
	</tr>
	<cfif qry_selectSubscriptionList.subscriptionDescription is not "">
		<tr valign="top">
			<td>Description: </td>
			<td><p class="TableText" style="width: 800"><cfif qry_selectSubscriptionList.subscriptionDescriptionHtml is 0>#HTMLEditFormat(qry_selectSubscriptionList.subscriptionDescription)#<cfelse>#qry_selectSubscriptionList.subscriptionDescription#</cfif></p></td>
		</tr>
	</cfif>
	</table>
	</p>
</cfloop>
</cfoutput>
