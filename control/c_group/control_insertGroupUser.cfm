<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitGroupUserInsert") and IsDefined("Form.userID")>
	<cfinvoke Component="#Application.billingMapping#data.Group" Method="insertGroupTarget" ReturnVariable="isGroupTargetInserted">
		<cfinvokeargument Name="groupID" Value="#URL.groupID#">
		<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID("userID")#">
		<cfinvokeargument Name="targetID" Value="#Form.userID#">
		<cfinvokeargument Name="userID" Value="#Session.userID#">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID#">
		<cfinvokeargument Name="groupTargetStatus" Value="1">
		<cfinvokeargument Name="isSubmitttedFromGroupControl" Value="True">
	</cfinvoke>

	<cfif IsDefined("Form.userListRedirect") and Trim(Form.userListRedirect) is not "">
		<cflocation url="#Form.userListRedirect#&confirm_group=#URL.action#" AddToken="No">
	<cfelse>
		<cflocation url="index.cfm?method=group.#Variables.doAction#&groupID=#URL.groupID#&confirm_group=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Form.groupID = URL.groupID>
<cfset URL.companyID = "">

<cfset Variables.doControl = "user">
<cfset Variables.doAction = "listUsers">
<cfinclude template="../control.cfm">

