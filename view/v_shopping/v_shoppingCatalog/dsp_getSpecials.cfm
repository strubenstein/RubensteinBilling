<cfoutput Query="qry_selectProductList">
	<cfif CurrentRow is not 1><tr></cfif>
	<td width="1" bgcolor="FF0000">&nbsp;</td>
	<td width="147" bgcolor="FFFFFF" align="center">
		<cfif CurrentRow is not 1><br></cfif>
		<cfif qry_selectProductList.imageTag is not ""><a href="index.cfm/method/product.viewProduct/productID/#qry_selectProductList.productID#.cfm">#qry_selectProductList.imageTag#</a><br></cfif>
		<font size="2" face="Arial, Helvetica, sans-serif">#qry_selectProductList.productLanguageName#<br>
		<font color="FF0000">
		<cfif Not StructKeyExists(Variables.productID_customPriceRow, "product#qry_selectProductList.productID#") or Not StructKeyExists(Variables.productID_customPriceAmount, "product#qry_selectProductList.productID#")>
			<cfif qry_selectProductList.productPriceCallForQuote is 1>(<a href="contactus.cfm?productID=#qry_selectProductList.productID#">Call for quote</a>)<br><cfelseif qry_selectProductList.productPrice is not 0>#DollarFormat(qry_selectProductList.productPrice)#<br></cfif>
		<cfelse>
			<cfif qry_selectProductList.productPrice is not 0>#DollarFormat(qry_selectProductList.productPrice)#<br></cfif>
			<cfif qry_selectPriceList.priceAppliesToAllCustomers[Variables.productID_customPriceRow["product#qry_selectProductList.productID#"]] is 1>Sale Price: <cfelse>Your Price: </cfif>
			<cfif qry_selectPriceList.priceStageVolumeDiscount[Variables.productID_customPriceRow["product#qry_selectProductList.productID#"]] is 1><br>from </cfif>
			#DollarFormat(Variables.productID_customPriceAmount["product#qry_selectProductList.productID#"])#<br>
		</cfif>
		</font>
		<a href="index.cfm/method/product.viewProduct/productID/#qry_selectProductList.productID#.cfm" class="plainlink">more info&gt;</a></font>
	</td>
	<td width="1" bgcolor="FF0000">&nbsp;</td>
	</tr>
</cfoutput>
