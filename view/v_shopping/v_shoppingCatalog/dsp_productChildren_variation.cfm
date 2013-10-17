<cfoutput>
<p>
<div class="MainText"><b><i>Select Product To Purchase</i></b></div>
<cfset Variables.count = 0>
<cfloop Query="qry_selectProductChildList" StartRow="#Variables.displayChildProduct_variation#">
	<cfif qry_selectProductChildList.productChildType is 1>
		<!--- begin new table if first child product or this product is separated --->
		<cfif CurrentRow is 1 or qry_selectProductChildList.productChildSeparate is 1>
			<cfif CurrentRow is not 1>
				</table></p>
				<cfif qry_selectProductChildList.productLanguageSummary is not "">
					<p class="TableText">
					<cfif qry_selectProductChildList.productLanguageSummaryHtml is 0>
						#Replace(qry_selectProductChildList.productLanguageSummary, Chr(10), "<br>", "ALL")#
					<cfelse>
						#qry_selectProductChildList.productLanguageSummary#
					</cfif>
					</p>
				</cfif>
				<p>
			</cfif>
			<table border="1" cellspacing="2" cellpadding="2" id="tableNode">
			<tr class="TableHeader" valign="bottom">
				<th>Code</th>
				<th>Product Name</th>
				<cfif Variables.displayProductSpec_child is True>
					<cfset Variables.specRow = ListFind(ValueList(qry_selectProductSpecList.productID), qry_selectProductChildList.productID)>
					<cfset Variables.specCount = 0>
					<cfif Variables.specRow is not 0>
						<cfset Variables.thisSpecProductID = qry_selectProductChildList.productID>
						<cfloop Query="qry_selectProductSpecList" StartRow="#Variables.specRow#">
							<cfif qry_selectProductSpecList.productID is not Variables.thisSpecProductID><cfbreak></cfif>
							<th>#qry_selectProductSpecList.productSpecName#</th>
							<cfset Variables.specCount = Variables.specCount + 1>
						</cfloop>
					</cfif>
				</cfif>
				<th>Price</th>
				<th>Qty / Add To Cart</th>
				<cfif Session.userID gt 0>
					<th>Add To Wish List</th>
				</cfif>
			</tr>
		</cfif>
		<tr class="TableText" valign="middle"<cfif (CurrentRow mod 2) is 0> bgColor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<td><cfif qry_selectProductChildList.productID_custom is "">&nbsp;<cfelse>#qry_selectProductChildList.productID_custom#</cfif></td>
		<td>#qry_selectProductChildList.productLanguageName#</td>
		<cfif Variables.displayProductSpec_child is True><!--- get child product specs --->
			<cfset Variables.specRow = ListFind(ValueList(qry_selectProductSpecList.productID), qry_selectProductChildList.productID)>
			<cfif Variables.specRow is not 0>
				<cfset Variables.thisSpecProductID = qry_selectProductChildList.productID>
				<cfloop Query="qry_selectProductSpecList" StartRow="#Variables.specRow#">
					<cfif qry_selectProductSpecList.productID is not Variables.thisSpecProductID><cfbreak></cfif>
					<td align="center">#qry_selectProductSpecList.productSpecValue#</td>
				</cfloop>
			</cfif>
		</cfif>
		<cfif qry_selectProductChildList.productPriceCallForQuote is 1>
			<td colspan="2" align="center"><a href="/contactus.cfm?productID=#qry_selectProductChildList.productID#">Call For Quote</a></td>
		<cfelse>
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
		</cfif>
		<!--- <cfif Session.userID gt 0><td align="center"><a href="wishList.cfm?action=insertWishList&productID=#qry_selectProductChildList.productID#&returnID=#URL.productID#">Add to Wish List</a></td></cfif> --->
		</tr>
		<cfset Variables.count = Variables.count + 1>
	</cfif>
</cfloop>
</table>
</p>
</cfoutput>