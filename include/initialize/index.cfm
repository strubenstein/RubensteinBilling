<!--- redirect if not calling initialize.cfm or if the system seems to have been initialized already --->
<cfif GetFileFromPath(GetBaseTemplatePath()) is not "initialize.cfm">
	<cflocation url="#Application.billingUrl#" AddToken="No">
<cfelseif Application.billingDsn is not ""
		or Application.billingUrl is not "http://www.agreedis.org"
		or FindNoCase(Application.billingFilePath, GetBaseTemplatePath())>
	<cflocation url="#Application.billingUrl#" AddToken="No">
</cfif>

