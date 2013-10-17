<cfinclude template="wslang_salesCommission.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfset returnValue = 0>
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = -1>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("insertSalesCommission", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = -1>
	<cfset returnError = Variables.wslang_salesCommission.insertSalesCommission>
<cfelse>
	<cfif Arguments.invoiceID is 0 and Not ListFind(Arguments.useCustomIDFieldList, "invoiceID") and Not ListFind(Arguments.useCustomIDFieldList, "invoiceID_custom")>
		<cfset Arguments.invoiceID = Application.objWebServiceSecurity.ws_checkInvoicePermission(qry_selectWebServiceSession.companyID_author, Arguments.invoiceID, Arguments.invoiceID_custom, Arguments.useCustomIDFieldList)>
		<cfif Arguments.invoiceID is 0>
			<cfset returnValue = -1>
			<cfset returnError = Variables.wslang_salesCommission.invalidInvoice>
		</cfif>
	</cfif>

	<cfswitch expression="#Arguments.primaryTargetKey#">
	<cfcase value="affiliateID"><cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkAffiliatePermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, Arguments.useCustomIDFieldList)></cfcase>
	<cfcase value="cobrandID"><cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkCobrandPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, Arguments.useCustomIDFieldList)></cfcase>
	<cfcase value="userID"><cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, Arguments.useCustomIDFieldList)></cfcase>
	<cfcase value="vendorID"><cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkVendorPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, Arguments.useCustomIDFieldList)></cfcase>
	<cfdefaultcase><cfset returnValue = -1></cfdefaultcase>
	</cfswitch>

	<cfif Arguments.targetID is 0 or returnValue is -1>
		<cfset returnValue = -1>
		<cfset returnError = Variables.wslang_salesCommission.invalidTarget>
	<cfelse>
		<cfset Form = Arguments>
		<cfset URL.control = "webservice">

		<cfinvoke component="#Application.billingMapping#data.SalesCommission" method="maxlength_SalesCommission" returnVariable="maxlength_SalesCommission" />
		<cfinclude template="../../view/v_salesCommission/lang_insertSalesCommission.cfm">
		<cfinclude template="../../control/c_salesCommission/formValidate_insertSalesCommission.cfm">

		<cfif isAllFormFieldsOk is False>
			<cfset returnValue = -1>
			<cfset returnError = "">
			<cfloop Collection="#errorMessage_fields#" Item="field">
				<cfset returnError = ListAppend(returnError, StructFind(errorMessage_fields, field), Chr(10))>
			</cfloop>
		<cfelse>
			<cfset commissionCustomerID = 0>
			<cfif Arguments.invoiceID is not 0 and Arguments.primaryTargetKey is "userID">
				<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoice" ReturnVariable="qry_selectInvoice">
					<cfinvokeargument Name="invoiceID" Value="#Arguments.invoiceID#">
				</cfinvoke>

				<cfinvoke Component="#Application.billingMapping#data.CommissionCustomer" Method="selectCommissionCustomerList" ReturnVariable="qry_selectCommissionCustomerList">
					<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
					<cfinvokeargument Name="companyID" Value="#qry_selectInvoice.companyID#">
					<cfinvokeargument Name="commissionCustomerStatus" Value="1">
					<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID(Form.primaryTargetKey)#">
					<cfinvokeargument Name="targetID" Value="#Arguments.targetID#">
				</cfinvoke>

				<cfif qry_selectCommissionCustomerList.RecordCount is not 0>
					<cfset commissionCustomerID = qry_selectCommissionCustomerList.commissionCustomerID[1]>
				</cfif>
			</cfif>

			<cfinvoke Component="#Application.billingMapping#data.SalesCommission" Method="insertSalesCommission" ReturnVariable="newSalesCommissionID">
				<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
				<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
				<cfinvokeargument Name="commissionID" Value="0">
				<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID(Form.primaryTargetKey)#">
				<cfinvokeargument Name="targetID" Value="#Arguments.targetID#">
				<cfinvokeargument Name="salesCommissionAmount" Value="#Arguments.salesCommissionAmount#">
				<cfinvokeargument Name="salesCommissionFinalized" Value="1">
				<cfinvokeargument Name="salesCommissionDateFinalized" Value="#Now()#">
				<cfinvokeargument Name="salesCommissionPaid" Value="#Arguments.salesCommissionPaid#">
				<cfif ListFind("0,1", Form.salesCommissionPaid)>
					<cfinvokeargument Name="salesCommissionDatePaid" Value="#Now()#">
				<cfelse>
					<cfinvokeargument Name="salesCommissionDatePaid" Value="">
				</cfif>
				<cfinvokeargument Name="salesCommissionStatus" Value="1">
				<cfinvokeargument Name="salesCommissionManual" Value="1">
				<cfinvokeargument Name="salesCommissionDateBegin" Value="#Arguments.salesCommissionDateBegin#">
				<cfinvokeargument Name="salesCommissionDateEnd" Value="#Arguments.salesCommissionDateEnd#">
				<cfinvokeargument Name="salesCommissionBasisTotal" Value="#Arguments.salesCommissionBasisTotal#">
				<cfinvokeargument Name="salesCommissionBasisQuantity" Value="#Form.salesCommissionBasisQuantity#">
				<cfinvokeargument Name="salesCommissionCalculatedAmount" Value="#Arguments.salesCommissionAmount#">
				<cfinvokeargument Name="commissionStageID" Value="0">
				<cfinvokeargument Name="commissionVolumeDiscountID" Value="0">
			</cfinvoke>

			<cfif Arguments.invoiceID is not 0>
				<cfinvoke Component="#Application.billingMapping#data.SalesCommissionInvoice" Method="insertSalesCommissionInvoice" ReturnVariable="isSalesCommissionInvoiceInserted">
					<cfinvokeargument Name="salesCommissionID" Value="#newSalesCommissionID#">
					<cfinvokeargument Name="invoiceID" Value="#Arguments.invoiceID#">
					<cfinvokeargument Name="invoiceLineItemID" Value="0">
					<cfinvokeargument Name="salesCommissionInvoiceAmount" Value="0">
					<cfinvokeargument Name="salesCommissionInvoiceQuantity" Value="0">
					<cfinvokeargument Name="commissionCustomerID" Value="#commissionCustomerID#">
				</cfinvoke>
			</cfif>

			<cfset returnValue = newSalesCommissionID>
		</cfif><!--- /all form fields are valid --->
	</cfif><!--- /invoice and target are validated --->
</cfif><!--- /session is valid and has permission --->

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

