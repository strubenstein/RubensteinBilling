<cfoutput>
<p>
<div class="MainText"><b><i>Bundles Which Include This Product</i></b></div>
<table border="1" cellspacing="2" cellpadding="2">
<tr class="TableHeader" valign="bottom">
	<th>Code</th>
	<th>Product Name</th>
	<th>Price</th>
</tr>
<cfloop Query="qry_selectProductBundleList">
	<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
	<td><cfif qry_selectProductBundleList.productID_custom is "">&nbsp;<cfelse>#qry_selectProductBundleList.productID_custom#</cfif></td>
	<td><a href="index.cfm/method/product.viewProduct/productID/#qry_selectProductBundleList.productID#.cfm">#qry_selectProductBundleList.productLanguageName#</a></td>
	<td nowrap>
		<cfif Not StructKeyExists(Variables.productID_customPriceRow, "product#qry_selectProductBundleList.productID#") or Not StructKeyExists(Variables.productID_customPriceAmount, "product#qry_selectProductBundleList.productID#")>
			<cfif qry_selectProductBundleList.productPriceCallForQuote is 1>(<a href="contactus.cfm?productID=#qry_selectProductBundleList.productID#">Call for quote</a>)<cfelse>#DollarFormat(qry_selectProductBundleList.productPrice)#</cfif>
		<cfelse>
			Normal Price: #DollarFormat(qry_selectProductBundleList.productPrice)#<br>
			<cfif qry_selectPriceList.priceAppliesToAllCustomers[Variables.productID_customPriceRow["product#qry_selectProductBundleList.productID#"]] is 1>Sale Price: <cfelse>Your Price: </cfif>
			Sale Price: <cfif qry_selectPriceList.priceStageVolumeDiscount[Variables.productID_customPriceRow["product#qry_selectProductBundleList.productID#"]] is 1>from </cfif>
			#DollarFormat(Variables.productID_customPriceAmount["product#qry_selectProductBundleList.productID#"])#
		</cfif>
	</td>
	</tr>
</cfloop>
</table>
</p>
</cfoutput>