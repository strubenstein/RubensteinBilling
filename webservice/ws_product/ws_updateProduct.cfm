<cfinclude template="wslang_product.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = False>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("updateProduct", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_product.updateProduct>
<cfelse>
	<cfloop Index="field" List="productPriceCallForQuote,productChildSeparate,productDisplayChildren,productStatus,productListedOnSite,productCanBePurchased,productInWarehouse,productLanguageLineItemDescriptionHtml,productLanguageSummaryHtml,productLanguageDescriptionHtml">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfset Arguments.productID = Application.objWebServiceSecurity.ws_checkProductPermission(qry_selectWebServiceSession.companyID_author, Arguments.productID, Arguments.productID_custom, Arguments.useCustomIDFieldList)>
	<cfif Arguments.productID lte 0>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_product.invalidProduct>
	<cfelse>
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

		<cfset Form = Arguments>
		<cfset Variables.doAction = "updateProduct">
		<cfset URL.productID = Arguments.productID>
		<cfset Form.templateFilename = "">

		<cfset Variables.updateFieldList_valid = "userID_manager,vendorID,productCode,productName,productPrice,productPriceCallForQuote,productWeight,productCatalogPageNumber,productID_parent,productID_parent,productChildType,productChildSeparate,productDisplayChildren,productStatus,productListedOnSite,productCanBePurchased,productInWarehouse">
		<cfset Variables.updateFieldList_validLanguage = "productLanguageName,productLanguageLineItemName,productLanguageLineItemDescription,productLanguageLineItemDescriptionHtml,productLanguageSummaryHtml,productLanguageSummary,productLanguageDescription,productLanguageDescriptionHtml">

		<cfinvoke Component="#Application.billingMapping#data.Product" Method="selectProduct" ReturnVariable="qry_selectProduct">
			<cfinvokeargument Name="productID" Value="#Arguments.productID#">
		</cfinvoke>

		<cfloop Index="field" List="#Variables.updateFieldList_valid#">
			<cfif Not IsDefined("Form.#field#") or Not ListFind(Arguments.updateFieldList, field)>
				<cfset Form[field] = Evaluate("qry_selectProduct.#field#")>
			</cfif>
		</cfloop>

		<cfinvoke component="#Application.billingMapping#data.Product" method="maxlength_Product" returnVariable="maxlength_Product" />
		<cfinclude template="../../control/c_product/formParam_insertUpdateProduct.cfm">
		<cfinclude template="../../view/v_product/lang_insertUpdateProduct.cfm">
		<cfinclude template="../../control/c_product/formValidate_insertUpdateProduct.cfm">

		<cfinvoke Component="#Application.billingMapping#data.ProductLanguage" Method="selectProductLanguage" ReturnVariable="qry_selectProductLanguage">
			<cfinvokeargument Name="productID" Value="#Arguments.productID#">
			<cfinvokeargument Name="languageID" Value="">
			<cfinvokeargument Name="productLanguageStatus" Value="1">
		</cfinvoke>

		<cfloop Index="field" List="#Variables.updateFieldList_validLanguage#">
			<cfif Not IsDefined("Form.#field#") or Not ListFind(Arguments.updateFieldList, field)>
				<cfset Form[field] = Evaluate("qry_selectProductLanguage.#field#")>
			</cfif>
		</cfloop>

		<cfif isAllFormFieldsOk is True>
			<cfinvoke component="#Application.billingMapping#data.ProductLanguage" method="maxlength_ProductLanguage" returnVariable="maxlength_ProductLanguage" />
			<cfinclude template="../../control/c_product/formParam_insertProductLanguage.cfm">
			<cfinclude template="../../view/v_product/lang_insertProductLanguage.cfm">
			<cfinclude template="../../control/c_product/formValidate_insertProductLanguage.cfm">
		</cfif>

		<cfif isAllFormFieldsOk is False>
			<cfset returnValue = False>
			<cfset returnError = "">
			<cfloop Collection="#errorMessage_fields#" Item="field">
				<cfset returnError = ListAppend(returnError, StructFind(errorMessage_fields, field), Chr(10))>
			</cfloop>
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.Product" Method="updateProduct" ReturnVariable="isProductUpdated">
				<cfinvokeargument Name="productID" Value="#Arguments.productID#">
				<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
				<cfloop Index="field" List="#Variables.updateFieldList_valid#">
					<cfif ListFind(Arguments.updateFieldList, field) and Not FindNoCase("productLanguage", field)>
						<cfinvokeargument Name="#field#" Value="#Arguments[field]#">
					</cfif>
				</cfloop>
			</cfinvoke>

			<cfif FindNoCase("productLanguage", Arguments.updateFieldList)>
				<cfinvoke Component="#Application.billingMapping#data.ProductLanguage" Method="insertProductLanguage" ReturnVariable="isProductLanguageInserted">
					<cfinvokeargument Name="productID" Value="#Arguments.productID#">
					<cfinvokeargument Name="languageID" Value="">
					<cfinvokeargument Name="userID" Value="#qry_selectWebServiceSession.userID#">
					<cfloop Index="field" List="#Variables.updateFieldList_valid#">
						<cfif ListFind(Arguments.updateFieldList, field) and FindNoCase("productLanguage", field)>
							<cfinvokeargument Name="#field#" Value="#Arguments[field]#">
						</cfif>
					</cfloop>
				</cfinvoke>
			</cfif>

			<!--- custom fields --->
			<cfif Trim(Arguments.customField) is not "" and ListFind(Arguments.updateFieldList, "customField")>
				<cfinvoke Component="#Application.billingMapping#webservice.WebServiceFunction" Method="insertCustomFieldValues" ReturnVariable="isCustomFieldValuesInserted">
					<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
					<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
					<cfinvokeargument Name="primaryTargetKey" Value="productID">
					<cfinvokeargument Name="targetID" Value="#Arguments.productID#">
					<cfinvokeargument Name="customField" Value="#Arguments.customField#">
				</cfinvoke>
			</cfif>

			<!--- custom status --->
			<cfif ListFind(Arguments.updateFieldList, "statusID")>
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

			<!--- archive field changes --->
			<cfinvoke component="#Application.billingMapping#control.c_fieldArchive.InsertFieldArchive" method="insertFieldArchiveViaTarget" returnVariable="isArchived">
				<cfinvokeargument name="primaryTargetKey" value="productID">
				<cfinvokeargument name="targetID" value="#Arguments.productID#">
				<cfinvokeargument name="userID" value="#qry_selectWebServiceSession.userID#">
				<cfinvokeargument name="qry_selectTarget" value="#qry_selectProduct#">
			</cfinvoke>

			<!--- check for trigger --->
			<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
				<cfinvokeargument name="companyID" value="#qry_selectWebServiceSession.companyID#">
				<cfinvokeargument name="doAction" value="updateProduct">
				<cfinvokeargument name="isWebService" value="True">
				<cfinvokeargument name="doControl" value="product">
				<cfinvokeargument name="primaryTargetKey" value="productID">
				<cfinvokeargument name="targetID" value="#Arguments.productID#">
			</cfinvoke>

			<cfset returnValue = True>
		</cfif>
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

