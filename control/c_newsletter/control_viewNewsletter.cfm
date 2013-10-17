<cfinvoke Component="#Application.billingMapping#data.Contact" Method="selectContact" ReturnVariable="qry_selectContact">
	<cfinvokeargument Name="contactID" Value="#qry_selectNewsletter.contactID#">
</cfinvoke>

<cfif qry_selectContact.contactTemplateID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.ContactTemplate" Method="selectContactTemplate" ReturnVariable="qry_selectContactTemplate">
		<cfinvokeargument Name="contactTemplateID" Value="#qry_selectContact.contactTemplateID#">
	</cfinvoke>
</cfif>

<cfinclude template="formParam_newsletterCriteria.cfm">
<cfinclude template="control_listNewsletterSubscribers.cfm">

<cfset Variables.formName = "viewNewsletter">
<cfset Variables.formAction = "">

<cfinclude template="../../view/v_newsletter/dsp_selectNewsletter.cfm">
