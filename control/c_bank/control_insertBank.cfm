<cfinclude template="formParam_insertBank.cfm">
<cfinvoke component="#Application.billingMapping#data.Bank" method="maxlength_Bank" returnVariable="maxlength_Bank" />

<cfset Variables.selectStateOption = 123>
<cfinclude template="../../view/v_address/var_stateList.cfm">
<cfinclude template="../../view/v_address/act_stateList.cfm">

<cfinclude template="../../view/v_address/var_countryList.cfm">
<cfset Variables.countryList_value = Variables.selectCountry_name_short>
<cfset Variables.countryList_label = Variables.selectCountry_name_short>

<cfinvoke Component="#Application.billingMapping#data.Address" Method="selectAddressList" ReturnVariable="qry_selectAddressList">
	<cfinvokeargument Name="companyID" Value="#URL.companyID#">
	<cfif Variables.doControl is "user" or URL.userID is not 0>
		<cfinvokeargument Name="userID" Value="#URL.userID#">
	</cfif>
	<!--- <cfinvokeargument Name="addressStatus" Value="1"> --->
	<!--- <cfinvokeargument Name="addressTypeBilling" Value="1"> --->
</cfinvoke>

<cfinclude template="../../view/v_bank/lang_insertBank.cfm">
<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitBank")>
	<cfinclude template="formValidate_insertBank.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfif URL.bankID is not 0>
			<cfinvoke Component="#Application.billingMapping#data.Bank" Method="updateBank" ReturnVariable="isBankUpdated">
				<cfinvokeargument Name="bankID" Value="#URL.bankID#">
				<cfinvokeargument Name="bankStatus" Value="0">
			</cfinvoke>
		</cfif>

		<cfinvoke Component="#Application.billingMapping#data.Bank" Method="insertBank" ReturnVariable="newBankID">
			<cfinvokeargument Name="companyID" Value="#URL.companyID#">
			<cfinvokeargument Name="userID" Value="#URL.userID#">
			<cfinvokeargument Name="userID_author" Value="#Session.userID#">
			<cfinvokeargument Name="bankName" Value="#Form.bankName#">
			<cfinvokeargument Name="bankBranch" Value="#Form.bankBranch#">
			<cfinvokeargument Name="bankBranchCity" Value="#Form.bankBranchCity#">
			<cfinvokeargument Name="bankBranchState" Value="#Form.bankBranchState#">
			<cfinvokeargument Name="bankBranchCountry" Value="#Form.bankBranchCountry#">
			<cfinvokeargument Name="bankBranchContactName" Value="#Form.bankBranchContactName#">
			<cfinvokeargument Name="bankBranchPhone" Value="#Form.bankBranchPhone#">
			<cfinvokeargument Name="bankBranchFax" Value="#Form.bankBranchFax#">
			<cfinvokeargument Name="bankRoutingNumber" Value="#Form.bankRoutingNumber#">
			<cfinvokeargument Name="bankAccountNumber" Value="#Form.bankAccountNumber#">
			<cfinvokeargument Name="bankAccountName" Value="#Form.bankAccountName#">
			<cfinvokeargument Name="bankCheckingOrSavings" Value="#Form.bankCheckingOrSavings#">
			<cfinvokeargument Name="bankPersonalOrCorporate" Value="#Form.bankPersonalOrCorporate#">
			<cfinvokeargument Name="bankDescription" Value="#Form.bankDescription#">
			<cfinvokeargument Name="bankAccountType" Value="#Form.bankAccountType#">
			<cfinvokeargument Name="bankStatus" Value="1">
			<cfinvokeargument Name="bankRetain" Value="#Form.bankRetain#">
			<cfinvokeargument Name="addressID" Value="#Form.addressID#">
		</cfinvoke>

		<!--- check for trigger --->
		<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
			<cfinvokeargument name="companyID" value="#Session.companyID#">
			<cfinvokeargument name="isWebService" value="False">
			<cfinvokeargument name="doControl" value="#Variables.doControl#">
			<cfinvokeargument name="primaryTargetKey" value="bankID">
			<cfinvokeargument name="targetID" value="#newBankID#">
			<cfif URL.bankID is not 0>
				<cfinvokeargument name="doAction" value="updateBank">
			<cfelse>
				<cfinvokeargument name="doAction" value="insertBank">
			</cfif>
		</cfinvoke>

		<cflocation url="#Variables.bankActionList#&confirm_bank=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfif URL.bankID is 0>
	<cfset Variables.formSubmitValue = Variables.lang_insertBank.formSubmitValue_insert>
<cfelse>
	<cfset Variables.formAction = Variables.formAction & "&bankID=#URL.bankID#">
	<cfset Variables.formSubmitValue = Variables.lang_insertBank.formSubmitValue_update>
</cfif>

<cfinclude template="../../view/v_bank/form_insertBank.cfm">
