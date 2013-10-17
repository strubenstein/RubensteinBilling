<cfcomponent DisplayName="WSAffiliate" Hint="Manages all affiliate web services">

<cffunction Name="insertAffiliate" Access="remote" Output="No" ReturnType="numeric" Hint="Inserts affiliate. Returns affiliateID.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="companyID" Type="numeric">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="userID" Type="numeric">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="affiliateID_custom" Type="string">
	<cfargument Name="affiliateCode" Type="string">
	<cfargument Name="affiliateName" Type="string">
	<cfargument Name="affiliateURL" Type="string">
	<cfargument Name="affiliateStatus" Type="boolean">
	<cfargument Name="customField" Type="string">
	<cfargument Name="statusID" Type="numeric">
	<cfargument Name="statusID_custom" Type="string">
	<cfargument Name="statusHistoryComment" Type="string">

	<cfset var returnValue = -1>
	<cfset var returnError = "">
	<cfset var qry_selectUserCompanyList_company = QueryNew("userID")>
	<cfset var errorMessage_fields = StructNew()>
	<cfset var isAllFormFieldsOk = False>
	<cfset var primaryTargetKey = "">
	<cfset var targetID = 0>

	<cfinclude template="ws_affiliate/ws_insertAffiliate.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="updateAffiliate" Access="remote" Output="No" ReturnType="boolean" Hint="Updates existing affiliate. Returns True.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="updateFieldList" Type="string">
	<cfargument Name="affiliateID" Type="numeric">
	<cfargument Name="affiliateID_custom" Type="string">
	<cfargument Name="userID" Type="numeric">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="affiliateCode" Type="string">
	<cfargument Name="affiliateName" Type="string">
	<cfargument Name="affiliateURL" Type="string">
	<cfargument Name="affiliateStatus" Type="boolean">
	<cfargument Name="customField" Type="string">
	<cfargument Name="statusID" Type="numeric">
	<cfargument Name="statusID_custom" Type="string">
	<cfargument Name="statusHistoryComment" Type="string">

	<cfset var returnValue = False>
	<cfset var returnError = "">
	<cfset var qry_selectUserCompanyList_company = QueryNew("userID")>
	<cfset var errorMessage_fields = StructNew()>
	<cfset var isAllFormFieldsOk = False>
	<cfset var primaryTargetKey = "">
	<cfset var targetID = 0>
	<cfset var fieldArchiveArray = ArrayNew(1)>

	<cfinclude template="ws_affiliate/ws_updateAffiliate.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectAffiliate" Access="remote" Output="No" ReturnType="query" Hint="Select one or more existing affiliates.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="affiliateID" Type="string">
	<cfargument Name="affiliateID_custom" Type="string">

	<cfset var returnValue = QueryNew("error")>
	<cfset var returnError = "">

	<cfinclude template="ws_affiliate/ws_selectAffiliate.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectAffiliateList_count" Access="remote" Output="No" ReturnType="numeric" Hint="Returns the number of affiliates that meet query criteria.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="searchFieldList" Type="string">
	<cfargument Name="companyID" Type="string">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="groupID" Type="string">
	<cfargument Name="groupID_custom" Type="string">
	<cfargument Name="userID" Type="string">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="statusID" Type="string">
	<cfargument Name="statusID_custom" Type="string">
	<cfargument Name="affiliateName" Type="string">
	<cfargument Name="affiliateCode" Type="string">
	<cfargument Name="affiliateID_custom" Type="string">
	<cfargument Name="affiliateURL" Type="string">
	<cfargument Name="affiliateHasCode" Type="boolean">
	<cfargument Name="affiliateHasCustomID" Type="boolean">
	<cfargument Name="affiliateStatus" Type="boolean">
	<cfargument Name="affiliateHasCustomPricing" Type="boolean">
	<cfargument Name="affiliateHasCommission" Type="boolean">
	<cfargument Name="affiliateHasUser" Type="boolean">
	<cfargument Name="affiliateHasURL" Type="boolean">
	<cfargument Name="affiliateNameIsCompanyName" Type="boolean">
	<cfargument Name="affiliateHasCustomer" Type="boolean">
	<cfargument Name="affiliateHasActiveSubscriber" Type="boolean">
	<cfargument Name="affiliateIsExported" Type="string">

	<cfset var returnValue = -1>
	<cfset var returnError = "">
	<cfset var qryParamStruct = StructNew()>

	<cfinclude template="ws_affiliate/ws_selectAffiliateList_count.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectAffiliateList" Access="remote" Output="No" ReturnType="query" Hint="Returns affiliates that meet query criteria.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="searchFieldList" Type="string">
	<cfargument Name="companyID" Type="string">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="groupID" Type="string">
	<cfargument Name="groupID_custom" Type="string">
	<cfargument Name="userID" Type="string">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="statusID" Type="string">
	<cfargument Name="statusID_custom" Type="string">
	<cfargument Name="affiliateName" Type="string">
	<cfargument Name="affiliateCode" Type="string">
	<cfargument Name="affiliateID_custom" Type="string">
	<cfargument Name="affiliateURL" Type="string">
	<cfargument Name="affiliateHasCode" Type="boolean">
	<cfargument Name="affiliateHasCustomID" Type="boolean">
	<cfargument Name="affiliateStatus" Type="boolean">
	<cfargument Name="affiliateHasCustomPricing" Type="boolean">
	<cfargument Name="affiliateHasCommission" Type="boolean">
	<cfargument Name="affiliateHasUser" Type="boolean">
	<cfargument Name="affiliateHasURL" Type="boolean">
	<cfargument Name="affiliateNameIsCompanyName" Type="boolean">
	<cfargument Name="affiliateHasCustomer" Type="boolean">
	<cfargument Name="affiliateHasActiveSubscriber" Type="boolean">
	<cfargument Name="affiliateIsExported" Type="string">
	<cfargument Name="returnUserFields" Type="boolean">
	<cfargument Name="returnCompanyFields" Type="boolean">
	<cfargument Name="queryDisplayPerPage" Type="numeric">
	<cfargument Name="queryPage" Type="numeric">
	<cfargument Name="queryOrderBy" Type="string">
	<cfargument Name="queryFirstLetter" Type="string">

	<cfset var returnValue = QueryNew("error")>
	<cfset var returnError = "">
	<cfset var queryFirstLetter_field = "">
	<cfset var qryParamStruct = StructNew()>

	<cfinclude template="ws_affiliate/ws_selectAffiliateList.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="updateAffiliateIsExported" Access="public" Output="No" ReturnType="boolean" Hint="Updates whether affiliate records have been exported. Returns True.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="affiliateID" Type="string" Required="Yes">
	<cfargument Name="affiliateID_custom" Type="string" Required="Yes">
	<cfargument Name="affiliateIsExported" Type="string" Required="Yes">

	<cfset var returnValue = False>
	<cfset var returnError = "">

	<cfinclude template="ws_affiliate/ws_updateAffiliateIsExported.cfm">
	<cfreturn returnValue>
</cffunction>

</cfcomponent>
