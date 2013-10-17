
<cflock Scope="Application" Timeout="10">
	<cfset Application.billingSiteTitle = "Billing">
	<cfset Application.billingDsn = "BillingDev">
	<cfset Application.billingDsnUsername = "">
	<cfset Application.billingDsnPassword = "">

	<cfif FileExists("C:\HostingSpaces\strubenstein.com\wwwroot\billing\admin\index.cfm")>
		<cfset Application.billingFilePath = "C:\HostingSpaces\strubenstein.com\wwwroot\billing">
		<cfset Application.billingTempPath = "C:\HostingSpaces\strubenstein.com\wwwroot\billing\importExportTemp">

		<cfset Application.billingUrl = "http://www.strubenstein.com/billing">
		<cfset Application.billingSecureUrl = "http://www.strubenstein.com/billing">
		<cfset Application.billingUrlroot = "/billingDemo">
	<cfelse>
		<cfset Application.billingFilePath = "C:\Documents and Settings\Steven\My Documents\emaze\billingSystem">
		<cfset Application.billingTempPath = "C:\Documents and Settings\Steven\My Documents\emaze\billingSystem\importExportTemp">

		<cfset Application.billingUrl = "http://billing.localhost.com">
		<cfset Application.billingSecureUrl = "http://billing.localhost.com">
		<cfset Application.billingUrlroot = "">
	</cfif>

	<cfset Application.billingCFversion = "CFMX">
	<cfset Application.billingFilePathSlash = "\">
	<cfset Application.billingDatabase = "MSSQLServer"><!--- MSSQLServer, MySQL, Oracle, DB2 --->
	<cfset Application.billingShowDebugOutput = True>

	<cfset Application.billingEncryptionCode = "billingcrypt">
	<cfset Application.billingMapping = "billingWebroot.">

	<cfset Application.billingErrorEmail = "support@agreedis.org">
	<cfset Application.billingErrorReplyTo = "support@agreedis.org">
	<cfset Application.billingErrorSubject = "Error on Billing">
	<cfset Application.billingErrorFrom = "Billing">
	<cfset Application.billingEmailUsername = "">
	<cfset Application.billingEmailPassword = "">

	<cfset Application.billingCustomerDirectory = "c">
	<cfset Application.billingCustomerImageDirectory = "images">
	<cfset Application.billingPartnerDirectory = "p">
	<cfset Application.billingQueryCacheTimeSpan = CreateTimeSpan(0,0,0,5)>
	<cfset Application.billingSuperuserCompanyID = 1>
	<cfset Application.billingSuperuserCompanyDirectory = "">
	<cfset Application.billingSuperuserEnabled = False>
	<cfset Application.billingTrackLoginSessions = True>
</cflock>

