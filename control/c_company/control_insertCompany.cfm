<cfset URL.companyID = 0>
<cfinvoke component="#Application.billingMapping#data.Company" method="maxlength_Company" returnVariable="maxlength_Company" />
<cfinclude template="formParam_insertUpdateCompany.cfm">

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
	<cfinvokeargument name="targetID_formParam" value="0">
</cfinvoke>

<cfinvoke component="#objInsertStatusHistory#" method="formParam_insertStatusHistory" returnVariable="isStatusExist">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="companyID">
	<cfinvokeargument name="targetID_formParam" value="0">
</cfinvoke>

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitInsertUpdateCompany")>
	<cfif Session.companyID is Application.billingSuperuserCompanyID and Application.billingSuperuserEnabled is True
			and IsDefined("Form.companyPrimary") and Form.companyPrimary is 1>
		<cfset Form.companyPrimary = 1>
	<cfelse>
		<cfset Form.companyPrimary = 0>
	</cfif>

	<cfinclude template="../../include/function/fn_IsValidURL.cfm">
	<cfinclude template="../../view/v_company/lang_insertUpdateCompany.cfm">
	<cfinclude template="formValidate_insertUpdateCompany.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Company" Method="insertCompany" ReturnVariable="newCompanyID">
			<cfinvokeargument Name="userID" Value="0">
			<cfinvokeargument Name="companyName" Value="#Form.companyName#">
			<cfinvokeargument Name="companyDBA" Value="#Form.companyDBA#">
			<cfinvokeargument Name="companyURL" Value="#Form.companyURL#">
			<cfinvokeargument Name="companyStatus" Value="#Form.companyStatus#">
			<cfinvokeargument Name="companyID_custom" Value="#Form.companyID_custom#">
			<cfinvokeargument Name="languageID" Value="">
			<cfinvokeargument Name="companyPrimary" Value="#Form.companyPrimary#">
			<cfinvokeargument Name="affiliateID" Value="#Form.affiliateID#">
			<cfinvokeargument Name="cobrandID" Value="#Form.cobrandID#">
			<cfinvokeargument Name="companyID_parent" Value="0">
			<cfinvokeargument Name="companyID_author" Value="#Session.companyID#">
			<cfinvokeargument Name="userID_author" Value="#Session.userID#">
			<cfinvokeargument Name="companyIsAffiliate" Value="#Form.companyIsAffiliate#">
			<cfinvokeargument Name="companyIsCobrand" Value="#Form.companyIsCobrand#">
			<cfinvokeargument Name="companyIsVendor" Value="#Form.companyIsVendor#">
			<cfinvokeargument Name="companyIsCustomer" Value="#Form.companyIsCustomer#">
			<cfinvokeargument Name="companyIsTaxExempt" Value="#Form.companyIsTaxExempt#">
			<cfif Form.companyPrimary is 1 and IsDefined("Form.companyDirectory")>
				<cfinvokeargument Name="companyDirectory" Value="#Form.companyDirectory#">
			</cfif>
		</cfinvoke>

		<cfif Form.companyPrimary is 1>
			<cfset Variables.companyID_author = newCompanyID>
		<cfelse>
			<cfset Variables.companyID_author = Session.companyID>
		</cfif>

		<!--- Insert custom fields and custom status if necessary --->
		<cfif isCustomFieldValueExist is True>
			<cfinvoke component="#objInsertCustomFieldValue#" method="formProcess_insertCustomFieldValue" returnVariable="isCustomFieldValueProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#newCompanyID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<cfif isStatusExist is True>
			<cfinvoke component="#objInsertStatusHistory#" method="formProcess_insertStatusHistory" returnVariable="isStatusHistoryProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#newCompanyID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<cfset companyTypeList = "">
		<cfif Form.companyIsAffiliate is 1>
			<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="insertAffiliate" ReturnVariable="newAffiliateID">
				<cfinvokeargument Name="companyID" Value="#newCompanyID#">
				<cfinvokeargument Name="userID" Value="0">
				<cfinvokeargument Name="userID_author" Value="#Session.userID#">
				<cfinvokeargument Name="companyID_author" Value="#Variables.companyID_author#">
				<cfinvokeargument Name="affiliateCode" Value="">
				<cfinvokeargument Name="affiliateName" Value="#Form.companyName#">
				<cfinvokeargument Name="affiliateURL" Value="">
				<cfinvokeargument Name="affiliateStatus" Value="1">
				<cfinvokeargument Name="affiliateID_custom" Value="">
				<cfinvokeargument Name="addressID_billing" Value="0">
				<cfinvokeargument Name="addressID_shipping" Value="0">
			</cfinvoke>
		</cfif>

		<cfif Form.companyIsCobrand is 1>
			<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="insertCobrand" ReturnVariable="newCobrandID">
				<cfinvokeargument Name="companyID" Value="#newCompanyID#">
				<cfinvokeargument Name="userID" Value="0">
				<cfinvokeargument Name="userID_author" Value="#Session.userID#">
				<cfinvokeargument Name="companyID_author" Value="#Variables.companyID_author#">
				<cfinvokeargument Name="cobrandName" Value="#Form.companyName#">
				<cfinvokeargument Name="cobrandCode" Value="">
				<cfinvokeargument Name="cobrandURL" Value="">
				<cfinvokeargument Name="cobrandStatus" Value="1">
				<cfinvokeargument Name="cobrandImage" Value="">
				<cfinvokeargument Name="cobrandTitle" Value="#Form.companyName#">
				<cfinvokeargument Name="cobrandDomain" Value="">
				<cfinvokeargument Name="cobrandDirectory" Value="">
				<cfinvokeargument Name="cobrandID_custom" Value="">
			</cfinvoke>
		</cfif>

		<cfif Form.companyIsVendor is 1>
			<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="insertVendor" ReturnVariable="newVendorID">
				<cfinvokeargument Name="companyID" Value="#newCompanyID#">
				<cfinvokeargument Name="userID" Value="0">
				<cfinvokeargument Name="companyID_author" Value="#Variables.companyID_author#">
				<cfinvokeargument Name="userID_author" Value="#Session.userID#">
				<cfinvokeargument Name="vendorCode" Value="">
				<cfinvokeargument Name="vendorDescription" Value="">
				<cfinvokeargument Name="vendorDescriptionHtml" Value="0">
				<cfinvokeargument Name="vendorDescriptionDisplay" Value="0">
				<cfinvokeargument Name="vendorURL" Value="">
				<cfinvokeargument Name="vendorURLdisplay" Value="0">
				<cfinvokeargument Name="vendorName" Value="#Form.companyName#">
				<cfinvokeargument Name="vendorImage" Value="">
				<cfinvokeargument Name="vendorStatus" Value="1">
				<cfinvokeargument Name="vendorID_custom" Value="">
			</cfinvoke>
		</cfif>

		<!--- check for trigger --->
		<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
			<cfinvokeargument name="companyID" value="#Session.companyID#">
			<cfinvokeargument name="doAction" value="insertCompany">
			<cfinvokeargument name="isWebService" value="False">
			<cfinvokeargument name="doControl" value="#Variables.doControl#">
			<cfinvokeargument name="primaryTargetKey" value="companyID">
			<cfinvokeargument name="targetID" value="#newCompanyID#">
		</cfinvoke>

		<cflocation url="index.cfm?method=company.viewCompany&confirm_company=#URL.action#&companyID=#newCompanyID#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formSubmitValue = "Create Company">
<cfinclude template="../../view/v_company/form_insertUpdateCompany.cfm">
