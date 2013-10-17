<cfcomponent DisplayName="WSVendor" Hint="Manages all vendor web services">

<cffunction Name="insertVendor" Access="remote" Output="No" ReturnType="numeric" Hint="Inserts vendor. Returns vendorID.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="companyID" Type="numeric">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="userID" Type="numeric">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="vendorID_custom" Type="string">
	<cfargument Name="vendorCode" Type="string">
	<cfargument Name="vendorDescription" Type="string">
	<cfargument Name="vendorDescriptionHtml" Type="boolean">
	<cfargument Name="vendorDescriptionDisplay" Type="boolean">
	<cfargument Name="vendorURL" Type="string">
	<cfargument Name="vendorURLdisplay" Type="boolean">
	<cfargument Name="vendorName" Type="string">
	<cfargument Name="vendorImage" Type="string">
	<cfargument Name="vendorStatus" Type="boolean">
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

	<cfinclude template="ws_vendor/ws_insertVendor.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="updateVendor" Access="remote" Output="No" ReturnType="boolean" Hint="Updates existing vendor. Returns True.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="updateFieldList" Type="string">
	<cfargument Name="vendorID" Type="numeric">
	<cfargument Name="vendorID_custom" Type="string">
	<cfargument Name="userID" Type="numeric">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="vendorCode" Type="string">
	<cfargument Name="vendorDescription" Type="string">
	<cfargument Name="vendorDescriptionHtml" Type="boolean">
	<cfargument Name="vendorDescriptionDisplay" Type="boolean">
	<cfargument Name="vendorURL" Type="string">
	<cfargument Name="vendorURLdisplay" Type="boolean">
	<cfargument Name="vendorName" Type="string">
	<cfargument Name="vendorImage" Type="string">
	<cfargument Name="vendorStatus" Type="boolean">
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

	<cfinclude template="ws_vendor/ws_updateVendor.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectVendor" Access="remote" Output="No" ReturnType="query" Hint="Selects one or more existing vendors.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="vendorID" Type="string">
	<cfargument Name="vendorID_custom" Type="string">
	<cfargument Name="returnVendorDescription" Type="boolean">

	<cfset var returnValue = QueryNew("error")>
	<cfset var returnError = "">

	<cfinclude template="ws_vendor/ws_selectVendor.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectVendorList_count" Access="remote" Output="No" ReturnType="numeric" Hint="Returns the number of vendors that meet query criteria.">
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
	<cfargument Name="vendorName" Type="string">
	<cfargument Name="vendorCode" Type="string">
	<cfargument Name="vendorID_custom" Type="string">
	<cfargument Name="vendorURL" Type="string">
	<cfargument Name="vendorHasCode" Type="boolean">
	<cfargument Name="vendorHasCustomID" Type="boolean">
	<cfargument Name="vendorStatus" Type="boolean">
	<cfargument Name="vendorHasUser" Type="boolean">
	<cfargument Name="vendorNameIsCompanyName" Type="boolean">
	<cfargument Name="vendorIsExported" Type="string">

	<cfset var returnValue = -1>
	<cfset var returnError = "">
	<cfset var qryParamStruct = StructNew()>

	<cfinclude template="ws_vendor/ws_selectVendorList_count.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectVendorList" Access="remote" Output="No" ReturnType="query" Hint="Returns vendors that meet query criteria.">
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
	<cfargument Name="vendorName" Type="string">
	<cfargument Name="vendorCode" Type="string">
	<cfargument Name="vendorID_custom" Type="string">
	<cfargument Name="vendorURL" Type="string">
	<cfargument Name="vendorHasCode" Type="boolean">
	<cfargument Name="vendorHasCustomID" Type="boolean">
	<cfargument Name="vendorStatus" Type="boolean">
	<cfargument Name="vendorHasUser" Type="boolean">
	<cfargument Name="vendorNameIsCompanyName" Type="boolean">
	<cfargument Name="vendorIsExported" Type="string">
	<cfargument Name="returnVendorDescription" Type="boolean">
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

	<cfinclude template="ws_vendor/ws_selectVendorList.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="updateVendorIsExported" Access="public" Output="No" ReturnType="boolean" Hint="Updates whether vendor records have been exported. Returns True.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="vendorID" Type="string" Required="Yes">
	<cfargument Name="vendorID_custom" Type="string" Required="Yes">
	<cfargument Name="vendorIsExported" Type="string" Required="Yes">

	<cfset var returnValue = False>
	<cfset var returnError = "">

	<cfinclude template="ws_vendor/ws_updateVendorIsExported.cfm">
	<cfreturn returnValue>
</cffunction>

</cfcomponent>
