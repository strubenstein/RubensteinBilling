<!--- 
regionID,taxID 
invoiceLineItemSubTotal
invoiceLineItemTotal

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
		<label><input type="radio" name="invoiceLineItemStatus" value="1"<cfif Form.invoiceLineItemStatus is 1> checked</cfif>>Active</label> &nbsp; &nbsp; 
		<label><input type="radio" name="invoiceLineItemStatus" value="0"<cfif Form.invoiceLineItemStatus is not 1> checked</cfif>>Not included in invoice</label>
	</td>
</tr>
<tr>
	<td>Manual: </td>
	<td><label><input type="checkbox" name="invoiceLineItemManual" value="1"<cfif Form.invoiceLineItemManual is 1> checked</cfif>> Item was added to invoice manually (or was updated manually)</label></td>
</tr>
--->
<cfif Variables.doAction is "insertInvoiceLineItem">
	<tr>
		<td>Line Item Order: </td>
		<td>
			<select name="invoiceLineItemOrder" size="1">
			<cfloop Query="qry_selectInvoiceLineItemList">
				<option value="#qry_selectInvoiceLineItemList.invoiceLineItemOrder#"<cfif Form.invoiceLineItemOrder is qry_selectInvoiceLineItemList.invoiceLineItemOrder> selected</cfif>>#qry_selectInvoiceLineItemList.invoiceLineItemOrder#. #HTMLEditFormat(Left(qry_selectInvoiceLineItemList.invoiceLineItemName, 50))#<cfif Len(qry_selectInvoiceLineItemList.invoiceLineItemName) gt 50> ...</cfif></option>
			</cfloop>
			<option value="0"<cfif Form.invoiceLineItemOrder is 0> selected</cfif>>-- LAST --</option>
			</select>
		</td>
	</tr>
</cfif>

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
		<textarea name="invoiceLineItemName" rows="3" cols="60" wrap="off">#HTMLEditFormat(Form.invoiceLineItemName)#</textarea><br>
		(maximum #maxlength_InvoiceLineItem.invoiceLineItemName# characters)
	</td>
</tr>
<tr valign="top">
	<td>Product Description: </td>
	<td>
		Select text or html format: 
		<select name="invoiceLineItemDescriptionHtml" size="1">
		<option value="0"<cfif Form.invoiceLineItemDescriptionHtml is 0> selected</cfif>>text</option>
		<option value="1"<cfif Form.invoiceLineItemDescriptionHtml is 1> selected</cfif>>html</option>
		</select><br>
		<textarea name="invoiceLineItemDescription" rows="3" cols="60" wrap="off">#HTMLEditFormat(Form.invoiceLineItemDescription)#</textarea><br>
		(maximum #maxlength_InvoiceLineItem.invoiceLineItemDescription# characters)
	</td>
</tr>
<cfif URL.productID is not 0 and qry_selectProductCategory.RecordCount gt 1>
	<tr>
		<td>Product Category: </td>
		<td>
			<select name="categoryID" size="1">
			<option value="0">-- SELECT CATEGORY --</option>
			<cfloop Query="qry_selectProductCategory">
				<option value="#qry_selectProductCategory.categoryID#"<cfif Form.categoryID is qry_selectProductCategory.categoryID> selected</cfif>>#HTMLEditFormat(qry_selectProductCategory.categoryTitle)#</option>
			</cfloop>
			</select> <font class="SmallText"></font>(product is listed in multiple categories; for reporting purposes)</font>
		</td>
	</tr>
</cfif>

<tr>
	<td>Custom Product ID: </td>
	<td>
		<input type="text" name="invoiceLineItemProductID_custom" value="#HTMLEditFormat(Form.invoiceLineItemProductID_custom)#" size="20" maxlength="#maxlength_InvoiceLineItem.invoiceLineItemProductID_custom#">
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

<tr><td colspan="2">Optional date ranges for which this line item applies:</td></tr>
<tr>
	<td align="right">Begin Date:&nbsp;</td>
	<td>#fn_FormSelectDateTime(Variables.formName, "invoiceLineItemDateBegin_date", Form.invoiceLineItemDateBegin_date, "invoiceLineItemDateBegin_hh", Form.invoiceLineItemDateBegin_hh, "invoiceLineItemDateBegin_mm", Form.invoiceLineItemDateBegin_mm, "invoiceLineItemDateBegin_tt", Form.invoiceLineItemDateBegin_tt, True)#</td>
</tr>

<tr>
	<td align="right">End Date:&nbsp;</td>
	<td>#fn_FormSelectDateTime(Variables.formName, "invoiceLineItemDateEnd_date", Form.invoiceLineItemDateEnd_date, "invoiceLineItemDateEnd_hh", Form.invoiceLineItemDateEnd_hh, "invoiceLineItemDateEnd_mm", Form.invoiceLineItemDateEnd_mm, "invoiceLineItemDateEnd_tt", Form.invoiceLineItemDateEnd_tt, True)#</td>
</tr>

<tr>
	<td>Quantity: </td>
	<td><input type="text" name="invoiceLineItemQuantity" value="#Application.fn_LimitPaddedDecimalZerosQuantity(Form.invoiceLineItemQuantity)#" size="10"> (max. #maxlength_InvoiceLineItem.invoiceLineItemQuantity# decimal places)</td>
</tr>
<!--- normal price --->
<tr>
	<td>Normal Unit Price: </td>
	<td>
		<cfif URL.productID is 0><!--- if not a real product --->
			$<input type="text" name="invoiceLineItemPriceNormal" value="#Application.fn_LimitPaddedDecimalZerosDollar(Form.invoiceLineItemPriceNormal)#" size="10"> (max. #maxlength_InvoiceLineItem.invoiceLineItemPriceNormal# decimal places)
		<cfelse>
			$#Application.fn_LimitPaddedDecimalZerosDollar(Form.invoiceLineItemPriceNormal)#
			<input type="hidden" name="invoiceLineItemPriceNormal" value="#Application.fn_LimitPaddedDecimalZerosDollar(Form.invoiceLineItemPriceNormal)#">
		</cfif>
	</td>
</tr>

<!--- customer price --->
<tr valign="top">
	<td>Actual Unit Price: </td>
	<td>
		<cfif URL.productID is 0 or Variables.displayCustomPrice is False><!--- if not a real product OR no custom price options --->
			$<input type="text" name="invoiceLineItemPriceUnit" value="#Application.fn_LimitPaddedDecimalZerosDollar(Form.invoiceLineItemPriceUnit)#" size="10"> (max. #maxlength_InvoiceLineItem.invoiceLineItemPriceUnit# decimal places)
		<cfelse>
			<table border="1" cellspacing="0" cellpadding="2">
			<tr class="TableHeader" valign="bottom">
				<th>Use<br>Price?</th>
				<!--- <cfif Variables.displayPriceCode is True><th>Code</th></cfif> --->
				<cfif Variables.displayPriceCode is True or Variables.displayPriceName is True><th>Name</th></cfif>
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
				<td colspan="5">
					$<input type="text" name="invoiceLineItemPriceUnit" value="#Application.fn_LimitPaddedDecimalZerosDollar(Form.invoiceLineItemPriceUnit)#" size="10"> (max. #maxlength_InvoiceLineItem.invoiceLineItemPriceUnit# decimal places)<br>
					<i>Or select custom price option below:</i>
				</td>
			</tr>
			<cfloop Query="qry_selectPriceListForTarget">
				<cfset Variables.currentPriceStageID = qry_selectPriceListForTarget.priceStageID>
				<cfif Variables.displayCustomPriceVolumeDiscount is True>
					<cfset Variables.volumeDiscountRowStart = ListFind(ValueList(qry_selectPriceVolumeDiscount.priceStageID), Variables.currentPriceStageID)>
				<cfelse>
					<cfset Variables.volumeDiscountRowStart = 0>
				</cfif>

				<tr valign="top" class="TableText"<cfif (CurrentRow mod 2) is 1> bgcolor="f4f4ff"</cfif>>
					<td align="center"><input type="radio" name="priceID" value="#qry_selectPriceListForTarget.priceID#"<cfif Form.priceID is qry_selectPriceListForTarget.priceID> checked</cfif>></td>
					<!--- <cfif Variables.displayPriceCode is True><td><cfif qry_selectPriceListForTarget.priceCode is "">&nbsp;<cfelse>#qry_selectPriceListForTarget.priceCode#</cfif></td></cfif> --->
					<cfif Variables.displayPriceName is True>
						<td><cfif qry_selectPriceListForTarget.priceCode is not "">#qry_selectPriceListForTarget.priceCode#. </cfif><cfif qry_selectPriceListForTarget.priceName is "">&nbsp;<cfelse>#qry_selectPriceListForTarget.priceName#</cfif></td>
					</cfif>
					<td>
						#fn_DisplayPriceAmount(Form.invoiceLineItemPriceNormal, qry_selectPriceListForTarget.priceStageAmount, qry_selectPriceListForTarget.priceStageDollarOrPercent, qry_selectPriceListForTarget.priceStageNewOrDeduction, qry_selectPriceListForTarget.priceStageVolumeDiscount, qry_selectPriceListForTarget.priceStageVolumeDollarOrQuantity, qry_selectPriceListForTarget.priceStageVolumeStep)#
						<cfif qry_selectPriceListForTarget.priceQuantityMinimumPerOrder is 0>
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
					<cfif Variables.volumeDiscountRowStart gt 0>
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
								<cfif Variables.displayCustomPriceCalc is True>
									<td>#fn_DisplayVolumePriceCustom(Form.invoiceLineItemPriceNormal, qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount, Variables.dollarOrPercent, Variables.newOrDeduction, 0, Variables.volumeDollarOrQuantity, Variables.volumeStep)#</td>
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
	<td>$<input type="text" name="invoiceLineItemDiscount" value="#Application.fn_LimitPaddedDecimalZerosDollar(Form.invoiceLineItemDiscount)#" size="10"> (applies to total, not unit price; enter a positive number; max. #maxlength_InvoiceLineItem.invoiceLineItemDiscount# decimal places)</td>
</tr>
<tr>
	<td>Total Taxes: </td>
	<td>$<input type="text" name="invoiceLineItemTotalTax" value="#Application.fn_LimitPaddedDecimalZerosDollar(Form.invoiceLineItemTotalTax)#" size="10"> (applies to total, not per unit; max. #maxlength_InvoiceLineItem.invoiceLineItemTotalTax# decimal places)</td>
</tr>
</table>

<!--- Insert custom fields and custom status forms if necessary --->
<cfif isStatusExist is True>
	<cfinvoke component="#objInsertStatusHistory#" method="form_insertStatusHistory" returnVariable="isStatusHistoryForm" />
</cfif>
<cfif isCustomFieldValueExist is True>
	<cfinvoke component="#objInsertCustomFieldValue#" method="form_insertCustomFieldValue" returnVariable="isCustomFieldValueForm" />
</cfif>

<p><input type="submit" name="submitInvoiceLineItem" value="#HTMLEditFormat(Variables.formSubmitValue)#"></p>

</form>

<cfif Variables.displayPriceQuantityMaximumPerCustomer is True or Variables.displayPriceQuantityMaximumAllCustomers is True>
	<p class="MainText">If maximum quantity applies for the custom price you are selecting,<br>do not enter a quantity greater than the remaining number.</p>
</cfif>
</cfoutput>
