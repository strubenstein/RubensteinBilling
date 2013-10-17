<cfif qry_selectContactTemplate.contactTemplateFromName is not "">
	<cfset Form.contactFromName = qry_selectContactTemplate.contactTemplateFromName>
</cfif>

<cfif qry_selectContactTemplate.contactTemplateReplyTo is not "">
	<cfset Form.contactReplyTo = qry_selectContactTemplate.contactTemplateReplyTo>
</cfif>

<cfif qry_selectContactTemplate.contactTemplateCC is not "">
	<cfset Form.contactCC = qry_selectContactTemplate.contactTemplateCC>
</cfif>

<cfif qry_selectContactTemplate.contactTemplateBCC is not "">
	<cfset Form.contactBCC = qry_selectContactTemplate.contactTemplateBCC>
</cfif>

<cfif qry_selectContactTemplate.contactTemplateHtml is not "">
	<cfset Form.contactHtml = qry_selectContactTemplate.contactTemplateHtml>
</cfif>

<cfif qry_selectContactTemplate.contactTemplateSubject is not "">
	<cfset Form.contactSubject = qry_selectContactTemplate.contactTemplateSubject>
</cfif>

<cfif qry_selectContactTemplate.contactTemplateMessage is not "">
	<cfset Form.contactMessage = qry_selectContactTemplate.contactTemplateMessage>
</cfif>

<!--- determine which populated fields to request and whether it is for subject and/or message --->
<cfset Variables.isContactTemplate = StructNew()>
<!--- determine carriage return: <br> if html email, Chr(10) if not --->
<cfif qry_selectContactTemplate.contactTemplateHtml is 1>
	<cfset Variables.carriageReturn = "<br>">
<cfelse>
	<cfset Variables.carriageReturn = Chr(10)>
</cfif>

<!--- today, yesterday and tomorrow dates --->
<cfinclude template="formParam_insertUpdateContact_templateDate.cfm">

<!--- customer information --->
<cfif Variables.userID is not 0>
	<cfset Variables.isContactTemplate.customerUser_subject = False>
	<cfset Variables.isContactTemplate.customerUser_message = False>

	<cfif FindNoCase("<<", qry_selectContactTemplate.contactTemplateSubject)>
		<cfset Variables.isContactTemplate.customerUser_subject = True>
	</cfif>
	<cfif FindNoCase("<<", qry_selectContactTemplate.contactTemplateMessage)>
		<cfset Variables.isContactTemplate.customerUser_message = True>
	</cfif>

	<cfif Variables.isContactTemplate.customerUser_subject is True or Variables.isContactTemplate.customerUser_message is True>
		<cfinclude template="formParam_insertUpdateContact_templateCustomerUser.cfm">
	</cfif>

	<!--- customer phone information --->
	<cfif FindNoCase("<<phone", qry_selectContactTemplate.contactTemplateMessage)>
		<cfinclude template="formParam_insertUpdateContact_templateCustomerPhone.cfm">
	</cfif>
</cfif>

<!--- customer company information --->
<cfif Variables.companyID is not 0>
	<cfset Variables.isContactTemplate.customerCompany_subject = False>
	<cfset Variables.isContactTemplate.customerCompany_message = False>

	<cfif FindNoCase("<<company", qry_selectContactTemplate.contactTemplateSubject)>
		<cfset Variables.isContactTemplate.customerCompany_subject = True>
	</cfif>
	<cfif FindNoCase("<<company", qry_selectContactTemplate.contactTemplateMessage)>
		<cfset Variables.isContactTemplate.customerCompany_message = True>
	</cfif>

	<cfif Variables.isContactTemplate.customerCompany_subject is True or Variables.isContactTemplate.customerCompany_message is True>
		<cfinclude template="formParam_insertUpdateContact_templateCustomerCompany.cfm">
	</cfif>
</cfif>

<!--- customer invoice info, including shipment, shipping/billing addresses --->
<cfif Variables.invoiceID is not 0>
	<cfinclude template="formParam_insertUpdateContact_templateInvoice.cfm">
</cfif>

<!--- admin user --->
<cfset Variables.isContactTemplate.adminUser_subject = False>
<cfset Variables.isContactTemplate.adminUser_message = False>

<cfif FindNoCase("<<admin", qry_selectContactTemplate.contactTemplateSubject)>
	<cfset Variables.isContactTemplate.adminUser_subject = True>
</cfif>
<cfif FindNoCase("<<admin", qry_selectContactTemplate.contactTemplateMessage)>
	<cfset Variables.isContactTemplate.adminUser_message = True>
</cfif>

<cfif Variables.isContactTemplate.adminUser_subject is True or Variables.isContactTemplate.adminUser_message is True>
	<cfinclude template="formParam_insertUpdateContact_templateAdminUser.cfm">
</cfif>

<!--- admin phone --->
<cfif FindNoCase("<<adminPhone", qry_selectContactTemplate.contactTemplateMessage)>
	<cfinclude template="formParam_insertUpdateContact_templateAdminPhone.cfm">
</cfif>

<!--- admin company --->
<cfset Variables.isContactTemplate.adminCompany_subject = False>
<cfset Variables.isContactTemplate.adminCompany_message = False>

<cfif FindNoCase("<<adminCompany", qry_selectContactTemplate.contactTemplateSubject)>
	<cfset Variables.isContactTemplate.adminCompany_subject = True>
</cfif>
<cfif FindNoCase("<<adminCompany", qry_selectContactTemplate.contactTemplateMessage)>
	<cfset Variables.isContactTemplate.adminCompany_message = True>
</cfif>

<cfif Variables.isContactTemplate.adminCompany_subject is True or Variables.isContactTemplate.adminCompany_message is True>
	<cfinclude template="formParam_insertUpdateContact_templateAdminCompany.cfm">
</cfif>

