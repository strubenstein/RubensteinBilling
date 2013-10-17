<cfset Form.stateOther = Form.state>
<cfset Form.countryOther = Form.country>

<cfset Variables.selectStateOption = 123>
<cfinclude template="../../view/v_address/var_stateList.cfm">
<cfinclude template="../../view/v_address/act_stateList.cfm">

<cfinclude template="../../view/v_address/var_countryList.cfm">
<cfset Variables.countryList_value = Variables.selectCountry_name_short>
<cfset Variables.countryList_label = Variables.selectCountry_name_short>

<cfinvoke component="#Application.billingMapping#data.Address" method="maxlength_Address" returnVariable="maxlength_Address" />
<cfinclude template="../../view/v_address/lang_insertAddress.cfm">
<cfinclude template="../../control/c_address/formValidate_insertAddress.cfm">

<cfif isAllFormFieldsOk is False>
	<cfset returnValue = -1>
	<cfset returnError = "">
	<cfloop Collection="#errorMessage_fields#" Item="field">
		<cfset returnError = ListAppend(returnError, StructFind(errorMessage_fields, field), Chr(10))>
	</cfloop>
<cfelse>
	<cfif URL.addressID is not 0>
		<cfinvoke Component="#Application.billingMapping#data.Address" Method="updateAddress" ReturnVariable="isAddressUpdated">
			<cfinvokeargument Name="addressID" Value="#Arguments.addressID#">
			<cfinvokeargument Name="addressStatus" Value="0">
		</cfinvoke>
	</cfif>

	<cfinvoke Component="#Application.billingMapping#data.Address" Method="insertAddress" ReturnVariable="newAddressID">
		<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
		<cfinvokeargument Name="userID" Value="#Arguments.userID#">
		<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
		<cfinvokeargument Name="addressStatus" Value="1">
		<cfinvokeargument Name="addressName" Value="#Arguments.addressName#">
		<cfinvokeargument Name="addressDescription" Value="#Arguments.addressDescription#">
		<cfinvokeargument Name="addressTypeShipping" Value="#Arguments.addressTypeShipping#">
		<cfinvokeargument Name="addressTypeBilling" Value="#Arguments.addressTypeBilling#">
		<cfinvokeargument Name="address" Value="#Arguments.address#">
		<cfinvokeargument Name="address2" Value="#Arguments.address2#">
		<cfinvokeargument Name="address3" Value="#Arguments.address3#">
		<cfinvokeargument Name="city" Value="#Arguments.city#">
		<cfinvokeargument Name="state" Value="#Arguments.state#">
		<cfinvokeargument Name="zipCode" Value="#Arguments.zipCode#">
		<cfinvokeargument Name="zipCodePlus4" Value="#Arguments.zipCodePlus4#">
		<cfinvokeargument Name="county" Value="#Arguments.county#">
		<cfinvokeargument Name="country" Value="#Arguments.country#">
		<cfinvokeargument Name="regionID" Value="0">
		<cfif URL.addressID is 0>
			<cfinvokeargument Name="addressID_trend" Value="0">
			<cfinvokeargument Name="addressID_parent" Value="0">
			<cfinvokeargument Name="addressVersion" Value="1">
		<cfelse>
			<cfinvokeargument Name="addressID_trend" Value="#qry_selectAddress.addressID_trend#">
			<cfinvokeargument Name="addressID_parent" Value="#Arguments.addressID#">
			<cfinvokeargument Name="addressVersion" Value="#IncrementValue(qry_selectAddress.addressVersion)#">
		</cfif>
	</cfinvoke>

	<!--- check for trigger --->
	<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
		<cfinvokeargument name="companyID" value="#qry_selectWebServiceSession.companyID#">
		<cfinvokeargument name="isWebService" value="True">
		<cfinvokeargument name="doControl" value="">
		<cfinvokeargument name="primaryTargetKey" value="addressID">
		<cfinvokeargument name="targetID" value="#newAddressID#">
		<cfif URL.addressID is not 0>
			<cfinvokeargument name="doAction" value="updateAddress">
		<cfelse>
			<cfinvokeargument name="doAction" value="insertAdress">
		</cfif>
		<cfif Arguments.userID is not 0>
			<cfinvokeargument Name="doControl" Value="user">
		<cfelse>
			<cfinvokeargument Name="doControl" Value="company">
		</cfif>
	</cfinvoke>

	<cfset returnValue = newAddressID>
</cfif><!--- /address fields are valid --->

