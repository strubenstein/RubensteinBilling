<cfinvoke Component="#Application.billingMapping#data.Merchant" Method="selectMerchantList" ReturnVariable="qry_selectMerchantList">
	<cfinvokeargument Name="merchantStatus" Value="1">
</cfinvoke>

<cfinclude template="formParam_insertUpdateMerchantAccount.cfm">
<cfinvoke component="#Application.billingMapping#data.MerchantAccount" method="maxlength_MerchantAccount" returnVariable="maxlength_MerchantAccount" />
<cfinclude template="../../view/v_merchant/lang_insertUpdateMerchantAccount.cfm">
<cfinclude template="../../view/v_creditCard/var_creditCardTypeList.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitInsertUpdateMerchantAccount")>
	<cfinclude template="formValidate_insertUpdateMerchantAccount.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.MerchantAccount" Method="updateMerchantAccount" ReturnVariable="isMerchantAccountUpdated">
			<cfinvokeargument Name="merchantAccountID" Value="#URL.merchantAccountID#">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="merchantID" Value="#Form.merchantID#">
			<cfinvokeargument Name="merchantAccountUsername" Value="#Form.merchantAccountUsername#">
			<cfinvokeargument Name="merchantAccountPassword" Value="#Form.merchantAccountPassword#">
			<cfinvokeargument Name="merchantAccountID_custom" Value="#Form.merchantAccountID_custom#">
			<cfinvokeargument Name="merchantAccountStatus" Value="#Form.merchantAccountStatus#">
			<cfinvokeargument Name="merchantAccountBank" Value="#Form.merchantAccountBank#">
			<cfinvokeargument Name="merchantAccountCreditCard" Value="#Form.merchantAccountCreditCard#">
			<cfinvokeargument Name="merchantAccountDescription" Value="#Form.merchantAccountDescription#">
			<cfinvokeargument Name="merchantAccountName" Value="#Form.merchantAccountName#">
			<cfinvokeargument Name="merchantAccountCreditCardTypeList" Value="#Form.merchantAccountCreditCardTypeList#">
		</cfinvoke>

		<cflocation url="index.cfm?method=merchant.#Variables.doAction#&confirm_merchant=#Variables.doAction#&merchantAccountID=#URL.merchantAccountID#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = "index.cfm?method=merchant.#Variables.doAction#&merchantAccountID=#URL.merchantAccountID#">
<cfset Variables.formSubmitValue = Variables.lang_insertUpdateMerchantAccount.formSubmitValue_update>

<cfinclude template="../../view/v_merchant/form_insertUpdateMerchantAccount.cfm">
