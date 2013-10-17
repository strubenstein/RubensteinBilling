<cfif Not Application.fn_IsIntegerNonNegative(URL.payflowID)>
	<cflocation url="index.cfm?method=#URL.control#.listPayflows#Variables.urlParameters#&error_payflow=invalidPayflow" AddToken="No">
<cfelseif URL.payflowID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Payflow" Method="checkPayflowPermission" ReturnVariable="isPayflowPermission">
		<cfinvokeargument Name="payflowID" Value="#URL.payflowID#">
		<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
	</cfinvoke>

	<cfif isPayflowPermission is False>
		<cflocation url="index.cfm?method=#URL.control#.listPayflows#Variables.urlParameters#&error_payflow=invalidPayflow" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Payflow" Method="selectPayflow" ReturnVariable="qry_selectPayflow">
			<cfinvokeargument Name="payflowID" Value="#URL.payflowID#">
		</cfinvoke>
	</cfif>
<cfelseif Not ListFind("listPayflows,insertPayflow,insertPayflowCompany,viewPayflowCompany,insertPayflowGroup,viewPayflowGroup,insertPayflowTarget,viewPayflowTarget", Variables.doAction)>
	<cflocation url="index.cfm?method=#URL.control#.listPayflows#Variables.urlParameters#&error_payflow=noPayflow" AddToken="No">
</cfif>
