<cfif Not Application.fn_IsIntegerNonNegative(URL.contactTemplateID)>
	<cflocation url="index.cfm?method=contactTemplate.listContactTemplates&error_contactTemplate=noContactTemplate" AddToken="No">
<cfelseif URL.contactTemplateID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.ContactTemplate" Method="checkContactTemplatePermission" ReturnVariable="isContactTemplatePermission">
		<cfinvokeargument Name="contactTemplateID" Value="#URL.contactTemplateID#">
		<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	</cfinvoke>

	<cfif isContactTemplatePermission is True>
		<cfinvoke Component="#Application.billingMapping#data.ContactTemplate" Method="selectContactTemplate" ReturnVariable="qry_selectContactTemplate">
			<cfinvokeargument Name="contactTemplateID" Value="#URL.contactTemplateID#">
		</cfinvoke>
	<cfelse>
		<cflocation url="index.cfm?method=contactTemplate.listContactTemplates&error_contactTemplate=invalidContactTemplate" AddToken="No">
	</cfif>
<cfelseif Not ListFind("listContactTemplates,insertContactTemplate,viewContactTemplateFields", Variables.doAction)>
	<cflocation url="index.cfm?method=contactTemplate.listContactTemplates&error_contactTemplate=noContactTemplate" AddToken="No">
</cfif>
