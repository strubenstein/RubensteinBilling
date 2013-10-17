<cfoutput>
<p>
<div class="MainText"><b><i>Recommended Products</i></b></div>
<table border="1" cellspacing="2" cellpadding="2">
<tr class="TableHeader" valign="bottom">
	<th>Code</th>
	<th>Product Name</th>
	<th>Price</th>
</tr>
<cfloop Query="qry_selectProductRecommendList">
	<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
	<td><cfif qry_selectProductRecommendList.productID_custom is "">&nbsp;<cfelse>#qry_selectProductRecommendList.productID_custom#</cfif></td>
	<td><a href="index.cfm/method/product.viewProduct/productID/#qry_selectProductRecommendList.productID#.cfm">#qry_selectProductRecommendList.productLanguageName#</a></td>
	<td nowrap>
		<cfif Not StructKeyExists(Variables.productID_customPriceRow, "product#qry_selectProductRecommendList.productID#") or Not StructKeyExists(Variables.productID_customPriceAmount, "product#qry_selectProductRecommendList.productID#")>
			<cfif qry_selectProductRecommendList.productPriceCallForQuote is 1>(<a href="/contactus.cfm?productID=#qry_selectProductRecommendList.productID#">Call for quote</a>)<cfelse>#DollarFormat(qry_selectProductRecommendList.productPrice)#</cfif>
		<cfelse>
			Normal Price: #DollarFormat(qry_selectProductRecommendList.productPrice)#<br>
			<cfif qry_selectPriceList.priceAppliesToAllCustomers[Variables.productID_customPriceRow["product#qry_selectProductRecommendList.productID#"]] is 1>Sale Price: <cfelse>Your Price: </cfif>
			<cfif qry_selectPriceList.priceStageVolumeDiscount[Variables.productID_customPriceRow["product#qry_selectProductRecommendList.productID#"]] is 1>from </cfif>
			#DollarFormat(Variables.productID_customPriceAmount["product#qry_selectProductRecommendList.productID#"])#
		</cfif>
	</tr>
</cfloop>
</table>
</p>
</cfoutput>