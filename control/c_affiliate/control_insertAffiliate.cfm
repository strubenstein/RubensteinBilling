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
	<cfinvokeargument name="targetID_formParam" value="0">
</cfinvoke>

<cfinvoke component="#objInsertStatusHistory#" method="formParam_insertStatusHistory" returnVariable="isStatusExist">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="affiliateID">
	<cfinvokeargument name="targetID_formParam" value="0">
</cfinvoke>

<cfinclude template="../../view/v_affiliate/lang_insertUpdateAffiliate.cfm">
<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitAffiliate")>
	<cfinclude template="../../include/function/fn_IsValidURL.cfm">
	<cfinclude template="formValidate_insertUpdateAffiliate.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="insertAffiliate" ReturnVariable="newAffiliateID">
			<cfinvokeargument Name="companyID" Value="#URL.companyID#">
			<cfinvokeargument Name="userID" Value="#Form.userID#">
			<cfinvokeargument Name="companyID_author" Value="#Session.companyID#">
			<cfinvokeargument Name="userID_author" Value="#Session.userID#">
			<cfinvokeargument Name="affiliateCode" Value="#Form.affiliateCode#">
			<cfinvokeargument Name="affiliateURL" Value="#Form.affiliateURL#">
			<cfinvokeargument Name="affiliateName" Value="#Form.affiliateName#">
			<cfinvokeargument Name="affiliateStatus" Value="#Form.affiliateStatus#">
			<cfinvokeargument Name="affiliateID_custom" Value="#Form.affiliateID_custom#">
		</cfinvoke>

		<cfinvoke Component="#Application.billingMapping#data.Company" Method="updateCompany" ReturnVariable="isCompanyUpdated">
			<cfinvokeargument Name="companyID" Value="#URL.companyID#">
			<cfinvokeargument Name="companyIsAffiliate" Value="1">
		</cfinvoke>

		<!--- Insert custom fields and custom status if necessary --->
		<cfif isCustomFieldValueExist is True>
			<cfinvoke component="#objInsertCustomFieldValue#" method="formProcess_insertCustomFieldValue" returnVariable="isCustomFieldValueProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#newAffiliateID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<cfif isStatusExist is True>
			<cfinvoke component="#objInsertStatusHistory#" method="formProcess_insertStatusHistory" returnVariable="isStatusHistoryProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#newAffiliateID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<!--- check for trigger --->
		<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
			<cfinvokeargument name="companyID" value="#Session.companyID#">
			<cfinvokeargument name="doAction" value="insertAffiliate">
			<cfinvokeargument name="isWebService" value="False">
			<cfinvokeargument name="doControl" value="#Variables.doControl#">
			<cfinvokeargument name="primaryTargetKey" value="affiliateID">
			<cfinvokeargument name="targetID" value="#newAffiliateID#">
		</cfinvoke>

		<cflocation url="index.cfm?method=#URL.method#&companyID=#URL.companyID#&confirm_affiliate=#URL.action#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = "index.cfm?method=#URL.method#&companyID=#URL.companyID#">
<cfset Variables.formSubmitValue = Variables.lang_insertUpdateAffiliate.formSubmitValue_insert>
<cfinclude template="../../view/v_affiliate/form_insertUpdateAffiliate.cfm">
