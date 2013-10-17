<cfset errorMessage_fields = StructNew()>

<cfif Not ListFind("0,1", Form.productStatus)>
	<cfset errorMessage_fields.productStatus = Variables.lang_insertUpdateProduct.productStatus>
</cfif>

<cfif Form.productID_parent is not "">
	<cfif Not Application.fn_IsIntegerPositive(Form.productID_parent)>
		<cfset errorMessage_fields.productID_parent = Variables.lang_insertUpdateProduct.productID_parent>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Product" Method="checkProductPermission" ReturnVariable="isProductPermission">
			<cfinvokeargument Name="productID" Value="#Form.productID_parent#">
			<cfinvokeargument Name="companyID" Value="#Session.companyID#">
		</cfinvoke>

		<cfif Not isProductPermission>
			<cfset errorMessage_fields.productID_parent = Variables.lang_insertUpdateProduct.productID_parent>
		</cfif>
	</cfif>
</cfif>

<cfif Not ListFind("0,1", Form.productCanBePurchased)>
	<cfset errorMessage_fields.productCanBePurchased = Variables.lang_insertUpdateProduct.productCanBePurchased>
</cfif>

<cfif Not ListFind("0,1", Form.productListedOnSite)>
	<cfset errorMessage_fields.productListedOnSite = Variables.lang_insertUpdateProduct.productListedOnSite>
</cfif>

<cfif Not ListFind("0,1", Form.productDisplayChildren)>
	<cfset errorMessage_fields.productDisplayChildren = Variables.lang_insertUpdateProduct.productDisplayChildren>
</cfif>

<cfif Form.productID_parent is "">
	<cfset Form.productChildType = 0>
<cfelseif Not ListFind("1,2", Form.productChildType)>
	<cfset errorMessage_fields.productChildType = Variables.lang_insertUpdateProduct.productChildType>
</cfif>

<cfif Not ListFind("0,1", Form.productIsBundle)>
	<cfset errorMessage_fields.productIsBundle = Variables.lang_insertUpdateProduct.productIsBundle_valid>
<cfelseif Form.productIsBundle is 1 and Form.productStatus is not 0 and Variables.doAction is "productCreate">
	<cfset errorMessage_fields.productIsBundle = Variables.lang_insertUpdateProduct.productIsBundle_status>
</cfif>

<cfif Trim(Form.productName) is "">
	<cfset errorMessage_fields.productName = Variables.lang_insertUpdateProduct.productName_blank>
<cfelseif Len(Form.productName) gt maxlength_Product.productName>
	<cfset errorMessage_fields.productName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateProduct.productName_maxlength, "<<MAXLENGTH>>", maxlength_Product.productName, "ALL"), "<<LEN>>", Len(Form.productName), "ALL")>
</cfif>

<cfif Not IsNumeric(Form.productPrice)>
	<cfset Form.productPrice = 0>
	<cfset errorMessage_fields.productPrice = Variables.lang_insertUpdateProduct.productPrice_numeric>
<cfelseif Find(".", Form.productPrice) and Len(ListLast(Form.productPrice, ".")) gt maxlength_Product.productPrice>
	<cfset errorMessage_fields.productPrice = ReplaceNoCase(Variables.lang_insertUpdateProduct.productPrice_maxlength, "<<MAXLENGTH>>", maxlength_Product.productPrice, "ALL")>
</cfif>

<cfif Not ListFind("0,1", Form.productPriceCallForQuote)>
	<cfset errorMessage_fields.productPriceCallForQuote = Variables.lang_insertUpdateProduct.productPriceCallForQuote>
</cfif>

<cfif Form.userID_manager is not 0>
	<cfif Not ListFind(ValueList(qry_selectUserCompanyList_company.userID), Form.userID_manager)>
		<cfset errorMessage_fields.userID_manager = Variables.lang_insertUpdateProduct.userID_manager>
	</cfif>
</cfif>

<cfif Len(Form.productID_custom) gt maxlength_Product.productID_custom>
	<cfset errorMessage_fields.productID_custom = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateProduct.productID_custom, "<<MAXLENGTH>>", maxlength_Product.productID_custom, "ALL"), "<<LEN>>", Len(Form.productID_custom), "ALL")>
</cfif>

<cfif Form.vendorID is not 0>
	<cfif Not ListFind(ValueList(qry_selectVendorList.vendorID), Form.vendorID)>
		<cfset errorMessage_fields.vendorID = Variables.lang_insertUpdateProduct.vendorID>
	</cfif>
</cfif>

<cfif Len(Form.productCode) gt maxlength_Product.productCode>
	<cfset errorMessage_fields.productCode = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateProduct.productCode, "<<MAXLENGTH>>", maxlength_Product.productCode, "ALL"), "<<LEN>>", Len(Form.productCode), "ALL")>
</cfif>

<cfif Not IsNumeric(Form.productWeight) or Form.productWeight lt 0>
	<cfset errorMessage_fields.productWeight = Variables.lang_insertUpdateProduct.productWeight_numeric>
<cfelseif Find(".", Form.productWeight) and Len(ListLast(Form.productWeight, ".")) gt maxlength_Product.productWeight>
	<cfset errorMessage_fields.productWeight = ReplaceNoCase(Variables.lang_insertUpdateProduct.productWeight_maxlength, "<<MAXLENGTH>>", maxlength_Product.productWeight, "ALL")>
</cfif>

<cfif Form.productCatalogPageNumber is not "" and Not Application.fn_IsIntegerNonNegative(Form.productCatalogPageNumber)>
	<cfset errorMessage_fields.productCatalogPageNumber = Variables.lang_insertUpdateProduct.productCatalogPageNumber>
</cfif>

<cfif Form.templateFilename is not "" and Not ListFind(ValueList(qry_selectTemplateList.templateFilename), Form.templateFilename)>
	<cfset errorMessage_fields.templateFilename = Variables.lang_insertUpdateProduct.templateFilename>
</cfif>

<cfif Not ListFind("0,1", Form.productInWarehouse)>
	<cfset errorMessage_fields.productInWarehouse = Variables.lang_insertUpdateProduct.productInWarehouse>
</cfif>

<!--- Validate custom fields and custom status if applicable (and not via web service) --->
<cfif GetFileFromPath(GetBaseTemplatePath()) is "index.cfm">
	<cfif isCustomFieldValueExist is True>
		<cfinvoke component="#objInsertCustomFieldValue#" method="formValidate_insertCustomFieldValue" returnVariable="errorMessageStruct_customField" />
		<cfif Not StructIsEmpty(errorMessageStruct_customField)>
			<cfset errorMessage_fields = StructAppend(errorMessage_fields, errorMessageStruct_customField)>
		</cfif>
	</cfif>

	<cfif isStatusExist is True>
		<cfinvoke component="#objInsertStatusHistory#" method="formValidate_insertStatusHistory" returnVariable="errorMessageStruct_status" />
		<cfif Not StructIsEmpty(errorMessageStruct_status)>
			<cfset errorMessage_fields = StructAppend(errorMessage_fields, errorMessageStruct_status)>
		</cfif>
	</cfif>
</cfif>

<cfif URL.displayExtendedForm is True>
	<cfinclude template="formValidate_insertProductLanguage.cfm">
	<cfinclude template="c_productCategory/formValidate_productCategory.cfm">
	<cfinclude template="../c_image/formValidate_insertUpdateImage.cfm">
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertProduct">
		<cfset errorMessage_title = Variables.lang_insertUpdateProduct.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertUpdateProduct.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdateProduct.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdateProduct.errorFooter>
</cfif>
