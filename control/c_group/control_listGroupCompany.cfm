<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitGroupCompanyDelete") and IsDefined("Form.companyID")>
	<cfinvoke Component="#Application.billingMapping#data.Group" Method="updateGroupTarget" ReturnVariable="isGroupTargetUpdated">
		<cfinvokeargument Name="groupID" Value="#URL.groupID#">
		<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID("companyID")#">
		<cfinvokeargument Name="targetID" Value="#Form.companyID#">
		<cfinvokeargument Name="userID" Value="#Session.userID#">
	</cfinvoke>

	<cfif IsDefined("Form.companyListRedirect") and Trim(Form.companyListRedirect) is not "">
		<cflocation url="#Form.companyListRedirect#&confirm_group=deleteGroupCompany" AddToken="No">
	<cfelse>
		<cflocation url="index.cfm?method=group.#URL.action#&groupID=#URL.groupID#&confirm_group=deleteGroupCompany" AddToken="No">
	</cfif>
</cfif>

<cfset Form.groupID = URL.groupID>
<cfset URL.companyID = 0>

<cfset Variables.doControl = "company">
<cfset Variables.doAction = "listCompanies">
<cfinclude template="../control.cfm">
