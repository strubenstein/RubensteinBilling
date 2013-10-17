<!--- select default invoice templates --->
<cfset Variables.templateID = qry_selectPayflow.templateID>
<cfsavecontent Variable="Variables.invoiceTemplateText">
	<cfinclude template="../c_invoice/act_generateInvoiceTemplate.cfm">
</cfsavecontent>
<cfset Variables.invoiceTemplateText = Trim(Variables.invoiceTemplateText)>

<!--- check for existing invoice documents --->
<cfinvoke Component="#Application.billingMapping#data.InvoiceTemplate" Method="selectInvoiceTemplate" ReturnVariable="qry_selectInvoiceTemplate">
	<cfinvokeargument Name="invoiceID" Value="#Variables.invoiceID#">
	<cfinvokeargument Name="templateID" Value="#Variables.templateID#">
</cfinvoke>

<cfif qry_selectInvoiceTemplate.RecordCount is 0>
	<cfset Variables.invoiceTemplateAction = "insertInvoiceTemplate">
<cfelse>
	<cfset Variables.invoiceTemplateAction = "updateInvoiceTemplate">
</cfif>

<cfinvoke Component="#Application.billingMapping#data.InvoiceTemplate" Method="#Variables.invoiceTemplateAction#" ReturnVariable="isInvoiceTemplateInserted">
	<cfinvokeargument Name="invoiceID" Value="#Variables.invoiceID#">
	<cfinvokeargument Name="templateID" Value="#Variables.templateID#">
	<cfinvokeargument Name="invoiceTemplateStatus" Value="1">
	<cfinvokeargument Name="invoiceTemplateManual" Value="0">
	<cfinvokeargument Name="invoiceTemplateText" Value="#Variables.invoiceTemplateText#">
	<cfinvokeargument Name="invoiceTemplateHtml" Value="1">
	<cfinvokeargument Name="userID" Value="0">
</cfinvoke>

