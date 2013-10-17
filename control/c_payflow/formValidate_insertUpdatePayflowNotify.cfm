<cfset errorMessage_fields = StructNew()>

<cfloop Query="qry_selectUserList">
	<cfif Not ListFind(ValueList(qry_selectUserCompanyList_company.userID), qry_selectUserList.userID)>
		<cfset errorMessage_fields["userID#qry_selectUserList.userID#"] = ReplaceNoCase(Variables.lang_insertUpdatePayflowNotify.userID, "<<USER>>", qry_selectUserList.firstName & " " & qry_selectUserList.lastName, "ALL")>
	</cfif>
	<cfset Variables.thisUserID = qry_selectUserList.userID>
	<cfloop Index="count" From="1" To="#ListLen(Variables.payflowTemplateTypeList_value)#">
		<cfset Variables.typeLabel = ListGetAt(Variables.payflowTemplateTypeList_label, count)>
		<cfset Variables.typeValue = ListGetAt(Variables.payflowTemplateTypeList_value, count)>

		<cfif Not ListFind("0,1", Form["payflowNotifyEmail#Variables.thisUserID#_#Variables.typeValue#"])>
			<cfset errorMessage_fields["payflowNotifyEmail#Variables.thisUserID#_#Variables.typeValue#"] = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePayflowNotify.payflowNotifyEmail, "<<USER>>", qry_selectUserList.firstName & " " & qry_selectUserList.lastName, "ALL"), "<<TYPE>>", Variables.typeLabel, "ALL")>
		</cfif>
		<cfif Not ListFind("0,1", Form["payflowNotifyTask#Variables.thisUserID#_#Variables.typeValue#"])>
			<cfset errorMessage_fields["payflowNotifyTask#Variables.thisUserID#_#Variables.typeValue#"] = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePayflowNotify.payflowNotifTask, "<<USER>>", qry_selectUserList.firstName & " " & qry_selectUserList.lastName, "ALL"), "<<TYPE>>", Variables.typeLabel, "ALL")>
		</cfif>
	</cfloop>
</cfloop>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertPayflowNotify">
		<cfset errorMessage_title = Variables.lang_insertUpdatePayflowNotify.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertUpdatePayflowNotify.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdatePayflowNotify.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdatePayflowNotify.errorFooter>
</cfif>
