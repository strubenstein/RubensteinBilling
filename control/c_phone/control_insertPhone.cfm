<cfinclude template="formParam_insertPhone.cfm">
<cfinvoke component="#Application.billingMapping#data.Phone" method="maxlength_Phone" returnVariable="maxlength_Phone" />

<cfinclude template="../../view/v_phone/lang_insertPhone.cfm">
<cfinclude template="../../view/v_phone/var_phoneTypeList.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitPhone")>
	<cfinclude template="formValidate_insertPhone.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfif URL.phoneID is 0>
			<cfset Variables.phoneID_trend = 0>
			<cfset Variables.phoneID_parent = 0>
			<cfset Variables.phoneVersion = 1>
		<cfelse>
			<cfset Variables.phoneID_trend = qry_selectPhone.phoneID_trend>
			<cfset Variables.phoneID_parent = URL.phoneID>
			<cfset Variables.phoneVersion = qry_selectPhone.phoneVersion + 1>

			<cfinvoke Component="#Application.billingMapping#data.Phone" Method="updatePhone" ReturnVariable="isPhoneUpdated">
				<cfinvokeargument Name="phoneID" Value="#URL.phoneID#">
				<cfinvokeargument Name="phoneStatus" Value="0">
			</cfinvoke>
		</cfif>

		<cfinvoke Component="#Application.billingMapping#data.Phone" Method="insertPhone" ReturnVariable="newPhoneID">
			<cfinvokeargument Name="companyID" Value="#URL.companyID#">
			<cfinvokeargument Name="userID" Value="#URL.userID#">
			<cfinvokeargument Name="userID_author" Value="#Session.userID#">
			<cfinvokeargument Name="phoneStatus" Value="1">
			<cfinvokeargument Name="phoneID_trend" Value="#Variables.phoneID_trend#">
			<cfinvokeargument Name="phoneID_parent" Value="#Variables.phoneID_parent#">
			<cfinvokeargument Name="phoneVersion" Value="#Variables.phoneVersion#">
			<cfinvokeargument Name="phoneAreaCode" Value="#Form.phoneAreaCode#">
			<cfinvokeargument Name="phoneNumber" Value="#Form.phoneNumber#">
			<cfinvokeargument Name="phoneExtension" Value="#Form.phoneExtension#">
			<cfinvokeargument Name="phoneType" Value="#Form.phoneType#">
			<cfinvokeargument Name="phoneDescription" Value="#Form.phoneDescription#">
		</cfinvoke>

		<cflocation url="#Variables.phoneActionList#&confirm_phone=#URL.action#" AddToken="No">
	</cfif>
</cfif>

<cfif URL.phoneID is 0>
	<cfset Variables.formSubmitValue = Variables.lang_insertPhone.formSubmitValue_insert>
<cfelse>
	<cfset Variables.formAction = Variables.formAction & "&phoneID=#URL.phoneID#">
	<cfset Variables.formSubmitValue = Variables.lang_insertPhone.formSubmitValue_update>
</cfif>

<cfinclude template="../../view/v_phone/form_insertPhone.cfm">
