<cfif Not Application.fn_IsIntegerNonNegative(URL.templateID)>
	<cflocation url="index.cfm?method=template.listTemplates&error_template=noTemplate" AddToken="No">
<cfelseif URL.templateID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Template" Method="checkTemplatePermission" ReturnVariable="isTemplatePermission">
		<cfinvokeargument Name="templateID" Value="#URL.templateID#">
		<cfif ListFind("viewTemplateSample,copyTemplate,updateTemplateDefault", Variables.doAction) or Session.companyID is Application.billingSuperuserCompanyID>
			<cfinvokeargument Name="companyID" Value="0,#Session.companyID#">
		<cfelse>
			<cfinvokeargument Name="companyID" Value="#Session.companyID#">
		</cfif>
	</cfinvoke>

	<cfif isTemplatePermission is True>
		<cfinvoke Component="#Application.billingMapping#data.Template" Method="selectTemplate" ReturnVariable="qry_selectTemplate">
			<cfinvokeargument Name="templateID" Value="#URL.templateID#">
			<cfif ListFind("customizeTemplate,copyTemplate,viewTemplateSample", Variables.doAction)>
				<cfinvokeargument Name="returnTemplateXML" Value="True">
			<cfelse>
				<cfinvokeargument Name="returnTemplateXML" Value="False">
			</cfif>
		</cfinvoke>
	<cfelse>
		<cflocation url="index.cfm?method=template.listTemplates&error_template=invalidTemplate" AddToken="No">
	</cfif>
<cfelseif Not ListFind("listTemplates,insertTemplate", Variables.doAction)>
	<cflocation url="index.cfm?method=template.listTemplates&error_template=noTemplate" AddToken="No">
</cfif>
