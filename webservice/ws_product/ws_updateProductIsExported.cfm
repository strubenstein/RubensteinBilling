<cfinclude template="wslang_product.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = False>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("exportProducts", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_product.exportProducts>
<cfelse>
	<cfset Arguments.productID = Application.objWebServiceSecurity.ws_checkProductPermission(qry_selectWebServiceSession.companyID_author, Arguments.productID, Arguments.productID_custom, Arguments.useCustomIDFieldList)>

	<cfif Arguments.productID lte 0>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_product.invalidProduct>
	<cfelseif Arguments.productIsExported is not "" and Not ListFind("0,1", Arguments.productIsExported)>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_product.exportOption>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Product" Method="updateProductIsExported" ReturnVariable="isProductExported">
			<cfinvokeargument Name="productID" Value="#Arguments.productID#">
			<cfinvokeargument Name="productIsExported" Value="#Arguments.productIsExported#">
		</cfinvoke>

		<cfset returnValue = True>
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

