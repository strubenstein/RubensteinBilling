<cfinvoke Component="#Application.billingMapping#data.TriggerAction" Method="selectTriggerActionList" ReturnVariable="qry_selectTriggerActionList" />

<cfset Variables.formAction = "index.cfm?method=trigger.#Variables.doAction#">
<cfif Variables.doAction is "updateTriggerAction">
	<cfset Variables.formAction = Variables.formAction & "&triggerAction=#URL.triggerAction#">
</cfif>

<cfinvoke component="#Application.billingMapping#data.TriggerAction" method="maxlength_TriggerAction" returnVariable="maxlength_TriggerAction" />
<cfinclude template="formParam_insertUpdateTriggerAction.cfm">
<cfinclude template="../../view/v_trigger/lang_insertUpdateTriggerAction.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitTriggerAction")>
	<cfinclude template="formValidate_insertUpdateTriggerAction.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelseif Variables.doAction is "insertTriggerAction">
		<cfinvoke Component="#Application.billingMapping#data.TriggerAction" Method="insertTriggerAction" ReturnVariable="isTriggerActionInserted">
			<cfinvokeargument Name="triggerAction" Value="#Form.triggerAction#">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="triggerActionControl" Value="#Form.triggerActionControl#">
			<cfinvokeargument Name="triggerActionDescription" Value="#Form.triggerActionDescription#">
			<cfinvokeargument Name="triggerActionStatus" Value="#Form.triggerActionStatus#">
			<cfinvokeargument Name="triggerActionSuperuserOnly" Value="#Form.triggerActionSuperuserOnly#">
			<cfinvokeargument Name="triggerActionOrder" Value="#Form.triggerActionOrder#">
		</cfinvoke>

		<cflocation url="#Variables.formAction#&confirm_trigger=#Variables.doAction#" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.TriggerAction" Method="updateTriggerAction" ReturnVariable="isTriggerActionUpdated">
			<cfinvokeargument Name="triggerAction" Value="#URL.triggerAction#">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="triggerActionControl" Value="#Form.triggerActionControl#">
			<cfinvokeargument Name="triggerActionDescription" Value="#Form.triggerActionDescription#">
			<cfinvokeargument Name="triggerActionStatus" Value="#Form.triggerActionStatus#">
			<cfinvokeargument Name="triggerActionSuperuserOnly" Value="#Form.triggerActionSuperuserOnly#">
		</cfinvoke>

		<cflocation url="#Variables.formAction#&confirm_trigger=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formSubmitValue = Variables.lang_insertUpdateTriggerAction.formSubmitValue>
<cfinclude template="../../view/v_trigger/form_insertUpdateTriggerAction.cfm">
