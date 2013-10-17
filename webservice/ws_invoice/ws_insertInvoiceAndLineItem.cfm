<cfinclude template="wslang_invoice.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValueXml = "">
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("insertInvoiceLineItem", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValueXml = "">
	<cfset returnError = Variables.wslang_invoice.insertInvoiceLineItem>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("insertInvoice", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValueXml = "">
	<cfset returnError = Variables.wslang_invoice.insertInvoice>
<cfelse>
	<cfloop Index="field" List="invoiceStatus,invoiceClosed,invoiceCompleted,invoiceSent,invoicePaid,invoiceLineItemDescriptionHtml">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfset returnValue = 0>
	<cfset returnValueXml = "">
	<cfset invoiceClosed_orig = Arguments.invoiceClosed>
	<cfset invoiceCompleted_orig = Arguments.invoiceCompleted>

	<cfset Arguments.userID = Arguments.userID_invoice>
	<cfset Arguments.userID_custom = Arguments.userID_invoice_custom>
	<cfif ListFind(Arguments.useCustomIDFieldList, "userID_invoice") or ListFind(Arguments.useCustomIDFieldList, "userID_invoice_custom")>
		<cfset Arguments.useCustomIDFieldList = ListAppend(Arguments.useCustomIDFieldList, "userID_invoice")>
	</cfif>

	<!--- Determine company, user and subscriber --->
	<cfinclude template="wsact_insertInvoice_determineCompany.cfm">

	<cfif returnValue is not -1>
		<!--- Determine whether an open invoice already exists for this company/user/subscriber --->
		<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoiceList" ReturnVariable="qry_selectInvoiceList" >
			<cfinvokeargument name="companyID_author" value="#qry_selectWebServiceSession.companyID_author#">
			<cfinvokeargument name="invoiceStatus" value="1">
			<cfinvokeargument name="invoiceClosed" value="0">
			<cfinvokeargument name="companyID" value="#Arguments.companyID#">
			<cfinvokeargument name="userID" value="#Arguments.userID#">
			<cfinvokeargument name="subscriberID" value="#Arguments.subscriberID#">
			<cfinvokeargument Name="queryOrderBy" Value="invoiceDateCreated">
		</cfinvoke>

		<!--- if no invoices, create new invoice. if 1, use it. if more than 1, return error. --->
		<cfif qry_selectInvoiceList.RecordCount gt 1>
			<cfset returnError = Variables.wslang_invoice.openInvoices>
		<cfelse>
			<cfif qry_selectInvoiceList.RecordCount is 1>
				<cfset Arguments.invoiceID = qry_selectInvoiceList.invoiceID>
			<cfelseif Arguments.invoiceCompleted is 1>
				<cfset Arguments.invoiceID = -1>
				<cfset returnError = Variables.wslang_invoice.invoiceIsClosed>
			<cfelse>
				<cfset Arguments.invoiceID = 0>
				<cfset Arguments.invoiceClosed = 0>
				<cfset Arguments.invoiceCompleted = 0>
				<cfinclude template="wsact_insertInvoice_validateInsert.cfm">
			</cfif>

			<cfif Application.fn_IsIntegerPositive(Arguments.invoiceID)>
				<cfset returnValueXml = returnValueXml & "<invoiceID>#Arguments.invoiceID#</invoiceID>">
				<cfset returnValue = 0>

				<!--- validate contact user(s) --->
				<cfif ((Arguments.userID_invoiceLineItem is 0 or Arguments.userID_invoiceLineItem is "") and Not ListFind(Arguments.useCustomIDFieldList, "userID_invoiceLineItem") and Not ListFind(Arguments.useCustomIDFieldList, "userID_invoiceLineItem_custom"))
						or (Arguments.userID_invoiceLineItem_custom is "" and (ListFind(Arguments.useCustomIDFieldList, "userID") or ListFind(Arguments.useCustomIDFieldList, "userID_invoiceLineItem_custom")))>
					<cfset Arguments.userID = 0>
				<cfelse>
					<cfset Arguments.userID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.userID_invoiceLineItem, Arguments.userID_invoiceLineItem_custom, Arguments.useCustomIDFieldList, Arguments.companyID)>
					<cfif Arguments.userID is not 0>
						<cfset returnValue = -1>
						<cfset returnError = Variables.wslang_invoice.invalidUser>
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

				<cfif returnValue is not -1>
					<cfset returnValueXml = returnValueXml & "<invoiceLineItemID>#returnValue#</invoiceLineItemID>">

					<cfif invoiceClosed_orig is 1>
						<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="updateInvoice" ReturnVariable="isInvoiceUpdated">
							<cfinvokeargument Name="invoiceID" Value="#Arguments.invoiceID#">
							<cfswitch expression="#invoiceClosed_orig#:#invoiceCompleted_orig#">
							<cfcase value="1:0">
								<cfinvokeargument Name="invoiceClosed" Value="1">
								<cfinvokeargument Name="invoiceCompleted" Value="0">
								<cfinvokeargument Name="invoiceDateClosed" Value="#Now()#">
							</cfcase>
							<cfcase value="1:1">
								<cfinvokeargument Name="invoiceClosed" Value="1">
								<cfinvokeargument Name="invoiceCompleted" Value="1">
								<cfinvokeargument Name="invoiceDateClosed" Value="#Now()#">
								<cfinvokeargument Name="invoiceDateCompleted" Value="#Now()#">
							</cfcase>
							</cfswitch>
						</cfinvoke>
					</cfif><!--- if necessary, close invoice --->
				</cfif><!--- line item successfully created --->
			</cfif><!--- invoice successfully selected or created --->
		</cfif><!--- 0 or 1 open invoice existed for company/user/subscriber (not multiple) --->
	</cfif><!--- company/user/subscriber is valid --->
</cfif><!--- /logged in and permission --->

<cfset returnValue = "<xml>" & returnValueXml & "</xml>">

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

