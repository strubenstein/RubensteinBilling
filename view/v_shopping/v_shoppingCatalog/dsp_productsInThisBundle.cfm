<cfoutput>
<p>
<div class="MainText"><b><i>Products Included in this Bundle</i></b></div>
<table border="1" cellspacing="2" cellpadding="2">
<tr class="TableHeader" valign="bottom">
	<th>Code</th>
	<th>Product Name</th>
	<th>Quantity<br>Included</th>
	<th>Unit<br>Price</th>
</tr>
<cfloop Query="qry_selectProductBundleProductList">
	<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
	<td><cfif qry_selectProductBundleProductList.productID_custom is "">&nbsp;<cfelse>#qry_selectProductBundleProductList.productID_custom#</cfif></td>
	<td><a href="index.cfm/method/product.viewProduct/productID/#qry_selectProductBundleProductList.productID#.cfm">#qry_selectProductBundleProductList.productLanguageName#</a></td>
	<td align="center"><cfif Application.fn_IsInteger(qry_selectProductBundleProductList.productBundleProductQuantity)>#Int(qry_selectProductBundleProductList.productBundleProductQuantity)#<cfelse>#DecimalFormat(qry_selectProductBundleProductList.productBundleProductQuantity)#</cfif></td>
	<td nowrap>
		<cfif Not StructKeyExists(Variables.productID_customPriceRow, "product#qry_selectProductBundleProductList.productID#") or Not StructKeyExists(Variables.productID_customPriceAmount, "product#qry_selectProductBundleProductList.productID#")>
			<cfif qry_selectProductBundleProductList.productPriceCallForQuote is 1>(<a href="/contactus.cfm?productID=#qry_selectProductBundleProductList.productID#">Call for quote</a>)<cfelse>#DollarFormat(qry_selectProductBundleProductList.productPrice)#</cfif>
		<cfelse>
			Normal Price: #DollarFormat(qry_selectProductBundleProductList.productPrice)#<br>
			<cfif qry_selectPriceList.priceAppliesToAllCustomers[Variables.productID_customPriceRow["product#qry_selectProductBundleProductList.productID#"]] is 1>Sale Price: <cfelse>Your Price: </cfif>
			<cfif qry_selectPriceList.priceStageVolumeDiscount[Variables.productID_customPriceRow["product#qry_selectProductBundleProductList.productID#"]] is 1>from </cfif>
			#DollarFormat(Variables.productID_customPriceAmount["product#qry_selectProductBundleProductList.productID#"])#
		</cfif>
	</td>
	</tr>
</cfloop>
</table>
</p>
</cfoutput>