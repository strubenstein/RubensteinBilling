<cfif Form.billingFilePathSlash is not "/" and Form.billingFilePathSlash is not "\">
	<cfset Form.billingFilePathSlash = "\">
	<cfset errorMessage_fields.billingFilePathSlash = Variables.lang_applicationVariables.billingFilePathSlash_valid>
<cfelseif Not Find(Form.billingFilePathSlash, GetBaseTemplatePath())>
	<cfset errorMessage_fields.billingFilePathSlash = Variables.lang_applicationVariables.billingFilePathSlash_mismatch>
</cfif>

<cfif Not ListFind("CFMX,BlueDragon,Railo", Form.billingCFversion)>
	<cfset errorMessage_fields.billingCFversion = Variables.lang_applicationVariables.billingCFversion>
</cfif>

<cfif Not ListFind("MySQL,MSSQLServer,Oracle,DB2", Form.billingDatabase)>
	<cfset errorMessage_fields.billingDatabase = Variables.lang_applicationVariables.billingDatabase>
</cfif>

<cfif Not FileExists(Form.billingFilePath & Form.billingFilePathSlash & "initialize.cfm")>
	<cfset errorMessage_fields.billingFilePath = Variables.lang_applicationVariables.billingFilePath>
</cfif>

<cfif Not DirectoryExists(Form.billingTempPath)>
	<cfset errorMessage_fields.billingTempPath = Variables.lang_applicationVariables.billingTempPath>
</cfif>

<cfif Not fn_IsValidURL(Form.billingUrl)>
	<cfset errorMessage_fields.billingUrl = Variables.lang_applicationVariables.billingUrl>
</cfif>
<cfif Not fn_IsValidURL(Form.billingSecureUrl)>
	<cfset errorMessage_fields.billingSecureUrl = Variables.lang_applicationVariables.billingSecureUrl>
</cfif>

<cfif Trim(Form.billingDsn) is "">
	<cfset errorMessage_fields.billingDsn = Variables.lang_applicationVariables.billingDsn_blank>
<cfelseif StructIsEmpty(errorMessage_fields)>
	<cftry>
		<cfquery Name="qry_testInitializeDB" Datasource="#Form.billingDsn#" Username="#Form.billingDsnUsername#" Password="#Form.billingDsnPassword#">
			SELECT username FROM avUser WHERE userID = 1
		</cfquery>

		<cfcatch>
			<cfset errorMessage_fields.billingDsn = Variables.lang_applicationVariables.billingDsn_valid>
		</cfcatch>
	</cftry>
</cfif>

<cfif Trim(Form.billingMapping) is "">
	<cfset errorMessage_fields.billingMapping = Variables.lang_applicationVariables.billingMapping_blank>
<cfelse>
	<cftry>
		<cfobject Name="objAddressTest" Component="#Form.billingMapping#.data.Address">
		<cfcatch>
			<cfset errorMessage_fields.billingMapping = Variables.lang_applicationVariables.billingMapping_valid>
		</cfcatch>
	</cftry>
</cfif>

<cfif Trim(Form.billingEncryptionCode) is "">
	<cfset errorMessage_fields.billingEncryptionCode = Variables.lang_applicationVariables.billingEncryptionCode>
</cfif>

<cfif Form.billingErrorEmail is not "">
	<cfloop Index="field" List="#Form.billingErrorEmail#">
		<cfif Not fn_IsValidEmail(field)>
			<cfset errorMessage_fields.billingErrorEmail = Variables.lang_applicationVariables.billingErrorEmail>
		</cfif>
	</cfloop>
</cfif>

<cfif Not fn_IsValidEmail(Form.billingErrorReplyTo)>
	<cfset errorMessage_fields.billingErrorReplyTo = Variables.lang_applicationVariables.billingErrorReplyTo>
</cfif>

<cfif Trim(Form.billingErrorSubject) is "">
	<cfset errorMessage_fields.billingErrorSubject = Variables.lang_applicationVariables.billingErrorSubject>
</cfif>

<cfif Trim(Form.billingErrorFrom) is "">
	<cfset errorMessage_fields.billingErrorFrom = Variables.lang_applicationVariables.billingErrorFrom>
</cfif>

<cfif Not ListFind("True,False", Form.billingTrackLoginSessions)>
	<cfset errorMessage_fields.billingTrackLoginSessions = Variables.lang_applicationVariables.billingTrackLoginSessions>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfset errorMessage_title = Variables.lang_applicationVariables.errorTitle>
	<cfset errorMessage_header = Variables.lang_applicationVariables.errorHeader>
	<cfset errorMessage_footer = Variables.lang_applicationVariables.errorFooter>
</cfif>
