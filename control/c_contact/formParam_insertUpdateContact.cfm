<cfif URL.contactID is not 0 and IsDefined("qry_selectContact")>
	<cfif Variables.doAction is "updateContact">
		<cfparam Name="Form.contactSubject" Default="#qry_selectContact.contactSubject#">
		<cfparam Name="Form.contactMessage" Default="#qry_selectContact.contactMessage#">
		<cfparam Name="Form.contactHtml" Default="#qry_selectContact.contactHtml#">
		<cfparam Name="Form.contactFax" Default="#qry_selectContact.contactFax#">
		<cfparam Name="Form.contactEmail" Default="#qry_selectContact.contactEmail#">
		<cfparam Name="Form.contactFromName" Default="#qry_selectContact.contactFromName#">
		<cfparam Name="Form.contactReplyTo" Default="#qry_selectContact.contactReplyTo#">
		<cfparam Name="Form.contactTo" Default="#qry_selectContact.contactTo#">
		<cfparam Name="Form.contactTopicID" Default="#qry_selectContact.contactTopicID#">
		<cfparam Name="Form.contactTemplateID" Default="#qry_selectContact.contactTemplateID#">
		<cfparam Name="Form.contactID_custom" Default="#qry_selectContact.contactID_custom#">
		<cfparam Name="Form.contactID_orig" Default="#qry_selectContact.contactID_orig#">
		<cfparam Name="Form.contactReplied" Default="#qry_selectContact.contactReplied#">
		<cfparam Name="Form.contactStatus" Default="#qry_selectContact.contactStatus#">
		<cfparam Name="Form.contactCC" Default="#qry_selectContact.contactCC#">
		<cfparam Name="Form.contactBCC" Default="#qry_selectContact.contactBCC#">

		<cfif Application.fn_IsIntegerPositive(qry_selectContact.primaryTargetID_partner)>
			<cfparam Name="Form.primaryTargetKey_targetID_userID_partner" Default="#Application.fn_GetPrimaryTargetKey(qry_selectContact.primaryTargetID_partner)#_#qry_selectContact.targetID_partner#_#qry_selectContact.userID_partner#">
		<cfelseif Application.fn_IsIntegerPositive(qry_selectContact.userID_partner)>
			<cfparam Name="Form.primaryTargetKey_targetID_userID_partner" Default="salespersonID_0_#qry_selectContact.userID_partner#">
		<cfelse>
			<cfparam Name="Form.primaryTargetKey_targetID_userID_partner" Default="">
		</cfif>

	<cfelseif Variables.doAction is "replyToContact">
		<cfparam Name="Form.contactTopicID" Default="#qry_selectContact.contactTopicID#">
		<cfparam Name="Form.contactHtml" Default="#qry_selectContact.contactHtml#">
		<cfparam Name="Form.contactEmail" Default="#qry_selectContact.contactEmail#">
		<cfparam Name="Form.contactTo" Default="#qry_selectContact.contactReplyTo#">
		<cfparam Name="Form.contactID_custom" Default="#qry_selectContact.contactID_custom#">
		<cfparam Name="Form.contactID_orig" Default="#URL.contactID#">
		<cfparam Name="Form.contactSubject" Default="RE: #qry_selectContact.contactSubject#">
		<cfparam Name="Form.contactMessage" Default="#Chr(10)##Chr(10)##Chr(10)##Chr(10)#---------------------------------------#Chr(10)#YOUR ORIGINAL MESSAGE:#Chr(10)##qry_selectContact.contactMessage#">
	</cfif>
</cfif>

<cfparam Name="Form.contactSubject" Default="">
<cfparam Name="Form.contactMessage" Default="">
<cfparam Name="Form.contactHtml" Default="0">
<cfparam Name="Form.contactFax" Default="0">
<cfparam Name="Form.contactEmail" Default="1">
<cfparam Name="Form.contactFromName" Default="#qry_selectAdminUser.firstName# #qry_selectAdminUser.lastName#">
<cfparam Name="Form.contactReplyTo" Default="#qry_selectAdminUser.email#">
<cfif IsDefined("qry_selectUser.email")>
	<cfparam Name="Form.contactTo" Default="#qry_selectUser.email#">
<cfelse>
	<cfparam Name="Form.contactTo" Default="">
</cfif>
<cfparam Name="Form.contactTopicID" Default="0">
<cfparam Name="Form.contactTemplateID" Default="0">
<cfparam Name="Form.contactID_custom" Default="">
<cfparam Name="Form.contactID_orig" Default="0">
<cfparam Name="Form.contactReplied" Default="0">
<cfparam Name="Form.contactStatus" Default="1">
<cfparam Name="Form.contactCC" Default="">
<cfparam Name="Form.contactBCC" Default="">
<cfparam Name="Form.primaryTargetKey_targetID_userID_partner" Default="">