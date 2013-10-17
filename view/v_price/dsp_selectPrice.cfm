<cfoutput>
<cfif qry_selectPrice.productID is not 0 and IsDefined("qry_selectProduct.productPrice")>
	<cfset Variables.productPrice = qry_selectProduct.productPrice>
	<p class="MainText"><b>Normal Price: $#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectProduct.productPrice)#</b></p>
<cfelse>
	<cfset Variables.productPrice = 0>
</cfif>

<table border="0" cellspacing="0" cellpadding="2" class="MainText">
<tr>
	<td>Status: </td>
	<td><cfif qry_selectPrice.priceStatus[1] is 1>Active<cfelse>Inactive</cfif></td>
</tr>
<tr>
	<td>Internal Name: </td>
	<td>#qry_selectPrice.priceName[1]#</td>
</tr>
<tr>
	<td>Custom ID: </td>
	<td>#qry_selectPrice.priceID_custom[1]#</td>
</tr>
<tr>
	<td>Description: </td>
	<td>#qry_selectPrice.priceDescription[1]#</td>
</tr>
</table>
<br>

<table border="0" cellspacing="0" cellpadding="2" class="MainText">
<tr><td colspan="2"><b>Price Applies To:</b></td></tr>
<tr>
	<td>All Customers? </td>
	<td><cfif qry_selectPrice.priceAppliesToAllCustomers[1] is 1>Yes - Price applies to all customers.<cfelse>No - Price applies only to selected customers.</cfif></td>
</tr>

<cfif qry_selectPrice.productID is not 0>
	<tr>
		<td>Child Products? </td>
		<td><cfif qry_selectPrice.priceAppliesToProductChildren[1] is 1>Yes - Price applies to all child products of this product.<cfelse>No - Price does not apply to child products of this product.</cfif></td>
	</tr>
<cfelseif qry_selectPrice.categoryID is not 0>
	<tr>
		<td>Sub Categories? </td>
		<td><cfif qry_selectPrice.priceAppliesToCategoryChildren[1] is 1>Yes - Price applies to all products in all sub-categories of this category.<cfelse>No - Price does not apply to products in all sub-categories of this category.</cfif></td>
	</tr>
</cfif>

<tr>
	<td valign="top">Special Code: </td>
	<td>#qry_selectPrice.priceCode[1]# <cfif qry_selectPrice.priceCode[1] is 1> - Customer must enter special code to receive price.</cfif></td>
</tr>
</table>
<br>

<cfif qry_selectPrice.productID is not 0>
	<table border="0" cellspacing="2" cellpadding="2" class="MainText">
	<tr><td colspan="2"><b>Quantity Requirements:</b></td></tr>
	<tr>
		<td>Minimum Per Order: </td>
		<td class="TableText"><cfif Not IsNumeric(qry_selectPrice.priceQuantityMinimumPerOrder[1])>n/a<cfelse>#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPrice.priceQuantityMinimumPerOrder[1])#</cfif> (minimum ## required to receive price)</td>
	</tr>
	<tr>
		<td>Maximum Per Customer: </td>
		<td class="TableText"><cfif Not IsNumeric(qry_selectPrice.priceQuantityMaximumAllCustomers[1])>n/a<cfelse>#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPrice.priceQuantityMaximumAllCustomers[1])#</cfif> (maximum ## each customer may purchase at this price among all purchases)</td>
	</tr>
	<tr>
		<td>Maximum Total: </td>
		<td class="TableText"><cfif Not IsNumeric(qry_selectPrice.priceQuantityMaximumPerCustomer[1])>n/a<cfelse>#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPrice.priceQuantityMaximumPerCustomer[1])#</cfif> (maximum ## available for all customers to purchase at this price)</td>
	</tr>
	</table>
	<br>
</cfif>

<p>
<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr><td colspan="2"><b>Date Range During Which Price Applies:</b></td></tr>
<tr>
	<td valign="top">Begin Date: </td>
	<td><cfif Not IsDate(qry_selectPrice.priceDateBegin[1])>n/a<cfelse>#DateFormat(qry_selectPrice.priceDateBegin[1], "mmmm dd, yyyy")# at #TimeFormat(qry_selectPrice.priceDateBegin[1], "hh:mm tt")#</cfif></td>
</tr>
<tr>
	<td valign="top">End Date: </td>
	<td><cfif Not IsDate(qry_selectPrice.priceDateEnd[1])>n/a<cfelse>#DateFormat(qry_selectPrice.priceDateEnd[1], "mmmm dd, yyyy")# at #TimeFormat(qry_selectPrice.priceDateEnd[1], "hh:mm tt")#</cfif></td>
</tr>
</table>
</p>

<cfloop Query="qry_selectPrice">
	<cfif qry_selectPrice.RecordCount is not 1><br></cfif>
	<table border="1" cellspacing="0" cellpadding="2" class="TableText">
	<tr valign="top"<cfif (qry_selectPrice.CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td>
			<cfif qry_selectPrice.RecordCount is 1>
				<b>Price has only one stage.</b>
			<cfelseif qry_selectPrice.CurrentRow is qry_selectPrice.RecordCount>
				<b>Price Stage ###qry_selectPrice.priceStageOrder#:</b> (this is the last price stage)
			<cfelse>
				<b>Price Stage ###qry_selectPrice.priceStageOrder#:</b> 
				#qry_selectPrice.priceStageInterval# 
				<cfset Variables.stagePos = ListFind(Variables.priceStageIntervalTypeList_value, qry_selectPrice.priceStageIntervalType)>
				<cfif Variables.stagePos is 0>
					?
				<cfelse>
					#ListGetAt(Variables.priceStageIntervalTypeList_label, Variables.stagePos)#<cfif qry_selectPrice.priceStageInterval gt 1>s</cfif>
				</cfif>
			</cfif>
		</td>
	</tr>
	<tr valign="top"<cfif (qry_selectPrice.priceStageOrder mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td>
			Internal Description of This Stage: #qry_selectPrice.priceStageDescription#<br>
			Text Added to Invoice Line Item: &nbsp; &nbsp; #qry_selectPrice.priceStageText#<br>
		</td>
	</tr>
	<tr valign="top"<cfif (qry_selectPrice.priceStageOrder mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td><b>Price Stated As:</b> #fn_DisplayPriceAmount(Variables.productPrice, qry_selectPrice.priceStageAmount, qry_selectPrice.priceStageDollarOrPercent, qry_selectPrice.priceStageNewOrDeduction, qry_selectPrice.priceStageVolumeDiscount, qry_selectPrice.priceStageVolumeDollarOrQuantity, qry_selectPrice.priceStageVolumeStep)#</td>
	</tr>
	<cfif qry_selectPrice.priceStageVolumeDiscount is 1>
		<tr>
			<td>
				Use volume discount options instead<br>
				<table border="0" cellspacing="0" cellpadding="0" class="TableText">
				<tr>
					<td>
						<b>Volume Discount Options:</b><br>
						<i>Price Levels:</i><br>
						<cfif qry_selectPrice.priceStageVolumeDollarOrQuantity is 1>
							Based on the <i>quantity</i> ordered.<br>
						<cfelse>
							Based on <i>dollar value</i> of quantity based on normal price.<br>
						</cfif>
						<br>
						<i>Use Step Pricing?</i><br>
						<cfif qry_selectPrice.priceStageVolumeStep is 1>
							No - Use price based on total quantity in invoice for all units<br>
						<cfelse>
							Yes - Apply price at each level within the same invoice<br>
						</cfif>
					</td>
					<td width="25">&nbsp;</td>
					<td>
						<table border="1" cellspacing="0" cellpadding="2" class="TableText">
						<tr valign="bottom">
							<th class="TableHeader">&nbsp;</th>
							<th class="TableHeader">Min. <cfif qry_selectPrice.priceStageVolumeDollarOrQuantity is 0>$<cfelse>##</cfif></th>
							<th class="TableHeader">Price <cfif qry_selectPrice.priceStageDollarOrPercent is 0>$<cfelse>%</cfif></th>
							<th class="TableHeader">Total<br>Price?</th>
						</tr>

						<cfset Variables.thisPriceStageID = qry_selectPrice.priceStageID>
						<cfset Variables.thisPriceStageOrder = qry_selectPrice.priceStageOrder>
						<cfset Variables.thisStageVolumeDollarOrQuantity = qry_selectPrice.priceStageVolumeDollarOrQuantity>
						<cfset Variables.thisStageDollarOrPercent = qry_selectPrice.priceStageDollarOrPercent>
						<cfset Variables.volumeDiscountRow = ListFind(ValueList(qry_selectPriceVolumeDiscount.priceStageID), qry_selectPrice.priceStageID)>

						<cfif Variables.volumeDiscountRow is not 0>
							<cfloop Query="qry_selectPriceVolumeDiscount" StartRow="#Variables.volumeDiscountRow#">
								<cfif qry_selectPriceVolumeDiscount.priceStageID is not Variables.thisPriceStageID><cfbreak></cfif>
								<tr<cfif (qry_selectPriceVolumeDiscount.CurrentRow mod 2) is not (Variables.thisPriceStageOrder mod 2)> bgcolor="f4f4ff"<cfelse> bgcolor="white"</cfif>>
								<td align="right">#IncrementValue(qry_selectPriceVolumeDiscount.CurrentRow - Variables.volumeDiscountRow)#: </td>
								<td align="center">
									<cfif qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityIsMaximum is 1>
										-
									<cfelseif Variables.thisStageVolumeDollarOrQuantity is 0>
										$#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum)#
									<cfelse>
										#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum)#
									</cfif>
								</td>
								<td align="center">
									<cfif Variables.thisStageDollarOrPercent is 0>
										$#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount)#
									<cfelse>
										#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount)#%
									</cfif>
								</td>
								<td align="center"><cfif qry_selectPrice.productID[1] is 0>-<cfelseif qry_selectPriceVolumeDiscount.priceVolumeDiscountIsTotalPrice is 1>Yes<cfelse>No</cfif></td>
								</tr>
							</cfloop>
						</cfif>
						</table>
					</td>
				</tr>
				</table>
			</td>
		</tr>
	</cfif>
	</table>
</cfloop>
</cfoutput>

