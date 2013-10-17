<cfinvoke Component="#Application.billingMapping#data.Status" Method="selectStatusList" ReturnVariable="qry_selectStatusList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	<cfinvokeargument Name="primaryTargetID" Value="#qry_selectStatus.primaryTargetID#">
</cfinvoke>

<cfinvoke component="#Application.billingMapping#data.Status" method="maxlength_Status" returnVariable="maxlength_Status" />
<cfinclude template="formParam_insertUpdateStatus.cfm">
<cfinclude template="../../view/v_status/lang_insertUpdateStatus.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitStatus")>
	<cfinclude template="formValidate_insertUpdateStatus.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Status" Method="updateStatus" ReturnVariable="isStatusUpdated">
			<cfinvokeargument Name="statusID" Value="#URL.statusID#">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="statusName" Value="#Form.statusName#">
			<cfinvokeargument Name="statusTitle" Value="#Form.statusTitle#">
			<cfinvokeargument Name="statusDisplayToCustomer" Value="#Form.statusDisplayToCustomer#">
			<cfinvokeargument Name="statusDescription" Value="#Form.statusDescription#">
			<cfinvokeargument Name="statusStatus" Value="#Form.statusStatus#">
			<cfinvokeargument Name="statusID_custom" Value="#Form.statusID_custom#">
		</cfinvoke>

		<cflocation url="index.cfm?method=status.#Variables.doAction#&primaryTargetID=#URL.primaryTargetID#&statusID=#URL.statusID#&confirm_status=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formSubmitValue = Variables.lang_insertUpdateStatus.formSubmitValue_update>
<cfset Variables.formAction = "index.cfm?method=status.#Variables.doAction#&primaryTargetID=#URL.primaryTargetID#&statusID=#URL.statusID#">

<cfinclude template="../../view/v_status/form_insertUpdateStatus.cfm">
