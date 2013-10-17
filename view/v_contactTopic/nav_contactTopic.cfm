<cfoutput>
<div class="SubNav">
<span class="SubNavTitle">Contact Management Topics: </span>
<cfif Application.fn_IsUserAuthorized("listContactTopics")><a href="index.cfm?method=contactTopic.listContactTopics" title="List existing contact management topics" class="SubNavLink<cfif Variables.doAction is "listContactTopics">On</cfif>">List Existing Topics</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertContactTopic")> | <a href="index.cfm?method=contactTopic.insertContactTopic" title="Create new contact management topic" class="SubNavLink<cfif Variables.doAction is "insertContactTopic">On</cfif>">Create New Topic</a></cfif>
</div><br>
</cfoutput>

