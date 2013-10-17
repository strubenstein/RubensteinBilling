<!--- customer user fields --->
<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectCustomerUser">
	<cfinvokeargument Name="userID" Value="#Variables.userID#">
</cfinvoke>

<cfif qry_selectCustomerUser.RecordCount is not 0 and Variables.isContactTemplate.customerUser_subject is True>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<firstName>>", qry_selectCustomerUser.firstName, "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<lastName>>", qry_selectCustomerUser.lastName, "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<email>>", qry_selectCustomerUser.email, "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<username>>", qry_selectCustomerUser.username, "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<middleName>>", qry_selectCustomerUser.middleName, "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<suffix>>", qry_selectCustomerUser.suffix, "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<salutation>>", qry_selectCustomerUser.salutation, "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<jobTitle>>", qry_selectCustomerUser.jobTitle, "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<jobDepartment>>", qry_selectCustomerUser.jobDepartment, "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<jobDivision>>", qry_selectCustomerUser.jobDivision, "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<userID>>", Variables.userID, "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<userID_custom>>", qry_selectCustomerUser.userID_custom, "ALL")>
</cfif>

<cfif qry_selectCustomerUser.RecordCount is not 0 and Variables.isContactTemplate.customerUser_message is True>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<firstName>>", qry_selectCustomerUser.firstName, "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<lastName>>", qry_selectCustomerUser.lastName, "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<email>>", qry_selectCustomerUser.email, "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<username>>", qry_selectCustomerUser.username, "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<middleName>>", qry_selectCustomerUser.middleName, "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<suffix>>", qry_selectCustomerUser.suffix, "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<salutation>>", qry_selectCustomerUser.salutation, "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<jobTitle>>", qry_selectCustomerUser.jobTitle, "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<jobDepartment>>", qry_selectCustomerUser.jobDepartment, "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<jobDivision>>", qry_selectCustomerUser.jobDivision, "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<userID>>", Variables.userID, "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<userID_custom>>", qry_selectCustomerUser.userID_custom, "ALL")>
</cfif>
