<cfcomponent DisplayName="WSCobrand" Hint="Manages all cobrand web services">

<cffunction Name="insertCobrand" Access="remote" Output="No" ReturnType="numeric" Hint="Inserts cobrand. Returns cobrandID.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="companyID" Type="numeric">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="userID" Type="numeric">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="cobrandID_custom" Type="string">
	<cfargument Name="cobrandName" Type="string">
	<cfargument Name="cobrandCode" Type="string">
	<cfargument Name="cobrandURL" Type="string">
	<cfargument Name="cobrandStatus" Type="boolean">
	<cfargument Name="cobrandImage" Type="string">
	<cfargument Name="cobrandTitle" Type="string">
	<cfargument Name="cobrandDomain" Type="string">
	<cfargument Name="cobrandDirectory" Type="string">
	<cfargument Name="customField" Type="string">
	<cfargument Name="statusID" Type="numeric">
	<cfargument Name="statusID_custom" Type="string">
	<cfargument Name="statusHistoryComment" Type="string">

	<cfset var returnValue = -1>
	<cfset var returnError = "">
	<cfset var qry_selectUserCompanyList_company = QueryNew("userID")>
	<cfset var errorMessage_fields = StructNew()>
	<cfset var isAllFormFieldsOk = False>

	<cfinclude template="ws_cobrand/ws_insertCobrand.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="updateCobrand" Access="remote" Output="No" ReturnType="boolean" Hint="Updates existing cobrand. Returns True.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="updateFieldList" Type="string">
	<cfargument Name="cobrandID" Type="numeric">
	<cfargument Name="cobrandID_custom" Type="string">
	<cfargument Name="userID" Type="numeric">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="cobrandName" Type="string">
	<cfargument Name="cobrandCode" Type="string">
	<cfargument Name="cobrandURL" Type="string">
	<cfargument Name="cobrandStatus" Type="boolean">
	<cfargument Name="cobrandImage" Type="string">
	<cfargument Name="cobrandTitle" Type="string">
	<cfargument Name="cobrandDomain" Type="string">
	<cfargument Name="cobrandDirectory" Type="string">
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

	<cfinclude template="ws_cobrand/ws_updateCobrand.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectCobrand" Access="remote" Output="No" ReturnType="query" Hint="Selects oen or more existing cobrands.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="cobrandID" Type="string">
	<cfargument Name="cobrandID_custom" Type="string">

	<cfset var returnValue = QueryNew("error")>
	<cfset var returnError = "">

	<cfinclude template="ws_cobrand/ws_selectCobrand.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectCobrandList_count" Access="remote" Output="No" ReturnType="numeric" Hint="Returns the number of cobrands that meet query criteria.">
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
	<cfargument Name="cobrandStatus" Type="boolean">
	<cfargument Name="cobrandHasCode" Type="boolean">
	<cfargument Name="cobrandHasCustomID" Type="boolean">
	<cfargument Name="cobrandHasCustomPricing" Type="boolean">
	<cfargument Name="cobrandHasCommission" Type="numeric">
	<cfargument Name="cobrandNameIsCompanyName" Type="boolean">
	<cfargument Name="cobrandHasUser" Type="boolean">
	<cfargument Name="cobrandHasCustomer" Type="boolean">
	<cfargument Name="cobrandHasActiveSubscriber" Type="boolean">
	<cfargument Name="cobrandName" Type="string">
	<cfargument Name="cobrandCode" Type="string">
	<cfargument Name="cobrandURL" Type="string">
	<cfargument Name="cobrandID_custom" Type="string">
	<cfargument Name="cobrandTitle" Type="string">
	<cfargument Name="cobrandDomain" Type="string">
	<cfargument Name="cobrandDirectory" Type="string">
	<cfargument Name="cobrandIsExported" Type="string">

	<cfset var returnValue = -1>
	<cfset var returnError = "">
	<cfset var qryParamStruct = StructNew()>

	<cfinclude template="ws_cobrand/ws_selectCobrandList_count.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectCobrandList" Access="remote" Output="No" ReturnType="query" Hint="Returns cobrands that meet query criteria.">
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
	<cfargument Name="cobrandStatus" Type="boolean">
	<cfargument Name="cobrandHasCode" Type="boolean">
	<cfargument Name="cobrandHasCustomID" Type="boolean">
	<cfargument Name="cobrandHasCustomPricing" Type="boolean">
	<cfargument Name="cobrandHasCommission" Type="numeric">
	<cfargument Name="cobrandNameIsCompanyName" Type="boolean">
	<cfargument Name="cobrandHasUser" Type="boolean">
	<cfargument Name="cobrandHasCustomer" Type="boolean">
	<cfargument Name="cobrandHasActiveSubscriber" Type="boolean">
	<cfargument Name="cobrandName" Type="string">
	<cfargument Name="cobrandCode" Type="string">
	<cfargument Name="cobrandURL" Type="string">
	<cfargument Name="cobrandID_custom" Type="string">
	<cfargument Name="cobrandTitle" Type="string">
	<cfargument Name="cobrandDomain" Type="string">
	<cfargument Name="cobrandDirectory" Type="string">
	<cfargument Name="cobrandIsExported" Type="string">
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

	<cfinclude template="ws_cobrand/ws_selectCobrandList.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="updateCobrandIsExported" Access="public" Output="No" ReturnType="boolean" Hint="Updates whether cobrand records have been exported. Returns True.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="cobrandID" Type="string" Required="Yes">
	<cfargument Name="cobrandID_custom" Type="string" Required="Yes">
	<cfargument Name="cobrandIsExported" Type="string" Required="Yes">

	<cfset var returnValue = False>
	<cfset var returnError = "">

	<cfinclude template="ws_cobrand/ws_updateCobrandIsExported.cfm">
	<cfreturn returnValue>
</cffunction>

</cfcomponent>
