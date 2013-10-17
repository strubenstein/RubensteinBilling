<cfinclude template="wslang_salesCommission.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = QueryNew("error")>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("viewSalesCommission", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_salesCommission.viewSalesCommission>
<cfelse>
	<cfif Not Application.fn_IsIntegerList(Arguments.salesCommissionID)>
		<cfset returnValue = QueryNew("error")>
		<cfset returnError = Variables.wslang_salesCommission.invalidSalesCommission>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.SalesCommission" Method="checkSalesCommissionPermission" ReturnVariable="isSalesCommissionPermission">
			<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
			<cfinvokeargument Name="salesCommissionID" Value="#Arguments.salesCommissionID#">
		</cfinvoke>

		<cfif isSalesCommissionPermission is False>
			<cfset returnValue = QueryNew("error")>
			<cfset returnError = Variables.wslang_salesCommission.invalidSalesCommission>
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.SalesCommission" Method="selectSalesCommission" ReturnVariable="qry_selectSalesCommission">
				<cfinvokeargument Name="salesCommissionID" Value="#Arguments.salesCommissionID#">
			</cfinvoke>

			<cfloop Query="qry_selectSalesCommission">
				<cfset primaryTargetKeyArray[qry_selectSalesCommission.CurrentRow] = Application.fn_GetPrimaryTargetKey(qry_selectSalesCommission.primaryTargetID)>
			</cfloop>
			<cfset temp = QueryAddColumn(qry_selectSalesCommission, "primaryTargetKey", primaryTargetKeyArray)>

			<cfset returnValue = qry_selectSalesCommission>
		</cfif><!--- /sales commissions are validated --->
	</cfif><!--- /sales commission is list of integers --->
</cfif><!--- /session is valid and has permission --->

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">


