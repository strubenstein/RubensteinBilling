<cfinclude template="wslang_creditCard.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = -1>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("updateCreditCard", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = -1>
	<cfset returnError = Variables.wslang_creditCard.updateCreditCard>
<cfelse>
	<cfset returnValue = 0>
	<cfloop Index="field" List="creditCardRetain,creditCardStatus">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfset updateFieldList_valid = "addressID,creditCardName,creditCardNumber,creditCardExpirationMonth,creditCardExpirationYear,creditCardType,creditCardCVC,creditCardRetain,creditCardDescription">
	<cfset URL.creditCardID = 0>

	<!--- 
	If creditCardID is not 0, validate creditCardID and update that. Get companyID/userID from existing credit card.
	Else determine creditCardID if companyID/userID/creditCardStatus=1 is unique
		If yes, "update".
		Else error.
	If simply updating creditCardStatus and/or creditCardRetain, update.
	Else update status and re-insert.
	--->

	<!--- Determine existing creditCardID --->
	<cfif Application.fn_IsIntegerPositive(Arguments.creditCardID)><!--- validate ID --->
		<cfinvoke Component="#Application.billingMapping#data.CreditCard" Method="selectCreditCard" ReturnVariable="qry_selectCreditCard">
			<cfinvokeargument Name="creditCardID" Value="#Arguments.creditCardID#">
		</cfinvoke>

		<cfif qry_selectCreditCard.RecordCount is not 1>
			<cfset returnValue = -1>
			<cfset returnError = Variables.wslang_creditCard.creditCardNotExist>
		<cfelse>
			<cfif qry_selectCreditCard.companyID is not 0>
				<cfinvoke Component="#Application.billingMapping#data.Company" Method="checkCompanyPermission" ReturnVariable="isCreditCardPermission">
					<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
					<cfinvokeargument Name="companyID" Value="#qry_selectCreditCard.companyID#">
				</cfinvoke>
			<cfelse>
				<cfinvoke Component="#Application.billingMapping#data.User" Method="checkUserPermission" ReturnVariable="isCreditCardPermission">
					<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
					<cfinvokeargument Name="userID" Value="#qry_selectCreditCard.userID#">
				</cfinvoke>
			</cfif>

			<cfif isCreditCardPermission is False>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_creditCard.creditCardNotExist>
			<cfelseif qry_selectCreditCard.creditCardStatus is 0>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_creditCard.creditCardStatusInactive>
			<cfelse>
				<cfset URL.creditCardID = Arguments.creditCardID>
				<cfset Arguments.companyID = qry_selectCreditCard.companyID>
				<cfset Arguments.userID = qry_selectCreditCard.userID>
			</cfif>
		</cfif>

	<cfelse><!--- Determine creditCardID based on company/user --->
		<!--- Determine companyID and userID --->
		<cfif Arguments.companyID is 0 and Arguments.companyID_custom is "">
			<cfset Arguments.companyID = 0>
		<cfelse>
			<cfset Arguments.companyID = Application.objWebServiceSecurity.ws_checkCompanyPermission(qry_selectWebServiceSession.companyID_author, Arguments.companyID, Arguments.companyID_custom, Arguments.useCustomIDFieldList)>
			<cfif Arguments.companyID is 0>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_creditCard.invalidCompany>
			</cfif>
		</cfif>

		<cfif Arguments.userID is 0 and Arguments.userID_custom is "">
			<cfset Arguments.userID = 0>
		<cfelseif returnValue is 0>
			<cfif Arguments.companyID is not 0>
				<cfset Arguments.userID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.userID, Arguments.userID_custom, Arguments.useCustomIDFieldList, Arguments.companyID)>
			<cfelse>
				<cfset Arguments.userID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.userID, Arguments.userID_custom, Arguments.useCustomIDFieldList)>
			</cfif>

			<cfif Arguments.userID is 0>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_creditCard.invalidUser>
			</cfif>
		</cfif>

		<cfif returnValue is 0 and Arguments.companyID is 0 and Arguments.userID is 0>
			<cfset returnValue = -1>
			<cfset returnError = Variables.wslang_creditCard.invalidCompanyOrUser>
		<cfelseif returnValue is 0>
			<cfinvoke Component="#Application.billingMapping#data.CreditCard" Method="selectCreditCardList" ReturnVariable="qry_selectCreditCard">
				<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
				<cfif Application.fn_IsIntegerPositive(Arguments.userID)>
					<cfinvokeargument Name="userID" Value="#Arguments.userID#">
				</cfif>
				<cfinvokeargument Name="creditCardStatus" Value="1">
				<cfinvokeargument Name="companyIDorUserID" Value="False">
			</cfinvoke>

			<cfif qry_selectCreditCard.RecordCount is 0>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_creditCard.invalidCreditCard>
			<cfelseif qry_selectCreditCard.RecordCount gt 1>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_creditCard.updateCreditCardMultiple>
			<cfelse>
				<cfset URL.creditCardID = qry_selectCreditCard.creditCardID>
				<cfset Arguments.creditCardID = qry_selectCreditCard.creditCardID>
			</cfif><!--- /does credit card exist --->
		</cfif><!--- /if company/user are valid --->
	</cfif><!--- /determine creditCardID --->

	<cfif returnValue is 0>
		<!--- if updating only non-essential fields, can update instead of re-insert --->
		<cfset isCreditCardUpdate = True>
		<cfloop Index="field" List="#Arguments.updateFieldList#">
			<cfif Not ListFind("creditCardStatus,creditCardRetain", field)>
				<cfset isCreditCardUpdate = False>
				<cfbreak>
			</cfif>
		</cfloop>

		<cfif isCreditCardUpdate is True><!--- update existing credit card --->
			<cfinvoke Component="#Application.billingMapping#data.CreditCard" Method="updateCreditCard" ReturnVariable="isCreditCardUpdated">
				<cfinvokeargument Name="creditCardID" Value="#Arguments.creditCardID#">
				<cfloop Index="field" List="creditCardStatus,creditCardRetain">
					<cfif ListFind(Arguments.updateFieldList, field)>
						<cfinvokeargument Name="#field#" Value="#Arguments[field]#">
					</cfif>
				</cfloop>
			</cfinvoke>

			<cfset returnValue = Arguments.creditCardID>

		<cfelse><!--- insert new credit card --->
			<cfloop Index="field" List="#updateFieldList_valid#">
				<cfif Not ListFind(Arguments.updateFieldList, field)>
					<cfset Arguments[field] = Evaluate("qry_selectCreditCard.#field#")>
				</cfif>
			</cfloop>

			<cfset Form = Arguments>
			<cfset Variables.doAction = "updateCreditCard">

			<cfinclude template="wsact_insertCreditCard.cfm">
		</cfif><!--- /update or insert credit card --->
	</cfif><!--- /if valid credit card to update --->
</cfif><!--- /user has permission to update credit cards --->

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

