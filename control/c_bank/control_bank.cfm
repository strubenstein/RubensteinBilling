<cfif IsDefined("Form.bankID") and Not IsDefined("URL.bankID")>
	<cfset URL.bankID = Form.bankID>
</cfif>

<cfparam Name="URL.bankID" Default="0">
<cfparam Name="URL.companyID" Default="0">
<cfparam Name="URL.userID" Default="0">

<cfset Variables.formAction = "index.cfm?method=#URL.control#.#URL.action#">
<cfif URL.control is "company" and URL.companyID is not 0>
	<cfset Variables.formAction = Variables.formAction & "&companyID=#URL.companyID#">
</cfif>
<cfif ListFind("user,company", URL.control) and URL.userID is not 0>
	<cfset Variables.formAction = Variables.formAction & "&userID=#URL.userID#">
</cfif>
<cfset Variables.bankActionList = Replace(Variables.formAction, URL.action, "listBanks", "ONE")>

<cfinclude template="security_bank.cfm">
<cfinclude template="../../view/v_bank/nav_bank.cfm">
<cfif IsDefined("URL.confirm_bank")>
	<cfinclude template="../../view/v_bank/confirm_bank.cfm">
</cfif>
<cfif IsDefined("URL.error_bank")>
	<cfinclude template="../../view/v_bank/error_bank.cfm">
</cfif>

<cfif FindNoCase("listBanksAll", CGI.HTTP_REFERER)>
	<cfset Variables.redirectURL = Replace(Variables.formAction, URL.action, "listBanksAll", "ONE")>
<cfelse>
	<cfset Variables.redirectURL = Replace(Variables.formAction, URL.action, "listBanks", "ONE")>
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="listBanks,listBanksAll">
	<cfinclude template="control_listBanks.cfm">
</cfcase>

<cfcase value="viewBank">
	<cfinclude template="../../view/v_bank/dsp_selectBank.cfm">
</cfcase>

<cfcase value="insertBank,updateBank">
	<cfinclude template="control_insertBank.cfm">
</cfcase>

<cfcase value="updateBankStatus0,updateBankStatus1">
	<cfinvoke Component="#Application.billingMapping#data.Bank" Method="updateBank" ReturnVariable="isBankUpdated">
		<cfinvokeargument Name="bankID" Value="#URL.bankID#">
		<cfinvokeargument Name="bankStatus" Value="#Right(Variables.doAction, 1)#">
	</cfinvoke>

	<cflocation url="#Variables.redirectURL#&confirm_bank=#Variables.doAction#" AddToken="No">
</cfcase>

<cfcase value="updateBankRetain0,updateBankRetain1">
	<cfinvoke Component="#Application.billingMapping#data.Bank" Method="updateBank" ReturnVariable="isBankUpdated">
		<cfinvokeargument Name="bankID" Value="#URL.bankID#">
		<cfinvokeargument Name="bankRetain" Value="#Right(Variables.doAction, 1)#">
	</cfinvoke>

	<cflocation url="#Variables.redirectURL#&confirm_bank=#Variables.doAction#" AddToken="No">
</cfcase>

<cfcase value="deleteBank">
	<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitDeleteBank") and IsDefined("Form.bankID")>
		<!--- check for trigger --->
		<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
			<cfinvokeargument name="companyID" value="#Session.companyID#">
			<cfinvokeargument name="doAction" value="deleteBank">
			<cfinvokeargument name="isWebService" value="False">
			<cfinvokeargument name="doControl" value="#Variables.doControl#">
			<cfinvokeargument name="primaryTargetKey" value="bankID">
			<cfinvokeargument name="targetID" value="#URL.bankID#">
		</cfinvoke>

		<cfinvoke Component="#Application.billingMapping#data.Bank" Method="deleteBank" ReturnVariable="isBankDeleted">
			<cfinvokeargument Name="bankID" Value="#URL.bankID#">
		</cfinvoke>

		<cflocation url="#Variables.redirectURL#&confirm_bank=#Variables.doAction#" AddToken="No">
	</cfif>
</cfcase>

<cfdefaultcase>
	<cfset URL.error_bank = "invalidAction">
	<cfinclude template="../../view/v_bank/error_bank.cfm">
</cfdefaultcase>
</cfswitch>
