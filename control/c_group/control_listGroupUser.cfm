<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitGroupUserDelete") and IsDefined("Form.userID")>
	<cfinvoke Component="#Application.billingMapping#data.Group" Method="updateGroupTarget" ReturnVariable="isGroupTargetUpdated">
		<cfinvokeargument Name="groupID" Value="#URL.groupID#">
		<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID("userID")#">
		<cfinvokeargument Name="targetID" Value="#Form.userID#">
		<cfinvokeargument Name="userID" Value="#Session.userID#">
	</cfinvoke>

	<cfif IsDefined("Form.userListRedirect") and Trim(Form.userListRedirect) is not "">
		<cflocation url="#Form.userListRedirect#&confirm_group=deleteGroupUser" AddToken="No">
	<cfelse>
		<cflocation url="index.cfm?method=group.#URL.action#&groupID=#URL.groupID#&confirm_group=deleteGroupUser" AddToken="No">
	</cfif>
</cfif>

<cfset Form.groupID = URL.groupID>
<cfset URL.companyID = "">

<cfset Variables.doControl = "user">
<cfset Variables.doAction = "listUsers">
<cfinclude template="../control.cfm">

