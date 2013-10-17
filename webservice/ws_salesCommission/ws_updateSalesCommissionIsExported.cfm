<cfinclude template="wslang_salesCommission.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = False>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("exportSalesCommissions", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_salesCommission.exportSalesCommissions>
<cfelse>
	<cfif Not Application.fn_IsIntegerList(Arguments.salesCommissionID)>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_salesCommission.invalidSalesCommission>
	<cfelseif Arguments.salesCommissionIsExported is not "" and Not ListFind("0,1", Arguments.salesCommissionIsExported)>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_salesCommission.exportOption>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.SalesCommission" Method="checkSalesCommissionPermission" ReturnVariable="isSalesCommissionPermission">
			<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
			<cfinvokeargument Name="salesCommissionID" Value="#Arguments.salesCommissionID#">
		</cfinvoke>

		<cfif isSalesCommissionPermission is False>
			<cfset returnValue = False>
			<cfset returnError = Variables.wslang_salesCommission.invalidSalesCommission>
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.SalesCommission" Method="updateSalesCommissionIsExported" ReturnVariable="isSalesCommissionExported">
				<cfinvokeargument Name="salesCommissionID" Value="#Arguments.salesCommissionID#">
				<cfinvokeargument Name="salesCommissionIsExported" Value="#Arguments.salesCommissionIsExported#">
			</cfinvoke>

			<cfset returnValue = True>
		</cfif>
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

