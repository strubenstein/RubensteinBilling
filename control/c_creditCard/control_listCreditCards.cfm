<cfinvoke Component="#Application.billingMapping#data.CreditCard" Method="selectCreditCardList" ReturnVariable="qry_selectCreditCardList">
	<cfinvokeargument Name="companyID" Value="#URL.companyID#">
	<cfif Variables.doControl is "user" or URL.userID is not 0>
		<cfinvokeargument Name="userID" Value="#URL.userID#">
		<cfinvokeargument Name="companyIDorUserID" Value="False">
	</cfif>
	<cfif URL.action is not "listCreditCardsAll">
		<cfinvokeargument Name="creditCardStatus" Value="1">
	</cfif>
</cfinvoke>

<cfset Variables.creditCardActionUpdate = Replace(Variables.formAction, URL.action, "updateCreditCard", "ONE")>
<cfset Variables.creditCardActionView = Replace(Variables.formAction, URL.action, "viewCreditCard", "ONE")>
<cfset Variables.creditCardActionList = Replace(Variables.formAction, URL.action, "listCreditCards", "ONE")>
<cfset Variables.creditCardActionListAll = Replace(Variables.formAction, URL.action, "listCreditCardsAll", "ONE")>
<cfset Variables.creditCardActionDelete = Replace(Variables.formAction, URL.action, "deleteCreditCard", "ONE")>

<cfset Variables.creditCardActionStatusActive = Replace(Variables.formAction, URL.action, "updateCreditCardStatus1", "ONE")>
<cfset Variables.creditCardActionStatusArchived = Replace(Variables.formAction, URL.action, "updateCreditCardStatus0", "ONE")>
<cfset Variables.creditCardActionRetainYes = Replace(Variables.formAction, URL.action, "updateCreditCardRetain1", "ONE")>
<cfset Variables.creditCardActionRetainNo = Replace(Variables.formAction, URL.action, "updateCreditCardRetain0", "ONE")>

<cfinclude template="../../view/v_creditCard/lang_listCreditCards.cfm">

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("insertCreditCard,viewCreditCard,listCreditCards,listCreditCardsAll,deleteCreditCard,updateCreditCardStatus1,updateCreditCardStatus0,updateCreditCardRetain1,updateCreditCardRetain0")>
<cfset Variables.creditCardColumnList = Variables.lang_listCreditCards_title.creditCardDescription
		& "^" &  Variables.lang_listCreditCards_title.creditCardUserCompany
		& "^" &  Variables.lang_listCreditCards_title.creditCardStatus
		& "^" &  Variables.lang_listCreditCards_title.creditCardRetain
		& "^" &  Variables.lang_listCreditCards_title.creditCardName
		& "^" &  Variables.lang_listCreditCards_title.creditCardType
		& "^" &  Variables.lang_listCreditCards_title.creditCardNumber
		& "^" &  Variables.lang_listCreditCards_title.creditCardExpirationDate
		& "^" &  Variables.lang_listCreditCards_title.creditCardCVC
		& "^" &  Variables.lang_listCreditCards_title.creditCardContact
		& "^" &  Variables.lang_listCreditCards_title.creditCardCityState
		& "^" &  Variables.lang_listCreditCards_title.creditCardDateCreated
		& "^" &  Variables.lang_listCreditCards_title.creditCardDateUpdated>

<cfif ListFind(Variables.permissionActionList, "deleteCreditCard")>
	<cfset Variables.creditCardColumnList = Variables.lang_listCreditCards_title.deleteCreditCard & "^" & Variables.creditCardColumnList>
</cfif>
<cfif ListFind(Variables.permissionActionList, "insertCreditCard")>
	<cfset Variables.creditCardColumnList = Variables.creditCardColumnList & "^" & Variables.lang_listCreditCards_title.insertCreditCard>
</cfif>
<cfif ListFind(Variables.permissionActionList, "viewCreditCard")>
	<cfset Variables.creditCardColumnList = Variables.creditCardColumnList & "^" & Variables.lang_listCreditCards_title.viewCreditCard>
</cfif>

<cfset Variables.creditCardColumnCount = DecrementValue(2 * ListLen(Variables.creditCardColumnList, "^"))>

<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../view/v_creditCard/dsp_selectCreditCardList.cfm">
