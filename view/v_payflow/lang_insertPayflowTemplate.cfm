<cfset Variables.lang_insertPayflowTemplate = StructNew()>

<cfset Variables.lang_insertPayflowTemplate.payflowTemplatePaymentMethod_notBlank = "For <<TYPE>> ##<<COUNT>>, you cannot check a payment method without selecting a template.">
<cfset Variables.lang_insertPayflowTemplate.payflowTemplateNotifyMethod_notBlank = "For <<TYPE>> ##<<COUNT>>, you cannot check a notification method without selecting a template.">
<cfset Variables.lang_insertPayflowTemplate.templateID_valid = "For <<TYPE>> ##<<COUNT>>, you did not select a valid template.">
<cfset Variables.lang_insertPayflowTemplate.payflowTemplatePaymentMethod_blank = "For <<TYPE>> ##<<COUNT>>, you selected a template but did not select a payment method.">
<cfset Variables.lang_insertPayflowTemplate.payflowTemplatePaymentMethod_maxlength = "For <<TYPE>> ##<<COUNT>>, the payment method must be <<MAXLENGTH>> characters or less. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertPayflowTemplate.payflowTemplatePaymentMethod_valid = "For <<TYPE>> ##<<COUNT>>, you did not select a valid payment method.">
<cfset Variables.lang_insertPayflowTemplate.payflowTemplateNotifyMethod_blank = "For <<TYPE>> ##<<COUNT>>, you selected a template but did not select a notification method.">
<cfset Variables.lang_insertPayflowTemplate.payflowTemplateNotifyMethod_maxlength = "For <<TYPE>> ##<<COUNT>>, the notification method must be <<MAXLENGTH>> characters or less. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertPayflowTemplate.payflowTemplateNotifyMethod_valid = "For <<TYPE>> ##<<COUNT>>, you did not select a valid notification method.">

<cfset Variables.lang_insertPayflowTemplate.errorTitle = "The notification templates could not be updated for the following reason(s):">
<cfset Variables.lang_insertPayflowTemplate.errorHeader = "">
<cfset Variables.lang_insertPayflowTemplate.errorFooter = "">
