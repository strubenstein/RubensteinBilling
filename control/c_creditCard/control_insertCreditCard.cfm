<cfinclude template="formParam_insertCreditCard.cfm">
<cfinvoke component="#Application.billingMapping#data.CreditCard" method="maxlength_CreditCard" returnVariable="maxlength_CreditCard" />
<cfinclude template="../../view/v_creditCard/var_creditCardTypeList.cfm">
<cfinclude template="../../view/v_creditCard/var_creditCardExpirationMonthList.cfm">

<cfinvoke Component="#Application.billingMapping#data.Address" Method="selectAddressList" ReturnVariable="qry_selectAddressList">
	<cfinvokeargument Name="companyID" Value="#URL.companyID#">
	<cfif Variables.doControl is "user" or URL.userID is not 0>
		<cfinvokeargument Name="userID" Value="#URL.userID#">
	</cfif>
	<!--- <cfinvokeargument Name="addressStatus" Value="1"> --->
	<!--- <cfinvokeargument Name="addressTypeBilling" Value="1"> --->
</cfinvoke>

<cfinclude template="../../view/v_creditCard/lang_insertCreditCard.cfm">
<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitCreditCard")>
	<cfinclude template="../../include/function/fn_creditCard.cfm">
	<cfinclude template="formValidate_insertCreditCard.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfif URL.creditCardID is not 0>
			<cfinvoke Component="#Application.billingMapping#data.CreditCard" Method="updateCreditCard" ReturnVariable="isCreditCardUpdated">
				<cfinvokeargument Name="creditCardID" Value="#URL.creditCardID#">
				<cfinvokeargument Name="creditCardStatus" Value="0">
			</cfinvoke>
		</cfif>

		<cfinvoke Component="#Application.billingMapping#data.CreditCard" Method="insertCreditCard" ReturnVariable="newCreditCardID">
			<cfinvokeargument Name="companyID" Value="#URL.companyID#">
			<cfinvokeargument Name="userID" Value="#URL.userID#">
			<cfinvokeargument Name="userID_author" Value="#Session.userID#">
			<cfinvokeargument Name="creditCardStatus" Value="1">
			<cfinvokeargument Name="addressID" Value="#Form.addressID#">
			<cfinvokeargument Name="creditCardName" Value="#Form.creditCardName#">
			<cfinvokeargument Name="creditCardNumber" Value="#Form.creditCardNumber#">
			<cfinvokeargument Name="creditCardExpirationMonth" Value="#Form.creditCardExpirationMonth#">
			<cfinvokeargument Name="creditCardExpirationYear" Value="#Form.creditCardExpirationYear#">
			<cfinvokeargument Name="creditCardType" Value="#Form.creditCardType#">
			<cfinvokeargument Name="creditCardCVC" Value="#Form.creditCardCVC#">
			<cfinvokeargument Name="creditCardDescription" Value="#Form.creditCardDescription#">
			<cfinvokeargument Name="creditCardRetain" Value="#Form.creditCardRetain#">
		</cfinvoke>

		<!--- check for trigger --->
		<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
			<cfinvokeargument name="companyID" value="#Session.companyID#">
			<cfinvokeargument name="isWebService" value="False">
			<cfinvokeargument name="doControl" value="#Variables.doControl#">
			<cfinvokeargument name="primaryTargetKey" value="creditCardID">
			<cfinvokeargument name="targetID" value="#newCreditCardID#">
			<cfif URL.creditCardID is not 0>
				<cfinvokeargument name="doAction" value="updateCreditCard">
			<cfelse>
				<cfinvokeargument name="doAction" value="insertCreditCard">
			</cfif>
		</cfinvoke>

		<cflocation url="#Variables.creditCardActionList#&confirm_creditCard=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfif URL.creditCardID is 0>
	<cfset Variables.formSubmitValue = Variables.lang_insertCreditCard.formSubmitValue_insert>
<cfelse>
	<cfset Variables.formAction = Variables.formAction & "&creditCardID=#URL.creditCardID#">
	<cfset Variables.formSubmitValue = Variables.lang_insertCreditCard.formSubmitValue_update>
</cfif>

<cfinclude template="../../view/v_creditCard/form_insertCreditCard.cfm">
