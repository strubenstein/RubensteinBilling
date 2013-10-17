<cfif IsDefined("qry_selectPayflowTemplateList") and Not IsDefined("Form.isFormSubmitted")>
	<cfloop Query="qry_selectPayflowTemplateList">
		<cfif Not IsDefined("Form.#qry_selectPayflowTemplateList.payflowTemplateType#Count")>
			<cfset Form["#qry_selectPayflowTemplateList.payflowTemplateType#Count"] = 1>
			<cfset count = 1>
		<cfelse>	
			<cfset Form["#qry_selectPayflowTemplateList.payflowTemplateType#Count"] = Form["#qry_selectPayflowTemplateList.payflowTemplateType#Count"] + 1>
			<cfset count = Form["#qry_selectPayflowTemplateList.payflowTemplateType#Count"]>
		</cfif>

		<cfparam Name="Form.templateID_#qry_selectPayflowTemplateList.payflowTemplateType##count#" Default="#qry_selectPayflowTemplateList.templateID#">
		<cfparam Name="Form.payflowTemplatePaymentMethod_#qry_selectPayflowTemplateList.payflowTemplateType##count#" Default="#qry_selectPayflowTemplateList.payflowTemplatePaymentMethod#">
		<cfparam Name="Form.payflowTemplateNotifyMethod_#qry_selectPayflowTemplateList.payflowTemplateType##count#" Default="#qry_selectPayflowTemplateList.payflowTemplateNotifyMethod#">
	</cfloop>
</cfif>

<cfloop Index="type" List="#Variables.payflowTemplateTypeList_value#">
	<cfparam Name="Form.#type#Count" Default="1">
	<cfif Not Application.fn_IsIntegerPositive(Form["#type#Count"])>
		<cfset Form["#type#Count"] = 1>
	</cfif>

	<cfloop Index="count" From="1" To="#Form["#type#Count"]#">
		<cfparam Name="Form.templateID_#type##count#" Default="">
		<cfparam Name="Form.payflowTemplatePaymentMethod_#type##count#" Default="">
		<cfparam Name="Form.payflowTemplateNotifyMethod_#type##count#" Default="">
	</cfloop>
</cfloop>
