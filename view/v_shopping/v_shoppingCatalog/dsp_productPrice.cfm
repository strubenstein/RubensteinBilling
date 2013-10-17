<cfoutput>
<font class="MainText">
<cfif Not StructKeyExists(Variables.productID_customPriceRow, "product#qry_selectProduct.productID#") or Not StructKeyExists(Variables.productID_customPriceAmount, "product#qry_selectProduct.productID#")>
	Price: <cfif qry_selectProduct.productPriceCallForQuote is 1>(<a href="/contactus.cfm?productID=#qry_selectProduct.productID#">Call for quote</a>)<cfelse>#DollarFormat(qry_selectProduct.productPrice)#</cfif>
<cfelse>
	<cfset Variables.priceRow = Variables.productID_customPriceRow["product#qry_selectProduct.productID#"]>
	Normal Price: #DollarFormat(qry_selectProduct.productPrice)#<br>
	<cfif qry_selectPriceList.priceStageVolumeDiscount[Variables.priceRow] is 0>
		<cfif qry_selectPriceList.priceAppliesToAllCustomers[Variables.priceRow] is 1>Sale Price: <cfelse>Your Price: </cfif>
		#DollarFormat(Variables.productID_customPriceAmount["product#qry_selectProduct.productID#"])#
	<cfelse><!--- display volume discount pricing --->
		<cfset Variables.thisPriceStageID = qry_selectPriceList.priceStageID[Variables.priceRow]>
		<!--- 
		<cfset Variables.thisPriceStageNewOrDeduction = qry_selectPriceList.priceStageNewOrDeduction[Variables.priceRow]>
		<cfset Variables.thisPriceStageDollarOrPercent = qry_selectPriceList.priceStageDollarOrPercent[Variables.priceRow]>
		--->
		<cfset Variables.beginRow = ListFind(ValueList(qry_selectPriceVolumeDiscount.priceStageID), Variables.thisPriceStageID)>

		<cfif Variables.beginRow is not 0><!--- volume options exist --->
			<b><cfif qry_selectPriceList.priceAppliesToAllCustomers[Variables.priceRow] is 1>Sale price <cfelse>Your price </cfif>
			based on quantity ordered:</b><br>
			<table border="1" cellspacing="2" cellpadding="2">
			<tr class="TableHeader">
				<th>Minimum <cfif qry_selectPriceList.priceStageVolumeDollarOrQuantity is 1>Quantity<cfelse>Order</cfif></th>
				<th>Unit Price</th>
			</tr>
			<cfloop Query="qry_selectPriceVolumeDiscount" StartRow="#Variables.beginRow#"><!--- loop thru volume options --->
				<cfif qry_selectPriceVolumeDiscount.priceStageID is not Variables.thisPriceStageID><cfbreak></cfif>
				<tr>
					<td align="center">
						<cfif qry_selectPriceList.priceStageVolumeDollarOrQuantity[Variables.priceRow] is 1>
							<cfif qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityIsMaximum is 0>#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum)#
							<cfelseif qry_selectPriceVolumeDiscount.CurrentRow is Variables.beginRow>(maximum)
							<cfelse>&gt; $#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum[qry_selectPriceVolumeDiscount.CurrentRow - 1])#
							</cfif>
						<cfelseif qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityIsMaximum is 0>#DollarFormat(qry_selectProduct.productPrice * qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum)#
						<cfelseif qry_selectPriceVolumeDiscount.CurrentRow is Variables.beginRow>(maximum)
						<cfelse>&gt; #DollarFormat(qry_selectProduct.productPrice * qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum[qry_selectPriceVolumeDiscount.CurrentRow - 1])#
						</cfif>
					</td>
					<td nowrap>
						<cfswitch expression="#qry_selectPriceList.priceStageDollarOrPercent[Variables.priceRow]#_#qry_selectPriceList.priceStageNewOrDeduction[Variables.priceRow]#">
						<cfcase value="0_0">#DollarFormat(qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount)#</cfcase>
						<cfcase value="0_1">#DollarFormat(qry_selectProduct.productPrice * qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount)#</cfcase>
						<cfcase value="1_0">#DollarFormat(qry_selectProduct.productPrice - qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount)#</cfcase>
						<cfcase value="1_1">#DollarFormat(qry_selectProduct.productPrice * (1 - qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount))#</cfcase>
						</cfswitch>
					</td>
				</tr>
			</cfloop><!--- /loop thru volume options --->
			</table>
		</cfif>
	</cfif>
	<cfif IsDate(qry_selectPriceList.priceDateEnd)>
		 <br>(Ends #DateFormat(qry_selectPriceList.priceDateEnd[Variables.priceRow], "mm/dd/yy")# at #TimeFormat(qry_selectPriceList.priceDateEnd[Variables.priceRow], "hh:mm tt")#)
	</cfif>
</cfif>
</font>
</cfoutput>
