<cfoutput>
<!--- 
<cfscript>
function fn_DisplayCustomPrice_category (normalPrice, customPrice, isDollarOrPercent, isNewOrDeduction, isVolumeDiscount, volumeDiscountMinimum)
{
	switch("#isDollarOrPercent#_#isNewOrDeduction#_#isVolumeDiscount#")
		{
		case "0_0_0" : return DollarFormat(customPrice);
		case "0_1_0" : return DollarFormat(normalPrice - customPrice);
		case "1_0_0" : return DollarFormat(normalPrice * customPrice);
		case "1_1_0" : return DollarFormat(normalPrice * (1 - customPrice));
		case "0_0_1" : return DollarFormat(volumeDiscountMinimum);
		case "0_1_1" : return DollarFormat(normalPrice - volumeDiscountMinimum);
		case "1_0_1" : return DollarFormat(normalPrice * volumeDiscountMinimum);
		case "1_1_1" : return DollarFormat(normalPrice * (1 - volumeDiscountMinimum));
		default : return DollarFormat(normalPrice);
		}
}
</cfscript>
--->

<!--- display this category name --->
<p class="SubTitle">#qry_selectCategory.categoryTitle#</p>

<!--- display category path --->
<cfif Variables.displayCategoryPath is True>
	<p class="TableText"><b>Category:</b>&nbsp;
	<cfloop Query="qry_selectParentCategoryList">
		<a href="index.cfm/method/category.viewCategory/categoryID/#qry_selectParentCategoryList.categoryID#.cfm" class="bluelink">#qry_selectParentCategoryList.categoryTitle#</a><cfif CurrentRow is not RecordCount> / </cfif>
	</cfloop>
	</p>
</cfif>

<!--- display category header --->
<cfif Variables.displayCategoryHeader is not 0>
	<p class="MainText">
	<cfif qry_selectHeaderFooterList.headerFooterHtml[Variables.displayCategoryHeader] is 0>
		#Replace(qry_selectHeaderFooterList.headerFooterText[Variables.displayCategoryHeader], Chr(10), "<br>", "ALL")#
	<cfelse>
		#qry_selectHeaderFooterList.headerFooterText[Variables.displayCategoryHeader]#
	</cfif>
	</p>
</cfif>

<!--- display sub-categories --->
<cfif Variables.displaySubCategoryList is True>
	<cfif qry_selectSubCategoryList.RecordCount lte 5>
		<cfset Variables.halfWayPoint = qry_selectSubCategoryList.RecordCount + 1>
	<cfelseif (qry_selectSubCategoryList.RecordCount mod 2) is 0>
		<cfset Variables.halfWayPoint = qry_selectSubCategoryList.RecordCount \ 2>
	<cfelse>
		<cfset Variables.halfWayPoint = (qry_selectSubCategoryList.RecordCount \ 2) + 1>
	</cfif>

	<p>
	<table border="0" cellspacing="2" cellpadding="2">
	<tr><td colspan="3" class="MainText"><b>Browse #qry_selectCategory.categoryTitle#</b></td></tr>
	<tr valign="top" class="MainText"><td><ul>
	<cfloop Query="qry_selectSubCategoryList">
		<li><a href="index.cfm/method/category.viewCategory/categoryID/#qry_selectSubCategoryList.categoryID#.cfm" class="plainlink">#qry_selectSubCategoryList.categoryTitle#</a></li>
		<cfif CurrentRow is Variables.halfWayPoint></ul></td><td width="25">&nbsp;</td><td><ul></cfif>
	</cfloop>
	</ul></td></tr>
	</table>
	</p>
</cfif>

<cfif Variables.totalProductPages gt 1>
	<p class="MainText"><b>Displaying Results #Variables.firstRecord#-#Variables.lastRecord# of #totalProductCount#</b></p>
</cfif>

<!--- display items in this category --->
<cfif qry_selectProductList.RecordCount is 0>
	<cfif URL.control is "category">
		<p class="ConfirmationMessage">This category has no products at this time.</p>
	</cfif>
<cfelse>
	<table border="0" cellspacing="5" cellpadding="0" class="MainText">
	<cfloop Query="qry_selectProductList">
		<tr>
		<td align="center" valign="center"><a href="index.cfm/method/product.viewProduct/productID/#qry_selectProductList.productID#.cfm"><cfif qry_selectProductList.imageTag is not ""><!--- <img src="/images/noimage.gif" width="120" height="80" alt="No Image Available" border="0"><cfelse> --->#qry_selectProductList.imageTag#</cfif></a></td>
		<td valign="top">
			<a href="index.cfm/method/product.viewProduct/productID/#qry_selectProductList.productID#.cfm">#qry_selectProductList.productLanguageName#</a><br>
			<cfif Not StructKeyExists(Variables.productID_customPriceRow, "product#qry_selectProductList.productID#") or Not StructKeyExists(Variables.productID_customPriceAmount, "product#qry_selectProductList.productID#")>
				<!--- Price: ---><cfif qry_selectProductList.productPriceCallForQuote is 1>(<a href="contactus.cfm?productID=#qry_selectProductList.productID#">Call for quote</a>)<cfelseif qry_selectProductList.productPrice is not 0>#DollarFormat(qry_selectProductList.productPrice)#</cfif>
			<cfelse>
				Normal Price: #DollarFormat(qry_selectProductList.productPrice)#<br>
				<cfif qry_selectPriceList.priceAppliesToAllCustomers[Variables.productID_customPriceRow["product#qry_selectProductList.productID#"]] is 1>Sale Price: <cfelse>Your Price: </cfif>
				<cfif qry_selectPriceList.priceStageVolumeDiscount[Variables.productID_customPriceRow["product#qry_selectProductList.productID#"]] is 1>from </cfif>
				#DollarFormat(Variables.productID_customPriceAmount["product#qry_selectProductList.productID#"])#
			</cfif>
		</td>
		</tr>
	</cfloop>
	</table>
</cfif>
			<!--- 
			<cfif Not StructKeyExists(Variables.productCustomPriceList, "all") and Not StructKeyExists(Variables.productCustomPriceList, "product#qry_selectProductList.productID#")>
				Price: #DollarFormat(qry_selectProductList.productPrice)#<br>
			<cfelse>
				<cfif StructKeyExists(Variables.productCustomPriceList, "all")>
					<cfloop Index="priceRow" List="#Variables.productCustomPriceList["all"]#">
						<b>Sale Price: #fn_DisplayCustomPrice_category(qry_selectProductList.productPrice, qry_selectPriceList.priceStageAmount[priceRow], qry_selectPriceList.priceStageDollarOrPercent[priceRow], qry_selectPriceList.priceStageNewOrDeduction[priceRow], qry_selectPriceList.priceStageVolumeDiscount[priceRow], qry_selectPriceList.priceVolumeDiscountMinimum[priceRow])#</b><br>
					</cfloop>
				</cfif>
				<cfif StructKeyExists(Variables.productCustomPriceList, "product#qry_selectProductList.productID#")>
					<cfloop Index="priceRow" List="#Variables.productCustomPriceList["product#qry_selectProductList.productID#"]#">
						<b>Your Price: #fn_DisplayCustomPrice_category(qry_selectProductList.productPrice, qry_selectPriceList.priceStageAmount[priceRow], qry_selectPriceList.priceStageDollarOrPercent[priceRow], qry_selectPriceList.priceStageNewOrDeduction[priceRow], qry_selectPriceList.priceStageVolumeDiscount[priceRow], qry_selectPriceList.priceVolumeDiscountMinimum[priceRow])#</b><br>
					</cfloop>
				</cfif>
			</cfif>
			--->

<cfif Variables.totalProductPages gt 1>
	<p class="MainText">
	<b>Go to Page: </b>
	<cfloop Index="count" From="1" To="#Variables.totalProductPages#">
		<cfif URL.queryPage is count><b>#count#</b><cfelse><a href="#Variables.queryViewAction_orderBy#&queryPage=#count#">#count#</a></cfif> - 
	</cfloop>
	<cfif URL.queryPage is not Variables.totalProductPages>
		<b><a href="#Variables.queryViewAction_orderBy#&queryPage=#IncrementValue(URL.queryPage)#">Next Page</a></b>
	</cfif>
	</p>
</cfif>

<!--- display category footer --->
<cfif Variables.displayCategoryFooter is not 0>
	<p class="MainText">
	<cfif qry_selectHeaderFooterList.headerFooterHtml[Variables.displayCategoryFooter] is 0>
		#Replace(qry_selectHeaderFooterList.headerFooterText[Variables.displayCategoryFooter], Chr(10), "<br>", "ALL")#
	<cfelse>
		#qry_selectHeaderFooterList.headerFooterText[Variables.displayCategoryFooter]#
	</cfif>
	</p>
</cfif>
</cfoutput>