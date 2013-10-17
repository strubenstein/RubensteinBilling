<cfcomponent DisplayName="WSCreditCard" Hint="Manages all credit card web services">

<cffunction Name="insertCreditCard" Access="remote" Output="No" ReturnType="numeric" Hint="Inserts new credit card into database and returns creditCardID">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="companyID" Type="numeric">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="userID" Type="numeric">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="addressID" Type="numeric">
	<cfargument Name="creditCardName" Type="string">
	<cfargument Name="creditCardNumber" Type="string">
	<cfargument Name="creditCardExpirationMonth" Type="string">
	<cfargument Name="creditCardExpirationYear" Type="string">
	<cfargument Name="creditCardType" Type="string">
	<cfargument Name="creditCardCVC" Type="string">
	<cfargument Name="creditCardRetain" Type="boolean">
	<cfargument Name="creditCardDescription" Type="string">

	<cfset var returnValue = -1>
	<cfset var returnError = "">
	<cfset var errorMessage_fields = StructNew()>
	<cfset var isAllFormFieldsOk = False>
	<cfset var ccTypePosition = 0>

	<cfinclude template="ws_creditCard/ws_insertCreditCard.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="updateCreditCard" Access="remote" Output="No" ReturnType="numeric" Hint="Updates existing credit card. If necessary, deletes existing credit card. Inserts new credit card and returns new creditCardID.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="updateFieldList" Type="string">
	<cfargument Name="creditCardID" Type="numeric">
	<cfargument Name="companyID" Type="numeric">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="userID" Type="numeric">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="addressID" Type="numeric">
	<cfargument Name="creditCardName" Type="string">
	<cfargument Name="creditCardNumber" Type="string">
	<cfargument Name="creditCardExpirationMonth" Type="string">
	<cfargument Name="creditCardExpirationYear" Type="string">
	<cfargument Name="creditCardType" Type="string">
	<cfargument Name="creditCardCVC" Type="string">
	<cfargument Name="creditCardRetain" Type="boolean">
	<cfargument Name="creditCardDescription" Type="string">
	<cfargument Name="creditCardStatus" Type="boolean">

	<cfset var returnValue = -1>
	<cfset var returnError = "">
	<cfset var errorMessage_fields = StructNew()>
	<cfset var isAllFormFieldsOk = False>
	<cfset var ccTypePosition = 0>
	<cfset var updateFieldList_valid = "">
	<cfset var isCreditCardUpdate = True>

	<cfinclude template="ws_creditCard/ws_updateCreditCard.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectCreditCard" Access="remote" Output="No" ReturnType="query" Hint="Select existing credit card(s)">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="creditCardID" Type="string">

	<cfset var returnValue = QueryNew("blank")>
	<cfset var returnError = "">
	<cfset var errorMessage_fields = StructNew()>
	<cfset var isAllFormFieldsOk = False>

	<cfinclude template="ws_creditCard/ws_selectCreditCard.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectCreditCardList" Access="remote" Output="No" ReturnType="query" Hint="Select existing credit card(s) based on designated criteria">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="searchFieldList" Type="string">
	<cfargument Name="companyID" Type="string">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="userID" Type="string">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="subscriberID" Type="string">
	<cfargument Name="subscriberID_custom" Type="string">
	<cfargument Name="creditCardExpirationMonth" Type="string">
	<cfargument Name="creditCardExpirationYear" Type="string">
	<cfargument Name="creditCardType" Type="string">
	<cfargument Name="creditCardRetain" Type="boolean">
	<cfargument Name="creditCardStatus" Type="boolean">
	<cfargument Name="creditCardDescription" Type="string">

	<cfset var returnValue = QueryNew("blank")>
	<cfset var returnError = "">
	<cfset var errorMessage_fields = StructNew()>
	<cfset var isAllFormFieldsOk = False>
	<cfset var ccTypePosition = 0>

	<cfinclude template="ws_creditCard/ws_selectCreditCardList.cfm">
	<cfreturn returnValue>
</cffunction>

</cfcomponent>
