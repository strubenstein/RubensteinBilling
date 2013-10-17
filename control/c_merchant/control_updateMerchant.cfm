<cfset Variables.displayUsers = False>
<cfif qry_selectMerchant.companyID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectUserCompanyList_company" ReturnVariable="qry_selectUserCompanyList_company">
		<cfinvokeargument Name="companyID" Value="#qry_selectMerchant.companyID#">
		<cfinvokeargument Name="userCompanyStatus" Value="1">
	</cfinvoke>

	<cfif qry_selectUserCompanyList_company.RecordCount is not 0>
		<cfset Variables.displayUsers = True>
	</cfif>
</cfif>

<cfinclude template="formParam_insertUpdateMerchant.cfm">
<cfinvoke component="#Application.billingMapping#data.Merchant" method="maxlength_Merchant" returnVariable="maxlength_Merchant" />
<cfinclude template="../../view/v_merchant/lang_insertUpdateMerchant.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitInsertUpdateMerchant")>
	<cfinclude template="../../include/function/fn_IsValidURL.cfm">
	<cfinclude template="formValidate_insertUpdateMerchant.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Merchant" Method="updateMerchant" ReturnVariable="isMerchantUpdated">
			<cfinvokeargument Name="merchantID" Value="#URL.merchantID#">
			<cfinvokeargument Name="userID" Value="#Form.userID#">
			<cfinvokeargument Name="merchantName" Value="#Form.merchantName#">
			<cfinvokeargument Name="merchantTitle" Value="#Form.merchantTitle#">
			<cfinvokeargument Name="merchantBank" Value="#Form.merchantBank#">
			<cfinvokeargument Name="merchantCreditCard" Value="#Form.merchantCreditCard#">
			<cfinvokeargument Name="merchantURL" Value="#Form.merchantURL#">
			<cfinvokeargument Name="merchantDescription" Value="#Form.merchantDescription#">
			<cfinvokeargument Name="merchantFilename" Value="#Form.merchantFilename#">
			<cfinvokeargument Name="merchantStatus" Value="#Form.merchantStatus#">
			<cfinvokeargument Name="merchantRequiredFields" Value="#Form.merchantRequiredFields#">
		</cfinvoke>

		<cflocation url="index.cfm?method=merchant.#Variables.doAction#&merchantID=#URL.merchantID#&confirm_merchant=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = "index.cfm?method=merchant.#Variables.doAction#&merchantID=#URL.merchantID#">
<cfset Variables.formSubmitValue = Variables.lang_insertUpdateMerchant.formSubmitValue_update>

<cfinclude template="../../view/v_merchant/form_insertUpdateMerchant.cfm">
