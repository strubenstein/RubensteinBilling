<cfinclude template="../../include/function/fn_datetime.cfm">

<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompany" ReturnVariable="qry_selectTriggerCompany">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
</cfinvoke>

<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="getCompanyTriggerDirectory" returnVariable="triggerDirStruct">
	<cfinvokeargument name="companyDirectory" value="#qry_selectTriggerCompany.companyDirectory#">
</cfinvoke>

<cfinclude template="formParam_insertUpdateTrigger.cfm">
<cfinvoke component="#Application.billingMapping#data.Trigger" method="maxlength_Trigger" returnVariable="maxlength_Trigger" />
<cfinclude template="../../view/v_trigger/lang_insertUpdateTrigger.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitTrigger")>
	<cfinclude template="formValidate_insertUpdateTrigger.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelseif Variables.doAction is "insertTrigger">
		<cfinvoke Component="#Application.billingMapping#data.Trigger" Method="insertTrigger" ReturnVariable="isTriggerInserted">
			<cfinvokeargument Name="triggerAction" Value="#URL.triggerAction#">
			<cfinvokeargument Name="companyID" Value="#Session.companyID#">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="triggerStatus" Value="#Form.triggerStatus#">
			<cfinvokeargument Name="triggerDescription" Value="#Form.triggerDescription#">
			<cfinvokeargument Name="triggerFilename" Value="#Form.triggerFilename#">
			<cfinvokeargument Name="triggerDateBegin" Value="#Form.triggerDateBegin#">
			<cfinvokeargument Name="triggerDateEnd" Value="#Form.triggerDateEnd#">
		</cfinvoke>

		<cflocation url="index.cfm?method=trigger.listTriggerActions&confirm_trigger=#Variables.doAction#" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Trigger" Method="updateTrigger" ReturnVariable="isTriggerUpdated">
			<cfinvokeargument Name="triggerID" Value="#qry_selectTrigger.triggerID#">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="triggerStatus" Value="#Form.triggerStatus#">
			<cfinvokeargument Name="triggerDescription" Value="#Form.triggerDescription#">
			<cfinvokeargument Name="triggerFilename" Value="#Form.triggerFilename#">
			<cfinvokeargument Name="triggerDateBegin" Value="#Form.triggerDateBegin#">
			<cfinvokeargument Name="triggerDateEnd" Value="#Form.triggerDateEnd#">
		</cfinvoke>

		<cflocation url="index.cfm?method=trigger.listTriggerActions&confirm_trigger=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = "index.cfm?method=trigger.#Variables.doAction#&triggerAction=#URL.triggerAction#">
<cfset Variables.formName = "insertUpdateTrigger">
<cfif Variables.doAction is "insertTrigger">
	<cfset Variables.formSubmitValue = Variables.lang_insertUpdateTrigger.formSubmitValue_insert>
<cfelse>
	<cfset Variables.formSubmitValue = Variables.lang_insertUpdateTrigger.formSubmitValue_update>
</cfif>

<cfinclude template="../../view/v_trigger/form_insertUpdateTrigger.cfm">
