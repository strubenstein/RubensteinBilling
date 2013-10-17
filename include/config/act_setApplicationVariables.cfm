<!--- set application-level variables if necessary --->
<cfif Not StructKeyExists(Application, "billingUrl") or Not StructKeyExists(Application, "objCompany") or IsDefined("URL.resetApplicationVariables")>
	<cfinclude template="var_applicationVariables.cfm">
	<cfinclude template="act_setConfigVariables.cfm">
</cfif>
<cfif Not StructKeyExists(Application, "fn_GetPrimaryTargetID") or IsDefined("URL.resetApplicationVariables")>
	<cfif IsDefined("URL.resetPrimaryTarget")>
		<cfinvoke component="#Application.billingMapping#control.c_primaryTarget.GeneratePrimaryTargetSwitch" method="generatePrimaryTargetSwitch" returnVariable="isSwitchGenerated" />
	</cfif>
	<cfinclude template="fn_GetPrimaryTargetID.cfm">
</cfif>
<cfif Not StructKeyExists(Application, "fn_IsInteger") or IsDefined("URL.resetApplicationVariables")>
	<cfinclude template="../function/fn_numeric.cfm">
</cfif>
<cfif Not StructKeyExists(Application, "fn_EncryptString") or IsDefined("URL.resetApplicationVariables")>
	<cfinclude template="../function/fn_crypt.cfm">
</cfif>
<cfif Not StructKeyExists(Application, "fn_setDecimalPrecision") or IsDefined("URL.resetApplicationVariables")>
	<cfinclude template="../function/fn_numberFormat.cfm">
</cfif>
<cfif Not StructKeyExists(Application, "permissionStruct") or IsDefined("URL.resetApplicationVariables")>
	<cfinclude template="../security/act_applicationPermissionStruct.cfm">
</cfif>
<cfif Not StructKeyExists(Application, "fn_IsUserAuthorized") or IsDefined("URL.resetApplicationVariables")>
	<cfinclude template="../security/fn_IsUserAuthorized.cfm">
</cfif>

<!--- for development version, display debug output --->
<cfif StructKeyExists(Application, "billingShowDebugOutput") and Application.billingShowDebugOutput is True>
	<cfsetting EnableCFoutputOnly="Yes" ShowDebugOutput="Yes">
<cfelse>
	<cfsetting EnableCFoutputOnly="Yes" ShowDebugOutput="No">
</cfif>
<!--- 
fn_creditCard.cfm
? fn_datetime.cfm
fn_DisplayOrderByNav.cfm
fn_DisplayPrice.cfm
fn_IPaddress.cfm
fn_IsValidEmail.cfm
fn_IsValidURL.cfm
fn_listObjects.cfm
--->
