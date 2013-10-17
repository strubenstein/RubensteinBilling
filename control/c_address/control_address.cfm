<!--- 
Select address:
	affiliate
	cobrand
	vendor?
update above addressID if updated
--->

<cfparam Name="URL.addressID" Default="0">
<cfparam Name="URL.companyID" Default="0">
<cfparam Name="URL.userID" Default="0">

<cfset Variables.formAction = "index.cfm?method=#URL.control#.#URL.action#">
<cfif URL.control is "company" and URL.companyID is not 0>
	<cfset Variables.formAction = Variables.formAction & "&companyID=#URL.companyID#">
</cfif>
<cfif ListFind("user,company", URL.control) and URL.userID is not 0>
	<cfset Variables.formAction = Variables.formAction & "&userID=#URL.userID#">
</cfif>
<cfset Variables.addressActionList = Replace(Variables.formAction, URL.action, "listAddresses", "ONE")>

<cfinclude template="security_address.cfm">
<cfinclude template="../../view/v_address/nav_address.cfm">
<cfif IsDefined("URL.confirm_address")>
	<cfinclude template="../../view/v_address/confirm_address.cfm">
</cfif>
<cfif IsDefined("URL.error_address")>
	<cfinclude template="../../view/v_address/error_address.cfm">
</cfif>

<cfset Variables.redirectURL = "index.cfm?method=#URL.control#.listAddresses&companyID=#URL.companyID#&userID=#URL.userID#">

<cfswitch expression="#Variables.doAction#">
<cfcase value="listAddresses,listAddressesAll">
	<cfinclude template="control_listAddresses.cfm">
</cfcase>

<cfcase value="viewAddress">
	<cfinclude template="../../view/v_address/dsp_selectAddress.cfm">
</cfcase>

<cfcase value="insertAddress">
	<cfinclude template="control_insertAddress.cfm">
</cfcase>

<cfcase value="updateAddressStatus0,updateAddressStatus1">
	<cfinvoke Component="#Application.billingMapping#data.Address" Method="updateAddress" ReturnVariable="isAddressUpdated">
		<cfinvokeargument Name="addressID" Value="#URL.addressID#">
		<cfinvokeargument Name="addressStatus" Value="#Right(Variables.doAction, 1)#">
	</cfinvoke>

	<cflocation url="#Variables.redirectURL#&confirm_address=#Variables.doAction#" AddToken="No">
</cfcase>

<cfcase value="updateAddressTypeBilling0,updateAddressTypeBilling1">
	<cfinvoke Component="#Application.billingMapping#data.Address" Method="updateAddress" ReturnVariable="isAddressUpdated">
		<cfinvokeargument Name="addressID" Value="#URL.addressID#">
		<cfinvokeargument Name="addressTypeBilling" Value="#Right(Variables.doAction, 1)#">
	</cfinvoke>

	<cflocation url="#Variables.redirectURL#&confirm_address=#Variables.doAction#" AddToken="No">
</cfcase>

<cfcase value="updateAddressTypeShipping0,updateAddressTypeShipping1">
	<cfinvoke Component="#Application.billingMapping#data.Address" Method="updateAddress" ReturnVariable="isAddressUpdated">
		<cfinvokeargument Name="addressID" Value="#URL.addressID#">
		<cfinvokeargument Name="addressTypeShipping" Value="#Right(Variables.doAction, 1)#">
	</cfinvoke>

	<cflocation url="#Variables.redirectURL#&confirm_address=#Variables.doAction#" AddToken="No">
</cfcase>

<cfdefaultcase>
	<cfset URL.error_address = "invalidAction">
	<cfinclude template="../../view/v_address/error_address.cfm">
</cfdefaultcase>
</cfswitch>
