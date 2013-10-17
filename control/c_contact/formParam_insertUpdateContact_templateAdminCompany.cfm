<!--- admin company fields --->
<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompany" ReturnVariable="qry_selectAdminCompany">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
</cfinvoke>

<cfif qry_selectAdminCompany.RecordCount is not 0 and Variables.isContactTemplate.adminCompany_subject is True>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<adminCompanyID>>", Session.companyID, "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<adminCompanyName>>", qry_selectAdminCompany.companyName, "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<adminCompanyDBA>>", qry_selectAdminCompany.companyDBA, "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<adminCompanyURL>>", qry_selectAdminCompany.companyURL, "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<adminCompanyID_custom>>", qry_selectAdminCompany.companyID_custom, "ALL")>
</cfif>

<cfif qry_selectAdminCompany.RecordCount is not 0 and Variables.isContactTemplate.adminCompany_message is True>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<adminCompanyID>>", Session.companyID, "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<adminCompanyName>>", qry_selectAdminCompany.companyName, "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<adminCompanyDBA>>", qry_selectAdminCompany.companyDBA, "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<adminCompanyURL>>", qry_selectAdminCompany.companyURL, "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<adminCompanyID_custom>>", qry_selectAdminCompany.companyID_custom, "ALL")>
</cfif>

