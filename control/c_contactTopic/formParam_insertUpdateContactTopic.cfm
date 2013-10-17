<cfif Variables.doAction is "updateContactTopic" and IsDefined("qry_selectContactTopic")>
	<cfparam Name="Form.contactTopicOrder" Default="#qry_selectContactTopic.contactTopicOrder#">
	<cfparam Name="Form.contactTopicStatus" Default="#qry_selectContactTopic.contactTopicStatus#">
	<cfparam Name="Form.contactTopicName" Default="#qry_selectContactTopic.contactTopicName#">
	<cfparam Name="Form.contactTopicTitle" Default="#qry_selectContactTopic.contactTopicTitle#">
	<cfparam Name="Form.contactTopicEmail" Default="#qry_selectContactTopic.contactTopicEmail#">
</cfif>

<cfparam Name="Form.contactTopicOrder" Default="0">
<cfparam Name="Form.contactTopicStatus" Default="1">
<cfparam Name="Form.contactTopicName" Default="">
<cfparam Name="Form.contactTopicTitle" Default="">
<cfparam Name="Form.contactTopicEmail" Default="">

