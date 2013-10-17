<cfif Find("/", GetBaseTemplatePath())><!--- Linux --->
	<cfparam Name="Form.billingFilePath" Default="#ReplaceNoCase(GetBaseTemplatePath(), "/initialize.cfm", "", "ONE")#">
	<cfparam Name="Form.billingTempPath" Default="#Form.billingFilePath#/importExportTemp">
	<cfparam Name="Form.billingFilePathSlash" Default="/">
	<cfparam Name="Form.billingDatabase" Default="MySQL">
<cfelse><!--- Windows --->
	<cfparam Name="Form.billingFilePath" Default="#ReplaceNoCase(GetBaseTemplatePath(), "\initialize.cfm", "", "ONE")#">
	<cfparam Name="Form.billingTempPath" Default="#Form.billingFilePath#\importExportTemp">
	<cfparam Name="Form.billingFilePathSlash" Default="\">
	<cfparam Name="Form.billingDatabase" Default="MSSQLServer">
</cfif>

<cfparam Name="Form.billingUrl" Default="http://#CGI.SERVER_NAME##Replace(CGI.PATH_INFO, "/initialize.cfm", "", "ONE")#">
<cfparam Name="Form.billingSecureUrl" Default="#Replace(Form.billingUrl, "http://", "https://", "ONE")#">
<cfparam Name="Form.billingUrlroot" Default="#Replace(Form.billingUrl, "http://#CGI.SERVER_NAME#", "", "ONE")#">

<cfparam Name="Form.billingSiteTitle" Default="Billing">
<cfparam Name="Form.billingMapping" Default="billingWebroot">
<cfparam Name="Form.billingDsn" Default="">
<cfparam Name="Form.billingDsnUsername" Default="">
<cfparam Name="Form.billingDsnPassword" Default="">
<cfparam Name="Form.billingEncryptionCode" Default="billingcrypt">
<cfparam Name="Form.billingCFversion" Default="CFMX">
<cfparam Name="Form.billingErrorEmail" Default="support@agreedis.org">
<cfparam Name="Form.billingErrorReplyTo" Default="support@agreedis.org">
<cfparam Name="Form.billingErrorSubject" Default="Error on Billing">
<cfparam Name="Form.billingErrorFrom" Default="Billing">
<cfparam Name="Form.billingEmailUsername" Default="">
<cfparam Name="Form.billingEmailPassword" Default="">
<cfparam Name="Form.billingTrackLoginSessions" Default="True">
