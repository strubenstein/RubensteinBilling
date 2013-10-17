<cfinvoke component="#Application.billingMapping#data.Bank" method="maxlength_Bank" returnVariable="maxlength_Bank" />

<cfset Variables.selectStateOption = 123>
<cfinclude template="../../view/v_address/var_stateList.cfm">
<cfinclude template="../../view/v_address/act_stateList.cfm">

<cfinclude template="../../view/v_address/var_countryList.cfm">
<cfset Variables.countryList_value = Variables.selectCountry_name_short>
<cfset Variables.countryList_label = Variables.selectCountry_name_short>

<cfset Form.bankBranchStateOther = Arguments.bankBranchState>
<cfset Form.bankBranchCountryOther = Arguments.bankBranchCountry>

<cfif Arguments.addressID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Address" Method="selectAddressList" ReturnVariable="qry_selectAddressList">
		<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
		<cfif StructKeyExists(Arguments, "userID") and Arguments.userID is not 0>
			<cfinvokeargument Name="userID" Value="#Arguments.userID#">
		</cfif>
	</cfinvoke>
</cfif>

<cfinclude template="../../view/v_bank/lang_insertBank.cfm">
<cfinclude template="../../control/c_bank/formValidate_insertBank.cfm">

<cfif isAllFormFieldsOk is False>
	<cfset returnValue = -1>
	<cfset returnError = "">
	<cfloop Collection="#errorMessage_fields#" Item="field">
		<cfset returnError = ListAppend(returnError, StructFind(errorMessage_fields, field), Chr(10))>
	</cfloop>
<cfelse>
	<cfif URL.bankID is not 0>
		<cfinvoke Component="#Application.billingMapping#data.Bank" Method="updateBank" ReturnVariable="isBankUpdated">
			<cfinvokeargument Name="bankID" Value="#URL.bankID#">
			<cfinvokeargument Name="bankStatus" Value="0">
		</cfinvoke>
	</cfif>

	<cfinvoke Component="#Application.billingMapping#data.Bank" Method="insertBank" ReturnVariable="newBankID">
		<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
		<cfinvokeargument Name="userID" Value="#Arguments.userID#">
		<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
		<cfinvokeargument Name="bankName" Value="#Arguments.bankName#">
		<cfinvokeargument Name="bankBranch" Value="#Arguments.bankBranch#">
		<cfinvokeargument Name="bankBranchCity" Value="#Arguments.bankBranchCity#">
		<cfinvokeargument Name="bankBranchState" Value="#Arguments.bankBranchState#">
		<cfinvokeargument Name="bankBranchCountry" Value="#Arguments.bankBranchCountry#">
		<cfinvokeargument Name="bankBranchContactName" Value="#Arguments.bankBranchContactName#">
		<cfinvokeargument Name="bankBranchPhone" Value="#Arguments.bankBranchPhone#">
		<cfinvokeargument Name="bankBranchFax" Value="#Arguments.bankBranchFax#">
		<cfinvokeargument Name="bankRoutingNumber" Value="#Arguments.bankRoutingNumber#">
		<cfinvokeargument Name="bankAccountNumber" Value="#Arguments.bankAccountNumber#">
		<cfinvokeargument Name="bankAccountName" Value="#Arguments.bankAccountName#">
		<cfinvokeargument Name="bankCheckingOrSavings" Value="#Arguments.bankCheckingOrSavings#">
		<cfinvokeargument Name="bankPersonalOrCorporate" Value="#Arguments.bankPersonalOrCorporate#">
		<cfinvokeargument Name="bankDescription" Value="#Arguments.bankDescription#">
		<cfinvokeargument Name="bankAccountType" Value="#Arguments.bankAccountType#">
		<cfinvokeargument Name="bankStatus" Value="1">
		<cfinvokeargument Name="bankRetain" Value="#Arguments.bankRetain#">
		<cfinvokeargument Name="addressID" Value="#Arguments.addressID#">
	</cfinvoke>

	<!--- check for trigger --->
	<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
		<cfinvokeargument name="companyID" value="#qry_selectWebServiceSession.companyID#">
		<cfinvokeargument name="isWebService" value="True">
		<cfinvokeargument name="doControl" value="bank">
		<cfinvokeargument name="primaryTargetKey" value="bankID">
		<cfinvokeargument name="targetID" value="#newBankID#">
		<cfif URL.bankID is not 0>
			<cfinvokeargument name="doAction" value="updateBank">
		<cfelse>
			<cfinvokeargument name="doAction" value="insertBank">
		</cfif>
	</cfinvoke>

	<cfset returnValue = newBankID>
</cfif>

