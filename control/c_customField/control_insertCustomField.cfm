<cfinvoke component="#Application.billingMapping#data.CustomField" method="maxlength_CustomField" returnVariable="maxlength_CustomField" />
<cfinvoke component="#Application.billingMapping#data.CustomFieldOption" method="maxlength_CustomFieldOption" returnVariable="maxlength_CustomFieldOption" />

<cfinclude template="formParam_insertUpdateCustomField.cfm">

<cfinclude template="../../view/v_customField/lang_insertUpdateCustomField.cfm">
<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitCustomField")>
	<cfinvoke component="#Application.billingMapping#data.CustomFieldValue" method="maxlength_CustomFieldVarchar" returnVariable="maxlength_CustomFieldVarchar" />
	<cfinvoke component="#Application.billingMapping#data.CustomFieldValue" method="maxlength_CustomFieldDecimal" returnVariable="maxlength_CustomFieldDecimal" />
	<cfinclude template="formValidate_insertUpdateCustomField.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.CustomField" Method="insertCustomField" ReturnVariable="newCustomFieldID">
			<cfinvokeargument Name="companyID" Value="#Session.companyID#">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="customFieldName" Value="#Form.customFieldName#">
			<cfinvokeargument Name="customFieldTitle" Value="#Form.customFieldTitle#">
			<cfinvokeargument Name="customFieldDescription" Value="#Form.customFieldDescription#">
			<cfinvokeargument Name="customFieldType" Value="#Form.customFieldType#">
			<cfinvokeargument Name="customFieldFormType" Value="#Form.customFieldFormType#">
			<cfinvokeargument Name="customFieldStatus" Value="#Form.customFieldStatus#">
			<cfinvokeargument Name="customFieldExportXml" Value="#Form.customFieldExportXml#">
			<cfinvokeargument Name="customFieldExportTab" Value="#Form.customFieldExportTab#">
			<cfinvokeargument Name="customFieldExportHtml" Value="#Form.customFieldExportHtml#">
			<cfinvokeargument Name="customFieldInternal" value="#Form.customFieldInternal#">
		</cfinvoke>

		<cfif Variables.customFieldOptionCount gt 0>
			<cfset Variables.customFieldOptionLabel_array = ArrayNew(1)>
			<cfset Variables.customFieldOptionValue_array = ArrayNew(1)>

			<cfloop Index="count" From="1" To="#Variables.customFieldOptionCount#">
				<cfset Variables.customFieldOptionLabel_array[count] = Form["customFieldOptionLabel#count#"]>
				<cfset Variables.customFieldOptionValue_array[count] = Form["customFieldOptionValue#count#"]>
			</cfloop>

			<cfinvoke Component="#Application.billingMapping#data.CustomFieldOption" Method="insertCustomFieldOption" ReturnVariable="isCustomFieldOptionInserted">
				<cfinvokeargument Name="customFieldID" Value="#newCustomFieldID#">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="customFieldOptionLabel" Value="#Variables.customFieldOptionLabel_array#">
				<cfinvokeargument Name="customFieldOptionValue" Value="#Variables.customFieldOptionValue_array#">
			</cfinvoke>
		</cfif>

		<cfloop Index="thisPrimaryTargetID" List="#Form.primaryTargetID#">
			<cfinvoke Component="#Application.billingMapping#data.CustomFieldTarget" Method="insertCustomFieldTarget" ReturnVariable="isCustomFieldTargetInserted">
				<cfinvokeargument Name="companyID" Value="#Session.companyID#">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="customFieldID" Value="#newCustomFieldID#">
				<cfinvokeargument Name="primaryTargetID" Value="#thisPrimaryTargetID#">
			</cfinvoke>
		</cfloop>

		<cflocation url="index.cfm?method=customField.listCustomFields&confirm_customField=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formName = "insertUpdateCustomField">
<cfset Variables.formAction = "index.cfm?method=customField.#Variables.doAction#">
<cfset Variables.formSubmitValue = Variables.lang_insertUpdateCustomField.formSubmitValue_insert>

<cfinclude template="../../view/v_customField/form_insertUpdateCustomField.cfm">
