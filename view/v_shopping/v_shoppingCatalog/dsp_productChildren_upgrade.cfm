<cfoutput>
<p>
<div class="MainText"><b><i>Optional Upgrades For This Product</i></b></div>
<table border="1" cellspacing="2" cellpadding="2">
<tr class="TableHeader" valign="bottom">
	<th>Code</th>
	<th>Upgrade Name</th>
	<th>Price</th>
	<th>Qty / Add To Cart</th>
	<cfif Session.userID gt 0>
		<th>Add To Wish List</th>
	</cfif>
</tr>
<cfloop Query="qry_selectProductChildList" StartRow="#Variables.displayChildProduct_upgrade#">
	<cfif qry_selectProductChildList.productChildType is 2>
		<tr class="TableText" valign="middle"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td><cfif qry_selectProductChildList.productID_custom is "">&nbsp;<cfelse>#qry_selectProductChildList.productID_custom#</cfif></td>
		<td>#qry_selectProductChildList.productLanguageName#</td>
		<td nowrap>
			<cfif Not StructKeyExists(Variables.productID_customPriceRow, "product#qry_selectProductChildList.productID#") or Not StructKeyExists(Variables.productID_customPriceAmount, "product#qry_selectProductChildList.productID#")>
				<cfif qry_selectProductChildList.productPriceCallForQuote is 1>(<a href="/contactus.cfm?productID=#qry_selectProductChildList.productID#">Call for quote</a>)<cfelse>#DollarFormat(qry_selectProductChildList.productPrice)#</cfif>
			<cfelse>
				Normal Price: #DollarFormat(qry_selectProductChildList.productPrice)#<br>
				<cfif qry_selectPriceList.priceAppliesToAllCustomers[Variables.productID_customPriceRow["product#qry_selectProductChildList.productID#"]] is 1>Sale Price: <cfelse>Your Price: </cfif>
				<cfif qry_selectPriceList.priceStageVolumeDiscount[Variables.productID_customPriceRow["product#qry_selectProductChildList.productID#"]] is 1>from </cfif>
				#DollarFormat(Variables.productID_customPriceAmount["product#qry_selectProductChildList.productID#"])#
			</cfif>
		</td>
		<td align="center">
			<input type="text" name="quantity#qry_selectProductChildList.productID#" size="2" value="1">
			<input type="image" name="product#qry_selectProductChildList.productID#" src="/images/img_store/addtocart.gif" width="87" height="20" alt="Add to Cart" border="0">
		</td>
		<!--- <cfif Session.userID gt 0><td align="center"><a href="wishList.cfm?action=insertWishList&productID=#qry_selectProductChildList.productID#&returnID=#URL.productID#">Add to Wish List</a></td></cfif> --->
		</tr>
	</cfif>
</cfloop>
</table>
</p>
</cfoutput>