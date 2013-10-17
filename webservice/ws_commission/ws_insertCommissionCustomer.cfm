<cfinclude template="wslang_commission.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = False>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("insertCommissionCustomer", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_commission.insertCommissionCustomer>
<cfelse>
	<cfset returnValue = True>
	<cfloop Index="field" List="commissionCustomerPrimary">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfset Arguments.companyID = Application.objWebServiceSecurity.ws_checkCompanyPermission(qry_selectWebServiceSession.companyID_author, Arguments.companyID, Arguments.companyID_custom, Arguments.useCustomIDFieldList)>
	<cfif Arguments.companyID lte 0>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_commission.invalidCompany>
	<cfelse>
		<cfif Arguments.userID_custom is "" and (ListFind(Arguments.useCustomIDFieldList, "userID") or ListFind(Arguments.useCustomIDFieldList, "userID_custom"))>
			<cfset Arguments.userID = 0>
		<cfelseif Arguments.userID is not 0>
			<cfset Arguments.userID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.userID, Arguments.userID_custom, Arguments.useCustomIDFieldList, Arguments.companyID)>
			<cfif Arguments.userID lte 0>
				<cfset returnValue = False>
				<cfset returnError = Variables.wslang_commission.invalidUser>
			</cfif>
		</cfif>

		<cfif Arguments.subscriberID_custom is "" and (ListFind(Arguments.useCustomIDFieldList, "subscriberID") or ListFind(Arguments.useCustomIDFieldList, "subscriberID_custom"))>
			<cfset Arguments.subscriberID = 0>
		<cfelseif Arguments.subscriberID is not 0>
			<cfset Arguments.subscriberID = Application.objWebServiceSecurity.ws_checkSubscriberPermission(qry_selectWebServiceSession.companyID_author, Arguments.subscriberID, Arguments.subscriberID_custom, Arguments.useCustomIDFieldList, Arguments.companyID)>
			<cfif Arguments.subscriberID lte 0>
				<cfset returnValue = False>
				<cfset returnError = Variables.wslang_commission.invalidSubscriber>
			</cfif>
		</cfif>

		<cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, Arguments.useCustomIDFieldList)>
		<cfif Arguments.targetID lte 0>
			<cfset returnValue = False>
			<cfset returnError = Variables.wslang_commission.invalidTarget>
		</cfif>

		<cfif returnValue is True>
			<cfset Form = Arguments>
			<cfset Form.commissionCustomerPercent = Arguments.commissionCustomerPercent * 100>
			<cfset Variables.doAction = "insertCommissionCustomer">

			<!--- 
			<cfset qry_selectUserCompanyList_company = QueryNew("userID")>
			<cfset temp = QueryAddRow(qry_selectUserCompanyList_company, 1)>
			<cfset temp = QuerySetCell(qry_selectUserCompanyList_company, "userID", ToString(Arguments.targetID), 1)>

			<cfif Arguments.userID is not 0>
				<cfset qry_selectUserCompanyList_customer = QueryNew("userID")>
				<cfloop Index="theUserID" List="#Arguments.userID#">
					<cfset temp = QueryAddRow(qry_selectUserCompanyList_customer, 1)>
					<cfset temp = QuerySetCell(qry_selectUserCompanyList_customer, "userID", ToString(theUserID))>
				</cfloop>
			</cfif>

			<cfif Arguments.subscriberID is not 0>
				<cfset qry_selectSubscriberList = QueryNew("subscriberID")>
				<cfloop Index="theSubscriberID" List="#Arguments.subscriberID#">
					<cfset temp = QueryAddRow(qry_selectSubscriberList, 1)>
					<cfset temp = QuerySetCell(qry_selectSubscriberList, "subscriberID", ToString(theSubscriberID))>
				</cfloop>
			</cfif>
			--->

			<cfinvoke component="#Application.billingMapping#data.CommissionCustomer" method="maxlength_CommissionCustomer" returnVariable="maxlength_CommissionCustomer" />
			<cfinclude template="../../view/v_commission/lang_insertCommissionCustomer.cfm">
			<cfinclude template="../../control/c_commission/formValidate_insertCommissionCustomer.cfm">

			<cfif isAllFormFieldsOk is False>
				<cfset returnValue = False>
				<cfset returnError = "">
				<cfloop Collection="#errorMessage_fields#" Item="field">
					<cfset returnError = ListAppend(returnError, StructFind(errorMessage_fields, field), Chr(10))>
				</cfloop>
			<cfelse>
				<cfinvoke Component="#Application.billingMapping#data.CommissionCustomer" Method="insertCommissionCustomer" ReturnVariable="isCommissionCustomerInserted">
					<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
					<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
					<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
					<cfinvokeargument Name="userID" Value="#Arguments.userID#">
					<cfinvokeargument Name="subscriberID" Value="#Arguments.subscriberID#">
					<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID("userID")#">
					<cfinvokeargument Name="targetID" Value="#Arguments.targetID#">
					<cfinvokeargument Name="commissionCustomerDateBegin" Value="#Arguments.commissionCustomerDateBegin#">
					<cfinvokeargument Name="commissionCustomerDateEnd" Value="#Arguments.commissionCustomerDateEnd#">
					<cfinvokeargument Name="commissionCustomerStatus" Value="1">
					<cfinvokeargument Name="commissionCustomerPercent" Value="#Arguments.commissionCustomerPercent#">
					<cfinvokeargument Name="commissionCustomerPrimary" Value="#Arguments.commissionCustomerPrimary#">
					<cfinvokeargument Name="commissionCustomerDescription" Value="#Arguments.commissionCustomerDescription#">
				</cfinvoke>
			</cfif><!--- /all fields are valid --->
		</cfif><!--- /all submitted info is seemingly valid --->
	</cfif><!--- /customer company is valid --->
</cfif><!--- /session is valid and has permission --->

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

