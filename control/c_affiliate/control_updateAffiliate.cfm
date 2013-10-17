<cfif URL.control is not "company">
	<cfset URL.companyID = qry_selectAffiliate.companyID>
	<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompany" ReturnVariable="qry_selectCompany">
		<cfinvokeargument Name="companyID" Value="#URL.companyID#">
	</cfinvoke>
</cfif>

<cfinclude template="formParam_insertUpdateAffiliate.cfm">
<cfinvoke component="#Application.billingMapping#data.Affiliate" method="maxlength_Affiliate" returnVariable="maxlength_Affiliate" />

<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectUserCompanyList_company" ReturnVariable="qry_selectUserCompanyList_company">
	<cfinvokeargument Name="companyID" Value="#URL.companyID#">
	<cfinvokeargument Name="userCompanyStatus" Value="1">
</cfinvoke>

<!--- Determine whether custom fields and custom status apply to this object --->
<cfobject name="objInsertCustomFieldValue" component="#Application.billingMapping#control.c_customField.InsertCustomFieldValue" />
<cfobject name="objInsertStatusHistory" component="#Application.billingMapping#control.c_status.InsertStatusHistory" />

<cfinvoke component="#objInsertCustomFieldValue#" method="formParam_insertCustomFieldValue" returnVariable="isCustomFieldValueExist">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="affiliateID">
	<cfinvokeargument name="targetID_formParam" value="#URL.affiliateID#">
</cfinvoke>

<cfinvoke component="#objInsertStatusHistory#" method="formParam_insertStatusHistory" returnVariable="isStatusExist">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="affiliateID">
	<cfinvokeargument name="targetID_formParam" value="#URL.affiliateID#">
</cfinvoke>

<cfinclude template="../../view/v_affiliate/lang_insertUpdateAffiliate.cfm">
<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitAffiliate")>
	<cfinclude template="../../include/function/fn_IsValidURL.cfm">
	<cfinclude template="formValidate_insertUpdateAffiliate.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="updateAffiliate" ReturnVariable="isAffiliateUpdated">
			<cfinvokeargument Name="affiliateID" Value="#URL.affiliateID#">
			<cfinvokeargument Name="userID" Value="#Form.userID#">
			<cfinvokeargument Name="affiliateCode" Value="#Form.affiliateCode#">
			<cfinvokeargument Name="affiliateURL" Value="#Form.affiliateURL#">
			<cfinvokeargument Name="affiliateName" Value="#Form.affiliateName#">
			<cfinvokeargument Name="affiliateStatus" Value="#Form.affiliateStatus#">
			<cfinvokeargument Name="affiliateID_custom" Value="#Form.affiliateID_custom#">
		</cfinvoke>

		<!--- Update custom status and fields if necessary --->
		<cfif isCustomFieldValueExist is True>
			<cfinvoke component="#objInsertCustomFieldValue#" method="formProcess_insertCustomFieldValue" returnVariable="isCustomFieldValueProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#URL.affiliateID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<cfif isStatusExist is True>
			<cfinvoke component="#objInsertStatusHistory#" method="formProcess_insertStatusHistory" returnVariable="isStatusHistoryProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#URL.affiliateID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<!--- archive field changes --->
		<cfinvoke component="#Application.billingMapping#control.c_fieldArchive.InsertFieldArchive" method="insertFieldArchiveViaTarget" returnVariable="isArchived">
			<cfinvokeargument name="primaryTargetKey" value="affiliateID">
			<cfinvokeargument name="targetID" value="#URL.affiliateID#">
			<cfinvokeargument name="userID" value="#Session.userID#">
			<cfinvokeargument name="qry_selectTarget" value="#qry_selectAffiliate#">
		</cfinvoke>

		<!--- check for trigger --->
		<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
			<cfinvokeargument name="companyID" value="#Session.companyID#">
			<cfinvokeargument name="doAction" value="updateAffiliate">
			<cfinvokeargument name="isWebService" value="False">
			<cfinvokeargument name="doControl" value="#Variables.doControl#">
			<cfinvokeargument name="primaryTargetKey" value="affiliateID">
			<cfinvokeargument name="targetID" value="#URL.affiliateID#">
		</cfinvoke>

		<cflocation url="index.cfm?method=#URL.method#&companyID=#URL.companyID#&affiliateID=#URL.affiliateID#&confirm_affiliate=#URL.action#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = "index.cfm?method=#URL.method#&affiliateID=#URL.affiliateID##Variables.urlParameters#">
<cfset Variables.formSubmitValue = Variables.lang_insertUpdateAffiliate.formSubmitValue_update>
<cfinclude template="../../view/v_affiliate/form_insertUpdateAffiliate.cfm">
