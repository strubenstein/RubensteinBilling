<cfoutput>
<cfif URL.productID is not 0>
	<p class="MainText">
	#qry_selectProduct.productName# 
	<cfif Application.fn_IsUserAuthorized("viewProduct")>
		(<a href="index.cfm?method=product.viewProduct&productID=#URL.productID#" class="plainlink">go</a>)
	</cfif>
	</p>
</cfif>

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>Status: </td>
	<td><cfif qry_selectInvoiceLineItem.invoiceLineItemStatus is 1><font color="green">Active</font><cfelse><font color="red">Inctive - Not included in invoice</font></cfif></td>
</tr>
<cfif qry_selectInvoiceLineItem.invoiceLineItemStatus is 1>
	<tr>
		<td>Line Item Order: </td>
		<td>#qry_selectInvoiceLineItem.invoiceLineItemOrder#</td>
	</tr>
</cfif>
<tr>
	<td>Manual: </td>
	<td>
		<cfif qry_selectInvoiceLineItem.invoiceLineItemManual is 1>
			Item was added to invoice manually (or was updated manually).
		<cfelse>
			Item was added to invoice automatically via subscription.
		</cfif>
	</td>
</tr>
<tr>
	<td>Date Added: </td>
	<td>#DateFormat(qry_selectInvoiceLineItem.invoiceLineItemDateCreated, "dddd, mmmm dd, yyyy")# at #TimeFormat(qry_selectInvoiceLineItem.invoiceLineItemDateCreated, "hh:mm tt")#</td>
</tr>
<cfif qry_selectInvoiceLineItem.userID_author is not 0>
	<tr>
		<td>Added By: </td>
		<td>
			#qry_selectInvoiceLineItemList.authorFirstName# #qry_selectInvoiceLineItemList.authorLastName#
			<cfif ListFind(Variables.permissionActionList, "viewUser")>
				 (<a href="index.cfm?method=user.viewUser&userID=#qry_selectInvoiceLineItem.userID_author#" class="plainlink">go</a>)
			</cfif>
		</td>
	</tr>
</cfif>
<cfif qry_selectInvoiceLineItem.userID_cancel is not 0>
	<tr>
		<td>Cancelled By: </td>
		<td>#qry_selectInvoiceLineItemList.cancelFirstName# #qry_selectInvoiceLineItemList.cancelLastName#</td>
	</tr>
</cfif>
<cfif qry_selectInvoiceLineItem.invoiceLineItemStatus is 0>
	<tr>
		<td>Date Cancelled: </td>
		<td>#DateFormat(qry_selectInvoiceLineItem.invoiceLineItemDateUpdated, "dddd, mmmm dd, yyyy")# at #TimeFormat(qry_selectInvoiceLineItem.invoiceLineItemDateUpdated, "hh:mm tt")#</td>
	</tr>
</cfif>

<tr valign="top">
	<td>Contact User(s): </td>
	<td>
		<cfif qry_selectInvoiceLineItemUser.RecordCount is 0>
			(no specified contact user)
		<cfelse>
			<cfloop Query="qry_selectInvoiceLineItemUser">
				#qry_selectInvoiceLineItemUser.lastName#, #qry_selectInvoiceLineItemUser.firstName#
				<cfif ListFind(Variables.permissionActionList, "viewUser")> (<a href="index.cfm?method=user.viewUser&userID=#qry_selectInvoiceLineItemUser.userID#" class="plainlink">go</a>)</cfif><br>
			</cfloop>
		</cfif>
	</td>
</tr>
<tr valign="top">
	<td>Item Name: </td>
	<td>#qry_selectInvoiceLineItem.invoiceLineItemName#</td>
</tr>
<tr valign="top">
	<td>Item Description: </td>
	<td>
		<cfif qry_selectInvoiceLineItem.invoiceLineItemDescriptionHtml is 0>
			#Replace(qry_selectInvoiceLineItem.invoiceLineItemDescription, Chr(10), "<br>", "ALL")#
		<cfelse>
			#qry_selectInvoiceLineItem.invoiceLineItemDescription#
		</cfif>
	</td>
</tr>
<cfif URL.productID is not 0 and qry_selectProductCategory.RecordCount gt 1>
	<cfset Variables.categoryRow = ListFind(ValueList(qry_selectProductCategory.categoryID), qry_selectInvoiceLineItem.categoryID)>
	<cfif Variables.categoryRow is not 0>
		<tr>
			<td>Product Category: </td>
			<td>#qry_selectProductCategory.categoryTitle[Variables.categoryRow]#</td>
		</tr>
	</cfif>
</cfif>

<tr>
	<td>Custom Product ID: </td>
	<td>#qry_selectInvoiceLineItem.invoiceLineItemProductID_custom#</td>
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
							<cfloop Query="qry_selectProductParameterOptionList" StartRow="#Variables.parameterRow#">
								<cfif qry_selectProductParameterOptionList.productParameterID is not Variables.thisParameterID><cfbreak></cfif>
								<cfif ListFind(ValueList(qry_selectInvoiceLineItemParameterList.productParameterOptionID), qry_selectProductParameterOptionList.productParameterOptionID)>
									#qry_selectProductParameterOptionList.productParameterOptionLabel#
									<cfbreak>
								</cfif>
							</cfloop>
						</td>
					</tr>
				</cfif>
			</cfloop>
			</table>

			<cfif qry_selectInvoiceLineItem.productParameterExceptionID is not 0>
				<cfset Variables.exceptionRow = ListFind(ValueList(qry_selectProductParameterExceptionList.productParameterExceptionID), qry_selectInvoiceLineItem.productParameterExceptionID)>
				<cfif Variables.exceptionRow is not 0>
					<br>Exception: #qry_selectProductParameterExceptionList.productParameterExceptionText[Variables.exceptionRow]#
				</cfif>
			</cfif>
		</td>
	</tr>
</cfif>

<tr><td colspan="2">Optional date ranges for which this line item applies:</td></tr>
<tr>
	<td align="right">Begin Date:&nbsp;</td>
	<td><cfif Not IsDate(qry_selectInvoiceLIneItem.invoiceLineItemDateBegin)>n/a<cfelse>#DateFormat(qry_selectInvoiceLIneItem.invoiceLineItemDateBegin, "dddd, mmmm dd, yyyy")#</cfif></td>
</tr>
<tr>
	<td align="right">End Date:&nbsp;</td>
	<td><cfif Not IsDate(qry_selectInvoiceLIneItem.invoiceLineItemDateEnd)>n/a<cfelse>#DateFormat(qry_selectInvoiceLIneItem.invoiceLineItemDateEnd, "dddd, mmmm dd, yyyy")#</cfif></td>
</tr>
<tr>
	<td>Quantity: </td>
	<td>#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectInvoiceLIneItem.invoiceLineItemQuantity)#</td>
</tr>
<!--- normal price --->
<tr>
	<td>Normal Unit Price: </td>
	<td>$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectInvoiceLIneItem.invoiceLineItemPriceNormal)#</td>
</tr>

<!--- customer price --->
<tr valign="top">
	<td>Actual Unit Price: </td>
	<td>$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectInvoiceLIneItem.invoiceLineItemPriceUnit)#<cfif qry_selectInvoiceLineItem.priceID is not 0> (<i>custom price</i>)</cfif><br>
		<cfif qry_selectInvoiceLineItem.priceID is not 0>
			<cfif qry_selectInvoiceLineItemList.priceStageText is not "">
				Price: #qry_selectInvoiceLineItemList.priceStageText#
				<cfif qry_selectInvoiceLineItemList.priceStageDescription is not "">
					<div class="SmallText">#qry_selectInvoiceLineItemList.priceStageDescription#</div>
				</cfif>
			</cfif>

			<cfset Variables.priceRow = ListFind(ValueList(qry_selectPriceListForTarget.priceID), qry_selectInvoiceLineItem.priceID)>
			<cfif Variables.priceRow is not 0>
				<table border="1" cellspacing="0" cellpadding="2">
				<tr class="TableHeader" valign="bottom">
					<cfif Variables.displayPriceCode is True>
						<th>Code</th>
					</cfif>
					<cfif Variables.displayPriceName is True>
						<th>Name</th>
					</cfif>
					<th>Price</th>
					<th>Min Per<br>Order</th>
					<th>Max Per<br>Customer</th>
					<th>Max All<br>Customers</th>
					<th>Date<br>Begins</th>
					<th>Date<br>Ends</th>
				</tr>

				<cfloop Query="qry_selectPriceListForTarget" StartRow="#Variables.priceRow#" EndRow="#Variables.priceRow#">
					<cfset Variables.currentPriceStageID = qry_selectPriceListForTarget.priceStageID>
					<cfif Variables.displayCustomPriceVolumeDiscount is True>
						<cfset Variables.volumeDiscountRowStart = ListFind(ValueList(qry_selectPriceVolumeDiscount.priceStageID), Variables.currentPriceStageID)>
					<cfelse>
						<cfset Variables.volumeDiscountRowStart = 0>
					</cfif>

					<tr valign="top" class="TableText"<cfif (CurrentRow mod 2) is 1> bgcolor="f4f4ff"</cfif>>
						<cfif Variables.displayPriceCode is True>
							<td><cfif qry_selectPriceListForTarget.priceCode is "">&nbsp;<cfelse>#qry_selectPriceListForTarget.priceCode#</cfif></td>
						</cfif>
						<cfif Variables.displayPriceName is True>
							<td><cfif qry_selectPriceListForTarget.priceName is "">&nbsp;<cfelse>#qry_selectPriceListForTarget.priceName#</cfif></td>
						</cfif>
						<td>#fn_DisplayPriceAmount(qry_selectInvoiceLineItem.invoiceLineItemPriceNormal, qry_selectPriceListForTarget.priceStageAmount, qry_selectPriceListForTarget.priceStageDollarOrPercent, qry_selectPriceListForTarget.priceStageNewOrDeduction, qry_selectPriceListForTarget.priceStageVolumeDiscount, qry_selectPriceListForTarget.priceStageVolumeDollarOrQuantity, qry_selectPriceListForTarget.priceStageVolumeStep)#</td>
						<td align="center"><cfif qry_selectPriceListForTarget.priceQuantityMinimumPerOrder is 0>n/a<cfelse>#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPriceListForTarget.priceQuantityMinimumPerOrder)#</cfif></td>
						<td align="center">
							<cfif qry_selectPriceListForTarget.priceQuantityMaximumPerCustomer is 0>
								n/a
							<cfelse>
								#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPriceListForTarget.priceQuantityMaximumPerCustomer)#
								<div class="SmallText">(
								<cfif Not StructKeyExists(Variables.quantityMaximumPerCustomer, "price#qry_selectPriceListForTarget.priceID#")>
									#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPriceListForTarget.priceQuantityMaximumAllCustomers)#
								<cfelse>
									#Application.fn_LimitPaddedDecimalZerosQuantity(Variables.quantityMaximumPerCustomer["price#qry_selectPriceListForTarget.priceID#"])#
								</cfif>
								 Available)</div>
							</cfif>
						</td>
						<td align="center">
							<cfif qry_selectPriceListForTarget.priceQuantityMaximumAllCustomers is 0>
								n/a
							<cfelse>
								#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPriceListForTarget.priceQuantityMaximumAllCustomers)#
								<div class="SmallText">(
								<cfif Not StructKeyExists(Variables.quantityMaximumAllCustomers, "price#qry_selectPriceListForTarget.priceID#")>
									#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPriceListForTarget.priceQuantityMaximumAllCustomers)#
								<cfelse>
									#Application.fn_LimitPaddedDecimalZerosQuantity(Variables.quantityMaximumAllCustomers["price#qry_selectPriceListForTarget.priceID#"])#
								</cfif>
								 Available)</div>
							</cfif>
						</td>
						<td align="center">#DateFormat(qry_selectPriceListForTarget.priceDateBegin, "mm-dd-yy")#<div class="SmallText">#TimeFormat(qry_selectPriceListForTarget.priceDateBegin, "hh:mm tt")#</div></td>
						<td align="center"><cfif Not IsDate(qry_selectPriceListForTarget.priceDateEnd)>-<cfelse>#DateFormat(qry_selectPriceListForTarget.priceDateEnd, "mm-dd-yy")#<div class="SmallText">#TimeFormat(qry_selectPriceListForTarget.priceDateEnd, "hh:mm tt")#</div></cfif></td>
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

							<td colspan="7">
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
										<td>#fn_DisplayVolumePriceCustom(qry_selectInvoiceLineItem.invoiceLineItemPriceNormal, qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount, Variables.dollarOrPercent, Variables.newOrDeduction, 0, Variables.volumeDollarOrQuantity, Variables.volumeStep)#</td>
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
		</cfif>
	</td>
</tr>

<tr>
	<td>Custom Discount: </td>
	<td>$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectInvoiceLIneItem.invoiceLineItemDiscount)#</td>
</tr>
<tr>
	<td>Total Taxes: </td>
	<td>$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectInvoiceLIneItem.invoiceLineItemTotalTax)#</td>
</tr>
</table>
<br>

<!--- Custom status and custom fields --->
<cfinvoke component="#Application.billingMapping#control.c_status.ViewStatusHistory" method="viewStatusHistory" returnVariable="isStatusHistoryViewed">
	<cfinvokeargument name="primaryTargetKey" value="invoiceLineItemID">
	<cfinvokeargument name="targetID" value="#URL.invoiceLineItemID#">
</cfinvoke>

<cfinvoke component="#Application.billingMapping#control.c_customField.ViewCustomFieldValue" method="viewCustomFieldValues" returnVariable="isCustomFieldValuesViewed">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="invoiceLineItemID">
	<cfinvokeargument name="targetID" value="#URL.invoiceLineItemID#">
</cfinvoke>
</cfoutput>
