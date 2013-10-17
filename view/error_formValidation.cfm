<cfparam Name="errorMessage_pageTitle" Default="">
<cfparam Name="errorMessage_title" Default="">
<cfparam Name="errorMessage_header" Default="">
<cfparam Name="errorMessage_footer" Default="">
<cfparam Name="errorMessage_fields" Type="struct" Default="">

<cfoutput>
<cfif errorMessage_pageTitle is not "">
	<p class="SubTitle">#errorMessage_pageTitle#</p>
</cfif>

<cfif errorMessage_title is not "">
	<p class="ErrorMessage">#errorMessage_title#</p>
</cfif>

<cfif errorMessage_header is not "">
	<p class="MainText">#errorMessage_header#</p>
</cfif>

<ul class="MainText">
<cfloop Collection="#errorMessage_fields#" Item="field">
	<li>#StructFind(errorMessage_fields, field)#</li>
</cfloop>
</ul>

<cfif errorMessage_footer is not "">
	<p class="MainText">#errorMessage_footer#</p>
</cfif>
</cfoutput>

