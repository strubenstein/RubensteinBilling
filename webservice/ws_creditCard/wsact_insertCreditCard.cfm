<cfinvoke Component="#Application.billingMapping#data.Address" Method="selectAddressList" ReturnVariable="qry_selectAddressList">
	<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
</cfinvoke>

<cfinvoke component="#Application.billingMapping#data.CreditCard" method="maxlength_CreditCard" returnVariable="maxlength_CreditCard" />
<cfinclude template="../../view/v_creditCard/var_creditCardTypeList.cfm">
<cfinclude template="../../view/v_creditCard/var_creditCardExpirationMonthList.cfm">

<cfif Not IsDefined("fn_IsMod10")>
	<cfinclude template="../../include/function/fn_creditCard.cfm">
</cfif>

<cfset ccTypePosition = ListFindNoCase(Variables.creditCardTypeList_value, Arguments.creditCardType)>
<cfif ccTypePosition is not 0 and Compare(Arguments.creditCardType, ListGetAt(Variables.creditCardTypeList_value, ccTypePosition)) is not 0>
	<cfset Arguments.creditCardType = ListGetAt(Variables.creditCardTypeList_value, ccTypePosition)>
	<cfset Form.creditCardType = Arguments.creditCardType>
</cfif>

<cfinclude template="../../view/v_creditCard/lang_insertCreditCard.cfm">
<cfinclude template="../../control/c_creditCard/formValidate_insertCreditCard.cfm">

<cfif isAllFormFieldsOk is False>
	<cfset returnValue = -1>
	<cfset returnError = "">
	<cfloop Collection="#errorMessage_fields#" Item="field">
		<cfset returnError = ListAppend(returnError, StructFind(errorMessage_fields, field), Chr(10))>
	</cfloop>
<cfelse>
	<cfif URL.creditCardID is not 0>
		<cfinvoke Component="#Application.billingMapping#data.CreditCard" Method="updateCreditCard" ReturnVariable="isCreditCardUpdated">
			<cfinvokeargument Name="creditCardID" Value="#URL.creditCardID#">
			<cfinvokeargument Name="creditCardStatus" Value="0">
		</cfinvoke>
	</cfif>

	<cfinvoke Component="#Application.billingMapping#data.CreditCard" Method="insertCreditCard" ReturnVariable="newCreditCardID">
		<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
		<cfinvokeargument Name="userID" Value="#Arguments.userID#">
		<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
		<cfinvokeargument Name="creditCardStatus" Value="1">
		<cfinvokeargument Name="addressID" Value="#Arguments.addressID#">
		<cfinvokeargument Name="creditCardName" Value="#Arguments.creditCardName#">
		<cfinvokeargument Name="creditCardNumber" Value="#Arguments.creditCardNumber#">
		<cfinvokeargument Name="creditCardExpirationMonth" Value="#Arguments.creditCardExpirationMonth#">
		<cfinvokeargument Name="creditCardExpirationYear" Value="#Arguments.creditCardExpirationYear#">
		<cfinvokeargument Name="creditCardType" Value="#Arguments.creditCardType#">
		<cfinvokeargument Name="creditCardCVC" Value="#Arguments.creditCardCVC#">
		<cfinvokeargument Name="creditCardDescription" Value="#Arguments.creditCardDescription#">
		<cfinvokeargument Name="creditCardRetain" Value="#Arguments.creditCardRetain#">
	</cfinvoke>

	<!--- check for trigger --->
	<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
		<cfinvokeargument name="companyID" value="#qry_selectWebServiceSession.companyID#">
		<cfinvokeargument name="doAction" value="insertCreditCard">
		<cfinvokeargument name="isWebService" value="True">
		<cfinvokeargument name="primaryTargetKey" value="creditCardID">
		<cfinvokeargument name="targetID" value="#newCreditCardID#">
		<cfif Arguments.userID is not 0>
			<cfinvokeargument name="doControl" value="user">
		<cfelse>
			<cfinvokeargument name="doControl" value="company">
		</cfif>
	</cfinvoke>

	<cfset returnValue = newCreditCardID>
</cfif>

