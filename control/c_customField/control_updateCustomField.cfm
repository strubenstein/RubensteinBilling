<cfinvoke component="#Application.billingMapping#data.CustomField" method="maxlength_CustomField" returnVariable="maxlength_CustomField" />
<cfinvoke component="#Application.billingMapping#data.CustomFieldOption" method="maxlength_CustomFieldOption" returnVariable="maxlength_CustomFieldOption" />

<cfinvoke Component="#Application.billingMapping#data.CustomFieldOption" Method="selectCustomFieldOptionList" ReturnVariable="qry_selectCustomFieldOptionList">
	<cfinvokeargument Name="customFieldID" Value="#URL.customFieldID#">
	<cfinvokeargument Name="customFieldOptionStatus" Value="1">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.CustomFieldTarget" Method="selectCustomFieldTargetList" ReturnVariable="qry_selectCustomFieldTargetList">
	<cfinvokeargument Name="customFieldID" Value="#URL.customFieldID#">
	<!--- <cfinvokeargument Name="customFieldTargetStatus" Value="1"> --->
</cfinvoke>

<cfinclude template="formParam_insertUpdateCustomField.cfm">

<cfinclude template="../../view/v_customField/lang_insertUpdateCustomField.cfm">
<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitCustomField")>
	<cfinvoke component="#Application.billingMapping#data.CustomFieldValue" method="maxlength_CustomFieldVarchar" returnVariable="maxlength_CustomFieldVarchar" />
	<cfinvoke component="#Application.billingMapping#data.CustomFieldValue" method="maxlength_CustomFieldDecimal" returnVariable="maxlength_CustomFieldDecimal" />
	<cfinclude template="formValidate_insertUpdateCustomField.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.CustomField" Method="updateCustomField" ReturnVariable="isCustomFieldUpdated">
			<cfinvokeargument Name="customFieldID" Value="#URL.customFieldID#">
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
				<cfinvokeargument Name="customFieldID" Value="#URL.customFieldID#">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="customFieldOptionLabel" Value="#Variables.customFieldOptionLabel_array#">
				<cfinvokeargument Name="customFieldOptionValue" Value="#Variables.customFieldOptionValue_array#">
			</cfinvoke>
		</cfif>

		<cfset Variables.primaryTargetID_nowInactive = "">
		<cfset Variables.primaryTargetID_nowActive = "">

		<cfloop Index="thisPrimaryTargetID" List="#Form.primaryTargetID#">
			<cfset Variables.targetRow = ListFind(ValueList(qry_selectCustomFieldTargetList.primaryTargetID), thisPrimaryTargetID)>
			<cfif Variables.targetRow is 0><!--- insert target --->
				<cfinvoke Component="#Application.billingMapping#data.CustomFieldTarget" Method="insertCustomFieldTarget" ReturnVariable="isCustomFieldTargetInserted">
					<cfinvokeargument Name="companyID" Value="#Session.companyID#">
					<cfinvokeargument Name="userID" Value="#Session.userID#">
					<cfinvokeargument Name="customFieldID" Value="#URL.customFieldID#">
					<cfinvokeargument Name="primaryTargetID" Value="#thisPrimaryTargetID#">
				</cfinvoke>
			<cfelseif qry_selectCustomFieldTargetList.customFieldTargetStatus[Variables.targetRow] is 0><!--- update target if not active --->
				<cfset Variables.primaryTargetID_nowActive = ListAppend(Variables.primaryTargetID_nowActive, thisPrimaryTargetID)>
			</cfif>
		</cfloop>

		<cfif Variables.primaryTargetID_nowActive is not "">
			<cfinvoke Component="#Application.billingMapping#data.CustomFieldTarget" Method="updateCustomFieldTarget" ReturnVariable="isCustomFieldTargetInserted">
				<cfinvokeargument Name="customFieldID" Value="#URL.customFieldID#">
				<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID_nowActive#">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="customFieldTargetStatus" Value="1">
			</cfinvoke>
		</cfif>

		<cfloop Query="qry_selectCustomFieldTargetList">
			<cfif qry_selectCustomFieldTargetList.customFieldTargetStatus is 1 and Not ListFind(Form.primaryTargetID, qry_selectCustomFieldTargetList.primaryTargetID)>
				<cfset Variables.primaryTargetID_nowInactive = ListAppend(Variables.primaryTargetID_nowInactive, qry_selectCustomFieldTargetList.primaryTargetID)>
			</cfif>
		</cfloop>

		<cfif Variables.primaryTargetID_nowInactive is not "">
			<cfinvoke Component="#Application.billingMapping#data.CustomFieldTarget" Method="updateCustomFieldTarget" ReturnVariable="isCustomFieldTargetInserted">
				<cfinvokeargument Name="customFieldID" Value="#URL.customFieldID#">
				<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID_nowInactive#">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="customFieldTargetStatus" Value="0">
			</cfinvoke>
		</cfif>

		<cflocation url="index.cfm?method=customField.#Variables.doAction#&customFieldID=#URL.customFieldID#&confirm_customField=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formName = "insertUpdateCustomField">
<cfset Variables.formAction = "index.cfm?method=customField.#Variables.doAction#&customFieldID=#URL.customFieldID#">
<cfset Variables.formSubmitValue = Variables.lang_insertUpdateCustomField.formSubmitValue_update>

<cfinclude template="../../view/v_customField/form_insertUpdateCustomField.cfm">
