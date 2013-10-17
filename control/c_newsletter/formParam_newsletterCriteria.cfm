<cfloop Index="fieldValue" List="#qry_selectNewsletter.newsletterCriteria#" Delimiters="&">
	<cfset thisField = ListFirst(fieldValue, "=")>
	<cfif ListLen(fieldValue, "=") is 1 or Right(fieldValue, 1) is "=">
		<cfset thisValue = "">
	<cfelse>
		<cfset thisValue = ListLast(fieldValue, "=")>
	</cfif>
	<cfparam Name="Form.#thisField#" Default="#thisValue#">
</cfloop>
