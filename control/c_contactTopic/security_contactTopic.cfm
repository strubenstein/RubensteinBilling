<cfif Not Application.fn_IsIntegerNonNegative(URL.contactTopicID)>
	<cflocation url="index.cfm?method=contactTopic.listContactTopics&error_contactTopic=noContactTopic" AddToken="No">
<cfelseif URL.contactTopicID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.ContactTopic" Method="checkContactTopicPermission" ReturnVariable="isContactTopicPermission">
		<cfinvokeargument Name="contactTopicID" Value="#URL.contactTopicID#">
		<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	</cfinvoke>

	<cfif isContactTopicPermission is True>
		<cfinvoke Component="#Application.billingMapping#data.ContactTopic" Method="selectContactTopic" ReturnVariable="qry_selectContactTopic">
			<cfinvokeargument Name="contactTopicID" Value="#URL.contactTopicID#">
		</cfinvoke>
	<cfelse>
		<cflocation url="index.cfm?method=contactTopic.listContactTopics&error_contactTopic=invalidContactTopic" AddToken="No">
	</cfif>
<cfelseif Not ListFind("listContactTopics,insertContactTopic", Variables.doAction)>
	<cflocation url="index.cfm?method=contactTopic.listContactTopics&error_contactTopic=noContactTopic" AddToken="No">
</cfif>
