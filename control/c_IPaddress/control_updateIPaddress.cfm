<cfinvoke component="#Application.billingMapping#data.IPaddress" method="maxlength_IPaddress" returnVariable="maxlength_IPaddress" />
<cfinclude template="formParam_insertUpdateIPaddress.cfm">
<cfinclude template="../../view/v_IPaddress/lang_insertUpdateIPaddress.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitIPaddress")>
	<cfinvoke Component="#Application.billingMapping#data.IPaddress" Method="selectIPaddressList" ReturnVariable="qry_selectIPaddressList">
		<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	</cfinvoke>

	<cfinclude template="../../include/function/fn_IPaddress.cfm">
	<cfinclude template="formValidate_insertUpdateIPaddress.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.IPaddress" Method="updateIPaddress" ReturnVariable="isIPaddressUpdated">
			<cfinvokeargument Name="IPaddressID" Value="#URL.IPaddressID#">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="IPaddress" Value="#Form.IPaddress#">
			<cfinvokeargument Name="IPaddress_max" Value="#Form.IPaddress_max#">
			<cfinvokeargument Name="IPaddressBrowser" Value="#Form.IPaddressBrowser#">
			<cfinvokeargument Name="IPaddressWebService" Value="#Form.IPaddressWebService#">
		</cfinvoke>

		<cflocation url="index.cfm?method=IPaddress.#Variables.doAction#&IPaddressID=#URL.IPaddressID#&confirm_IPaddress=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = "index.cfm?method=IPaddress.#Variables.doAction#&IPaddressID=#URL.IPaddressID#">
<cfset Variables.formSubmitValue = Variables.lang_insertUpdateIPaddress.formSubmitValue_update>

<cfinclude template="../../view/v_IPaddress/form_insertUpdateIPaddress.cfm">

