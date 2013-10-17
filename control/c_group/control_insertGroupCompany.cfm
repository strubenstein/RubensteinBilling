<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitGroupCompanyInsert") and IsDefined("Form.companyID")>
	<cfinvoke Component="#Application.billingMapping#data.Group" Method="insertGroupTarget" ReturnVariable="isGroupTargetInserted">
		<cfinvokeargument Name="groupID" Value="#URL.groupID#">
		<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID("companyID")#">
		<cfinvokeargument Name="targetID" Value="#Form.companyID#">
		<cfinvokeargument Name="userID" Value="#Session.userID#">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID#">
		<cfinvokeargument Name="groupTargetStatus" Value="1">
		<cfinvokeargument Name="isSubmitttedFromGroupControl" Value="True">
	</cfinvoke>

	<cfif IsDefined("Form.companyListRedirect") and Trim(Form.companyListRedirect) is not "">
		<cflocation url="#Form.companyListRedirect#&confirm_group=#URL.action#" AddToken="No">
	<cfelse>
		<cflocation url="index.cfm?method=group.#URL.action#&groupID=#URL.groupID#&confirm_group=#URL.action#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.doControl = "company">
<cfset Variables.doAction = "listCompanies">
<cfinclude template="../control.cfm">
