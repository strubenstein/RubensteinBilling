<cfoutput>
<p class="SubTitle">Welcome to Billing!</p>

<cfif Not IsDefined("Form.isFormSubmitted")>
	<p class="MainText">
	We will now walk you thru the steps to initialize Billing.<br>
	Before submitting this page, you should have done the following:
	<ol class="TableText">
		<li>Copy Billing directory to your server (obviously done or you would not see this page)</li>
		<li>Move importExportTemp directory to non-public directory</li>
		<li>Create database (MySQL, Microsoft SQL Server, Oracle or IBM DB2)</li>
		<li>Create database tables</li>
		<li>Create mapping in ColdFusion Administrator</li>
		<li>Create ColdFusion datasource</li>
	</ol>
	</p>
</cfif>

<form method="post" action="initialize.cfm">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td class="#fn_setTextClass('billingSiteTitle')#">Site Title: </td>
	<td><input type="text" name="billingSiteTitle" size="50" value="#HTMLEditFormat(Form.billingSiteTitle)#"> (displayed at top of browser and page)</td>
</tr>

<tr><td colspan="2"><b>ColdFusion Information:</b></td></tr>
<tr>
	<td class="#fn_setTextClass('billingMapping')#">ColdFusion Mapping: </td>
	<td><input type="text" name="billingMapping" size="30" value="#HTMLEditFormat(Form.billingMapping)#"><!--- . ---> (mapping to the Billing directory)</td>
</tr>
<tr>
	<td class="#fn_setTextClass('billingDsn')#">ColdFusion Datasource Name: </td>
	<td><input type="text" name="billingDsn" size="30" value="#HTMLEditFormat(Form.billingDsn)#"></td>
</tr>
<tr>
	<td class="#fn_setTextClass('billingDsnUsername')#">ColdFusion Datasource Username: </td>
	<td><input type="text" name="billingDsnUsername" size="30" value="#HTMLEditFormat(Form.billingDsnUsername)#"></td>
</tr>
<tr>
	<td class="#fn_setTextClass('billingDsnPassword')#">ColdFusion Datasource Password: </td>
	<td><input type="text" name="billingDsnPassword" size="30" value="#HTMLEditFormat(Form.billingDsnPassword)#"></td>
</tr>

<tr><td colspan="2"><b>File &amp; URL Information:</b></td></tr>
<tr>
	<td colspan="2" class="#fn_setTextClass('billingFilePath')#">
		File Path to Billing Directory:<br>
		&nbsp; &nbsp; <input type="text" name="billingFilePath" size="150" value="#HTMLEditFormat(Form.billingFilePath)#" class="SmallText">
	</td>
</tr>
<tr>
	<td colspan="2" class="#fn_setTextClass('billingTempPath')#">
		File Path to importExportTemp Directory:<br>
		&nbsp; &nbsp; <input type="text" name="billingTempPath" size="150" value="#HTMLEditFormat(Form.billingTempPath)#" class="SmallText">
		<div class="SmallText">&nbsp; &nbsp; &nbsp; &nbsp; This should be a directory location that is <u>not</u> publicly accessible.</div>
	</td>
</tr>
<tr>
	<td class="#fn_setTextClass('billingUrl')#">URL to Billing Directory: </td>
	<td><input type="text" name="billingUrl" size="50" value="#HTMLEditFormat(Form.billingUrl)#"></td>
</tr>
<tr>
	<td class="#fn_setTextClass('billingSecureUrl')#">Secure URL: </td>
	<td><input type="text" name="billingSecureUrl" size="50" value="#HTMLEditFormat(Form.billingSecureUrl)#"></td>
</tr>
<tr valign="top">
	<td class="#fn_setTextClass('billingUrlroot')#">URL Root: </td>
	<td>
		<input type="text" name="billingUrlroot" size="30" value="#HTMLEditFormat(Form.billingUrlroot)#">
		<div class="SmallText">Absolute path from root directory of your server, e.g., &quot;/Billing&quot;. If root directory, leave blank.<br>
		Otherwise begin with a &quot;/&quot;. This is generally the path after &quot;http://www.yourdomain.com&quot;.</div>
	</td>
</tr>

<tr><td colspan="2"><b>Other Configuration Information:</b></td></tr>
<tr>
	<td class="#fn_setTextClass('billingCFversion')#">ColdFusion Version: </td>
	<td>
		<label><input type="radio" name="billingCFversion" value="CFMX"<cfif Form.billingCFversion is "CFMX"> checked</cfif>>ColdFusion</label> &nbsp; 
		<label><input type="radio" name="billingCFversion" value="BlueDragon"<cfif Form.billingCFversion is "BlueDragon"> checked</cfif>>BlueDragon</label>
		<label><input type="radio" name="billingCFversion" value="Railo"<cfif Form.billingCFversion is "Railo"> checked</cfif>>Railo</label>
		<div class="SmallText">Does not currently matter, but might for future versions based on differences in the CF engines regarding supported features.</div>
	</td>
</tr>
<tr valign="top">
	<td class="#fn_setTextClass('billingDatabase')#">Database Type: </td>
	<td>
		<label><input type="radio" name="billingDatabase" value="MSSQLServer"<cfif Form.billingDatabase is "MSSQLServer"> checked</cfif>>Microsoft SQL Server 2000 (or later)</label><br>
		<label><input type="radio" name="billingDatabase" value="MySQL"<cfif Form.billingDatabase is "MySQL"> checked</cfif>>MySQL 4.1 (or later)</label><br>
		<!---
		<label><input type="radio" name="billingDatabase" value="Oracle"<cfif Form.billingDatabase is "Oracle"> checked</cfif>>Oracle 8 (or later)</label><br>
		<label><input type="radio" name="billingDatabase" value="DB2"<cfif Form.billingDatabase is "DB2"> checked</cfif>>IBM DB2 8</label><br>
		--->
	</td>
</tr>
<tr>
	<td class="#fn_setTextClass('billingFilePathSlash')#">Operating System: </td>
	<td>
		<label><input type="radio" name="billingFilePathSlash" value="\"<cfif Form.billingFilePathSlash is "\"> checked</cfif>>Microsoft Windows</label> &nbsp; 
		<label><input type="radio" name="billingFilePathSlash" value="/"<cfif Form.billingFilePathSlash is "/"> checked</cfif>>Linux / Unix</label>
	</td>
</tr>
<tr>
	<td class="#fn_setTextClass('billingEncryptionCode')#">Encryption Key: </td>
	<td><input type="text" name="billingEncryptionCode" size="30" value="#HTMLEditFormat(Form.billingEncryptionCode)#"> (string used as encryption basis)</td>
</tr>

<tr valign="top">
	<td class="#fn_setTextClass('billingTrackLoginSessions')#">Track Login Sessions: </td>
	<td>
		<label><input type="radio" name="billingTrackLoginSessions" value="True"<cfif Form.billingTrackLoginSessions is "True">checked</cfif>> Yes</label> &nbsp; &nbsp; 
		<label><input type="radio" name="billingTrackLoginSessions" value="False"<cfif Form.billingTrackLoginSessions is "False">checked</cfif>> No</label>
		<div class="SmallText">Records login and logout date/times of each user, including whether they manually logged out or were timed out. Also enables viewing users who are currently logged in. With some minimal effort, this feature can be used to prevent users from logging in simultaneously via the same account from multiple computers or browsers.</div>
	</td>
</tr>

<tr><td colspan="2"><b>Error Reporting Via Email:</b></td></tr>
<tr valign="top">
	<td class="#fn_setTextClass('billingErrorEmail')#">Recipient(s): </td>
	<td>
		<input type="text" name="billingErrorEmail" size="60" value="#HTMLEditFormat(Form.billingErrorEmail)#">
		<div class="SmallText">Email address to notify with error messages. Separate multiple addresses with a comma. If blank, no email will be sent.</div>
	</td>
</tr>
<tr>
	<td class="#fn_setTextClass('billingErrorFrom')#">From Name: </td>
	<td><input type="text" name="billingErrorFrom" size="60" value="#HTMLEditFormat(Form.billingErrorFrom)#"></td>
</tr>
<tr>
	<td class="#fn_setTextClass('billingErrorReplyTo')#">From Email: </td>
	<td><input type="text" name="billingErrorReplyTo" size="60" value="#HTMLEditFormat(Form.billingErrorReplyTo)#"></td>
</tr>
<tr>
	<td class="#fn_setTextClass('billingErrorSubject')#">Subject: </td>
	<td><input type="text" name="billingErrorSubject" size="60" value="#HTMLEditFormat(Form.billingErrorSubject)#"></td>
</tr>
<tr>
	<td class="#fn_setTextClass('billingEmailUsername')#">Email Username: </td>
	<td><input type="text" name="billingEmailUsername" size="60" value="#HTMLEditFormat(Form.billingEmailUsername)#"></td>
</tr>
<tr>
	<td class="#fn_setTextClass('billingEmailPassword')#">Email Password: </td>
	<td><input type="text" name="billingEmailPassword" size="60" value="#HTMLEditFormat(Form.billingEmailPassword)#"></td>
</tr>

<tr>
	<td></td>
	<td><input type="submit" name="submitApplicationVariables" value="Continue to Step 2"></td>
</tr>
</table>
</form>
</cfoutput>
