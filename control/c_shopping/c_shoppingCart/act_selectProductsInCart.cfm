<!--- put cart items in order; may require duplicating product depending on parameters --->
<cfset cartColumnList = "productID,productCode,productPrice,productWeight,productHasCustomPrice,productID_custom,productInWarehouse,productID_parent,productIsBundle,productCatalogPageNumber,productPriceCallForQuote,productLanguageName,productLanguageLineItemName,productLanguageLineItemDescription,productLanguageLineItemDescriptionHtml">
<cfset qry_selectProductsInCart_cartOrder = QueryNew(cartColumnList)>
<cfset temp = QueryAddRow(qry_selectProductsInCart_cartOrder, ArrayLen(theShoppingCart))>

<cfloop Index="count" From="1" To="#ArrayLen(theShoppingCart)#">
	<cfset productRow = ListFind(ValueList(qry_selectProductsInCart.productID), theShoppingCart[count].productID)>
	<cfif productRow is not 0>
		<cfset thisCount = count>
		<cfloop Index="field" List="#cartColumnList#">
			<cfset temp = QuerySetCell(qry_selectProductsInCart_cartOrder, field, Evaluate("qry_selectProductsInCart.#field#[#productRow#]"), thisCount)>
		</cfloop>
	</cfif>
</cfloop>

<cfset temp = ArraySet(parameterArray, 1, ArrayLen(theShoppingCart), "")>

<cfif productParameterOptionID_list is not "">
	<cfinclude template="qry_selectProductParameterOptionsInCart.cfm">
	<!--- loop thru cart/new query and add product parameter options --->
	<cfloop Index="count" From="1" To="#ArrayLen(theShoppingCart)#">
		<cfif theShoppingCart[count].productParameterOptionID_list is not "">
			<cfloop Index="optionID" List="#theShoppingCart[count].productParameterOptionID_list#">
				<cfset optionRow = ListFind(ValueList(qry_selectProductParameterOptionsInCart.productParameterOptionID), optionID)>
				<cfif optionRow is not 0>
					<cfset parameterValueList = ListAppend(parameterValueList, qry_selectProductParameterOptionsInCart.productParameterText[optionRow] & " = " & qry_selectProductParameterOptionsInCart.productParameterOptionLabel[optionRow], ";")>
				</cfif>
			</cfloop>
			<cfset parameterArray[count] = parameterValueList>
		</cfif>
	</cfloop>
</cfif>

<!--- add parameter values to query --->
<cfset temp = QueryAddColumn(qry_selectProductsInCart_cartOrder, "productParameters", parameterArray)>

