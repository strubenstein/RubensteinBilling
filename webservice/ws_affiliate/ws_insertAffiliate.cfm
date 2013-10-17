<cfinclude template="wslang_affiliate.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = -1>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("insertAffiliate", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = -1>
	<cfset returnError = Variables.wslang_affiliate.insertAffiliate>
<cfelse>
	<cfloop Index="field" List="affiliateStatus">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfset Arguments.companyID = Application.objWebServiceSecurity.ws_checkCompanyPermission(qry_selectWebServiceSession.companyID_author, Arguments.companyID, Arguments.companyID_custom, Arguments.useCustomIDFieldList)>
	<cfif Arguments.companyID lte 0>
		<cfset returnValue = -1>
		<cfset returnError = Variables.wslang_affiliate.invalidCompany>
	<cfelse>
		<cfset Arguments.userID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.userID, Arguments.userID_custom, Arguments.useCustomIDFieldList, Arguments.companyID)>
		<cfif Arguments.userID is not 0>
			<!--- <cfset qry_selectUserCompanyList_company = QueryNew("userID")> --->
			<cfset temp = QueryAddRow(qry_selectUserCompanyList_company, 1)>
			<cfset temp = QuerySetCell(qry_selectUserCompanyList_company, "userID", ToString(Arguments.userID), 1)>
		</cfif>

		<cfset Form = Arguments>
		<cfset URL.affiliateID = 0>
		<cfset Variables.doAction = "insertAffiliate">

		<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompany" ReturnVariable="qry_selectCompany">
			<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
		</cfinvoke>

		<cfif Not IsDefined("fn_IsValidURL")>
			<cfinclude template="../../include/function/fn_IsValidURL.cfm">
		</cfif>

		<cfinclude template="../../control/c_affiliate/formParam_insertUpdateAffiliate.cfm">
		<cfinvoke component="#Application.billingMapping#data.Affiliate" method="maxlength_Affiliate" returnVariable="maxlength_Affiliate" />
		<cfinclude template="../../view/v_affiliate/lang_insertUpdateAffiliate.cfm">
		<cfinclude template="../../control/c_affiliate/formValidate_insertUpdateAffiliate.cfm">

		<cfif isAllFormFieldsOk is False>
			<cfset returnValue = -1>
			<cfset returnError = "">
			<cfloop Collection="#errorMessage_fields#" Item="field">
				<cfset returnError = ListAppend(returnError, StructFind(errorMessage_fields, field), Chr(10))>
			</cfloop>
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="insertAffiliate" ReturnVariable="newAffiliateID">
				<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
				<cfinvokeargument Name="userID" Value="#Arguments.userID#">
				<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
				<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
				<cfinvokeargument Name="affiliateCode" Value="#Arguments.affiliateCode#">
				<cfinvokeargument Name="affiliateURL" Value="#Arguments.affiliateURL#">
				<cfinvokeargument Name="affiliateName" Value="#Arguments.affiliateName#">
				<cfinvokeargument Name="affiliateStatus" Value="#Arguments.affiliateStatus#">
				<cfinvokeargument Name="affiliateID_custom" Value="#Arguments.affiliateID_custom#">
			</cfinvoke>

			<cfinvoke Component="#Application.billingMapping#data.Company" Method="updateCompany" ReturnVariable="isCompanyUpdated">
				<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
				<cfinvokeargument Name="companyIsAffiliate" Value="1">
			</cfinvoke>

			<!--- custom fields --->
			<cfif Trim(Arguments.customField) is not "">
				<cfinvoke Component="#Application.billingMapping#webservice.WebServiceFunction" Method="insertCustomFieldValues" ReturnVariable="isCustomFieldValuesInserted">
					<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
					<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
					<cfinvokeargument Name="primaryTargetKey" Value="affiliateID">
					<cfinvokeargument Name="targetID" Value="#newAffiliateID#">
					<cfinvokeargument Name="customField" Value="#Arguments.customField#">
				</cfinvoke>
			</cfif>

			<!--- custom status --->
			<cfif Arguments.statusID is not 0 or ListFind(Arguments.useCustomIDFieldList, "statusID") or ListFind(Arguments.useCustomIDFieldList, "statusID_custom")>
				<cfinvoke Component="#Application.billingMapping#webservice.WebServiceFunction" Method="insertStatusHistory" ReturnVariable="isStatusHistoryInserted">
					<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
					<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
					<cfinvokeargument Name="primaryTargetKey" Value="affiliateID">
					<cfinvokeargument Name="targetID" Value="#newAffiliateID#">
					<cfinvokeargument Name="useCustomIDFieldList" Value="#Arguments.useCustomIDFieldList#">
					<cfinvokeargument Name="statusID" Value="#Arguments.statusID#">
					<cfinvokeargument Name="statusID_custom" Value="#Arguments.statusID_custom#">
					<cfinvokeargument Name="statusHistoryComment" Value="#Arguments.statusHistoryComment#">
				</cfinvoke>
			</cfif>

			<!--- check for trigger --->
			<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
				<cfinvokeargument name="companyID" value="#qry_selectWebServiceSession.companyID#">
				<cfinvokeargument name="doAction" value="insertAffiliate">
				<cfinvokeargument name="isWebService" value="True">
				<cfinvokeargument name="doControl" value="affiliate">
				<cfinvokeargument name="primaryTargetKey" value="affiliateID">
				<cfinvokeargument name="targetID" value="#newAffiliateID#">
			</cfinvoke>

			<cfset returnValue = newAffiliateID>
		</cfif><!--- affiliate was successfully created --->
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

