<cfinclude template="wslang_salesCommission.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = QueryNew("error")>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("viewSalesCommission", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_salesCommission.viewSalesCommission>
<cfelse>
	<cfset isAllFormFieldsOk = True>
	<cfif Not ListFind(Arguments.searchFieldList, "salesCommissionID")
			and Not ListFind(Arguments.searchFieldList, "invoiceID")
			and Not ListFind(Arguments.searchFieldList, "commissionCustomerID")>
		<cfset isAllFormFieldsOk = False>
		<cfset returnError = Variables.wslang_salesCommission.invalidSearch>
	<cfelse>
		<cfif ListFind(Arguments.searchFieldList, "invoiceID")>
			<cfset Arguments.invoiceID = Application.objWebServiceSecurity.ws_checkInvoicePermission(qry_selectWebServiceSession.companyID_author, Arguments.invoiceID, Arguments.invoiceID_custom, Arguments.useCustomIDFieldList)>
			<cfif Arguments.invoiceID lte 0>
				<cfset isAllFormFieldsOk = False>
				<cfset returnError = Variables.wslang_salesCommission.invalidInvoice>
			</cfif>
		</cfif>

		<cfif ListFind(Arguments.searchFieldList, "salesCommissionID")>
			<cfinvoke Component="#Application.billingMapping#data.SalesCommission" Method="checkSalesCommissionPermission" ReturnVariable="isSalesCommissionPermission">
				<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
				<cfinvokeargument Name="salesCommissionID" Value="#Arguments.salesCommissionID#">
			</cfinvoke>

			<cfif isSalesCommissionPermission is False>
				<cfset isAllFormFieldsOk = False>
			</cfif>
		</cfif>

		<cfif ListFind(Arguments.searchFieldList, "commissionCustomerID")>
			<cfif Not Application.fn_IsIntegerList(Arguments.commissionCustomerID)>
				<cfset isAllFormFieldsOk = False>
			<cfelse>
				<cfinvoke Component="#Application.billingMapping#data.CommissionCustomer" Method="selectCommissionCustomerList" ReturnVariable="qry_selectCommissionCustomerList">
					<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
					<cfinvokeargument Name="commissionCustomerID" Value="#Arguments.commissionCustomerID#">
				</cfinvoke>
			</cfif>

			<cfif qry_selectCommissionCustomerList.RecordCount is 0 or qry_selectCommissionCustomerList.RecordCount is not ListLen(Arguments.commissionCustomerID)>
				<cfset isAllFormFieldsOk = False>
			</cfif>
		</cfif>
	</cfif><!--- /at least one criteria is selected --->

	<cfif isAllFormFieldsOk is False>
		<cfset returnValue = QueryNew("error")>
		<cfset returnError = Variables.wslang_salesCommission.invalidSalesCommission>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.SalesCommissionInvoice" Method="selectSalesCommissionInvoice" ReturnVariable="qry_selectSalesCommissionInvoice">
			<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
			<cfloop Index="field" List="salesCommissionID,invoiceID,commissionCustomerID">
				<cfif ListFind(Arguments.searchFieldList, field) and StructKeyExists(Arguments, field) and Arguments[field] is not 0 and Application.fn_IsIntegerList(Arguments[field])>
					<cfinvokeargument Name="#field#" Value="#Arguments[field]#">
				</cfif>
			</cfloop>
		</cfinvoke>

		<cfset returnValue = qry_selectSalesCommissionInvoice>
	</cfif><!--- /at least one valid criteria --->
</cfif><!--- /session is valid and has permission --->

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">


