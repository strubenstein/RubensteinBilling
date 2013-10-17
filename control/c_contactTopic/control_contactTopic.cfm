<cfparam Name="URL.contactTopicID" Default="0">
<cfparam Name="URL.languageID" Default="">

<cfinclude template="security_contactTopic.cfm">
<cfinclude template="../../view/v_contactTopic/nav_contactTopic.cfm">
<cfif IsDefined("URL.confirm_contactTopic")>
	<cfinclude template="../../view/v_contactTopic/confirm_contactTopic.cfm">
</cfif>
<cfif IsDefined("URL.error_contactTopic")>
	<cfinclude template="../../view/v_contactTopic/error_contactTopic.cfm">
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="listContactTopics">
	<cfinclude template="control_listContactTopics.cfm">
</cfcase>

<cfcase value="insertContactTopic">
	<cfinclude template="control_insertContactTopic.cfm">
</cfcase>

<cfcase value="updateContactTopic">
	<cfinclude template="control_updateContactTopic.cfm">
</cfcase>

<cfcase value="moveContactTopicUp,moveContactTopicDown">
	<cfinvoke Component="#Application.billingMapping#data.ContactTopic" Method="switchContactTopicOrder" ReturnVariable="isContactTopicOrderSwitched">
		<cfinvokeargument Name="companyID" Value="#Session.companyID#">
		<cfinvokeargument Name="contactTopicID" Value="#URL.contactTopicID#">
		<cfinvokeargument Name="contactTopicOrder_direction" Value="#Variables.doAction#">
	</cfinvoke>

	<cflocation url="index.cfm?method=contactTopic.listContactTopics&confirm_contactTopic=#Variables.doAction#" AddToken="No">
</cfcase>

<cfdefaultcase>
	<cfset URL.error_contactTopic = "invalidAction">
	<cfinclude template="../../view/v_contactTopic/error_contactTopic.cfm">
</cfdefaultcase>
</cfswitch>

