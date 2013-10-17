<!--- customer company fields --->
<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompany" ReturnVariable="qry_selectCustomerCompany">
	<cfinvokeargument Name="companyID" Value="#Variables.companyID#">
</cfinvoke>

<cfif qry_selectCustomerCompany.RecordCount is not 0 and Variables.isContactTemplate.customerCompany_subject is True>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<companyID>>", Variables.companyID, "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<companyName>>", qry_selectCustomerCompany.companyName, "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<companyDBA>>", qry_selectCustomerCompany.companyDBA, "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<companyURL>>", qry_selectCustomerCompany.companyURL, "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<companyID_custom>>", qry_selectCustomerCompany.companyID_custom, "ALL")>
</cfif>

<cfif qry_selectCustomerCompany.RecordCount is not 0 and Variables.isContactTemplate.customerCompany_message is True>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<companyID>>", Variables.companyID, "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<companyName>>", qry_selectCustomerCompany.companyName, "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<companyDBA>>", qry_selectCustomerCompany.companyDBA, "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<companyURL>>", qry_selectCustomerCompany.companyURL, "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<companyID_custom>>", qry_selectCustomerCompany.companyID_custom, "ALL")>
</cfif>
