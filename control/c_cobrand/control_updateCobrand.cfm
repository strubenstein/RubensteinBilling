<cfif URL.control is not "company">
	<cfset URL.companyID = qry_selectCobrand.companyID>
	<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompany" ReturnVariable="qry_selectCompany">
		<cfinvokeargument Name="companyID" Value="#URL.companyID#">
	</cfinvoke>
</cfif>

<cfinclude template="formParam_insertUpdateCobrand.cfm">
<cfinvoke component="#Application.billingMapping#data.Cobrand" method="maxlength_Cobrand" returnVariable="maxlength_Cobrand" />
<cfinclude template="../../include/function/fn_IsValidURL.cfm">
<cfinclude template="../../include/function/fn_GetDomainFromURL.cfm">

<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectUserCompanyList_company" ReturnVariable="qry_selectUserCompanyList_company">
	<cfinvokeargument Name="companyID" Value="#URL.companyID#">
	<cfinvokeargument Name="userCompanyStatus" Value="1">
</cfinvoke>

<!--- Determine whether custom fields and custom status apply to this object --->
<cfobject name="objInsertCustomFieldValue" component="#Application.billingMapping#control.c_customField.InsertCustomFieldValue" />
<cfobject name="objInsertStatusHistory" component="#Application.billingMapping#control.c_status.InsertStatusHistory" />

<cfinvoke component="#objInsertCustomFieldValue#" method="formParam_insertCustomFieldValue" returnVariable="isCustomFieldValueExist">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="cobrandID">
	<cfinvokeargument name="targetID_formParam" value="#URL.cobrandID#">
</cfinvoke>

<cfinvoke component="#objInsertStatusHistory#" method="formParam_insertStatusHistory" returnVariable="isStatusExist">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="cobrandID">
	<cfinvokeargument name="targetID_formParam" value="#URL.cobrandID#">
</cfinvoke>

<cfinclude template="../../view/v_cobrand/lang_insertUpdateCobrand.cfm">
<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitCobrand")>
	<cfinclude template="formValidate_insertUpdateCobrand.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="updateCobrand" ReturnVariable="isCobrandUpdated">
			<cfinvokeargument Name="cobrandID" Value="#URL.cobrandID#">
			<cfinvokeargument Name="userID" Value="#Form.userID#">
			<cfinvokeargument Name="cobrandCode" Value="#Form.cobrandCode#">
			<cfinvokeargument Name="cobrandTitle" Value="#Form.cobrandTitle#">
			<cfinvokeargument Name="cobrandDomain" Value="#Form.cobrandDomain#">
			<cfinvokeargument Name="cobrandDirectory" Value="#Form.cobrandDirectory#">
			<cfinvokeargument Name="cobrandURL" Value="#Form.cobrandURL#">
			<cfinvokeargument Name="cobrandName" Value="#Form.cobrandName#">
			<cfinvokeargument Name="cobrandImage" Value="#Form.cobrandImage#">
			<cfinvokeargument Name="cobrandStatus" Value="#Form.cobrandStatus#">
			<cfinvokeargument Name="cobrandID_custom" Value="#Form.cobrandID_custom#">
		</cfinvoke>

		<!--- Update custom fields if necessary --->
		<cfif isCustomFieldValueExist is True>
			<cfinvoke component="#objInsertCustomFieldValue#" method="formProcess_insertCustomFieldValue" returnVariable="isCustomFieldValueProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#URL.cobrandID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<cfif isStatusExist is True>
			<cfinvoke component="#objInsertStatusHistory#" method="formProcess_insertStatusHistory" returnVariable="isStatusHistoryProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#URL.cobrandID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<!--- archive field changes --->
		<cfinvoke component="#Application.billingMapping#control.c_fieldArchive.InsertFieldArchive" method="insertFieldArchiveViaTarget" returnVariable="isArchived">
			<cfinvokeargument name="primaryTargetKey" value="cobrandID">
			<cfinvokeargument name="targetID" value="#URL.cobrandID#">
			<cfinvokeargument name="userID" value="#Session.userID#">
			<cfinvokeargument name="qry_selectTarget" value="#qry_selectCobrand#">
		</cfinvoke>

		<!--- check for trigger --->
		<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
			<cfinvokeargument name="companyID" value="#Session.companyID#">
			<cfinvokeargument name="doAction" value="updateCobrand">
			<cfinvokeargument name="isWebService" value="False">
			<cfinvokeargument name="doControl" value="#Variables.doControl#">
			<cfinvokeargument name="primaryTargetKey" value="cobrandID">
			<cfinvokeargument name="targetID" value="#URL.cobrandID#">
		</cfinvoke>

		<cflocation url="index.cfm?method=#URL.method#&companyID=#URL.companyID#&cobrandID=#URL.cobrandID#&confirm_cobrand=#URL.action#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = "index.cfm?method=#URL.method#&cobrandID=#URL.cobrandID##Variables.urlParameters#">
<cfset Variables.formSubmitValue = Variables.lang_insertUpdateCobrand.formSubmitValue_update>
<cfinclude template="../../view/v_cobrand/form_insertUpdateCobrand.cfm">
