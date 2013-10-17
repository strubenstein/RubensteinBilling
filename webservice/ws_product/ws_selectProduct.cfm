<cfinclude template="wslang_product.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = QueryNew("error")>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("viewProduct", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_product.viewProduct>
<cfelse>
	<cfset Arguments.productID = Application.objWebServiceSecurity.ws_checkProductPermission(qry_selectWebServiceSession.companyID_author, Arguments.productID, Arguments.productID_custom, Arguments.useCustomIDFieldList)>

	<cfif ListLen(Arguments.productID) is 1 and Arguments.productID lte 0>
		<cfset returnValue = QueryNew("error")>
		<cfset returnError = Variables.wslang_product.invalidProduct>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Product" Method="selectProduct" ReturnVariable="qry_selectProduct">
			<cfinvokeargument Name="productID" Value="#Arguments.productID#">
			<cfinvokeargument Name="languageID" Value="">
			<cfinvokeargument Name="returnProductLanguage" Value="True">
		</cfinvoke>

		<cfset returnValue = qry_selectProduct>
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

