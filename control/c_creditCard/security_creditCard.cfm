<cfif Not Application.fn_IsIntegerNonNegative(URL.creditCardID)>
	<cflocation url="#Variables.creditCardActionList#&error_creditCard=noCreditCard" AddToken="No">
<cfelseif Not Application.fn_IsIntegerNonNegative(URL.companyID) or (URL.companyID is not 0 and Not ListFind("company,user", URL.control))>
	<cflocation url="#Variables.creditCardActionList#&error_creditCard=invalidCompany" AddToken="No">
<cfelseif Not Application.fn_IsIntegerNonNegative(URL.userID) or (URL.userID is not 0 and Not ListFind("user,company", URL.control))>
	<cflocation url="#Variables.creditCardActionList#&error_creditCard=invalidUser" AddToken="No">
<cfelseif URL.userID is 0 and URL.companyID is 0>
	<cflocation url="#Variables.creditCardActionList#&error_creditCard=invalidCompany" AddToken="No">
<cfelseif URL.creditCardID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.CreditCard" Method="checkCreditCardPermission" ReturnVariable="isCreditCardPermission">
		<cfinvokeargument Name="creditCardID" Value="#URL.creditCardID#">
		<cfinvokeargument Name="companyID" Value="#URL.companyID#">
		<cfif URL.userID is not 0>
			<cfinvokeargument Name="userID" Value="#URL.userID#">
		</cfif>
	</cfinvoke>

	<cfif isCreditCardPermission is False>
		<cflocation url="#Variables.creditCardActionList#&error_creditCard=invalidCreditCard" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.CreditCard" Method="selectCreditCard" ReturnVariable="qry_selectCreditCard">
			<cfinvokeargument Name="creditCardID" Value="#URL.creditCardID#">
		</cfinvoke>

		<cfif qry_selectCreditCard.companyID is not URL.companyID and qry_selectCreditCard.userID is not URL.userID>
			<cflocation url="#Variables.creditCardActionList#&error_creditCard=invalidCreditCard" AddToken="No">
		<cfelseif qry_selectCreditCard.creditCardStatus is 0 and Variables.doAction is "insertCreditCard">
			<cflocation url="#Variables.creditCardActionList#&error_creditCard=invalidCreditCardStatus" AddToken="No">
		</cfif>
	</cfif>
<cfelseif Not ListFind("listCreditCards,listCreditCardsAll,insertCreditCard", Variables.doAction)>
	<cflocation url="#Variables.creditCardActionList#&error_creditCard=noCreditCard" AddToken="No">
</cfif>
