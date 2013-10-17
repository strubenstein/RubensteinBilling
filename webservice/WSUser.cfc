<cfcomponent DisplayName="WSUser" Hint="Manages all user web services">

<cffunction Name="insertUser" Access="remote" Output="No" ReturnType="numeric" Hint="Inserts new user into database. Returns userID.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="companyID" Type="numeric">
	<cfargument Name="companyID_custom" Type="string">
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
	<cfargument Name="customField" Type="string">
	<cfargument Name="statusID" Type="numeric">
	<cfargument Name="statusID_custom" Type="string">
	<cfargument Name="statusHistoryComment" Type="string">

	<cfset var returnValue = -1>
	<cfset var returnError = "">
	<cfset var errorMessage_fields = StructNew()>
	<cfset var isAllFormFieldsOk = False>

	<cfinclude template="ws_user/ws_insertUser.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="insertUser_extended" Access="remote" Output="No" ReturnType="string" Hint="Insert new user and other options, including billing address, shipping address, phone, fax, credit card, bank, groups, custom fields, and custom status. Returns XML string of IDs.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="insertExtendedFieldTypeList" Type="string">
	<cfargument Name="companyID" Type="numeric">
	<cfargument Name="companyID_custom" Type="string">
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
	<cfargument Name="customField" Type="string">
	<cfargument Name="statusID" Type="numeric">
	<cfargument Name="statusID_custom" Type="string">
	<cfargument Name="statusHistoryComment" Type="string">
	<cfargument Name="groupID" Type="string">
	<cfargument Name="groupID_custom" Type="string">
	<cfargument Name="subscriberID" Type="numeric">
	<cfargument Name="subscriberID_custom" Type="string">
	<cfargument Name="subscriberNotifyEmail" Type="boolean">
	<cfargument Name="subscriberNotifyEmailHtml" Type="boolean">
	<cfargument Name="subscriberNotifyPdf" Type="boolean">
	<cfargument Name="subscriberNotifyDoc" Type="boolean">
	<cfargument Name="subscriberNotifyFax" Type="boolean">
	<cfargument Name="subscriberNotifyBillingAddress" Type="boolean">
	<cfargument Name="subscriberNotifyShippingAddress" Type="boolean">

	<cfset var returnValue = "">
	<cfset var returnError = "">
	<cfset var errorMessage_fields = StructNew()>
	<cfset var isAllFormFieldsOk = False>
	<cfset var returnValueXml = "">
	<cfset var permissionActionList = "">

	<cfset var hour_ampm = 0>
	<cfset var dateResponse = "">
	<cfset var targetID = 0>
	<cfset var primaryTargetKey = "">
	<cfset var targetUseCustomIDFieldList = "">
	<cfset var isUserAuthorized = False>

	<!--- user, billing address, shipping address, phone, fax, groups, custom fields, custom status, subscriberNotify --->
	<cfinclude template="ws_user/ws_insertUser_extended.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="updateUser" Access="remote" Output="No" ReturnType="boolean" Hint="Updates existing user">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="updateFieldList" Type="string">
	<cfargument Name="userID" Type="numeric">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="username" Type="string">
	<cfargument Name="password" Type="string">
	<cfargument Name="userStatus" Type="boolean">
	<cfargument Name="firstName" Type="string">
	<cfargument Name="middleName" Type="string">
	<cfargument Name="lastName" Type="string">
	<cfargument Name="suffix" Type="string">
	<cfargument Name="salutation" Type="string">
	<cfargument Name="email" Type="string">
	<cfargument Name="jobTitle" Type="string">
	<cfargument Name="jobDepartment" Type="string">
	<cfargument Name="jobDivision" Type="string">
	<cfargument Name="userNewsletterStatus" Type="boolean">
	<cfargument Name="userNewsletterHtml" Type="boolean">
	<cfargument Name="customField" Type="string">
	<cfargument Name="statusID" Type="numeric">
	<cfargument Name="statusID_custom" Type="string">
	<cfargument Name="statusHistoryComment" Type="string">

	<cfset var returnValue = False>
	<cfset var returnError = "">
	<cfset var errorMessage_fields = StructNew()>
	<cfset var isAllFormFieldsOk = False>
	<cfset var primaryTargetKey = "">
	<cfset var targetID = 0>
	<cfset var fieldArchiveArray = ArrayNew(1)>

	<cfinclude template="ws_user/ws_updateUser.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectUser" Access="remote" Output="No" ReturnType="query" Hint="Selects one or more existing users">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="userID" Type="string">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="useCustomIDFieldList" Type="string">

	<cfset var returnValue = QueryNew("error")>
	<cfset var returnError = "">

	<cfinclude template="ws_user/ws_selectUser.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectUserList_count" Access="remote" Output="No" ReturnType="numeric" Hint="Returns number of users that meet criteria">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="searchFieldList" Type="string">
	<cfargument Name="userStatus" Type="boolean">
	<cfargument Name="username" Type="string">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="firstName" Type="string">
	<cfargument Name="middleName" Type="string">
	<cfargument Name="lastName" Type="string">
	<cfargument Name="suffix" Type="string">
	<cfargument Name="salutation" Type="string">
	<cfargument Name="email" Type="string">
	<cfargument Name="jobTitle" Type="string">
	<cfargument Name="jobDepartment" Type="string">
	<cfargument Name="jobDivision" Type="string">
	<cfargument Name="userNewsletterStatus" Type="boolean">
	<cfargument Name="userNewsletterHtml" Type="boolean">
	<cfargument Name="companyID" Type="string">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="groupID" Type="string">
	<cfargument Name="groupID_custom" Type="string">
	<cfargument Name="affiliateID" Type="string">
	<cfargument Name="affiliateID_custom" Type="string">
	<cfargument Name="cobrandID" Type="string">
	<cfargument Name="cobrandID_custom" Type="string">
	<cfargument Name="statusID" Type="string">
	<cfargument Name="statusID_custom" Type="string">
	<cfargument Name="userIsExported" Type="string">

	<cfset var returnValue = -1>
	<cfset var returnError = "">
	<cfset var qryParamStruct = StructNew()>

	<cfinclude template="ws_user/ws_selectUserList_count.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectUserList" Access="remote" Output="No" ReturnType="query" Hint="Select user list that meet criteria">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="searchFieldList" Type="string">
	<cfargument Name="userStatus" Type="boolean">
	<cfargument Name="username" Type="string">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="firstName" Type="string">
	<cfargument Name="middleName" Type="string">
	<cfargument Name="lastName" Type="string">
	<cfargument Name="suffix" Type="string">
	<cfargument Name="salutation" Type="string">
	<cfargument Name="email" Type="string">
	<cfargument Name="jobTitle" Type="string">
	<cfargument Name="jobDepartment" Type="string">
	<cfargument Name="jobDivision" Type="string">
	<cfargument Name="userNewsletterStatus" Type="boolean">
	<cfargument Name="userNewsletterHtml" Type="boolean">
	<cfargument Name="companyID" Type="string">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="groupID" Type="string">
	<cfargument Name="groupID_custom" Type="string">
	<cfargument Name="affiliateID" Type="string">
	<cfargument Name="affiliateID_custom" Type="string">
	<cfargument Name="cobrandID" Type="string">
	<cfargument Name="cobrandID_custom" Type="string">
	<cfargument Name="statusID" Type="string">
	<cfargument Name="statusID_custom" Type="string">
	<cfargument Name="userIsExported" Type="string">
	<cfargument Name="queryDisplayPerPage" Type="numeric">
	<cfargument Name="queryPage" Type="numeric">
	<cfargument Name="queryOrderBy" Type="string">
	<cfargument Name="queryFirstLetter" Type="string">

	<cfset var returnValue = QueryNew("error")>
	<cfset var returnError = "">
	<cfset var queryFirstLetter_field = "">
	<cfset var qryParamStruct = StructNew()>

	<cfinclude template="ws_user/ws_selectUserList.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="updateUserIsExported" Access="public" Output="No" ReturnType="boolean" Hint="Updates whether user records have been exported. Returns True.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="userID" Type="string" Required="Yes">
	<cfargument Name="userID_custom" Type="string" Required="Yes">
	<cfargument Name="userIsExported" Type="string" Required="Yes">

	<cfset var returnValue = False>
	<cfset var returnError = "">

	<cfinclude template="ws_user/ws_updateUserIsExported.cfm">
	<cfreturn returnValue>
</cffunction>

</cfcomponent>
