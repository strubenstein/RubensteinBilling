<cfoutput>
<form method="get" action="index.cfm">
<input type="hidden" name="method" value="invoice.viewInvoiceTemplate">
<input type="hidden" name="invoiceID" value="#URL.invoiceID#">
<div class="MainText"><b>Select the template to use for displaying this invoice:</b></div>
<select name="templateID" size="1">
<cfloop Query="qry_selectTemplateList">
	<cfset Variables.invoiceTemplateRow = ListFind(ValueList(qry_selectInvoiceTemplateList.templateID), qry_selectTemplateList.templateID)>
	<option value="#qry_selectTemplateList.templateID#"<cfif URL.templateID is qry_selectTemplateList.templateID> selected</cfif>>#HTMLEditFormat(qry_selectTemplateList.templateName)#<cfif Variables.invoiceTemplateRow is not 0> *<cfif qry_selectInvoiceTemplateList.invoiceTemplateStatus[Variables.invoiceTemplateRow] is 1> (current)</cfif></cfif></option>
</cfloop>
</select> <input type="submit" value="Go">
<div class="SmallText">* indicates the invoice via this template already exists.</div>
</form>
</cfoutput>
