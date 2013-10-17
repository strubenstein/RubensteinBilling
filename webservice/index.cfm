<cfif Right(GetFileFromPath(GetBaseTemplatePath()), 4) is not ".cfc" or ListFindNoCase("WebServiceSession.cfc,WebServiceSecurity.cfc", GetFileFromPath(GetBaseTemplatePath()))>
	<cflocation url="#Application.billingUrl#" AddToken="No">
</cfif>

