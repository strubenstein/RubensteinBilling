<cfcomponent DisplayName="WSCompany" Hint="Manages all company web services">

<cffunction Name="insertCompany" Access="remote" Output="No" ReturnType="numeric" Hint="Inserts new company. Returns companyID.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="companyName" Type="string">
	<cfargument Name="companyDBA" Type="string">
	<cfargument Name="companyURL" Type="string">
	<cfargument Name="companyStatus" Type="boolean">
	<cfargument Name="companyIsCustomer" Type="boolean">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="companyIsTaxExempt" Type="boolean">
	<cfargument Name="affiliateID" Type="numeric">
	<cfargument Name="affiliateID_custom" Type="string">
	<cfargument Name="cobrandID" Type="numeric">
	<cfargument Name="cobrandID_custom" Type="string">
	<cfargument Name="customField" Type="string">
	<cfargument Name="statusID" Type="numeric">
	<cfargument Name="statusID_custom" Type="string">
	<cfargument Name="statusHistoryComment" Type="string">

	<cfset var returnValue = -1>
	<cfset var returnError = "">
	<cfset var errorMessage_fields = StructNew()>
	<cfset var isAllFormFieldsOk = False>

	<cfinclude template="ws_company/ws_insertCompany.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="insertCompany_extended" Access="remote" Output="No" ReturnType="string" Hint="Inserts new company and other options, including primary user, billing address, shipping address, phone, fax, credit card, bank, groups, custom fields, custom status, subscriber, and payflow. Returns XML string of IDs."><!--- region,salesperson --->
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="insertExtendedFieldTypeList" Type="string">
	<cfargument Name="companyName" Type="string">
	<cfargument Name="companyDBA" Type="string">
	<cfargument Name="companyURL" Type="string">
	<cfargument Name="companyStatus" Type="boolean">
	<cfargument Name="companyIsCustomer" Type="boolean">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="companyIsTaxExempt" Type="boolean">
	<cfargument Name="affiliateID" Type="numeric">
	<cfargument Name="affiliateID_custom" Type="string">
	<cfargument Name="cobrandID" Type="numeric">
	<cfargument Name="cobrandID_custom" Type="string">
	<cfargument Name="customField_company" Type="string">
	<cfargument Name="statusID_company" Type="numeric">
	<cfargument Name="statusID_company_custom" Type="string">
	<cfargument Name="statusHistoryComment_company" Type="string">
	<cfargument Name="username" Type="string">
	<cfargument Name="password" Type="string">
	<cfargument Name="userStatus" Type="boolean">
	<cfargument Name="firstName" Type="string">
	<cfargument Name="middleName" Type="string">
	<cfargument Name="lastName" Type="string">
	<cfargument Name="suffix" Type="string">
	<cfargument Name="salutation" Type="string">
	<cfargument Name="email" Type="string">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="jobTitle" Type="string">
	<cfargument Name="jobDepartment" Type="string">
	<cfargument Name="jobDivision" Type="string">
	<cfargument Name="userNewsletterStatus" Type="boolean">
	<cfargument Name="userNewsletterHtml" Type="boolean">
	<cfargument Name="customField_user" Type="string">
	<cfargument Name="statusID_user" Type="numeric">
	<cfargument Name="statusID_user_custom" Type="string">
	<cfargument Name="statusHistoryComment_user" Type="string">
	<cfargument Name="phoneAreaCode" Type="string">
	<cfargument Name="phoneNumber" Type="string">
	<cfargument Name="phoneExtension" Type="string">
	<cfargument Name="phoneType" Type="string">
	<cfargument Name="phoneDescription" Type="string">
	<cfargument Name="faxAreaCode" Type="string">
	<cfargument Name="faxNumber" Type="string">
	<cfargument Name="faxDescription" Type="string">
	<cfargument Name="addressName_billing" Type="string">
	<cfargument Name="addressDescription_billing" Type="string">
	<cfargument Name="address_billing" Type="string">
	<cfargument Name="address2_billing" Type="string">
	<cfargument Name="address3_billing" Type="string">
	<cfargument Name="city_billing" Type="string">
	<cfargument Name="state_billing" Type="string">
	<cfargument Name="zipCode_billing" Type="string">
	<cfargument Name="zipCodePlus4_billing" Type="string">
	<cfargument Name="county_billing" Type="string">
	<cfargument Name="country_billing" Type="string">
	<cfargument Name="shippingAddressSameAsBillingAddress" Type="boolean">
	<cfargument Name="addressName_shipping" Type="string">
	<cfargument Name="addressDescription_shipping" Type="string">
	<cfargument Name="address_shipping" Type="string">
	<cfargument Name="address2_shipping" Type="string">
	<cfargument Name="address3_shipping" Type="string">
	<cfargument Name="city_shipping" Type="string">
	<cfargument Name="state_shipping" Type="string">
	<cfargument Name="zipCode_shipping" Type="string">
	<cfargument Name="zipCodePlus4_shipping" Type="string">
	<cfargument Name="county_shipping" Type="string">
	<cfargument Name="country_shipping" Type="string">
	<cfargument Name="bankName" Type="string">
	<cfargument Name="bankBranch" Type="string">
	<cfargument Name="bankBranchCity" Type="string">
	<cfargument Name="bankBranchState" Type="string">
	<cfargument Name="bankBranchCountry" Type="string">
	<cfargument Name="bankBranchContactName" Type="string">
	<cfargument Name="bankBranchPhone" Type="string">
	<cfargument Name="bankBranchFax" Type="string">
	<cfargument Name="bankRoutingNumber" Type="string">
	<cfargument Name="bankAccountNumber" Type="string">
	<cfargument Name="bankAccountName" Type="string">
	<cfargument Name="bankCheckingOrSavings" Type="string">
	<cfargument Name="bankPersonalOrCorporate" Type="boolean">
	<cfargument Name="bankDescription" Type="string">
	<cfargument Name="bankAccountType" Type="string">
	<cfargument Name="bankRetain" Type="boolean">
	<cfargument Name="creditCardName" Type="string">
	<cfargument Name="creditCardNumber" Type="string">
	<cfargument Name="creditCardExpirationMonth" Type="string">
	<cfargument Name="creditCardExpirationYear" Type="string">
	<cfargument Name="creditCardType" Type="string">
	<cfargument Name="creditCardCVC" Type="string">
	<cfargument Name="creditCardRetain" Type="boolean">
	<cfargument Name="creditCardDescription" Type="string">
	<cfargument Name="groupID" Type="string">
	<cfargument Name="groupID_custom" Type="string">
	<cfargument Name="payflowID" Type="numeric">
	<cfargument Name="payflowID_custom" Type="string">
	<cfargument Name="subscriberName" Type="string">
	<cfargument Name="subscriberID_custom" Type="string">
	<cfargument Name="subscriberDateProcessNext" Type="string">
	<cfargument Name="subscriberPaymentViaCreditCard" Type="boolean">
	<cfargument Name="subscriberPaymentViaBank" Type="boolean">
	<cfargument Name="subscriberNotifyEmail" Type="boolean">
	<cfargument Name="subscriberNotifyEmailHtml" Type="boolean">
	<cfargument Name="subscriberNotifyPdf" Type="boolean">
	<cfargument Name="subscriberNotifyDoc" Type="boolean">
	<cfargument Name="subscriberNotifyFax" Type="boolean">
	<cfargument Name="subscriberNotifyBillingAddress" Type="boolean">
	<cfargument Name="subscriberNotifyShippingAddress" Type="boolean">
	<cfargument Name="customField_subscriber" Type="string">
	<cfargument Name="statusID_subscriber" Type="numeric">
	<cfargument Name="statusID_subscriber_custom" Type="string">
	<cfargument Name="statusHistoryComment_subscriber" Type="string">

	<cfset var returnValue = "">
	<cfset var returnError = "">
	<cfset var errorMessage_fields = StructNew()>
	<cfset var isAllFormFieldsOk = False>
	<cfset var returnValueXml = "">
	<cfset var permissionActionList = "">

	<cfset var hour_ampm = 0>
	<cfset var dateResponse = "">
	<cfset var ccTypePosition = 0>
	<cfset var targetID = 0>
	<cfset var primaryTargetKey = "">
	<cfset var targetUseCustomIDFieldList = "">
	<cfset var isUserAuthorized = False>

	<!--- company, primary user, billing address, shipping address, phone, fax, credit card, bank, groups, custom fields, custom status, subscriber, subscriberNotify, subscriberPayment, and payflow. --->
	<cfinclude template="ws_company/ws_insertCompany_extended.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="updateCompany" Access="remote" Output="No" ReturnType="boolean" Hint="Updates existing company. Returns True.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="updateFieldList" Type="string">
	<cfargument Name="companyID" Type="numeric">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="userID" Type="numeric">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="companyName" Type="string">
	<cfargument Name="companyDBA" Type="string">
	<cfargument Name="companyURL" Type="string">
	<cfargument Name="companyStatus" Type="boolean">
	<cfargument Name="companyIsTaxExempt" Type="boolean">
	<cfargument Name="customField" Type="string">
	<cfargument Name="statusID" Type="numeric">
	<cfargument Name="statusID_custom" Type="string">
	<cfargument Name="statusHistoryComment" Type="string">

	<cfset var returnValue = False>
	<cfset var returnError = "">
	<cfset var errorMessage_fields = StructNew()>
	<cfset var qry_selectUserCompanyList_company = QueryNew("userID")>
	<cfset var isAllFormFieldsOk = False>
	<cfset var primaryTargetKey = "">
	<cfset var targetID = 0>
	<cfset var fieldArchiveArray = ArrayNew(1)>

	<cfinclude template="ws_company/ws_updateCompany.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectCompany" Access="remote" Output="No" ReturnType="query" Hint="Selects one or more existing companies. Returns query.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="companyID" Type="string">
	<cfargument Name="companyID_custom" Type="string">

	<cfset var returnValue = QueryNew("error")>
	<cfset var returnError = "">

	<cfinclude template="ws_company/ws_selectCompany.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectCompanyList_count" Access="remote" Output="No" ReturnType="numeric" Hint="Returns number of companies that meet criteria.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="searchFieldList" Type="string">
	<cfargument Name="groupID" Type="string">
	<cfargument Name="groupID_custom" Type="string">
	<cfargument Name="affiliateID" Type="string">
	<cfargument Name="affiliateID_custom" Type="string">
	<cfargument Name="cobrandID" Type="string">
	<cfargument Name="cobrandID_custom" Type="string">
	<cfargument Name="statusID" Type="string">
	<cfargument Name="statusID_custom" Type="string">
	<cfargument Name="payflowID" Type="string">
	<cfargument Name="payflowID_custom" Type="string">
	<cfargument Name="companyStatus" Type="boolean">
	<cfargument Name="companyIsCustomer" Type="boolean">
	<cfargument Name="companyIsTaxExempt" Type="boolean">
	<cfargument Name="companyName" Type="string">
	<cfargument Name="companyDBA" Type="string">
	<cfargument Name="companyURL" Type="string">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="city" Type="string">
	<cfargument Name="state" Type="string">
	<cfargument Name="county" Type="string">
	<cfargument Name="zipCode" Type="string">
	<cfargument Name="country" Type="string">
	<cfargument Name="companyIsExported" Type="string">

	<cfset var returnValue = -1>
	<cfset var returnError = "">
	<cfset var qryParamStruct = StructNew()>

	<cfinclude template="ws_company/ws_selectCompanyList_count.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectCompanyList" Access="remote" Output="No" ReturnType="query" Hint="Select company list. Returns query.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="searchFieldList" Type="string">
	<cfargument Name="groupID" Type="string">
	<cfargument Name="groupID_custom" Type="string">
	<cfargument Name="affiliateID" Type="string">
	<cfargument Name="affiliateID_custom" Type="string">
	<cfargument Name="cobrandID" Type="string">
	<cfargument Name="cobrandID_custom" Type="string">
	<cfargument Name="statusID" Type="string">
	<cfargument Name="statusID_custom" Type="string">
	<cfargument Name="payflowID" Type="string">
	<cfargument Name="payflowID_custom" Type="string">
	<cfargument Name="companyStatus" Type="boolean">
	<cfargument Name="companyIsCustomer" Type="boolean">
	<cfargument Name="companyIsTaxExempt" Type="boolean">
	<cfargument Name="companyName" Type="string">
	<cfargument Name="companyDBA" Type="string">
	<cfargument Name="companyURL" Type="string">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="city" Type="string">
	<cfargument Name="state" Type="string">
	<cfargument Name="county" Type="string">
	<cfargument Name="zipCode" Type="string">
	<cfargument Name="country" Type="string">
	<cfargument Name="companyIsExported" Type="string">
	<cfargument Name="queryDisplayPerPage" Type="numeric">
	<cfargument Name="queryPage" Type="numeric">
	<cfargument Name="queryOrderBy" Type="string">
	<cfargument Name="queryFirstLetter" Type="string">

	<cfset var returnValue = QueryNew("error")>
	<cfset var returnError = "">
	<cfset var qryParamStruct = StructNew()>

	<cfinclude template="ws_company/ws_selectCompanyList.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="updateCompanyIsExported" Access="public" Output="No" ReturnType="boolean" Hint="Updates whether company records have been exported. Returns True.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="companyID" Type="string" Required="Yes">
	<cfargument Name="companyID_custom" Type="string" Required="Yes">
	<cfargument Name="companyIsExported" Type="string" Required="Yes">

	<cfset var returnValue = False>
	<cfset var returnError = "">

	<cfinclude template="ws_company/ws_updateCompanyIsExported.cfm">
	<cfreturn returnValue>
</cffunction>

</cfcomponent>
