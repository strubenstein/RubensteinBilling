<cfinclude template="wslang_creditCard.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = QueryNew("error")>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("listCreditCards", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_creditCard.listCreditCards>
<cfelse>
	<cfloop Index="field" List="creditCardRetain,creditCardStatus">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfif ListFind(Arguments.searchFieldList, "companyID") or ListFind(Arguments.searchFieldList, "companyID_custom")>
		<cfset Arguments.companyID = Application.objWebServiceSecurity.ws_checkCompanyPermission(qry_selectWebServiceSession.companyID_author, Arguments.companyID, Arguments.companyID_custom, Arguments.useCustomIDFieldList)>
	</cfif>
	<cfif ListFind(Arguments.searchFieldList, "userID") or ListFind(Arguments.searchFieldList, "userID_custom")>
		<cfset Arguments.userID = Application.objWebServiceSecurity.ws_checkCompanyPermission(qry_selectWebServiceSession.companyID_author, Arguments.userID, Arguments.userID_custom, Arguments.useCustomIDFieldList)>
	</cfif>
	<cfif ListFind(Arguments.searchFieldList, "subscriberID") or ListFind(Arguments.searchFieldList, "subscriberID_custom")>
		<cfset Arguments.subscriberID = Application.objWebServiceSecurity.ws_checkCompanyPermission(qry_selectWebServiceSession.companyID_author, Arguments.subscriberID, Arguments.subscriberID_custom, Arguments.useCustomIDFieldList)>
	</cfif>

	<cfif ListFind(Arguments.searchFieldList, "creditCardExpirationMonth")>
		<cfinclude template="../../view/v_creditCard/var_creditCardExpirationMonthList.cfm">
		<cfif Not ListFind(Variables.creditCardExpirationMonthList_value, Arguments.creditCardExpirationMonth)>
			<cfset returnError = Variables.wslang_creditCard.creditCardExpirationMonth>
		</cfif>
	</cfif>
	<cfif ListFind(Arguments.searchFieldList, "creditCardExpirationYear") and Not Application.fn_IsIntegerPositive(Arguments.creditCardExpirationYear)>
		<cfset returnError = Variables.wslang_creditCard.creditCardExpirationYear>
	</cfif>

	<cfif ListFind(Arguments.searchFieldList, "creditCardType") and Trim(Arguments.creditCardType) is not "">
		<cfinclude template="../../view/v_creditCard/var_creditCardTypeList.cfm">
		<cfloop Index="count" From="1" To="#ListLen(Arguments.creditCardType)#">
			<cfset ccTypePosition = ListFindNoCase(Variables.creditCardTypeList_value, ListGetAt(Arguments.creditCardType, count))>
			<cfif ccTypePosition is 0>
				<cfset returnError = Variables.wslang_creditCard.creditCardType>
				<cfbreak>
			<cfelseif Compare(ListGetAt(Arguments.creditCardType, count), ListGetAt(Variables.creditCardTypeList_value, ccTypePosition)) is not 0>
				<cfset Arguments.creditCardType = ListSetAt(Arguments.creditCardType, count, ListGetAt(Variables.creditCardTypeList_value, ccTypePosition))>
			</cfif>
		</cfloop>
	</cfif>

	<cfif returnError is not "">
		<cfset returnValue = QueryNew("error")>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.CreditCard" Method="selectCreditCardList" ReturnVariable="qry_selectCreditCardList">
			<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
			<cfinvokeargument Name="returnCompanyFields" Value="True">
			<cfloop Index="field" List="companyID,userID,subscriberID">
				<cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field]) and ListFind(Arguments.searchFieldList, field)>
					<cfinvokeargument Name="#field#" Value="#Arguments[field]#">
				</cfif>
			</cfloop>
			<cfloop Index="field" List="creditCardStatus,creditCardRetain">
				<cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field]) and ListFind(Arguments.searchFieldList, field)>
					<cfinvokeargument Name="#field#" Value="#Arguments[field]#">
				</cfif>
			</cfloop>
			<cfif StructKeyExists(Arguments, "creditCardDescription") and Trim(Arguments.creditCardDescription) is not "" and ListFind(Arguments.searchFieldList, "creditCardDescription")>
				<cfinvokeargument Name="creditCardDescription" Value="#Arguments.creditCardDescription#">
			</cfif>
			<cfloop Index="field" List="creditCardExpirationMonth,creditCardExpirationYear,creditCardType">
				<cfif ListFind(Arguments.searchFieldList, field)>
					<cfinvokeargument Name="#field#" Value="#Arguments[field]#">
				</cfif>
			</cfloop>
		</cfinvoke>

		<cfset returnValue = qry_selectCreditCardList>
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">


