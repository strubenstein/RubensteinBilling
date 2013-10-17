<cfinvoke Component="#Application.billingMapping#data.ContactTopic" Method="selectContactTopicList" ReturnVariable="qry_selectContactTopicList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
</cfinvoke>

<cfinclude template="../../view/v_contactTopic/lang_listContactTopics.cfm">

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("updateContactTopic,moveContactTopicDown,moveContactTopicUp")>
<cfset Variables.contactTopicColumnList = Variables.lang_listContactTopics_title.contactTopicOrder
		& "^" & Variables.lang_listContactTopics_title.contactTopicName
		& "^" & Variables.lang_listContactTopics_title.contactTopicTitle
		& "^" & Variables.lang_listContactTopics_title.contactTopicNotify
		& "^" & Variables.lang_listContactTopics_title.contactTopicStatus
		& "^" & Variables.lang_listContactTopics_title.contactTopicDateCreated
		& "^" & Variables.lang_listContactTopics_title.contactTopicDateUpdated>

<cfif ListFind(Variables.permissionActionList, "moveContactTopicDown") and ListFind(Variables.permissionActionList, "moveContactTopicUp")>
	<cfset Variables.contactTopicColumnList = Variables.contactTopicColumnList & "^" & Variables.lang_listContactTopics_title.moveContactTopic>
</cfif>
<cfif ListFind(Variables.permissionActionList, "updateContactTopic")>
	<cfset Variables.contactTopicColumnList = Variables.contactTopicColumnList & "^" & Variables.lang_listContactTopics_title.updateContactTopic>
</cfif>

<cfset Variables.contactTopicColumnCount = DecrementValue(2 * ListLen(Variables.contactTopicColumnList, "^"))>

<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../view/v_contactTopic/dsp_selectContactTopicList.cfm">
