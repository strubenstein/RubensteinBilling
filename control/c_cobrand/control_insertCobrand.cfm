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
	<cfinvokeargument name="targetID_formParam" value="0">
</cfinvoke>

<cfinvoke component="#objInsertStatusHistory#" method="formParam_insertStatusHistory" returnVariable="isStatusExist">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="cobrandID">
	<cfinvokeargument name="targetID_formParam" value="0">
</cfinvoke>

<cfinclude template="../../view/v_cobrand/lang_insertUpdateCobrand.cfm">
<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitCobrand")>
	<cfinclude template="formValidate_insertUpdateCobrand.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="insertCobrand" ReturnVariable="newCobrandID">
			<cfinvokeargument Name="companyID" Value="#URL.companyID#">
			<cfinvokeargument Name="userID" Value="#Form.userID#">
			<cfinvokeargument Name="companyID_author" Value="#Session.companyID#">
			<cfinvokeargument Name="userID_author" Value="#Session.userID#">
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

		<cfif isImageUploaded is True>
			<cfset moveImage = ListLast(Form.cobrandImage, "/")>
			<cfset moveSourceDir = Application.billingFilePath & Application.billingFilePathSlash & "images" & Application.billingFilePathSlash & "img_cobrand">
			<cfset moveDestinationDir = Application.billingFilePath & Application.billingFilePathSlash & Application.billingPartnerDirectory & Application.billingFilePathSlash & "p" & newCobrandID>
			<cfset Form.cobrandImage = "#Application.billingUrl#/#Application.billingPartnerDirectory#/p#newCobrandID#/#moveImage#">

			<cfif Not DirectoryExists(moveDestinationDir)>
				<cfdirectory action="create" mode="777" directory="#moveDestinationDir#">
			</cfif>

			<cffile action="Move" source="#moveSourceDir##Application.billingFilePathSlash##moveImage#" destination="#moveDestinationDir##Application.billingFilePathSlash##moveImage#">
			<cfinvoke component="#Application.billingMapping#data.Cobrand" method="updateCobrand" returnVariable="isCobrandUpdated">
				<cfinvokeargument name="cobrandID" value="#newCobrandID#">
				<cfinvokeargument Name="cobrandImage" Value="#Form.cobrandImage#">
			</cfinvoke>
		</cfif>

		<cfinvoke Component="#Application.billingMapping#data.Company" Method="updateCompany" ReturnVariable="isCompanyUpdated">
			<cfinvokeargument Name="companyID" Value="#URL.companyID#">
			<cfinvokeargument Name="companyIsCobrand" Value="1">
		</cfinvoke>

		<!--- Insert custom fields and custom status if necessary --->
		<cfif isCustomFieldValueExist is True>
			<cfinvoke component="#objInsertCustomFieldValue#" method="formProcess_insertCustomFieldValue" returnVariable="isCustomFieldValueProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#newCobrandID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<cfif isStatusExist is True>
			<cfinvoke component="#objInsertStatusHistory#" method="formProcess_insertStatusHistory" returnVariable="isStatusHistoryProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#newCobrandID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<!--- write default header and footer files --->

		<!--- check for trigger --->
		<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
			<cfinvokeargument name="companyID" value="#Session.companyID#">
			<cfinvokeargument name="doAction" value="insertCobrand">
			<cfinvokeargument name="isWebService" value="False">
			<cfinvokeargument name="doControl" value="#Variables.doControl#">
			<cfinvokeargument name="primaryTargetKey" value="cobrandID">
			<cfinvokeargument name="targetID" value="#newCobrandID#">
		</cfinvoke>

		<cflocation url="index.cfm?method=#URL.method#&companyID=#URL.companyID#&confirm_cobrand=#URL.action#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = "index.cfm?method=#URL.method#&companyID=#URL.companyID#">
<cfset Variables.formSubmitValue = Variables.lang_insertUpdateCobrand.formSubmitValue_insert>
<cfinclude template="../../view/v_cobrand/form_insertUpdateCobrand.cfm">
