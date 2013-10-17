<cfswitch expression="#Variables.doAction#">
<cfcase value="listGroupAffiliate">
	<cfset Variables.doControl = "affiliate">
	<cfset Variables.doAction_new = "listAffiliates">
	<cfset Variables.primaryTargetKey = "affiliateID">
	<cfset Variables.confirm_group = "deleteGroupAffiliate">
</cfcase>
<cfcase value="listGroupCobrand">
	<cfset Variables.doControl = "cobrand">
	<cfset Variables.doAction_new = "listCobrands">
	<cfset Variables.primaryTargetKey = "cobrandID">
	<cfset Variables.confirm_group = "deleteGroupCobrand">
</cfcase>
<cfcase value="listGroupVendor">
	<cfset Variables.doControl = "vendor">
	<cfset Variables.doAction_new = "listVendors">
	<cfset Variables.primaryTargetKey = "vendorID">
	<cfset Variables.confirm_group = "deleteGroupVendor">
</cfcase>
</cfswitch>

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitGroupTargetDelete") and IsDefined("Form.#Variables.primaryTargetKey#")>
	<cfinvoke Component="#Application.billingMapping#data.Group" Method="updateGroupTarget" ReturnVariable="isGroupTargetUpdated">
		<cfinvokeargument Name="groupID" Value="#URL.groupID#">
		<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID(Variables.primaryTargetKey)#">
		<cfinvokeargument Name="targetID" Value="#Form[Variables.primaryTargetKey]#">
		<cfinvokeargument Name="userID" Value="#Session.userID#">
	</cfinvoke>

	<cflocation url="index.cfm?method=group.#URL.action#&groupID=#URL.groupID#&confirm_group=#Variables.confirm_group#" AddToken="No">
</cfif>

<cfset Form.groupID = URL.groupID>

<cfset Variables.doAction = Variables.doAction_new>
<cfinclude template="../control.cfm">
