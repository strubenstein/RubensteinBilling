<cfinvoke Component="#Application.billingMapping#data.Template" Method="selectTemplateList" ReturnVariable="qry_selectTemplateList">
	<cfinvokeargument Name="companyID" Value="0,#Session.companyID_author#">
	<cfinvokeargument Name="templateType" Value="Invoice">
	<cfinvokeargument Name="returnTemplateXML" Value="False">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.InvoiceTemplate" Method="selectInvoiceTemplateList" ReturnVariable="qry_selectInvoiceTemplateList">
	<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
</cfinvoke>

<cfloop Query="qry_selectTemplateList">
	<cfif qry_selectTemplateList.templateDefault is 1>
		<cfparam Name="URL.templateID" Default="#qry_selectTemplateList.templateID#">
		<cfbreak>
	</cfif>
</cfloop>

<cfparam Name="URL.templateID" Default="0">

<cfif qry_selectTemplateList.RecordCount is 0>
	<cflocation url="index.cfm?method=invoice.viewInvoice&invoiceID=#URL.invoiceID#&error_invoice=#Variables.doAction#" AddToken="No">
<cfelseif qry_selectTemplateList.RecordCount is 1>
	<cfset URL.templateID = qry_selectTemplateList.templateID>
<cfelseif URL.templateID is 0 or Not ListFind(ValueList(qry_selectTemplateList.templateID), URL.templateID)>
	<!--- <cfset Variables.invoiceTemplateRow = ListFind(ValueList(qry_selectInvoiceTemplateList.invoiceTemplateStatus), 1)> --->
	<cfset Variables.invoiceTemplateRow_current = 0>
	<cfloop Query="qry_selectInvoiceTemplateList">
		<cfif qry_selectInvoiceTemplateList.invoiceTemplateStatus is 1>
			<cfset Variables.invoiceTemplateRow_current = CurrentRow>
			<cfset URL.templateID = qry_selectInvoiceTemplateList.templateID>
			<cfbreak>
		</cfif>
	</cfloop>

	<cfif Variables.invoiceTemplateRow_current is 0>
		<cfset URL.templateID = qry_selectTemplateList.templateID[1]>
	</cfif>
</cfif>

<cfinclude template="../../view/v_template/form_viewInvoiceTemplate.cfm">

<cfif URL.templateID is not 0>
	<cfset Variables.invoiceTemplateRow = ListFind(ValueList(qry_selectInvoiceTemplateList.templateID), URL.templateID)>
	<!--- invoice already exists for this template AND template is completed, so do not re-create invoice --->
	<cfif qry_selectInvoice.invoiceCompleted is 1 and Variables.invoiceTemplateRow is not 0>
		<cfoutput>#qry_selectInvoiceTemplateList.invoiceTemplateText[Variables.invoiceTemplateRow]#</cfoutput>
	<cfelse>
		<cfset Variables.invoiceID = URL.invoiceID>
		<cfset Variables.templateID = URL.templateID>

		<cfsavecontent Variable="Variables.invoiceTemplateText">
			<cfinclude template="act_generateInvoiceTemplate.cfm">
		</cfsavecontent>
		<cfset Variables.invoiceTemplateText = Trim(Variables.invoiceTemplateText)>

		<cfoutput>#Variables.invoiceTemplateText#</cfoutput>

		<cfif Not ListFind(ValueList(qry_selectInvoiceTemplateList.templateID), URL.templateID)>
			<cfset Variables.invoiceTemplateAction = "insertInvoiceTemplate">
		<cfelse>
			<cfset Variables.invoiceTemplateAction = "updateInvoiceTemplate">
		</cfif>

		<cfinvoke Component="#Application.billingMapping#data.InvoiceTemplate" Method="#Variables.invoiceTemplateAction#" ReturnVariable="isInvoiceTemplateInserted">
			<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
			<cfinvokeargument Name="templateID" Value="#URL.templateID#">
			<cfinvokeargument Name="invoiceTemplateStatus" Value="1">
			<cfinvokeargument Name="invoiceTemplateManual" Value="1">
			<cfinvokeargument Name="invoiceTemplateText" Value="#Variables.invoiceTemplateText#">
			<cfinvokeargument Name="invoiceTemplateHtml" Value="1">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
		</cfinvoke>
	</cfif>
</cfif>
