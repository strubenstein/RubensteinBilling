<cfif URL.noteID is not 0 and IsDefined("qry_selectNote")>
	<cfparam Name="Form.noteMessage" Default="#qry_selectNote.noteMessage#">
	<cfparam Name="Form.noteStatus" Default="#qry_selectNote.noteStatus#">

	<cfif Application.fn_IsIntegerPositive(qry_selectNote.primaryTargetID_partner)>
		<cfparam Name="Form.primaryTargetKey_targetID_userID_partner" Default="#Application.fn_GetPrimaryTargetKey(qry_selectNote.primaryTargetID_partner)#_#qry_selectNote.targetID_partner#_#qry_selectNote.userID_partner#">
	<cfelseif Application.fn_IsIntegerPositive(qry_selectNote.userID_partner)>
		<cfparam Name="Form.primaryTargetKey_targetID_userID_partner" Default="salespersonID_0_#qry_selectNote.userID_partner#">
	<cfelse>
		<cfparam Name="Form.primaryTargetKey_targetID_userID_partner" Default="">
	</cfif>
</cfif>

<cfparam Name="Form.noteMessage" Default="">
<cfparam Name="Form.noteStatus" Default="1">
<cfparam Name="Form.primaryTargetKey_targetID_userID_partner" Default="">
