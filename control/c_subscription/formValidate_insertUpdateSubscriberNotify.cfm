<cfset errorMessage_fields = StructNew()>

<cfloop Query="qry_selectUserList">
	<cfif Not ListFind(ValueList(qry_selectUserCompanyList_company.userID), qry_selectUserList.userID)>
		<cfset errorMessage_fields["userID#qry_selectUserList.userID#"] = ReplaceNoCase(Variables.lang_insertUpdateSubscriberNotify.userID, "<<USER>>", qry_selectUserList.firstName & " " & qry_selectUserList.lastName, "ALL")>
	</cfif>
	<cfif Form["addressID#qry_selectUserList.userID#"] is not 0 and Not ListFind(ValueList(qry_selectAddressList.addressID), Form["addressID#qry_selectUserList.userID#"])>
		<cfset errorMessage_fields["addressID#qry_selectUserList.userID#"] = ReplaceNoCase(Variables.lang_insertUpdateSubscriberNotify.addressID, "<<USER>>", qry_selectUserList.firstName & " " & qry_selectUserList.lastName, "ALL")>
	</cfif>
	<cfif Form["phoneID#qry_selectUserList.userID#"] is not 0 and Not ListFind(ValueList(qry_selectPhoneList.phoneID), Form["phoneID#qry_selectUserList.userID#"])>
		<cfset errorMessage_fields["phoneID#qry_selectUserList.userID#"] = ReplaceNoCase(Variables.lang_insertUpdateSubscriberNotify.phoneID, "<<USER>>", qry_selectUserList.firstName & " " & qry_selectUserList.lastName, "ALL")>
	</cfif>
	<cfif Not ListFind("0,1", Form["subscriberNotifyEmail#qry_selectUserList.userID#"])>
		<cfset errorMessage_fields["subscriberNotifyEmail#qry_selectUserList.userID#"] = ReplaceNoCase(Variables.lang_insertUpdateSubscriberNotify.subscriberNotifyEmail, "<<USER>>", qry_selectUserList.firstName & " " & qry_selectUserList.lastName, "ALL")>
	</cfif>
	<cfif Not ListFind("0,1", Form["subscriberNotifyEmailHtml#qry_selectUserList.userID#"])>
		<cfset errorMessage_fields["subscriberNotifyEmailHtml#qry_selectUserList.userID#"] = ReplaceNoCase(Variables.lang_insertUpdateSubscriberNotify.subscriberNotifyEmailHtml, "<<USER>>", qry_selectUserList.firstName & " " & qry_selectUserList.lastName, "ALL")>
	</cfif>
	<cfif Not ListFind("0,1", Form["subscriberNotifyPdf#qry_selectUserList.userID#"])>
		<cfset errorMessage_fields["subscriberNotifyPdf#qry_selectUserList.userID#"] = ReplaceNoCase(Variables.lang_insertUpdateSubscriberNotify.subscriberNotifyPdf, "<<USER>>", qry_selectUserList.firstName & " " & qry_selectUserList.lastName, "ALL")>
	</cfif>
	<cfif Not ListFind("0,1", Form["subscriberNotifyDoc#qry_selectUserList.userID#"])>
		<cfset errorMessage_fields["subscriberNotifyDoc#qry_selectUserList.userID#"] = ReplaceNoCase(Variables.lang_insertUpdateSubscriberNotify.subscriberNotifyDoc, "<<USER>>", qry_selectUserList.firstName & " " & qry_selectUserList.lastName, "ALL")>
	</cfif>
</cfloop>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertSubscriberNotify">
		<cfset errorMessage_title = Variables.lang_insertUpdateSubscriberNotify.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertUpdateSubscriberNotify.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdateSubscriberNotify.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdateSubscriberNotify.errorFooter>
</cfif>
