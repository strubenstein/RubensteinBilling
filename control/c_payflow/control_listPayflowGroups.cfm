<cfinvoke Component="#Application.billingMapping#data.PayflowTarget" Method="selectPayflowTarget" ReturnVariable="qry_selectPayflowTarget">
	<cfinvokeargument Name="payflowID" Value="#URL.payflowID#">
	<cfinvokeargument Name="payflowTargetStatus" Value="1">
	<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID("groupID")#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Group" Method="selectGroupList" ReturnVariable="qry_selectGroupList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
</cfinvoke>

<cfinclude template="../../view/v_payflow/lang_listPayflowGroups.cfm">

<cfset Variables.groupColumnList = Variables.lang_listPayflowGroups_title.groupName
		& "^" & Variables.lang_listPayflowGroups_title.groupStatus
		& "^" & Variables.lang_listPayflowGroups_title.payflowDateBegin
		& "^" & Variables.lang_listPayflowGroups_title.payflowDateEnd
		& "^" & Variables.lang_listPayflowGroups_title.groupDescription>
<cfset Variables.groupColumnCount = DecrementValue(2 * ListLen(groupColumnList, "^"))>

<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../view/v_payflow/dsp_selectPayflowGroupList.cfm">
