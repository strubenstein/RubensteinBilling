<cfinvoke Component="#Application.billingMapping#data.ContactTemplate" Method="selectContactTemplateList" ReturnVariable="qry_selectContactTemplateList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	<cfinvokeargument Name="returnContactTemplateMessage" Value="False">
</cfinvoke>

<cfinclude template="../../view/v_contactTemplate/lang_listContactTemplates.cfm">

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("insertContactTemplate,moveContactTemplateDown,moveContactTemplateUp,updateContactTemplate")>
<cfset Variables.contactTemplateColumnList = Variables.lang_listContactTemplates_title.contactTemplateOrder
		& "^" & Variables.lang_listContactTemplates_title.contactTemplateName
		& "^" & Variables.lang_listContactTemplates_title.contactTemplateSubject
		& "^" & Variables.lang_listContactTemplates_title.contactTemplateHtml
		& "^" & Variables.lang_listContactTemplates_title.contactTemplateFrom
		& "^" & Variables.lang_listContactTemplates_title.contactTemplateStatus
		& "^" & Variables.lang_listContactTemplates_title.contactTemplateDateCreated
		& "^" & Variables.lang_listContactTemplates_title.contactTemplateDateUpdated>

<cfif ListFind(Variables.permissionActionList, "moveContactTemplateDown") and ListFind(Variables.permissionActionList, "moveContactTemplateUp")>
	<cfset Variables.contactTemplateColumnList = Variables.contactTemplateColumnList & "^" & Variables.lang_listContactTemplates_title.moveContactTemplate>
</cfif>
<cfif ListFind(Variables.permissionActionList, "updateContactTemplate")>
	<cfset Variables.contactTemplateColumnList = Variables.contactTemplateColumnList & "^" & Variables.lang_listContactTemplates_title.updateContactTemplate>
</cfif>

<cfset Variables.contactTemplateColumnCount = DecrementValue(2 * ListLen(Variables.contactTemplateColumnList, "^"))>

<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../view/v_contactTemplate/dsp_selectContactTemplateList.cfm">

