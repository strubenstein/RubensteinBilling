<cfinclude template="wslang_product.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = -1>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("insertProduct", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = -1>
	<cfset returnError = Variables.wslang_product.insertProduct>
<cfelse>
	<cfloop Index="field" List="productPriceCallForQuote,productIsBundle,productChildSeparate,productDisplayChildren,productStatus,productListedOnSite,productCanBePurchased,productInWarehouse,productLanguageLineItemDescriptionHtml,productLanguageSummaryHtml,productLanguageDescriptionHtml">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfset Arguments.vendorID = Application.objWebServiceSecurity.ws_checkVendorPermission(qry_selectWebServiceSession.companyID_author, Arguments.vendorID, Arguments.vendorID_custom, Arguments.useCustomIDFieldList)>
	<cfset Arguments.userID_manager = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.userID_manager, Arguments.userID_manager_custom, Arguments.useCustomIDFieldList)>
	<cfset Arguments.productID_parent = Application.objWebServiceSecurity.ws_checkProductPermission(qry_selectWebServiceSession.companyID_author, Arguments.productID_parent, Arguments.productID_parent_custom, Arguments.useCustomIDFieldList)>

	<cfif Arguments.userID_manager is not 0>
		<!--- <cfset qry_selectUserCompanyList_company = QueryNew("userID_manager")> --->
		<cfset temp = QueryAddRow(qry_selectUserCompanyList_company, 1)>
		<cfset temp = QuerySetCell(qry_selectUserCompanyList_company, "userID", ToString(Arguments.userID_manager), 1)>
	</cfif>

	<cfif Arguments.vendorID is not 0>
		<!--- <cfset qry_selectVendorList = QueryNew("vendorID")> --->
		<cfset temp = QueryAddRow(qry_selectVendorList, 1)>
		<cfset temp = QuerySetCell(qry_selectVendorList, "vendorID", ToString(Arguments.vendorID), 1)>
	</cfif>

	<cfinvoke Component="#Application.billingMapping#data.Template" Method="selectTemplateList" ReturnVariable="qry_selectTemplateList">
		<cfinvokeargument Name="companyID" Value="0,#qry_selectWebServiceSession.companyID_author#">
		<cfinvokeargument Name="templateStatus" Value="1">
		<cfinvokeargument Name="templateType" Value="Product">
		<cfinvokeargument Name="returnTemplateXML" Value="False">
		<cfinvokeargument Name="templateDefault" Value="1">
	</cfinvoke>

	<cfif qry_selectTemplateList.RecordCount is 0>
		<cfset Arguments.templateFilename = "">
	<cfelse>
		<cfset Arguments.templateFilename = qry_selectTemplateList.templateFilename[1]>
	</cfif>

	<cfset returnValue = 0>
	<cfset Form = Arguments>
	<cfset URL.productID = 0>

	<cfset Variables.doAction = "insertProduct">
	<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("productID")>

	<cfinvoke component="#Application.billingMapping#data.Product" method="maxlength_Product" returnVariable="maxlength_Product" />
	<cfinclude template="../../control/c_product/formParam_insertUpdateProduct.cfm">
	<cfinclude template="../../view/v_product/lang_insertUpdateProduct.cfm">
	<cfinclude template="../../control/c_product/formValidate_insertUpdateProduct.cfm">

	<!--- only validate product language is product validates ok --->
	<cfif isAllFormFieldsOk is True>
		<cfinvoke component="#Application.billingMapping#data.ProductLanguage" method="maxlength_ProductLanguage" returnVariable="maxlength_ProductLanguage" />
		<cfinclude template="../../control/c_product/formParam_insertProductLanguage.cfm">
		<cfinclude template="../../view/v_product/lang_insertProductLanguage.cfm">
		<cfinclude template="../../control/c_product/formValidate_insertProductLanguage.cfm">
	</cfif>

	<cfif isAllFormFieldsOk is False>
		<cfset returnValue = -1>
		<cfset returnError = "">
		<cfloop Collection="#errorMessage_fields#" Item="field">
			<cfset returnError = ListAppend(returnError, StructFind(errorMessage_fields, field), Chr(10))>
		</cfloop>
	<cfelse>
		<cfif Not IsNumeric(Form.productCatalogPageNumber)>
			<cfset Form.productCatalogPageNumber = 0>
		</cfif>
		<cfif Not IsNumeric(Form.productID_parent)>
			<cfset Form.productID_parent = 0>
		</cfif>

		<cfinvoke Component="#Application.billingMapping#data.Product" Method="insertProduct" ReturnVariable="newProductID">
			<cfinvokeargument Name="companyID" Value="#qry_selectWebServiceSession.companyID_author#">
			<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
			<cfinvokeargument Name="userID_manager" Value="#Form.userID_manager#">
			<cfinvokeargument Name="vendorID" Value="#Form.vendorID#">
			<cfinvokeargument Name="productCode" Value="#Form.productCode#">
			<cfinvokeargument Name="productName" Value="#Form.productName#">
			<cfinvokeargument Name="productPrice" Value="#Form.productPrice#">
			<cfinvokeargument Name="productPriceCallForQuote" Value="#Form.productPriceCallForQuote#">
			<cfinvokeargument Name="productWeight" Value="#Form.productWeight#">
			<cfinvokeargument Name="productStatus" Value="#Form.productStatus#">
			<cfinvokeargument Name="productListedOnSite" Value="#Form.productListedOnSite#">
			<cfinvokeargument Name="productCanBePurchased" Value="#Form.productCanBePurchased#">
			<cfinvokeargument Name="productDisplayChildren" Value="#Form.productDisplayChildren#">
			<cfinvokeargument Name="productIsBundle" Value="#Form.productIsBundle#">
			<cfinvokeargument Name="productID_custom" Value="#Form.productID_custom#">
			<cfinvokeargument Name="templateFilename" Value="#Form.templateFilename#">
			<cfinvokeargument Name="productCatalogPageNumber" Value="#Form.productCatalogPageNumber#">
			<cfinvokeargument Name="productID_parent" Value="#Form.productID_parent#">
			<cfinvokeargument Name="productChildType" Value="#Form.productChildType#">
			<cfinvokeargument Name="productInWarehouse" Value="#Form.productInWarehouse#">
		</cfinvoke>

		<cfinvoke Component="#Application.billingMapping#data.ProductLanguage" Method="insertProductLanguage" ReturnVariable="isProductLanguageInserted">
			<cfinvokeargument Name="productID" Value="#newProductID#">
			<cfinvokeargument Name="languageID" Value="">
			<cfinvokeargument Name="userID" Value="#qry_selectWebServiceSession.userID#">
			<cfinvokeargument Name="productLanguageName" Value="#Form.productLanguageName#">
			<cfinvokeargument Name="productLanguageLineItemName" Value="#Form.productLanguageLineItemName#">
			<cfinvokeargument Name="productLanguageLineItemDescription" Value="#Form.productLanguageLineItemDescription#">
			<cfinvokeargument Name="productLanguageLineItemDescriptionHtml" Value="#Form.productLanguageLineItemDescriptionHtml#">
			<cfinvokeargument Name="productLanguageSummaryHtml" Value="#Form.productLanguageSummaryHtml#">
			<cfinvokeargument Name="productLanguageSummary" Value="#Form.productLanguageSummary#">
			<cfinvokeargument Name="productLanguageDescription" Value="#Form.productLanguageDescription#">
			<cfinvokeargument Name="productLanguageDescriptionHtml" Value="#Form.productLanguageDescriptionHtml#">
		</cfinvoke>

		<cfif Form.productID_parent is not 0>
			<cfinvoke Component="#Application.billingMapping#data.Product" Method="updateProduct" ReturnVariable="isProductUpdated">
				<cfinvokeargument Name="productID" Value="#Form.productID_parent#">
				<cfinvokeargument Name="productHasChildren" Value="1">
			</cfinvoke>
		</cfif>
	
		<!--- custom fields --->
		<cfif Trim(Arguments.customField) is not "">
			<cfinvoke Component="#Application.billingMapping#webservice.WebServiceFunction" Method="insertCustomFieldValues" ReturnVariable="isCustomFieldValuesInserted">
				<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
				<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
				<cfinvokeargument Name="primaryTargetKey" Value="productID">
				<cfinvokeargument Name="targetID" Value="#Arguments.productID#">
				<cfinvokeargument Name="customField" Value="#Arguments.customField#">
			</cfinvoke>
		</cfif>

		<!--- custom status --->
		<cfif Arguments.statusID is not 0 or ListFind(Arguments.useCustomIDFieldList, "statusID") or ListFind(Arguments.useCustomIDFieldList, "statusID_custom")>
			<cfinvoke Component="#Application.billingMapping#webservice.WebServiceFunction" Method="insertStatusHistory" ReturnVariable="isStatusHistoryInserted">
				<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
				<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
				<cfinvokeargument Name="primaryTargetKey" Value="productID">
				<cfinvokeargument Name="targetID" Value="#Arguments.productID#">
				<cfinvokeargument Name="useCustomIDFieldList" Value="#Arguments.useCustomIDFieldList#">
				<cfinvokeargument Name="statusID" Value="#Arguments.statusID#">
				<cfinvokeargument Name="statusID_custom" Value="#Arguments.statusID_custom#">
				<cfinvokeargument Name="statusHistoryComment" Value="#Arguments.statusHistoryComment#">
			</cfinvoke>
		</cfif>

		<!--- check for trigger --->
		<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
			<cfinvokeargument name="companyID" value="#qry_selectWebServiceSession.companyID#">
			<cfinvokeargument name="doAction" value="insertProduct">
			<cfinvokeargument name="isWebService" value="True">
			<cfinvokeargument name="doControl" value="product">
			<cfinvokeargument name="primaryTargetKey" value="productID">
			<cfinvokeargument name="targetID" value="#newProductID#">
		</cfinvoke>

		<cfset returnValue = newProductID>
	</cfif><!--- product was successfully created --->
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

