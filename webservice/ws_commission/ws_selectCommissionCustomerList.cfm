<cfinclude template="wslang_commission.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = QueryNew("error")>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("viewCommissionCustomer", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_commission.viewCommissionCustomer>
<cfelseif Not ListFind(Arguments.searchFieldList, "companyID") and Not ListFind(Arguments.searchFieldList, "userID")
		and Not ListFind(Arguments.searchFieldList, "subscriberID") and Not ListFind(Arguments.searchFieldList, "targetID")>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_commission.noSearchField>
<cfelse>
	<cfloop Index="field" List="commissionCustomerPrimary">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfif ListFind(Arguments.searchFieldList, "companyID")>
		<cfset Arguments.companyID = Application.objWebServiceSecurity.ws_checkCompanyPermission(qry_selectWebServiceSession.companyID_author, Arguments.companyID, Arguments.companyID_custom, Arguments.useCustomIDFieldList)>
		<cfif Arguments.companyID lte 0>
			<cfset isAllFormFieldsOk = False>
			<cfset returnError = Variables.wslang_commission.invalidCompany>
		</cfif>
	</cfif>

	<cfif ListFind(Arguments.searchFieldList, "userID")>
		<cfset Arguments.userID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.userID, Arguments.userID_custom, Arguments.useCustomIDFieldList)>
		<cfif Arguments.userID lte 0>
			<cfset isAllFormFieldsOk = False>
			<cfset returnError = Variables.wslang_commission.invalidUser>
		</cfif>
	</cfif>

	<cfif ListFind(Arguments.searchFieldList, "subscriberID")>
		<cfset Arguments.subscriberID = Application.objWebServiceSecurity.ws_checkSubscriberPermission(qry_selectWebServiceSession.companyID_author, Arguments.subscriberID, Arguments.subscriberID_custom, Arguments.useCustomIDFieldList)>
		<cfif Arguments.subscriberID lte 0>
			<cfset isAllFormFieldsOk = False>
			<cfset returnError = Variables.wslang_commission.invalidSubscriber>
		</cfif>
	</cfif>

	<cfif ListFind(Arguments.searchFieldList, "targetID")>
		<cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, Arguments.useCustomIDFieldList)>
		<cfif Arguments.targetID lte 0>
			<cfset isAllFormFieldsOk = False>
			<cfset returnError = Variables.wslang_commission.invalidTarget>
		</cfif>
	</cfif>

	<cfif ListFind(Arguments.searchFieldList, "commissionCustomerPrimary") and Not ListFind("0,1", Arguments.commissionCustomerPrimary)>
		<cfset isAllFormFieldsOk = False>
		<cfset returnError = Variables.wslang_commission.commissionCustomerPrimary>
	</cfif>

	<cfif isAllFormFieldsOk is False>
		<cfset returnValue = QueryNew("error")>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.CommissionCustomer" Method="selectCommissionCustomerList" ReturnVariable="qry_selectCommissionCustomerList">
			<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
			<cfinvokeargument Name="commissionCustomerStatus" Value="1">
			<cfloop Index="field" List="companyID,userID,subscriberID,targetID,commissionCustomerPrimary">
				<cfif ListFind(Arguments.searchFieldList, field)>
					<cfinvokeargument Name="#field#" Value="#Arguments[field]#">
				</cfif>
			</cfloop>
			<cfif ListFind(Arguments.searchFieldList, "targetID")>
				<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID("userID")#">
			</cfif>
		</cfinvoke>

		<cfloop Query="qry_selectCommissionCustomerList">
			<cfset primaryTargetKeyArray[qry_selectCommissionCustomerList.CurrentRow] = Application.fn_GetPrimaryTargetKey(qry_selectCommissionCustomerList.primaryTargetID)>
		</cfloop>
		<cfset temp = QueryAddColumn(qry_selectCommissionCustomerList, "primaryTargetKey", primaryTargetKeyArray)>

		<cfset returnValue = qry_selectCommissionCustomerList>
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">
