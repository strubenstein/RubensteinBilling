<!--- admin user fields --->
<!--- 
<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectAdminUser">
	<cfinvokeargument Name="userID" Value="#Session.userID#">
</cfinvoke>
--->

<cfif qry_selectAdminUser.RecordCount is not 0 and Variables.isContactTemplate.adminUser_subject is True>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<adminUserID>>", Session.userID, "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<adminFirstName>>", qry_selectAdminUser.firstName, "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<adminLastName>>", qry_selectAdminUser.lastName, "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<adminEmail>>", qry_selectAdminUser.email, "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<adminUsername>>", qry_selectAdminUser.username, "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<adminMiddleName>>", qry_selectAdminUser.middleName, "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<adminSuffix>>", qry_selectAdminUser.suffix, "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<adminSalutation>>", qry_selectAdminUser.salutation, "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<adminJobTitle>>", qry_selectAdminUser.jobTitle, "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<adminJobDepartment>>", qry_selectAdminUser.jobDepartment, "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<adminJobDivision>>", qry_selectAdminUser.jobDivision, "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<adminUserID_custom>>", qry_selectAdminUser.userID_custom, "ALL")>
</cfif>

<cfif qry_selectAdminUser.RecordCount is not 0 and Variables.isContactTemplate.adminUser_message is True>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<adminUserID>>", Session.userID, "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<adminFirstName>>", qry_selectAdminUser.firstName, "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<adminLastName>>", qry_selectAdminUser.lastName, "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<adminEmail>>", qry_selectAdminUser.email, "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<adminUsername>>", qry_selectAdminUser.username, "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<adminMiddleName>>", qry_selectAdminUser.middleName, "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<adminSuffix>>", qry_selectAdminUser.suffix, "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<adminSalutation>>", qry_selectAdminUser.salutation, "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<adminJobTitle>>", qry_selectAdminUser.jobTitle, "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<adminJobDepartment>>", qry_selectAdminUser.jobDepartment, "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<adminJobDivision>>", qry_selectAdminUser.jobDivision, "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<adminUserID_custom>>", qry_selectAdminUser.userID_custom, "ALL")>
</cfif>
