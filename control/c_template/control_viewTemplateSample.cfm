<cfif qry_selectTemplate.templateType is not "Invoice">
	<cfset URL.error_template = Variables.doAction>
	<cfinclude template="../../view/v_template/error_template.cfm">
<cfelse>
	<cfinclude template="../c_invoice/act_previewInvoiceTemplate.cfm">

	<!--- convert template XML options into simpler structure --->
	<cfset Variables.templateStruct = StructNew()>
	<cfinclude template="../../view/v_template/var_templateFormFields_#qry_selectTemplate.templateFilename#"><!--- defaultInvoice.cfm --->
	<cfset templateXmlObject = XmlParse("<templateXml>#qry_selectTemplate.templateXml#</templateXml>")>
	<cfloop Index="field" List="#Variables.templateFormFields#">
		<cfif StructKeyExists(templateXmlObject.templateXml, field)>
			<cfset Variables.templateStruct[field] = templateXmlObject.templateXml[field].XmlText>
		<cfelse>
			<cfset Variables.templateStruct[field] = "">
		</cfif>
	</cfloop>

	<cfinclude template="../../include/template/#qry_selectTemplate.templateFilename#"><!--- defaultInvoice.cfm --->
</cfif>

