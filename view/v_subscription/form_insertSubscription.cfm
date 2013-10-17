<!--- 
regionID,taxID 

display why each price is applicable?
PARAMETERS
	store as text in name?
	<cfif qry_selectProductsInCart.productParameters[count] is "">
		<cfset Variables.invoiceLineItemName = qry_selectProductsInCart.productLanguageLineItemName[count]>
	<cfelse>
		<cfset Variables.invoiceLineItemName = qry_selectProductsInCart.productLanguageLineItemName[count] & "<br>" & qry_selectProductsInCart.productParameters[count]>
	</cfif>
--->

<cfoutput>
<script language="Javascript" src="#Application.billingUrlroot#/js/popcalendar.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_layers.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_menu.js"></script>

<form method="post" name="#Variables.formName#" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<cfif URL.productID is not 0>
	<p class="MainText">
	<b>#qry_selectProduct.productName#</b> 
	<cfif Application.fn_IsUserAuthorized("viewProduct")>
		(<a href="index.cfm?method=product.viewProduct&productID=#URL.productID#" class="plainlink">go</a>)
	</cfif>
	</p>
</cfif>

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<!--- 
<tr>
	<td>Status: </td>
	<td>
		<label><input type="radio" name="subscriptionStatus" value="1"<cfif Form.subscriptionStatus is 1> checked</cfif>>Active</label> &nbsp; &nbsp; 
		<label><input type="radio" name="subscriptionStatus" value="0"<cfif Form.subscriptionStatus is not 1> checked</cfif>>Not included for subscriber</label>
	</td>
</tr>
--->
<tr valign="top">
	<td>Subscription Roll Up: </td>
	<td>
		<select name="subscriptionID_rollup" size="1">
		<option value="0">-- NOT A ROLLUP --</option>
		<cfloop Query="qry_selectSubscriptionList">
			<cfif qry_selectSubscriptionList.subscriptionID_rollup is 0 and IsDate(qry_selectSubscriptionList.subscriptionDateProcessNext)>
				<option value="#qry_selectSubscriptionList.subscriptionID#"<cfif Form.subscriptionID_rollup is qry_selectSubscriptionList.subscriptionID> selected</cfif>><cfif qry_selectSubscriptionList.subscriptionIsRollup is 1>* </cfif>#qry_selectSubscriptionList.subscriptionOrder#. #HTMLEditFormat(Left(qry_selectSubscriptionList.subscriptionName, 50))#<cfif Len(qry_selectSubscriptionList.subscriptionName) gt 50> ...</cfif> (Next: #DateFormat(qry_selectSubscriptionList.subscriptionDateProcessNext, "mm/dd/yy")#)</option>
			</cfif>
		</cfloop>
		</select> (<a href="##rollup" class="plainlink">see note at bottom</a>)
	</td>
</tr>
<cfif Variables.doAction is "insertSubscription">
	<tr>
		<td>Subscription Order: </td>
		<td>
			<select name="subscriptionOrder" size="1">
			<cfloop Query="qry_selectSubscriptionList">
				<option value="#qry_selectSubscriptionList.subscriptionOrder#"<cfif Form.subscriptionOrder is qry_selectSubscriptionList.subscriptionOrder> selected</cfif>>#qry_selectSubscriptionList.subscriptionOrder#. #HTMLEditFormat(Left(qry_selectSubscriptionList.subscriptionName, 50))#<cfif Len(qry_selectSubscriptionList.subscriptionName) gt 50> ...</cfif></option>
			</cfloop>
			<option value="0"<cfif Form.subscriptionOrder is 0> selected</cfif>>-- LAST --</option>
			</select>
		</td>
	</tr>
</cfif>
<tr>
	<td>Custom Subscription ID: </td>
	<td><input type="text" name="subscriptionID_custom" value="#HTMLEditFormat(Form.subscriptionID_custom)#" size="20" maxlength="#maxlength_Subscription.subscriptionID_custom#"></td>
</tr>
<tr valign="top">
	<td>Optional Contact(s): </td>
	<td>
		<select name="userID" size="#Min(5, IncrementValue(qry_selectUserCompanyList_company.RecordCount))#" multiple>
		<cfloop Query="qry_selectUserCompanyList_company">
			<option value="#qry_selectUserCompanyList_company.userID#"<cfif ListFind(Form.userID, qry_selectUserCompanyList_company.userID)> selected</cfif>>#HTMLEditFormat(qry_selectUserCompanyList_company.lastName)#, #HTMLEditFormat(qry_selectUserCompanyList_company.firstName)#</option>
		</cfloop>
		</select>
	</td>
</tr>
<tr valign="top">
	<td>Product Name: </td>
	<td>
		<textarea name="subscriptionName" rows="3" cols="60" wrap="off">#HTMLEditFormat(Form.subscriptionName)#</textarea><br>
		(maximum #maxlength_Subscription.subscriptionName# characters)
	</td>
</tr>
<tr valign="top">
	<td>Product Description: </td>
	<td>
		Select text or html format: 
		<select name="subscriptionDescriptionHtml" size="1">
		<option value="0"<cfif Form.subscriptionDescriptionHtml is 0> selected</cfif>>text</option>
		<option value="1"<cfif Form.subscriptionDescriptionHtml is 1> selected</cfif>>html</option>
		</select><br>
		<textarea name="subscriptionDescription" rows="3" cols="60" wrap="off">#HTMLEditFormat(Form.subscriptionDescription)#</textarea><br>
		(maximum #maxlength_Subscription.subscriptionDescription# characters)
	</td>
</tr>
<cfif URL.productID is not 0 and qry_selectProductCategory.RecordCount gt 1>
	<tr>
		<td>Category: </td>
		<td>
			<select name="categoryID" size="1">
			<option value="0">-- SELECT CATEGORY --</option>
			<cfloop Query="qry_selectProductCategory">
				<option value="#qry_selectProductCategory.categoryID#"<cfif Form.categoryID is qry_selectProductCategory.categoryID> selected</cfif>>#HTMLEditFormat(qry_selectProductCategory.categoryTitle)#</option>
			</cfloop>
			</select>
		</td>
	</tr>
</cfif>

<tr>
	<td>Custom Product ID: </td>
	<td>
		<input type="text" name="subscriptionProductID_custom" value="#HTMLEditFormat(Form.subscriptionProductID_custom)#" size="20" maxlength="#maxlength_Subscription.subscriptionProductID_custom#">
		<cfif Variables.displayProductParameter is True> (may be overwritten if parameters generate custom ID)</cfif>
	</td>
</tr>

<cfif Variables.displayProductParameter is True>
	<tr>
		<td valign="top">Product Parameters: </td>
		<td>
			<table border="0" cellspacing="2" cellpadding="2" class="TableText">
			<cfloop Query="qry_selectProductParameterList">
				<cfset Variables.thisParameterID = qry_selectProductParameterList.productParameterID>
				<cfset Variables.parameterRow = ListFind(ValueList(qry_selectProductParameterOptionList.productParameterID), Variables.thisParameterID)>
				<cfif Variables.parameterRow is not 0>
					<tr>
						<td>#qry_selectProductParameterList.productParameterText#: </td>
						<td>
							<select name="parameter#Variables.thisParameterID#" size="1" class="TableText">
							<cfloop Query="qry_selectProductParameterOptionList" StartRow="#Variables.parameterRow#">
								<cfif qry_selectProductParameterOptionList.productParameterID is not Variables.thisParameterID><cfbreak></cfif>
								<option value="#qry_selectProductParameterOptionList.productParameterOptionID#"<cfif Form["parameter#Variables.thisParameterID#"] is Variables.thisParameterID> selected</cfif>>#HTMLEditFormat(qry_selectProductParameterOptionList.productParameterOptionLabel)#</option>
							</cfloop>
							</select>
						</td>
					</tr>
				</cfif>
			</cfloop>
			</table>

			<cfif Variables.displayProductParameterException is True>
				<div class="TableText">
				<cfloop Query="qry_selectProductParameterExceptionList">#productParameterExceptionText#<br></cfloop>
				</div>
			</cfif>
		</td>
	</tr>
</cfif>

<tr>
	<td valign="top">Quantity: </td>
	<td>
		<input type="text" name="subscriptionQuantity" value="#Application.fn_LimitPaddedDecimalZerosQuantity(Form.subscriptionQuantity)#" size="10"> (max. #maxlength_Subscription.subscriptionQuantity# decimal places)<br>
		<label><input type="checkbox" name="subscriptionQuantityVaries" value="1"<cfif Form.subscriptionQuantityVaries is 1> checked</cfif>> 
		Check if quantity will vary with each billing period. If so, the quantity may be entered for each billing period.</label><br>
		&nbsp; &nbsp; &nbsp; If no quantity is specified for a billing period, the above quantity is used as the default value.<br>
		&nbsp; &nbsp; &nbsp; So if default quantity should be zero (0), be sure to enter 0 for the quantity above instead of 1.
	</td>
</tr>
<!--- normal price --->
<tr>
	<td>Normal Unit Price: </td>
	<td>
		<cfif URL.productID is 0><!--- if not a real product --->
			$<input type="text" name="subscriptionPriceNormal" value="#Application.fn_LimitPaddedDecimalZerosDollar(Form.subscriptionPriceNormal)#" size="10"> (max. #maxlength_Subscription.subscriptionPriceNormal# decimal places)
		<cfelse>
			$#Application.fn_LimitPaddedDecimalZerosDollar(Form.subscriptionPriceNormal)#
		</cfif>
	</td>
</tr>

<!--- customer price --->
<tr valign="top">
	<td>Actual Unit Price: </td>
	<td>
		<cfif URL.productID is 0 or Variables.displayCustomPrice is False><!--- if not a real product OR no custom price options --->
			$<input type="text" name="subscriptionPriceUnit" value="#Application.fn_LimitPaddedDecimalZerosDollar(Form.subscriptionPriceUnit)#" size="10"> (max. #maxlength_Subscription.subscriptionPriceUnit# decimal places)
		<cfelse>
			<table border="1" cellspacing="0" cellpadding="2">
			<tr class="TableHeader" valign="bottom">
				<th>Use<br>Price?</th>
				<!--- <cfif Variables.displayPriceCode is True><th>Price<br>Code</th></cfif> --->
				<cfif Variables.displayPriceCode is True or Variables.displayPriceName is True><th>Price Name</th></cfif>
				<th>Price</th>
				<!--- 
				<th>Min Per<br>Order</th>
				<th>Max Per<br>Customer</th>
				<th>Max All<br>Customers</th>
				--->
				<th>Date<br>Begins</th>
				<th>Date<br>Ends</th>
				<cfif Variables.displayCustomPriceVolumeDiscount is True><th>Volume Discount Options</th></cfif>
			</tr>
			<tr valign="top" class="TableText">
				<td align="center"><input type="radio" name="priceID" value="0"<cfif Form.priceID is 0> checked</cfif>></td>
				<td colspan="6">
					$<input type="text" name="subscriptionPriceUnit" value="#Application.fn_LimitPaddedDecimalZerosDollar(Form.subscriptionPriceUnit)#" size="10"> (max. #maxlength_Subscription.subscriptionPriceUnit# decimal places)<br>
					<i>Or select custom price option below:</i>
				</td>
			</tr>
			<cfset Variables.rowBG = 0>
			<cfloop Query="qry_selectPriceListForTarget">
				<cfset Variables.currentPriceStageID = qry_selectPriceListForTarget.priceStageID>
				<cfif Variables.displayCustomPriceVolumeDiscount is True>
					<cfset Variables.volumeDiscountRowStart = ListFind(ValueList(qry_selectPriceVolumeDiscount.priceStageID), Variables.currentPriceStageID)>
				<cfelse>
					<cfset Variables.volumeDiscountRowStart = 0>
				</cfif>

				<cfif CurrentRow is 1 or qry_selectPriceListForTarget.priceID is not qry_selectPriceListForTarget.priceID[CurrentRow - 1]>
					<cfset Variables.rowBG = Iif(Variables.rowBG is 1, 0, 1)>
				</cfif>
				<tr class="TableText" valign="top"<cfif Variables.rowBG is 1> bgcolor="f4f4ff"</cfif>>
				<cfif CurrentRow is 1 or qry_selectPriceListForTarget.priceID is not qry_selectPriceListForTarget.priceID[CurrentRow - 1]>
					<td align="center"><input type="radio" name="priceID" value="#qry_selectPriceListForTarget.priceID#"<cfif Form.priceID is qry_selectPriceListForTarget.priceID> checked</cfif>></td>
					<!--- <cfif Variables.displayPriceCode is True><td><cfif qry_selectPriceListForTarget.priceCode is "">&nbsp;<cfelse>#qry_selectPriceListForTarget.priceCode#</cfif></td></cfif> --->
					<cfif Variables.displayPriceCode is True or Variables.displayPriceName is True>
						<td><cfif qry_selectPriceListForTarget.priceCode is not "">#qry_selectPriceListForTarget.priceCode#. </cfif><cfif qry_selectPriceListForTarget.priceName is "">&nbsp;<cfelse>#qry_selectPriceListForTarget.priceName#</cfif></td>
					</cfif>
					<td>
						<cfif qry_selectPriceListForTarget.priceHasMultipleStages is 1><i>Stage ###qry_selectPriceListForTarget.priceStageOrder#</i> - #fn_ReturnPriceInterval(qry_selectPriceListForTarget.priceStageInterval, qry_selectPriceListForTarget.priceStageIntervalType)#<br></cfif>
						<cfif qry_selectPriceListForTarget.priceStageText is not "">#qry_selectPriceListForTarget.priceStageText#<br></cfif>
						#fn_DisplayPriceAmount(Form.subscriptionPriceNormal, qry_selectPriceListForTarget.priceStageAmount, qry_selectPriceListForTarget.priceStageDollarOrPercent, qry_selectPriceListForTarget.priceStageNewOrDeduction, qry_selectPriceListForTarget.priceStageVolumeDiscount, qry_selectPriceListForTarget.priceStageVolumeDollarOrQuantity, qry_selectPriceListForTarget.priceStageVolumeStep)#<br>

						<cfif qry_selectPriceListForTarget.priceQuantityMinimumPerOrder is not 0>
							Min. per order: #Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPriceListForTarget.priceQuantityMinimumPerOrder)#<br>
						</cfif>
						<cfif qry_selectPriceListForTarget.priceQuantityMaximumPerCustomer is not 0>
							Max. per customer: #Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPriceListForTarget.priceQuantityMaximumPerCustomer)#
							<div class="SmallText">(
							<cfif Not StructKeyExists(Variables.quantityMaximumPerCustomer, "price#qry_selectPriceListForTarget.priceID#")>
								#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPriceListForTarget.priceQuantityMaximumAllCustomers)#
							<cfelse>
								#Application.fn_LimitPaddedDecimalZerosQuantity(Variables.quantityMaximumPerCustomer["price#qry_selectPriceListForTarget.priceID#"])#
							</cfif>
							 Available)</div>
						</cfif>
						<cfif qry_selectPriceListForTarget.priceQuantityMaximumAllCustomers is not 0>
							Max. all customers: #Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPriceListForTarget.priceQuantityMaximumAllCustomers)#
							<div class="SmallText">(
							<cfif Not StructKeyExists(Variables.quantityMaximumAllCustomers, "price#qry_selectPriceListForTarget.priceID#")>
								#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPriceListForTarget.priceQuantityMaximumAllCustomers)#
							<cfelse>
								#Application.fn_LimitPaddedDecimalZerosQuantity(Variables.quantityMaximumAllCustomers["price#qry_selectPriceListForTarget.priceID#"])#
							</cfif>
							 Available)</div>
						</cfif>
					</td>
					<td align="center" nowrap>#DateFormat(qry_selectPriceListForTarget.priceDateBegin, "mm-dd-yy")#<div class="SmallText">#TimeFormat(qry_selectPriceListForTarget.priceDateBegin, "hh:mm tt")#</div></td>
					<td align="center" nowrap><cfif Not IsDate(qry_selectPriceListForTarget.priceDateEnd)>-<cfelse>#DateFormat(qry_selectPriceListForTarget.priceDateEnd, "mm-dd-yy")#<div class="SmallText">#TimeFormat(qry_selectPriceListForTarget.priceDateEnd, "hh:mm tt")#</div></cfif></td>
				<cfelse>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td colspan="3">
						<cfif qry_selectPriceListForTarget.priceHasMultipleStages is 1>3423 <i>Stage ###qry_selectPriceListForTarget.priceStageOrder#</i> - #fn_ReturnPriceInterval(qry_selectPriceListForTarget.priceStageInterval, qry_selectPriceListForTarget.priceStageIntervalType)#<br></cfif>
						#fn_DisplayPriceAmount(Form.subscriptionPriceNormal, qry_selectPriceListForTarget.priceStageAmount, qry_selectPriceListForTarget.priceStageDollarOrPercent, qry_selectPriceListForTarget.priceStageNewOrDeduction, qry_selectPriceListForTarget.priceStageVolumeDiscount, qry_selectPriceListForTarget.priceStageVolumeDollarOrQuantity, qry_selectPriceListForTarget.priceStageVolumeStep)#
					</td>
				</cfif>

				<cfif Variables.volumeDiscountRowStart is 0 and Variables.displayCustomPriceVolumeDiscount is True>
					<td>&nbsp;</td>
				<cfelseif Variables.volumeDiscountRowStart gt 0>
					<cfset Variables.volumeDollarOrQuantity = qry_selectPriceListForTarget.priceStageVolumeDollarOrQuantity>
					<cfset Variables.volumeStep = qry_selectPriceListForTarget.priceStageVolumeStep>
					<cfset Variables.dollarOrPercent = qry_selectPriceListForTarget.priceStageDollarOrPercent>
					<cfset Variables.newOrDeduction = qry_selectPriceListForTarget.priceStageNewOrDeduction>

					<cfif URL.productID is not 0 and (Variables.dollarOrPercent is 1 or Variables.newOrDeduction is 1)>
						<cfset Variables.displayCustomPriceCalc = True>
					<cfelse>
						<cfset Variables.displayCustomPriceCalc = False>
					</cfif>
					<cfif URL.productID is not 0 and Variables.volumeStep is 1 and Variables.dollarOrPercent is 0 and Variables.newOrDeduction is 0>
						<cfset Variables.displayIsTotalPrice = True>
					<cfelse>
						<cfset Variables.displayIsTotalPrice = False>
					</cfif>

					<td>
						<table border="1" cellspacing="2" cellpadding="2">
						<cfif qry_selectPriceListForTarget.priceHasMultipleStages is 1>
							<tr valign="bottom" class="TableHeader">
								<th colspan="4"><i>Stage ###qry_selectPriceListForTarget.priceStageOrder#</i> - #fn_ReturnPriceInterval(qry_selectPriceListForTarget.priceStageInterval, qry_selectPriceListForTarget.priceStageIntervalType)#</th>
							</tr>
						</cfif>
						<tr valign="bottom" class="TableHeader">
							<th>Min. <cfif Variables.volumeDollarOrQuantity is 0>Order ($)<cfelse>Qty (##)</cfif></th>
							<th><cfswitch expression="#Variables.dollarOrPercent#_#Variables.newOrDeduction#"><cfcase value="0_0">Custom Price ($)</cfcase><cfcase value="0_1">$ Discount</cfcase><cfcase value="1_0">% of Normal Price</cfcase><cfdefaultcase><!--- 1_1 --->% Discount</cfdefaultcase></cfswitch></th>
							<cfif Variables.displayCustomPriceCalc is True><th>Custom Price</th></cfif>
							<cfif Variables.displayIsTotalPrice is True><th>Total Price?</th></cfif>
						</tr>
						<cfloop Query="qry_selectPriceVolumeDiscount" StartRow="#Variables.volumeDiscountRowStart#">
							<cfif qry_selectPriceVolumeDiscount.priceStageID is not Variables.currentPriceStageID><cfbreak></cfif>
							<tr class="TableText" valign="top" align="center">
							<td><cfif Variables.volumeDollarOrQuantity is 0>$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum)#<cfelseif qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum is -1>Max<cfelse>#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum)#</cfif></td>
							<td><cfif Variables.dollarOrPercent is 0>$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount)#<cfelse>#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount * 100)#%</cfif><br></td>
							<cfif Variables.displayCustomPriceCalc is True>
								<td>#fn_DisplayVolumePriceCustom(Form.subscriptionPriceNormal, qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount, Variables.dollarOrPercent, Variables.newOrDeduction, 0, Variables.volumeDollarOrQuantity, Variables.volumeStep)#</td>
							</cfif>
							<cfif Variables.displayIsTotalPrice is True>
								<td align="center"><cfif qry_selectPriceVolumeDiscount.priceVolumeDiscountIsTotalPrice is 1>Yes<cfelse>-</cfif></td>
							</cfif>
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

<tr>
	<td>Custom Discount: </td>
	<td>$<input type="text" name="subscriptionDiscount" value="#Application.fn_LimitPaddedDecimalZerosDollar(Form.subscriptionDiscount)#" size="10"> (applies to total, not unit price; enter a positive number; max. #maxlength_Subscription.subscriptionDiscount# decimal places)</td>
</tr>
<!--- 
<tr>
	<td>Total Taxes: </td>
	<td>$<input type="text" name="subscriptionTotalTax" value="#Application.fn_LimitPaddedDecimalZerosDollar(Form.subscriptionTotalTax)#" size="10"> (applies to total, not per unit; max. #maxlength_Subscription.subscriptionTotalTax# decimal places)</td>
</tr>
--->
<tr><td colspan="2"><b>Subscription Processing Dates:</b></td></tr>
<tr valign="top">
	<td>Subscription Begins: </td>
	<td>#fn_FormSelectDateTime(Variables.formName, "subscriptionDateBegin_date", Form.subscriptionDateBegin_date, "", 0, "", 0, "", "", True)#</td>
</tr>
<tr valign="top">
	<td valign="top">Subscription Ends: </td>
	<td>
		<input type="radio" name="subscriptionEndByDateOrAppliedMaximum" value=""<cfif Form.subscriptionEndByDateOrAppliedMaximum is ""> checked</cfif>>
		Continues indefinitely until cancelled manually<br>
		<input type="radio" name="subscriptionEndByDateOrAppliedMaximum" value="1"<cfif Form.subscriptionEndByDateOrAppliedMaximum is 1> checked</cfif>>
		Max. Times Applied: <input type="text" name="subscriptionAppliedMaximum" <cfif Form.subscriptionAppliedMaximum is not 0> value="#HTMLEditFormat(Form.subscriptionAppliedMaximum)#"</cfif> size="3">
		<cfif URL.subscriptionID is not 0 and IsDefined("qry_selectSubscription.subscriptionAppliedCount")> (already applied #qry_selectSubscription.subscriptionAppliedCount# times)</cfif><br>
		<input type="radio" name="subscriptionEndByDateOrAppliedMaximum" value="0"<cfif Form.subscriptionEndByDateOrAppliedMaximum is 0> checked</cfif>>
		Date: #fn_FormSelectDateTime(Variables.formName, "subscriptionDateEnd_date", Form.subscriptionDateEnd_date, "", 0, "", 0, "", "", True)# (enables partial subscription for last period)<br>
		(<i>If &quot;indefinitely&quot;, you may still enter max. times applies <b>or</b> end date to indicate <br>
		a minimum required length of the subscription for notification and reporting purposes.</i>)
	</td>
</tr>

<tr>
	<td>Processing Interval: </td>
	<td>
		Every <input type="text" name="subscriptionInterval" value="#HTMLEditFormat(Form.subscriptionInterval)#" size="2">
		<select name="subscriptionIntervalType" size="1">
		<cfloop Index="count" From="1" To="#ListLen(Variables.subscriptionIntervalTypeList_value)#">
			<option value="#ListGetAt(Variables.subscriptionIntervalTypeList_value, count)#"<cfif Form.subscriptionIntervalType is ListGetAt(Variables.subscriptionIntervalTypeList_value, count)> selected</cfif>>#HTMLEditFormat(ListGetAt(Variables.subscriptionIntervalTypeList_label, count))#</option>
		</cfloop>
		</select> (<i>if 0, subscription will not be processed automatically</i>)
	</td>
</tr>
<tr valign="top">
	<td><cfif Variables.doAction is "insertSubscription">First<cfelse>Next</cfif> Processing Date: </td>
	<td>#fn_FormSelectDateTime(Variables.formName, "subscriptionDateProcessNext_date", Form.subscriptionDateProcessNext_date, "", 0, "", 0, "", "", True)#</td>
</tr>
<tr valign="top">
	<td>First Billing Period: </td>
	<td>
		<input type="checkbox" name="subscriptionChargeBeforeService" value="1">
		If first bill is after service begins, does the first bill include a pro-rated amount for the time between<br>
		&nbsp; &nbsp; &nbsp; when service begins and the first bill PLUS the amount for the first full billing period?
	</td>
</tr>
<tr valign="top">
	<td>Pro Rate Partial<br>Billing Periods: </td>
	<td>
		<input type="radio" name="subscriptionProRate" value="1"<cfif Form.subscriptionProRate is 1> checked</cfif>>
		Yes, pro-rate subscription for partial billing periods, i.e., charge partial subscription amount based on number of days used.<br>
		<input type="radio" name="subscriptionProRate" value="0"<cfif Form.subscriptionProRate is not 1> checked</cfif>>
		No, charge full subscription for all billing periods, even partial billing periods.<br>
	</td>
</tr>
</table>

<!--- Insert custom fields and custom status forms if necessary --->
<cfif isStatusExist is True>
	<cfinvoke component="#objInsertStatusHistory#" method="form_insertStatusHistory" returnVariable="isStatusHistoryForm" />
</cfif>
<cfif isCustomFieldValueExist is True>
	<cfinvoke component="#objInsertCustomFieldValue#" method="form_insertCustomFieldValue" returnVariable="isCustomFieldValueForm" />
</cfif>

<p><input type="submit" name="submitSubscription" value="#HTMLEditFormat(Variables.formSubmitValue)#"></p>
</form>

<cfif Variables.displayPriceQuantityMaximumPerCustomer is True or Variables.displayPriceQuantityMaximumAllCustomers is True>
	<p class="MainText">If maximum quantity applies for the custom price you are selecting,<br>do not enter a quantity greater than the remaining number.</p>
</cfif>

<p class="TableText" style="width: 650">
<a name="rollup">Roll-up Subscriptions:</a><br>
Allows you to enter subscription quantity, but the quantity rolls up to the master subscription for calculating price. 
Useful for volume discounts for a group subscription, but still displaying usage individually.  
Subscriptions that roll up will be listed on the invoice, but with price of 0. 
Subscriptions that roll up must have same price, processing date and interval as master subscription.
When entering variable quantities for each billing period, the master subscription is automatically calculated via its rollup subscriptions. 
Subscriptions marked with a * already have subscriptions that roll up to them. 
</p>

</cfoutput>
