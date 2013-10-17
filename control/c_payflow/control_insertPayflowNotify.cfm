<!--- 
Steps to add a user notification option:
1. Select user(s) to notify
2. Display in form to select options
3. Insert/update as necessary
--->

<!--- get admin users who are notified --->
<cfinvoke Component="#Application.billingMapping#data.PayflowNotify" Method="selectPayflowNotifyList" ReturnVariable="qry_selectPayflowNotifyList">
	<cfinvokeargument Name="payflowID" Value="#URL.payflowID#">
</cfinvoke>

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.userID")>
	<cfset Variables.payflowUserID_list = Form.userID>
	<cfinclude template="control_updatePayflowNotify.cfm">
<cfelse>
	<cfset Form.userID_not = ValueList(qry_selectPayflowNotifyList.userID)>
	<cfif Not IsDefined("Form.isFormSubmitted")>
		<cfset Form.returnMyCompanyUsersOnly = 1>
	</cfif>

	<cfset Variables.doAction = "listUsers">
	<cfset Variables.doControl = "user">
	<cfinclude template="../control.cfm">
</cfif>

