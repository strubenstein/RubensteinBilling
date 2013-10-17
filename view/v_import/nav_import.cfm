<cfoutput>
<div class="SubNav">
<span class="SubNavTitle">Import Records: </span>
<cfif Application.fn_IsUserAuthorized("importData")><a href="index.cfm?method=import.importData" title="Begin process of importing new records" class="SubNavLink">Import New Records</a></cfif>
</div><br>
</cfoutput>

