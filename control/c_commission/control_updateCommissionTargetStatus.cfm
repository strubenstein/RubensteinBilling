<cfset Variables.commissionTargetRedirectURL = Replace(Variables.navCommissionAction, Variables.doAction, "listCommissionTargets", "ONE")>
<cfset Variables.commissionTargetRedirectURL = Replace(Variables.commissionTargetRedirectURL, "&commissionTargetID=#URL.commissionTargetID#", "", "ONE")>

<cfif Not IsDefined("URL.commissionTargetID") or Not Application.fn_IsIntegerPositive(URL.commissionTargetID)>
	<cflocation url="#Variables.commissionTargetRedirectURL#&error_commission=invalidTarget" AddToken="No">
</cfif>

<cfinvoke Component="#Application.billingMapping#data.CommissionTarget" Method="selectCommissionTarget" ReturnVariable="qry_selectCommissionTarget">
	<cfinvokeargument Name="commissionID" Value="#URL.commissionID#">
	<cfinvokeargument Name="commissionTargetWithTargetInfo" Value="True">
</cfinvoke>

<cfset ctRow = ListFind(ValueList(qry_selectCommissionTarget.commissionTargetID), URL.commissionTargetID)>
<cfif ctRow is 0>
	<cflocation url="#Variables.commissionTargetRedirectURL#&error_commission=invalidTarget" AddToken="No">
<cfelseif Variables.doAction is "commissionTargetStatus0" and qry_selectCommissionTarget.commissionTargetStatus[ctRow] is 0>
	<cflocation url="#Variables.commissionTargetRedirectURL#&error_commission=invalidTargetStatus0" AddToken="No">
<cfelseif Variables.doAction is "commissionTargetStatus1" and qry_selectCommissionTarget.commissionTargetStatus[ctRow] is 1>
	<cflocation url="#Variables.commissionTargetRedirectURL#&error_commission=invalidTargetStatus1" AddToken="No">
</cfif>

<cfinvoke Component="#Application.billingMapping#data.CommissionTarget" Method="updateCommissionTarget" ReturnVariable="isCommissionTargetUpdated">
	<cfinvokeargument Name="userID" Value="#Session.userID#">
	<cfinvokeargument Name="commissionTargetID" Value="#URL.commissionTargetID#">
	<cfinvokeargument Name="commissionTargetStatus" Value="#Right(Variables.doAction, 1)#">
</cfinvoke>

<cflocation url="#Variables.commissionTargetRedirectURL#&confirm_commission=#URL.action#" AddToken="No">
