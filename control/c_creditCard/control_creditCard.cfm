<cfif IsDefined("Form.creditCardID") and Not IsDefined("URL.creditCardID")>
	<cfset URL.creditCardID = Form.creditCardID>
</cfif>

<cfparam Name="URL.creditCardID" Default="0">
<cfparam Name="URL.companyID" Default="0">
<cfparam Name="URL.userID" Default="0">

<cfset Variables.formAction = "index.cfm?method=#URL.control#.#URL.action#">
<cfif URL.control is "company" and URL.companyID is not 0>
	<cfset Variables.formAction = Variables.formAction & "&companyID=#URL.companyID#">
</cfif>
<cfif ListFind("user,company", URL.control) and URL.userID is not 0>
	<cfset Variables.formAction = Variables.formAction & "&userID=#URL.userID#">
</cfif>
<cfset Variables.creditCardActionList = Replace(Variables.formAction, URL.action, "listCreditCards", "ONE")>

<cfinclude template="security_creditCard.cfm">
<cfinclude template="../../view/v_creditCard/nav_creditCard.cfm">
<cfif IsDefined("URL.confirm_creditCard")>
	<cfinclude template="../../view/v_creditCard/confirm_creditCard.cfm">
</cfif>
<cfif IsDefined("URL.error_creditCard")>
	<cfinclude template="../../view/v_creditCard/error_creditCard.cfm">
</cfif>

<cfif FindNoCase("listCreditCardsAll", CGI.HTTP_REFERER)>
	<cfset Variables.redirectURL = Replace(Variables.formAction, URL.action, "listCreditCardsAll", "ONE")>
<cfelse>
	<cfset Variables.redirectURL = Replace(Variables.formAction, URL.action, "listCreditCards", "ONE")>
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="listCreditCards,listCreditCardsAll">
	<cfinclude template="control_listCreditCards.cfm">
</cfcase>

<cfcase value="viewCreditCard">
	<cfinclude template="../../view/v_creditCard/dsp_selectCreditCard.cfm">
</cfcase>

<cfcase value="insertCreditCard,updateCreditCard">
	<cfinclude template="control_insertCreditCard.cfm">
</cfcase>

<cfcase value="updateCreditCardStatus0,updateCreditCardStatus1">
	<cfinvoke Component="#Application.billingMapping#data.CreditCard" Method="updateCreditCard" ReturnVariable="isCreditCardUpdated">
		<cfinvokeargument Name="creditCardID" Value="#URL.creditCardID#">
		<cfinvokeargument Name="creditCardStatus" Value="#Right(Variables.doAction, 1)#">
	</cfinvoke>

	<cflocation url="#Variables.redirectURL#&confirm_creditCard=#Variables.doAction#" AddToken="No">
</cfcase>

<cfcase value="updateCreditCardRetain0,updateCreditCardRetain1">
	<cfinvoke Component="#Application.billingMapping#data.CreditCard" Method="updateCreditCard" ReturnVariable="isCreditCardUpdated">
		<cfinvokeargument Name="creditCardID" Value="#URL.creditCardID#">
		<cfinvokeargument Name="creditCardRetain" Value="#Right(Variables.doAction, 1)#">
	</cfinvoke>

	<cflocation url="#Variables.redirectURL#&confirm_creditCard=#Variables.doAction#" AddToken="No">
</cfcase>

<cfcase value="deleteCreditCard">
	<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitDeleteCreditCard") and IsDefined("Form.creditCardID")>
		<!--- check for trigger --->
		<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
			<cfinvokeargument name="companyID" value="#Session.companyID#">
			<cfinvokeargument name="doAction" value="#Variables.doAction#">
			<cfinvokeargument name="isWebService" value="False">
			<cfinvokeargument name="doControl" value="#Variables.doControl#">
			<cfinvokeargument name="primaryTargetKey" value="creditCardID">
			<cfinvokeargument name="targetID" value="#URL.creditCardID#">
		</cfinvoke>

		<cfinvoke Component="#Application.billingMapping#data.CreditCard" Method="deleteCreditCard" ReturnVariable="isCreditCardDeleted">
			<cfinvokeargument Name="creditCardID" Value="#URL.creditCardID#">
		</cfinvoke>

		<cflocation url="#Variables.redirectURL#&confirm_creditCard=#Variables.doAction#" AddToken="No">
	</cfif>
</cfcase>

<cfdefaultcase>
	<cfset URL.error_creditCard = "invalidAction">
	<cfinclude template="../../view/v_creditCard/error_creditCard.cfm">
</cfdefaultcase>
</cfswitch>
