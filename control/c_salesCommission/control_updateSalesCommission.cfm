<cfif Not IsDefined("Form.isFormSubmitted") or Not IsDefined("Form.submitUpdateSalesCommission")
		or Not IsDefined("Form.salesCommissionStatus") or Not IsDefined("Form.salesCommissionPaid")
		or Not ListFind("0,1", Form.salesCommissionStatus)
		or (Form.salesCommissionPaid is not "" and Not ListFind("0,1", Form.salesCommissionPaid))>
	<cfset URL.error_salesCommission = Variables.doAction>
	<cfinclude template="../../view/v_salesCommission/error_salesCommission.cfm">

<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.SalesCommission" Method="updateSalesCommission" ReturnVariable="isSalesCommissionUpdated">
		<cfinvokeargument Name="salesCommissionID" Value="#URL.salesCommissionID#">
		<cfinvokeargument Name="userID_author" Value="#Session.userID#">
		<cfinvokeargument Name="salesCommissionStatus" Value="#Form.salesCommissionStatus#">
		<cfinvokeargument Name="salesCommissionPaid" Value="#Form.salesCommissionPaid#">
		<cfif Form.salesCommissionPaid is "">
			<cfinvokeargument Name="salesCommissionDatePaid" Value="">
		<cfelseif Form.salesCommissionPaid is not qry_selectSalesCommission.salesCommissionPaid>
			<cfinvokeargument Name="salesCommissionDatePaid" Value="#Now()#">
		</cfif>
	</cfinvoke>

	<cflocation url="index.cfm?method=salesCommission.viewSalesCommission&salesCommissionID=#URL.salesCommissionID#&confirm_salesCommission=#Variables.doAction#" AddToken="No">
</cfif>
