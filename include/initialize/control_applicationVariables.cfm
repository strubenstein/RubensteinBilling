<cfinclude template="../function/fn_IsValidEmail.cfm">
<cfinclude template="../function/fn_IsValidURL.cfm">

<cfinclude template="formParam_applicationVariables.cfm">
<cfset errorMessage_fields = StructNew()>
<cfset isAllFormFieldsOk = False>

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitApplicationVariables")>
	<cfinclude template="lang_applicationVariables.cfm">
	<cfinclude template="formValidate_applicationVariables.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfset Variables.varFilePath = Form.billingFilePath & Form.billingFilePathSlash & "include" & Form.billingFilePathSlash & "config" & Form.billingFilePathSlash & "var_applicationVariables.cfm">
		<cfset Variables.companyDirectory = "">

		<cfinvoke component="#Form.billingMapping#.data.Company" method="maxlength_Company" returnVariable="maxlength_Company" />
		<cfset billingSql = StructNew()>

		<cfswitch expression="#Form.billingDatabase#">
		<cfcase value="MySQL"><cfinclude template="../config/var_mysql.cfm"></cfcase>
		<cfcase value="Oracle"><cfinclude template="../config/var_oracle.cfm"></cfcase>
		<cfcase value="DB2"><cfinclude template="../config/var_db2.cfm"></cfcase>
		<cfdefaultcase><!--- MSSQLServer ---><cfinclude template="../config/var_mssql.cfm"></cfdefaultcase>
		</cfswitch>

		<cftransaction>
		<cfquery Name="qry_insertCompany" Datasource="#Form.billingDsn#" Username="#Form.billingDsnUsername#" Password="#Form.billingDsnPassword#">
			INSERT INTO avCompany
			(
				<cfif billingSql.identityField_field is True>companyID,</cfif>
				userID, companyName, companyDBA, companyURL, languageID, companyPrimary, companyStatus,
				affiliateID, cobrandID, companyID_custom, companyID_parent, companyID_author, companyIsAffiliate,
				companyIsCobrand, companyIsVendor, companyIsCustomer, companyIsTaxExempt, companyDirectory,
				companyDateCreated, companyDateUpdated
			)
			VALUES
			(
				<cfif billingSql.identityField_field is True>#Replace(billingSql.identityField_value, "primaryKeyField", "companyID", "ALL")#,</cfif>
				<cfqueryparam Value="0" cfsqltype="cf_sql_integer">,
				<cfqueryparam Value="" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Company.companyName#">,
				<cfqueryparam Value="" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Company.companyDBA#">,
				<cfqueryparam Value="" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Company.companyURL#">,
				<cfqueryparam Value="" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Company.languageID#">,
				<cfqueryparam Value="1" cfsqltype="#billingSql.cfSqlType_bit#">,
				<cfqueryparam Value="1" cfsqltype="#billingSql.cfSqlType_bit#">,
				<cfqueryparam Value="0" cfsqltype="cf_sql_integer">,
				<cfqueryparam Value="0" cfsqltype="cf_sql_integer">,
				<cfqueryparam Value="" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Company.companyID_custom#">,
				<cfqueryparam Value="0" cfsqltype="cf_sql_integer">,
				<cfqueryparam Value="0" cfsqltype="cf_sql_integer">,
				<cfqueryparam Value="0" cfsqltype="#billingSql.cfSqlType_bit#">,
				<cfqueryparam Value="0" cfsqltype="#billingSql.cfSqlType_bit#">,
				<cfqueryparam Value="0" cfsqltype="#billingSql.cfSqlType_bit#">,
				<cfqueryparam Value="0" cfsqltype="#billingSql.cfSqlType_bit#">,
				<cfqueryparam Value="0" cfsqltype="#billingSql.cfSqlType_bit#">,
				<cfqueryparam Value="#Variables.companyDirectory#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Company.companyDirectory#">,
				#billingSql.sql_nowDateTime#,
				#billingSql.sql_nowDateTime#
			);

			#Replace(billingSql.identityField_select, "primaryKeyField", "companyID", "ALL")#;
		</cfquery>

		<cfset Variables.companyID = qry_insertCompany.primaryKeyID>
		<cfquery Name="qry_updateCompanyID_author" Datasource="#Form.billingDsn#" Username="#Form.billingDsnUsername#" Password="#Form.billingDsnPassword#">
			UPDATE avCompany
			SET companyID_author = companyID
			WHERE companyID = <cfqueryparam Value="#Variables.companyID#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cffile Action="Write" File="#Variables.varFilePath#" Output="
<cflock Scope=""Application"" Timeout=""10"">
	<cfset Application.billingSiteTitle = ""#Form.billingSiteTitle#"">
	<cfset Application.billingDsn = ""#Form.billingDsn#"">
	<cfset Application.billingDsnUsername = ""#Form.billingDsnUsername#"">
	<cfset Application.billingDsnPassword = ""#Form.billingDsnPassword#"">
	<cfset Application.billingFilePath = ""#Form.billingFilePath#"">
	<cfset Application.billingTempPath = ""#Form.billingTempPath#"">

	<cfset Application.billingUrl = ""#Form.billingUrl#"">
	<cfset Application.billingSecureUrl = ""#Form.billingSecureUrl#"">
	<cfset Application.billingEncryptionCode = ""#Form.billingEncryptionCode#"">
	<cfset Application.billingUrlroot = ""#Form.billingUrlroot#"">
	<cfset Application.billingMapping = ""#Form.billingMapping#."">
	<cfset Application.billingFilePathSlash = ""#Form.billingFilePathSlash#"">
	<cfset Application.billingDatabase = ""#Form.billingDatabase#"">
	<cfset Application.billingCFversion = ""#Form.billingCFversion#"">

	<cfset Application.billingErrorEmail = ""#Form.billingErrorEmail#"">
	<cfset Application.billingErrorReplyTo = ""#Form.billingErrorReplyTo#"">
	<cfset Application.billingErrorSubject = ""#Form.billingErrorSubject#"">
	<cfset Application.billingErrorFrom = ""#Form.billingErrorFrom#"">
	<cfset Application.billingEmailUsername = ""#Form.billingEmailUsername#"">
	<cfset Application.billingEmailPassword = ""#Form.billingEmailPassword#"">

	<cfset Application.billingCustomerDirectory = ""c"">
	<cfset Application.billingCustomerImageDirectory = ""images"">
	<cfset Application.billingPartnerDirectory = ""p"">
	<cfset Application.billingQueryCacheTimeSpan = CreateTimeSpan(0,0,0,5)>
	<cfset Application.billingSuperuserCompanyID = #Variables.companyID#>
	<cfset Application.billingSuperuserCompanyDirectory = ""#Variables.companyDirectory#"">
	<cfset Application.billingSuperuserEnabled = False>
	<cfset Application.billingShowDebugOutput = False>
	<cfset Application.billingTrackLoginSessions = #Form.billingTrackLoginSessions#>
</cflock>
">

		<cfoutput>
		<p class="ConfirmationMessage">Application variables saved. Step 1 successfully completed.<br>Continue to Step 2 to insert the permissions.</p>
		<form method="get" action="initialize.cfm">
		<input type="hidden" name="step" value="2">
		<input type="hidden" name="resetApplicationVariables" value="2">
		<input type="submit" value="Continue to Step 2">
		</form>
		</cfoutput>
	</cfif>
</cfif>

<cfif isAllFormFieldsOk is False>
	<cfinclude template="form_applicationVariables.cfm">
</cfif>
