<cfinvoke component="#Application.billingMapping#data.Company" method="maxlength_Company" returnVariable="maxlength_Company" />
<cfinclude template="formParam_insertUpdateCompany.cfm">

<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectUserCompanyList_company" ReturnVariable="qry_selectUserCompanyList_company">
	<cfinvokeargument Name="companyID" Value="#URL.companyID#">
	<cfinvokeargument Name="userCompanyStatus" Value="1">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="selectAffiliateList" ReturnVariable="qry_selectAffiliateList">
	<cfinvokeargument Name="companyID_author" Value="#Session.companyID#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="selectCobrandList" ReturnVariable="qry_selectCobrandList">
	<cfinvokeargument Name="companyID_author" Value="#Session.companyID#">
</cfinvoke>

<!--- Determine whether custom fields and custom status apply to this object --->
<cfobject name="objInsertCustomFieldValue" component="#Application.billingMapping#control.c_customField.InsertCustomFieldValue" />
<cfobject name="objInsertStatusHistory" component="#Application.billingMapping#control.c_status.InsertStatusHistory" />

<cfinvoke component="#objInsertCustomFieldValue#" method="formParam_insertCustomFieldValue" returnVariable="isCustomFieldValueExist">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="companyID">
	<cfinvokeargument name="targetID_formParam" value="#URL.companyID#">
</cfinvoke>

<cfinvoke component="#objInsertStatusHistory#" method="formParam_insertStatusHistory" returnVariable="isStatusExist">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="companyID">
	<cfinvokeargument name="targetID_formParam" value="#URL.companyID#">
</cfinvoke>

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitInsertUpdateCompany")>
	<cfinclude template="../../include/function/fn_IsValidURL.cfm">
	<cfinclude template="../../view/v_company/lang_insertUpdateCompany.cfm">
	<cfinclude template="formValidate_insertUpdateCompany.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Company" Method="updateCompany" ReturnVariable="isCompanyUpdated">
			<cfinvokeargument Name="companyID" Value="#URL.companyID#">
			<cfif Form.userID is not "" and Form.userID is not 0>
				<cfinvokeargument Name="userID" Value="#Form.userID#">
			</cfif>
			<cfinvokeargument Name="companyName" Value="#Form.companyName#">
			<cfinvokeargument Name="companyDBA" Value="#Form.companyDBA#">
			<cfinvokeargument Name="companyURL" Value="#Form.companyURL#">
			<cfinvokeargument Name="companyStatus" Value="#Form.companyStatus#">
			<cfinvokeargument Name="companyID_custom" Value="#Form.companyID_custom#">
			<cfinvokeargument Name="companyIsTaxExempt" Value="#Form.companyIsTaxExempt#">
			<cfinvokeargument Name="affiliateID" Value="#Form.affiliateID#">
			<cfinvokeargument Name="cobrandID" Value="#Form.cobrandID#">
			<cfinvokeargument Name="companyIsCustomer" Value="#Form.companyIsCustomer#">
		</cfinvoke>

		<!--- Update custom fields and status if necessary --->
		<cfif isCustomFieldValueExist is True>
			<cfinvoke component="#objInsertCustomFieldValue#" method="formProcess_insertCustomFieldValue" returnVariable="isCustomFieldValueProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#URL.companyID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<cfif isStatusExist is True>
			<cfinvoke component="#objInsertStatusHistory#" method="formProcess_insertStatusHistory" returnVariable="isStatusHistoryProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#URL.companyID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<!--- archive field changes --->
		<cfinvoke component="#Application.billingMapping#control.c_fieldArchive.InsertFieldArchive" method="insertFieldArchiveViaTarget" returnVariable="isArchived">
			<cfinvokeargument name="primaryTargetKey" value="companyID">
			<cfinvokeargument name="targetID" value="#URL.companyID#">
			<cfinvokeargument name="userID" value="#Session.userID#">
			<cfinvokeargument name="qry_selectTarget" value="#qry_selectCompany#">
		</cfinvoke>

		<!--- check for trigger --->
		<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
			<cfinvokeargument name="companyID" value="#Session.companyID#">
			<cfinvokeargument name="doAction" value="updateCompany">
			<cfinvokeargument name="isWebService" value="False">
			<cfinvokeargument name="doControl" value="#Variables.doControl#">
			<cfinvokeargument name="primaryTargetKey" value="companyID">
			<cfinvokeargument name="targetID" value="#URL.companyID#">
		</cfinvoke>

		<cflocation url="#formAction#&confirm_company=#URL.action#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formSubmitValue = "Update Company">
<cfinclude template="../../view/v_company/form_insertUpdateCompany.cfm">
