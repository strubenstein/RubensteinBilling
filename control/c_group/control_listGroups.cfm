<cfinvoke Component="#Application.billingMapping#data.Group" Method="selectGroupList" ReturnVariable="qry_selectGroupList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	<cfinvokeargument Name="returnGroupCounts" Value="True">
</cfinvoke>

<cfinclude template="../../view/v_group/lang_listGroups.cfm">

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("viewGroup")>
<cfset Variables.groupColumnList = Variables.lang_listGroups_title.groupName
		& "^" & Variables.lang_listGroups_title.groupID_custom
		& "^" & Variables.lang_listGroups_title.groupStatus
		& "^" & Variables.lang_listGroups_title.groupDescription
		& "^" & Variables.lang_listGroups_title.groupDateCreated
		& "^" & Variables.lang_listGroups_title.groupDateUpdated
		& "^" & Variables.lang_listGroups_title.userCount
		& "^" & Variables.lang_listGroups_title.partnerCount
		& "^" & Variables.lang_listGroups_title.priceCount>

<cfif ListFind(Variables.permissionActionList, "viewGroup")>
	<cfset Variables.groupColumnList = Variables.groupColumnList & "^" & Variables.lang_listGroups_title.viewGroup>
</cfif>

<cfset Variables.groupColumnCount = DecrementValue(2 * ListLen(Variables.groupColumnList, "^"))>

<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../view/v_group/dsp_selectGroupList.cfm">
