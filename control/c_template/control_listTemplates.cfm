<cfinvoke Component="#Application.billingMapping#data.Template" Method="selectTemplateList" ReturnVariable="qry_selectTemplateList">
	<cfinvokeargument Name="companyID" Value="0,#Session.companyID#">
	<cfinvokeargument Name="returnTemplateXML" Value="False">
	<cfinvokeargument Name="returnTemplateUseCount" Value="True">
</cfinvoke>

<cfinclude template="../../view/v_template/lang_listTemplates.cfm">
<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("updateTemplate,viewTemplateSample,copyTemplate,customizeTemplate,updateTemplateDefault")>

<cfif Session.companyID is Application.billingSuperuserCompanyID>
	<cfset Variables.displayTemplateFilename = True>
<cfelse>
	<cfset Variables.displayTemplateFilename = False>
</cfif>

<cfset Variables.templateColumnList = Variables.lang_listTemplates_title.templateName
		& "^" & Variables.lang_listTemplates_title.templateStatus
		& "^" & Variables.lang_listTemplates_title.templateDefault
		& "^" & Variables.lang_listTemplates_title.templateDescription
		& "^" & Variables.lang_listTemplates_title.templateDateCreated
		& "^" & Variables.lang_listTemplates_title.templateDateUpdated>

<cfif REFind("[1-9]", ValueList(qry_selectTemplateList.templateUseCount))>
	<cfset Variables.displayNumberUsed = True>
	<cfset Variables.templateColumnList = Variables.templateColumnList & "^" & Variables.lang_listTemplates_title.templateUseCount>
<cfelse>
	<cfset Variables.displayNumberUsed = False>
</cfif>

<cfif ListFind(Variables.permissionActionList, "updateTemplate") or ListFind(Variables.permissionActionList, "viewTemplateSample")
		or ListFind(Variables.permissionActionList, "copyTemplate") or ListFind(Variables.permissionActionList, "customizeTemplate")>
	<cfset Variables.templateColumnList = Variables.templateColumnList & "^" & Variables.lang_listTemplates_title.viewTemplateSample>
</cfif>

<cfset Variables.templateColumnCount = DecrementValue(2 * ListLen(Variables.templateColumnList, "^"))>

<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../view/v_template/dsp_selectTemplateList.cfm">
