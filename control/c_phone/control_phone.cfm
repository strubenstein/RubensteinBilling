<cfparam Name="URL.phoneID" Default="0">
<cfparam Name="URL.companyID" Default="0">
<cfparam Name="URL.userID" Default="0">

<cfset Variables.formAction = "index.cfm?method=#URL.control#.#URL.action#">
<cfif URL.control is "company" and URL.companyID is not 0>
	<cfset Variables.formAction = Variables.formAction & "&companyID=#URL.companyID#">
</cfif>
<cfif ListFind("user,company", URL.control) and URL.userID is not 0>
	<cfset Variables.formAction = Variables.formAction & "&userID=#URL.userID#">
</cfif>
<cfset Variables.phoneActionList = Replace(Variables.formAction, URL.action, "listPhones", "ONE")>

<cfinclude template="security_phone.cfm">
<cfinclude template="../../view/v_phone/nav_phone.cfm">
<cfif IsDefined("URL.confirm_phone")>
	<cfinclude template="../../view/v_phone/confirm_phone.cfm">
</cfif>
<cfif IsDefined("URL.error_phone")>
	<cfinclude template="../../view/v_phone/error_phone.cfm">
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="listPhones,listPhonesAll">
	<cfinclude template="control_listPhones.cfm">
</cfcase>

<cfcase value="insertPhone">
	<cfinclude template="control_insertPhone.cfm">
</cfcase>

<cfcase value="updatePhoneStatus0,updatePhoneStatus1">
	<cfinvoke Component="#Application.billingMapping#data.Phone" Method="updatePhone" ReturnVariable="isPhoneUpdated">
		<cfinvokeargument Name="phoneID" Value="#URL.phoneID#">
		<cfinvokeargument Name="phoneStatus" Value="#Right(Variables.doAction, 1)#">
	</cfinvoke>

	<cflocation url="index.cfm?method=#URL.control#.listPhones&companyID=#URL.companyID#&userID=#URL.userID#&confirm_phone=#Variables.doAction#" AddToken="No">
</cfcase>

<cfdefaultcase>
	<cfset URL.error_phone = "invalidAction">
	<cfinclude template="../../view/v_phone/error_phone.cfm">
</cfdefaultcase>
</cfswitch>
