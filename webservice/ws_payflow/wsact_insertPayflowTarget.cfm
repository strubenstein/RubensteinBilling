<!--- 
INPUT:
Variables.primaryTargetKey
Variables.targetID
Arguments.payflowID
Arguments.payflowID_custom
Arguments.useCustomIDFieldList
--->

<cfif Not IsDefined("Variables.wslang_payflow")>
	<cfinclude template="wslang_payflow.cfm">
</cfif>

<cfif Application.fn_GetPrimaryTargetID(Arguments.primaryTargetKey) is 0>
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_payflow.invalidTargetType>
<cfelseif Not Application.fn_IsIntegerPositive(Arguments.targetID)>
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_payflow.invalidTarget>
<cfelse>
	<cfset Arguments.payflowID = Application.objWebServiceSecurity.ws_checkPayflowPermission(qry_selectWebServiceSession.companyID_author, Arguments.payflowID, Arguments.payflowID_custom, Arguments.useCustomIDFieldList)>

	<cfif Arguments.payflowID is 0>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_payflow.invalidPayflow>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.PayflowTarget" Method="selectPayflowTarget" ReturnVariable="qry_selectPayflowTarget">
			<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID(Arguments.primaryTargetKey)#">
			<cfinvokeargument Name="targetID" Value="#Arguments.targetID#">
			<cfinvokeargument Name="payflowID" Value="#Arguments.payflowID#">
		</cfinvoke>

		<cfif qry_selectPayflowTarget.RecordCount is not 0>
			<cfinvoke Component="#Application.billingMapping#data.PayflowTarget" Method="updatePayflowTarget" ReturnVariable="isPayflowTargetUpdated">
				<cfinvokeargument Name="payflowTargetID" Value="#qry_selectPayflowTarget.payflowTargetID#">
				<cfinvokeargument Name="userID" Value="#qry_selectWebServiceSession.userID#">
				<cfinvokeargument Name="payflowTargetStatus" Value="1">
				<cfinvokeargument Name="payflowTargetDateBegin" Value="#Now()#">
				<cfinvokeargument Name="payflowTargetDateEnd" Value="">
			</cfinvoke>
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.PayflowTarget" Method="insertPayflowTarget" ReturnVariable="isPayflowTargetInserted">
				<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID(Arguments.primaryTargetKey)#">
				<cfinvokeargument Name="targetID" Value="#Arguments.targetID#">
				<cfinvokeargument Name="userID" Value="#qry_selectWebServiceSession.userID#">
				<cfinvokeargument Name="payflowID" Value="#Arguments.payflowID#">
				<cfinvokeargument Name="payflowTargetStatus" Value="1">
				<cfinvokeargument Name="payflowTargetDateBegin" Value="#Now()#">
				<cfinvokeargument Name="payflowTargetDateEnd" Value="">
			</cfinvoke>
		</cfif>

		<cfset returnValue = True>
	</cfif>
</cfif>

