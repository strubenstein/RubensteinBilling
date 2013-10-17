<cfoutput>
<div class="SubNav">
<cfif Application.fn_IsUserAuthorized("listNotes")><a href="index.cfm?method=#Arguments.doControl#.listNotes#Arguments.urlParameters#" title="View existing notes associated with this target" class="SubNavLink<cfif Arguments.doAction is "listNotes">On</cfif>">List Existing Notes</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertNote")> | <a href="index.cfm?method=#Arguments.doControl#.insertNote#Arguments.urlParameters#" title="Add new note associated with this target" class="SubNavLink<cfif Arguments.doAction is "insertNote">On</cfif>">Add New Note</a></cfif>
</div><br>
</cfoutput>

