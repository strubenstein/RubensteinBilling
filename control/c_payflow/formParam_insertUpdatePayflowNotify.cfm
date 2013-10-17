<cfif Not IsDefined("Form.isFormSubmitted")>
	<cfloop Query="qry_selectPayflowNotifyList">
		<cfif qry_selectPayflowNotifyList.payflowNotifyStatus is 1 and qry_selectPayflowNotifyList.payflowNotifyType is not "">
			<cfset Variables.thisUserID = qry_selectPayflowNotifyList.userID>
			<cfparam Name="Form.payflowNotifyEmail#Variables.thisUserID#_#qry_selectPayflowNotifyList.payflowNotifyType#" Default="#qry_selectPayflowNotifyList.payflowNotifyEmail#">
			<cfparam Name="Form.payflowNotifyTask#Variables.thisUserID#_#qry_selectPayflowNotifyList.payflowNotifyType#" Default="#qry_selectPayflowNotifyList.payflowNotifyTask#">
		</cfif>
	</cfloop>
</cfif>

<cfloop Query="qry_selectUserList">
	<cfset Variables.thisUserID = qry_selectUserList.userID>
	<cfloop Index="type" List="#Variables.payflowTemplateTypeList_value#">
		<cfparam Name="Form.payflowNotifyEmail#Variables.thisUserID#_#type#" Default="0">
		<cfparam Name="Form.payflowNotifyTask#Variables.thisUserID#_#type#" Default="0">
	</cfloop>
</cfloop>

