<cfinclude template="wslang_invoice.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = -1>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("insertInvoiceLineItem", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = -1>
	<cfset returnError = Variables.wslang_invoice.insertInvoiceLineItem>
<cfelse>
	<cfloop Index="field" List="invoiceLineItemDescriptionHtml">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfset returnValue = 0>
	<!--- validate invoice --->
	<cfset Arguments.invoiceID = Application.objWebServiceSecurity.ws_checkInvoicePermission(qry_selectWebServiceSession.companyID_author, Arguments.invoiceID, Arguments.invoiceID_custom, Arguments.useCustomIDFieldList)>
	<cfif Arguments.invoiceID lte 0>
		<cfset returnValue = -1>
		<cfset returnError = Variables.wslang_invoice.invalidInvoice>
	<cfelse>
		<!--- validate contact user(s) --->
		<cfif ((Arguments.userID is 0 or Arguments.userID is "") and Not ListFind(Arguments.useCustomIDFieldList, "userID") and Not ListFind(Arguments.useCustomIDFieldList, "userID_custom"))
				or (Arguments.userID_custom is "" and (ListFind(Arguments.useCustomIDFieldList, "userID") or ListFind(Arguments.useCustomIDFieldList, "userID_custom")))>
			<cfset Arguments.userID = 0>
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoice" ReturnVariable="qry_selectInvoice">
				<cfinvokeargument Name="invoiceID" Value="#Arguments.invoiceID#">
			</cfinvoke>

			<cfset Arguments.userID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.userID, Arguments.userID_custom, Arguments.useCustomIDFieldList, qry_selectInvoice.companyID)>
			<cfif Arguments.userID is not 0>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_subscription.invalidUser>
			<cfelse>
				<!--- <cfset qry_selectUserCompanyList_company = QueryNew("userID")> --->
				<cfloop Index="thisUserID" List="#Arguments.userID#">
					<cfset temp = QueryAddRow(qry_selectUserCompanyList_company, 1)>
					<cfset temp = QuerySetCell(qry_selectUserCompanyList_company, "userID", ToString(thisUserID))>
				</cfloop>
			</cfif>
		</cfif>

		<cfif returnValue is 0>
			<cfinclude template="wsact_insertInvoiceLineItem.cfm">
		</cfif>
	</cfif>
</cfif><!--- /logged in and permission --->

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

