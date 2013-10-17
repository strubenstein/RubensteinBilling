<cfinclude template="wslang_salesCommission.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = False>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("updateSalesCommission", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_salesCommission.updateSalesCommission>
<cfelse>
	<cfset returnValue = True>
	<cfloop Index="field" List="salesCommissionPaid,salesCommissionStatus">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfif Not Application.fn_IsIntegerList(Arguments.salesCommissionID)>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_salesCommission.invalidSalesCommission>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.SalesCommission" Method="checkSalesCommissionPermission" ReturnVariable="isSalesCommissionPermission">
			<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
			<cfinvokeargument Name="salesCommissionID" Value="#Arguments.salesCommissionID#">
		</cfinvoke>

		<cfif isSalesCommissionPermission is False>
			<cfset returnValue = False>
			<cfset returnError = Variables.wslang_salesCommission.invalidSalesCommission>
		</cfif>
	</cfif>

	<cfif (Not ListFind(Arguments.updateFieldList, "salesCommissionPaid") and Not ListFind(Arguments.updateFieldList, "salesCommissionStatus"))
			or (ListFind(Arguments.updateFieldList, "salesCommissionPaid") and Arguments.salesCommissionPaid is not "" and Not ListFind("0,1", Arguments.salesCommissionPaid))
			or (ListFind(Arguments.updateFieldList, "salesCommissionStatus") and Not ListFind("0,1", Arguments.salesCommissionStatus))>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_salesCommission.salesCommissionOptions>
	</cfif>

	<cfif returnValue is True>
		<cfinvoke Component="#Application.billingMapping#data.SalesCommission" Method="updateSalesCommission" ReturnVariable="isSalesCommissionUpdated">
			<cfinvokeargument Name="salesCommissionID" Value="#Arguments.salesCommissionID#">
			<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
			<cfif ListFind(Arguments.updateFieldList, "salesCommissionStatus")>
				<cfinvokeargument Name="salesCommissionStatus" Value="#Arguments.salesCommissionStatus#">
			</cfif>
			<cfif ListFind(Arguments.updateFieldList, "salesCommissionPaid")>
				<cfinvokeargument Name="salesCommissionPaid" Value="#Arguments.salesCommissionPaid#">
				<cfif ListFind("0,1", Arguments.salesCommissionPaid)>
					<cfinvokeargument Name="salesCommissionDatePaid" Value="#Now()#">
				<cfelse>
					<cfinvokeargument Name="salesCommissionDatePaid" Value="">
				</cfif>
			</cfif>
		</cfinvoke>
	</cfif><!--- /sales commission and options are validated --->
</cfif><!--- /session is valid and has permission --->

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

