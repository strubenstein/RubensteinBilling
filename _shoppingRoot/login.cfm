<cfoutput>
<cfif IsDefined("URL.confirm") and URL.confirm is "logout">
	<p class="ConfirmationMessage">You have successfully logged out.</p>
</cfif>

<p class="SubTitle">Login</p>

<cfif IsDefined("URL.action") and URL.action is "logout">
	<cflock Scope="Session" Timeout="5">
		<cfset Session.userID = 0>
		<cfset Session.fullName = "">
		<cfset Session.companyID = 0>
		<cfset Session.username = "">
		<cfset Session.groupID = 0>

		<cfif StructKeyExists(Session, "companyAuthorizedUsers")>
			<cfset StructDelete(Session, "companyAuthorizedUsers")>
		</cfif>
		<cfif StructKeyExists(Session, "companyExpirationDate")>
			<cfset StructDelete(Session, "companyExpirationDate")>
		</cfif>
		<cfif StructKeyExists(Session, "companyPrimaryUser")>
			<cfset StructDelete(Session, "companyPrimaryUser")>
		</cfif>
	</cflock>

	<cflocation url="login.cfm?confirm=logout" AddToken="No">

<cfelseif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitLogin") and IsDefined("Form.login_username") and IsDefined("Form.login_password")>
	<!--- validate username and password are not blank --->
	<!--- validate user: check username/password against database --->
	<!--- ensure user has permission for site --->
	<!--- get user permissions (groups) for site --->
	<cfif Trim(Form.login_username) is "" or Trim(Form.login_password) is "">
		<p class="ErrorMessage">You must enter text in both the User Name and Password fields</p>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#include.security.Login" Method="checkLogin" ReturnVariable="qry_checkLogin">
			<cfinvokeargument Name="username" Value="#Form.login_username#">
			<cfinvokeargument Name="password" Value="#Form.login_password#">
			<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
			<cfif IsDefined("Form.login_companyDirectory")>
				<cfinvokeargument Name="companyDirectory" Value="#Form.login_companyDirectory#">
			<cfelse>
				<cfinvokeargument Name="companyDirectory" Value="">
			</cfif>
		</cfinvoke>

		<cfif qry_checkLogin.RecordCount is not 1>
			<p class="ErrorMessage">Your username and password were not correct.</p>
		<cfelseif qry_checkLogin.userStatus is not 1>
			<p class="ErrorMessage">You do not have permission for this site.</p>
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#include.security.Login" Method="checkLoginGroup" ReturnVariable="qry_checkLoginGroup">
				<cfinvokeargument Name="userID" Value="#qry_checkLogin.userID#">
				<cfinvokeargument Name="companyID" Value="#qry_checkLogin.companyID#">
			</cfinvoke>

			<!---
			<cfinvoke Component="#Application.billingMapping#include.security.Login" Method="checkLoginCobrand" ReturnVariable="qry_checkLoginCobrand">
				<cfinvokeargument Name="companyID" Value="#qry_checkLogin.companyID#">
			</cfinvoke>
			--->
			<cfif qry_checkLogin.cobrandID is not 0>
				<cfquery Name="qry_checkLoginCobrand" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
					SELECT cobrandID, companyID_author, cobrandDirectory
					FROM avCobrand
					WHERE cobrandID = <CFQUERYPARAM Value="#qry_checkLogin.cobrandID#" CFSqlType="CF_SQL_INTEGER">
				</cfquery>
			</cfif>

			<cfif qry_checkLogin.affiliateID is not 0>
				<cfinvoke component="#Application.billingMapping#data.Affiliate" method="selectAffiliate" returnVariable="qry_selectAffiliate">
					<cfinvokeargument name="affiliateID" value="#qry_checkLogin.affiliateID#">
				</cfinvoke>
			</cfif>

			<cflock Scope="Session" Timeout="5">
				<cfset Session.userID = qry_checkLogin.userID>
				<cfset Session.companyID = qry_checkLogin.companyID>
				<cfset Session.fullName = qry_checkLogin.firstName & " " & qry_checkLogin.lastName>
				<cfset Session.cobrandID = qry_checkLogin.cobrandID>
				<cfset Session.affiliateID = qry_checkLogin.affiliateID>
				<cfset Session.username = Form.login_username>
				<cfif qry_checkLoginGroup.RecordCount is not 0>
					<cfset Session.groupID = ValueList(qry_checkLoginGroup.groupID)>
				<cfelse>
					<cfset Session.groupID = 0>
				</cfif>
				<cfif qry_checkLogin.cobrandID is not 0 and qry_checkLoginCobrand.cobrandDirectory is not "" and DirectoryExists("#Application.billingFilePath#\#Application.billingPartnerDirectory#\#qry_checkLoginCobrand.cobrandDirectory#")>
					<cfset Session.cobrandDirectory = qry_checkLoginCobrand.cobrandDirectory>
				</cfif>
				<cfif qry_checkLogin.affiliateID is not 0 and qry_selectAffiliate.affiliateCode is not "">
					<cfset Session.affiliateCode = qry_selectAffiliate.affiliateCode>
				</cfif>
			</cflock>

			<!--- if in checkout process, return to checkout process, otherwise display login confirmation--->
			<cfif IsDefined("URL.checkout")>
				<cflocation url="checkout.cfm?action=shipping" AddToken="No">
			<cfelseif IsDefined("URL.myAccount")>
				<cflocation url="myAccount.cfm" AddToken="No">
			<cfelse>
				<!--- <p class="ConfirmationMessage">#Form.login_username#, You have successfully logged in.</p> --->
				<cflocation url="myAccount.cfm" AddToken="No">
			</cfif>
		</cfif>
	</cfif>
</cfif>

<cfif Session.userID is 0>
	<form method="post" action="login.cfm<CFIF Trim(CGI.Query_String) is not "" and CGI.Query_String is not "confirm=logout">?#CGI.Query_String#</CFIF>">
	<input type="hidden" name="isFormSubmitted" value="True">

	<table border="0" cellspacing="2" cellpadding="2" class="MainText">
	<tr>
		<td>Username: </td>
		<td><input type="text" name="login_username" size="15"></td>
	</tr>
	<tr>
		<td>Password: </td>
		<td><input type="password" name="login_password" size="15"></td>
	</tr>
	<tr>
		<td></td>
		<td><input type="submit" name="submitLogin" value="Login"></td>
	</tr>
	</table>
	</form>

	<p class="MainText"><a href="forget.cfm">Forget your username and/or password?</a></p>
</cfif>
</cfoutput>
