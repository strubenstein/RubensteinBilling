<cfloop Index="field" List="categoryID_sub,categoryID_multiple,productStatus,productHasImage,productListedOnSite,productHasSpec,productCanBePurchased,productInBundle,productIsBundle,productIsRecommended,productHasRecommendation,productIsDateRestricted,productIsDateAvailable,productHasChildren,productHasCustomPrice,productPriceCallForQuote,productInWarehouse,productHasParameter,productHasParameterException">
	<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
</cfloop>

<cfset Arguments.statusID = Application.objWebServiceSecurity.ws_checkStatusPermission(qry_selectWebServiceSession.companyID_author, Arguments.statusID, Arguments.statusID_custom, Arguments.useCustomIDFieldList, "productID")>
<cfset Arguments.categoryID = Application.objWebServiceSecurity.ws_checkCategoryPermission(qry_selectWebServiceSession.companyID_author, Arguments.categoryID, Arguments.categoryCode, Arguments.useCustomIDFieldList)>

<cfset categoryID_list = Arguments.categoryID>
<cfif Arguments.categoryID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Category" Method="selectCategoryList" ReturnVariable="qry_selectCategoryList">
		<cfinvokeargument Name="companyID" Value="#qry_selectWebServiceSession.companyID_author#">
	</cfinvoke>

	<cfif Arguments.categoryID gt 0 and Arguments.categoryID_sub is 1>
		<cfset beginRow = ListFind(ValueList(qry_selectCategoryList.categoryID), Arguments.categoryID) + 1>
		<cfif beginRow gt 1 and beginRow lte qry_selectCategoryList.RecordCount>
			<cfloop Query="qry_selectCategoryList" StartRow="#beginRow#">
				<cfif ListFind(qry_selectCategoryList.categoryID_parentList, Arguments.categoryID)>
					<cfset categoryID_list = ListAppend(categoryID_list, qry_selectCategoryList.categoryID)>
				<cfelse>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
	</cfif>

	<cfset Variables.displayProductCategoryOrder = False>
	<cfset Variables.displaySwitchProductCategoryOrder = False>
</cfif>

<cfset qryParamStruct.companyID = qry_selectWebServiceSession.companyID_author>
<cfif categoryID_list is not "">
	<cfset qryParamStruct.categoryID_list = categoryID_list>
</cfif>
<cfloop Index="field" List="categoryID_sub,categoryID_multiple,productStatus,productHasImage,productListedOnSite,productInBundle,productIsBundle,productIsRecommended,productHasRecommendation,productIsDateRestricted,productHasChildren,productHasCustomPrice,productHasSpec,productCanBePurchased,productInWarehouse,productPriceCallForQuote,productWeight,productHasParameter,productHasParameterException">
	<cfif ListFind(Arguments.searchFieldList, field) and StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])>
		<cfset qryParamStruct[field] = Arguments[field]>
	</cfif>
</cfloop>
<cfloop Index="field" List="categoryID,productID_parent">
	<cfif ListFind(Arguments.searchFieldList, field) and StructKeyExists(Arguments, field) and Arguments[field] is not 0 and Application.fn_IsIntegerList(Arguments[field])>
		<cfset qryParamStruct[field] = Arguments[field]>
	</cfif>
</cfloop>
<cfloop Index="field" List="productCatalogPageNumber,productPrice_min,productPrice_max,productWeight_min,productWeight_max">
	<cfif ListFind(Arguments.searchFieldList, field) and StructKeyExists(Arguments, field) and IsNumeric(Arguments[field])>
		<cfset qryParamStruct[field] = Arguments[field]>
	</cfif>
</cfloop>
<cfloop Index="field" List="productName,productID_custom,productCode,productLanguageSummary,productLanguageDescription,templateFilename">
	<cfif ListFind(Arguments.searchFieldList, field) and StructKeyExists(Arguments, field) and Trim(Arguments[field]) is not "">
		<cfset qryParamStruct[field] = Arguments[field]>
	</cfif>
</cfloop>
<cfloop Index="field" List="userID_manager,vendorID,statusID">
	<cfif ListFind(Arguments.searchFieldList, field) and StructKeyExists(Arguments, field) and Application.fn_IsIntegerNonNegative(Arguments[field])>
		<cfset qryParamStruct[field] = Arguments[field]>
	</cfif>
</cfloop>
<cfif ListFind(Arguments.searchFieldList, "productIsExported") and StructKeyExists(Arguments, "productIsExported") and (Arguments.productIsExported is "" or ListFind("0,1", Arguments.productIsExported))>
	<cfset qryParamStruct.productIsExported = Arguments.productIsExported>
</cfif>

