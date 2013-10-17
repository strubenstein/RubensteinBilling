<cfswitch expression="#Variables.doAction#">
<cfcase value="insertGroupAffiliate">
	<cfset Variables.doControl = "affiliate">
	<cfset Variables.doAction_new = "listAffiliates">
	<cfset Variables.primaryTargetKey = "affiliateID">
	<cfset Variables.confirm_group = "insertGroupAffiliate">
</cfcase>
<cfcase value="insertGroupCobrand">
	<cfset Variables.doControl = "cobrand">
	<cfset Variables.doAction_new = "listCobrands">
	<cfset Variables.primaryTargetKey = "cobrandID">
	<cfset Variables.confirm_group = "insertGroupCobrand">
</cfcase>
<cfcase value="insertGroupVendor">
	<cfset Variables.doControl = "vendor">
	<cfset Variables.doAction_new = "listVendors">
	<cfset Variables.primaryTargetKey = "vendorID">
	<cfset Variables.confirm_group = "insertGroupVendor">
</cfcase>
</cfswitch>

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitGroupTargetInsert") and IsDefined("Form.#Variables.primaryTargetKey#")>
	<cfinvoke Component="#Application.billingMapping#data.Group" Method="insertGroupTarget" ReturnVariable="isGroupTargetInserted">
		<cfinvokeargument Name="groupID" Value="#URL.groupID#">
		<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID(Variables.primaryTargetKey)#">
		<cfinvokeargument Name="targetID" Value="#Form[Variables.primaryTargetKey]#">
		<cfinvokeargument Name="userID" Value="#Session.userID#">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID#">
		<cfinvokeargument Name="groupTargetStatus" Value="1">
		<cfinvokeargument Name="isSubmitttedFromGroupControl" Value="True">
	</cfinvoke>

	<cflocation url="index.cfm?method=group.#URL.action#&groupID=#URL.groupID#&confirm_group=#Variables.confirm_group#" AddToken="No">
</cfif>

<cfset Variables.doAction = Variables.doAction_new>
<cfinclude template="../control.cfm">
