<!--- company: userID, creditCardID, bankID, payflowID --->
<cfif ListFind("companyID", Form.primaryTargetKey)>
	<cfif Trim(Variables.importDataStruct.username) is not "" or Trim(Variables.importDataStruct.firstName) is not "" or Trim(Variables.importDataStruct.lastName) is not "" or Trim(Variables.importDataStruct.email) is not "" or Trim(Variables.importDataStruct.userID_custom) is not "">
		<cfset Variables.importDataStruct.insertExtendedFieldTypeList = ListAppend(Variables.importDataStruct.insertExtendedFieldTypeList, "userID")>
	</cfif>

	<cfif Trim(Variables.importDataStruct.creditCardName) is not "" or Trim(Variables.importDataStruct.creditCardNumber) is not "" or Trim(Variables.importDataStruct.creditCardExpirationMonth) is not "" or Trim(Variables.importDataStruct.creditCardExpirationYear) is not "" or Trim(Variables.importDataStruct.creditCardType) is not "">
		<cfset Variables.importDataStruct.insertExtendedFieldTypeList = ListAppend(Variables.importDataStruct.insertExtendedFieldTypeList, "creditCardID")>
	</cfif>

	<cfif Trim(Variables.importDataStruct.bankName) is not "" or Trim(Variables.importDataStruct.bankRoutingNumber) is not "" or Trim(Variables.importDataStruct.bankAccountNumber) is not "" or Trim(Variables.importDataStruct.bankAccountName) is not "">
		<cfset Variables.importDataStruct.insertExtendedFieldTypeList = ListAppend(Variables.importDataStruct.insertExtendedFieldTypeList, "bankID")>
	</cfif>

	<cfif Application.fn_IsIntegerPositive(Variables.importDataStruct.payflowID) or Trim(Variables.importDataStruct.payflowID_custom) is not "">
		<cfset Variables.importDataStruct.insertExtendedFieldTypeList = ListAppend(Variables.importDataStruct.insertExtendedFieldTypeList, "payflowID")>
	</cfif>

	<cfif Trim(Variables.importDataStruct.subscriberName) is not "" or Trim(Variables.importDataStruct.subscriberID_custom) is not "" or Trim(Variables.importDataStruct.subscriberDateProcessNext) is not "">
		<cfset Variables.importDataStruct.insertExtendedFieldTypeList = ListAppend(Variables.importDataStruct.insertExtendedFieldTypeList, "subscriberID")>
	</cfif>
</cfif>

<!--- company/user: phoneID, faxID, addressID_billing, addressID_shipping, subscriberID, groupID --->
<cfif ListFind("companyID,userID", Form.primaryTargetKey)>
	<cfif Trim(Variables.importDataStruct.phoneAreaCode) is not "" or Trim(Variables.importDataStruct.phoneNumber) is not "">
		<cfset Variables.importDataStruct.insertExtendedFieldTypeList = ListAppend(Variables.importDataStruct.insertExtendedFieldTypeList, "phoneID")>
	</cfif>

	<cfif Trim(Variables.importDataStruct.faxAreaCode) is not "" or Trim(Variables.importDataStruct.faxNumber) is not "">
		<cfset Variables.importDataStruct.insertExtendedFieldTypeList = ListAppend(Variables.importDataStruct.insertExtendedFieldTypeList, "faxID")>
	</cfif>

	<cfif Trim(Variables.importDataStruct.address_billing) is not "" or Trim(Variables.importDataStruct.city_billing) is not "" or Trim(Variables.importDataStruct.state_billing) is not "" or Trim(Variables.importDataStruct.zipCode_billing) is not "">
		<cfset Variables.importDataStruct.insertExtendedFieldTypeList = ListAppend(Variables.importDataStruct.insertExtendedFieldTypeList, "addressID_billing")>
	</cfif>

	<cfif Trim(Variables.importDataStruct.address_shipping) is not "" or Trim(Variables.importDataStruct.city_shipping) is not "" or Trim(Variables.importDataStruct.state_shipping) is not "" or Trim(Variables.importDataStruct.zipCode_shipping) is not "">
		<cfset Variables.importDataStruct.insertExtendedFieldTypeList = ListAppend(Variables.importDataStruct.insertExtendedFieldTypeList, "addressID_shipping")>
	</cfif>

	<cfif Application.fn_IsIntegerPositive(Variables.importDataStruct.groupID) or Trim(Variables.importDataStruct.groupID_custom) is not "">
		<cfset Variables.importDataStruct.insertExtendedFieldTypeList = ListAppend(Variables.importDataStruct.insertExtendedFieldTypeList, "groupID")>
	</cfif>
</cfif>

<!--- user: insertSubscriberNotify --->
<cfif ListFind("userID", Form.primaryTargetKey)>
	<cfif Application.fn_IsIntegerPositive(Variables.importDataStruct.subscriberID) or Trim(Variables.importDataStruct.subscriberID_custom) is not "">
		<cfset Variables.importDataStruct.insertExtendedFieldTypeList = ListAppend(Variables.importDataStruct.insertExtendedFieldTypeList, "insertSubscriberNotify")>
	</cfif>
</cfif>
