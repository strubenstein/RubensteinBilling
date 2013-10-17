<cfoutput>
<div class="SubNav">
<cfif Application.fn_IsUserAuthorized("listContacts")><a href="index.cfm?method=#URL.control#.listContacts#Variables.urlParameters#" title="List existing contact management messages" class="SubNavLink<cfif Variables.doAction is "listContacts">On</cfif>">List Existing Messages</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertContact")> | <a href="index.cfm?method=#URL.control#.insertContact#Variables.urlParameters#" title="Send new contact management message" class="SubNavLink<cfif Variables.doAction is "insertContact">On</cfif>">Send/Create New Message</a></cfif>
</div><br>
</cfoutput>

