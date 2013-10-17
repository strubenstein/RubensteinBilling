<cfif qry_selectTemplate.companyID is not 0 and qry_selectTemplate.templateDefault is 1>
	<cflocation url="index.cfm?method=template.listTemplates&error_template=#Variables.doAction#" AddToken="No">
</cfif>

<cfinvoke Component="#Application.billingMapping#data.Template" Method="selectTemplateList" ReturnVariable="qry_selectTemplateList">
	<cfif qry_selectTemplate.companyID is 0 and Session.companyID is Application.billingSuperuserCompanyID>
		<cfinvokeargument Name="companyID" Value="0,#Session.companyID#">
	<cfelse>
		<cfinvokeargument Name="companyID" Value="#qry_selectTemplate.companyID#">
	</cfif>
	<cfinvokeargument Name="templateType" Value="#qry_selectTemplate.templateType#">
	<cfinvokeargument Name="templateDefault" Value="1">
	<cfinvokeargument Name="returnTemplateXML" Value="False">
</cfinvoke>

<cfif qry_selectTemplateList.RecordCount gte 1>
	<cfinvoke Component="#Application.billingMapping#data.Template" Method="updateTemplate" ReturnVariable="isTemplateUpdated">
		<cfinvokeargument Name="templateID" Value="#qry_selectTemplateList.templateID[1]#">
		<cfinvokeargument Name="templateDefault" Value="0">
	</cfinvoke>
</cfif>

<cfif qry_selectTemplate.companyID is not 0 or Session.companyID is Application.billingSuperuserCompanyID>
	<cfinvoke Component="#Application.billingMapping#data.Template" Method="updateTemplate" ReturnVariable="isTemplateUpdated">
		<cfinvokeargument Name="templateID" Value="#URL.templateID#">
		<cfinvokeargument Name="templateDefault" Value="1">
	</cfinvoke>
</cfif>

<cflocation url="index.cfm?method=template.listTemplates&confirm_template=#Variables.doAction#" AddToken="No">
