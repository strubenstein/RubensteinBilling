<cfset primaryTargetID_group = Application.fn_GetPrimaryTargetID("groupID")>

<cfinvoke Component="#Application.billingMapping#data.CommissionTarget" Method="selectCommissionTarget" ReturnVariable="qry_selectCommissionTarget">
	<cfinvokeargument Name="commissionID" Value="#URL.commissionID#">
	<cfinvokeargument Name="commissionTargetWithTargetInfo" Value="False">
	<cfinvokeargument Name="primaryTargetID" Value="#primaryTargetID_group#">
	<cfinvokeargument Name="commissionTargetStatus" Value="1">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Group" Method="selectGroupList" ReturnVariable="qry_selectGroupList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
</cfinvoke>

<cfset Variables.formAction = Variables.navCommissionAction><!---  & "&commissionID=" & URL.commissionID --->
<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitCommissionTarget") and IsDefined("Form.groupID")>
	<cfloop Index="loopGroupID" List="#Form.groupID#">
		<cfif Not ListFind(ValueList(qry_selectCommissionTarget.targetID), loopGroupID)>
			<cfinvoke Component="#Application.billingMapping#data.CommissionTarget" Method="insertCommissionTarget" ReturnVariable="isCommissionTargetInserted">
				<cfinvokeargument Name="commissionID" Value="#URL.commissionID#">
				<cfinvokeargument Name="primaryTargetID" Value="#primaryTargetID_group#">
				<cfinvokeargument Name="targetID" Value="#loopGroupID#">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="commissionTargetStatus" Value="1">
			</cfinvoke>
		</cfif>
	</cfloop>

	<cflocation url="index.cfm?method=#URL.method#&commissionID=#URL.commissionID##Variables.urlParameters#&confirm_commission=#Variables.doAction#" AddToken="No">
</cfif>

<cfinclude template="../../view/v_commission/lang_insertCommissionTargetGroup.cfm">

<cfset Variables.groupColumnList = Variables.lang_insertCommissionTargetGroup_title.groupID
		& "^" & Variables.lang_insertCommissionTargetGroup_title.groupName
		& "^" & Variables.lang_insertCommissionTargetGroup_title.groupStatus
		& "^" & Variables.lang_insertCommissionTargetGroup_title.groupDescription>
<cfset Variables.groupColumnCount = DecrementValue(2 * ListLen(groupColumnList, "^"))>

<cfset Variables.formName = "commissionTargetGroup">
<cfset Variables.formSubmitName = "submitCommissionTarget">
<cfset Variables.formSubmitValue = Variables.lang_insertCommissionTargetGroup_title.formSubmitValue>
<cfset Form.groupID = ValueList(qry_selectCommissionTarget.targetID)>

<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../view/v_group/form_groupTarget.cfm">
