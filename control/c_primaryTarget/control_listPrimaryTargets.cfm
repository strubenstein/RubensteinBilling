<cfparam Name="URL.queryOrderBy" Default="primaryTargetTable">
<cfinvoke Component="#Application.billingMapping#data.PrimaryTarget" Method="selectPrimaryTargetList" ReturnVariable="qry_selectPrimaryTargetList">
	<cfinvokeargument Name="queryOrderBy" Value="#URL.queryOrderBy#">
</cfinvoke>

<cfinclude template="../../view/v_primaryTarget/lang_listPrimaryTargets.cfm">

<cfset Variables.viewAction = "index.cfm?method=primaryTarget.listPrimaryTargets">
<cfset Variables.primaryTargetColumnList = Variables.lang_listPrimaryTargets_title.primaryTargetID
		& "^" &  Variables.lang_listPrimaryTargets_title.primaryTargetTable
		& "^" &  Variables.lang_listPrimaryTargets_title.primaryTargetKey
		& "^" &  Variables.lang_listPrimaryTargets_title.primaryTargetName
		& "^" &  Variables.lang_listPrimaryTargets_title.primaryTargetDescription
		& "^" &  Variables.lang_listPrimaryTargets_title.primaryTargetStatus
		& "^" &  Variables.lang_listPrimaryTargets_title.primaryTargetDateCreated
		& "^" &  Variables.lang_listPrimaryTargets_title.primaryTargetDateUpdated
		& "^" &  Variables.lang_listPrimaryTargets_title.lastName>

<cfset Variables.primaryTargetOrderList = "primaryTargetID^primaryTargetTable^primaryTargetKey^primaryTargetName^False^primaryTargetStatus^primaryTargetDateCreated^primaryTargetDateUpdated^lastName">
<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("updatePrimaryTarget")>

<cfif ListFind(Variables.permissionActionList, "updatePrimaryTarget")>
	<cfset Variables.primaryTargetColumnList = Variables.primaryTargetColumnList & "^" & Variables.lang_listPrimaryTargets_title.updatePrimaryTarget>
	<cfset Variables.primaryTargetOrderList = Variables.primaryTargetOrderList & "^False">
</cfif>

<cfset Variables.primaryTargetColumnCount = DecrementValue(2 * ListLen(Variables.primaryTargetColumnList, "^"))>

<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../view/v_primaryTarget/dsp_selectPrimaryTargetList.cfm">
