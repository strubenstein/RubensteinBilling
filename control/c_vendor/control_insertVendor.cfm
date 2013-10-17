<cfinclude template="formParam_insertUpdateVendor.cfm">
<cfinvoke component="#Application.billingMapping#data.Vendor" method="maxlength_Vendor" returnVariable="maxlength_Vendor" />
<cfinclude template="../../view/v_vendor/lang_insertUpdateVendor.cfm">

<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectUserCompanyList_company" ReturnVariable="qry_selectUserCompanyList_company">
	<cfinvokeargument Name="companyID" Value="#URL.companyID#">
	<cfinvokeargument Name="userCompanyStatus" Value="1">
</cfinvoke>

<!--- Determine whether custom fields and custom status apply to this object --->
<cfobject name="objInsertCustomFieldValue" component="#Application.billingMapping#control.c_customField.InsertCustomFieldValue" />
<cfobject name="objInsertStatusHistory" component="#Application.billingMapping#control.c_status.InsertStatusHistory" />

<cfinvoke component="#objInsertCustomFieldValue#" method="formParam_insertCustomFieldValue" returnVariable="isCustomFieldValueExist">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="vendorID">
	<cfinvokeargument name="targetID_formParam" value="0">
</cfinvoke>

<cfinvoke component="#objInsertStatusHistory#" method="formParam_insertStatusHistory" returnVariable="isStatusExist">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="vendorID">
	<cfinvokeargument name="targetID_formParam" value="0">
</cfinvoke>

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitVendor")>
	<cfinclude template="../../include/function/fn_IsValidURL.cfm">
	<cfinclude template="formValidate_insertUpdateVendor.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="insertVendor" ReturnVariable="newVendorID">
			<cfinvokeargument Name="companyID" Value="#URL.companyID#">
			<cfinvokeargument Name="userID" Value="#Form.userID#">
			<cfinvokeargument Name="companyID_author" Value="#Session.companyID#">
			<cfinvokeargument Name="userID_author" Value="#Session.userID#">
			<cfinvokeargument Name="vendorCode" Value="#Form.vendorCode#">
			<cfinvokeargument Name="vendorDescription" Value="#Form.vendorDescription#">
			<cfinvokeargument Name="vendorDescriptionHtml" Value="#Form.vendorDescriptionHtml#">
			<cfinvokeargument Name="vendorDescriptionDisplay" Value="#Form.vendorDescriptionDisplay#">
			<cfif Form.vendorURL is Variables.default_vendorURL>
				<cfinvokeargument Name="vendorURL" Value="">
			<cfelse>
				<cfinvokeargument Name="vendorURL" Value="#Form.vendorURL#">
			</cfif>
			<cfinvokeargument Name="vendorURLdisplay" Value="#Form.vendorURLdisplay#">
			<cfinvokeargument Name="vendorName" Value="#Form.vendorName#">
			<cfinvokeargument Name="vendorImage" Value="#Form.vendorImage#">
			<cfinvokeargument Name="vendorStatus" Value="#Form.vendorStatus#">
			<cfinvokeargument Name="vendorID_custom" Value="#Form.vendorID_custom#">
		</cfinvoke>

		<cfinvoke Component="#Application.billingMapping#data.Company" Method="updateCompany" ReturnVariable="isCompanyUpdated">
			<cfinvokeargument Name="companyID" Value="#URL.companyID#">
			<cfinvokeargument Name="companyIsVendor" Value="1">
		</cfinvoke>

		<!--- Insert custom fields and custom status if necessary --->
		<cfif isCustomFieldValueExist is True>
			<cfinvoke component="#objInsertCustomFieldValue#" method="formProcess_insertCustomFieldValue" returnVariable="isCustomFieldValueProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#newVendorID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<cfif isStatusExist is True>
			<cfinvoke component="#objInsertStatusHistory#" method="formProcess_insertStatusHistory" returnVariable="isStatusHistoryProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#newVendorID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<!--- check for trigger --->
		<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
			<cfinvokeargument name="companyID" value="#Session.companyID#">
			<cfinvokeargument name="doAction" value="#Variables.doAction#">
			<cfinvokeargument name="isWebService" value="False">
			<cfinvokeargument name="doControl" value="#Variables.doControl#">
			<cfinvokeargument name="primaryTargetKey" value="vendorID">
			<cfinvokeargument name="targetID" value="#newVendorID#">
		</cfinvoke>

		<cflocation url="index.cfm?method=#URL.method#&companyID=#URL.companyID#&confirm_vendor=#URL.action#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = "index.cfm?method=#URL.method#&companyID=#URL.companyID#">
<cfset Variables.formSubmitValue = Variables.lang_insertUpdateVendor.formSubmitValue_insert>
<cfinclude template="../../view/v_vendor/form_insertUpdateVendor.cfm">
