<cfinclude template="formParam_insertAddress.cfm">
<cfinvoke component="#Application.billingMapping#data.Address" method="maxlength_Address" returnVariable="maxlength_Address" />

<cfset Variables.selectStateOption = 123>
<cfinclude template="../../view/v_address/var_stateList.cfm">
<cfinclude template="../../view/v_address/act_stateList.cfm">

<cfinclude template="../../view/v_address/var_countryList.cfm">
<cfset Variables.countryList_value = Variables.selectCountry_name_short>
<cfset Variables.countryList_label = Variables.selectCountry_name_short>

<cfinclude template="../../view/v_address/lang_insertAddress.cfm">
<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitAddress")>
	<cfinclude template="formValidate_insertAddress.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfif URL.addressID is 0>
			<cfset Variables.addressID_trend = 0>
			<cfset Variables.addressID_parent = 0>
			<cfset Variables.addressVersion = 1>
		<cfelse>
			<cfset Variables.addressID_trend = qry_selectAddress.addressID_trend>
			<cfset Variables.addressID_parent = URL.addressID>
			<cfset Variables.addressVersion = qry_selectAddress.addressVersion + 1>

			<cfinvoke Component="#Application.billingMapping#data.Address" Method="updateAddress" ReturnVariable="isAddressUpdated">
				<cfinvokeargument Name="addressID" Value="#URL.addressID#">
				<cfinvokeargument Name="addressStatus" Value="0">
			</cfinvoke>
		</cfif>

		<cfinvoke Component="#Application.billingMapping#data.Address" Method="insertAddress" ReturnVariable="newAddressID">
			<cfinvokeargument Name="companyID" Value="#URL.companyID#">
			<cfinvokeargument Name="userID" Value="#URL.userID#">
			<cfinvokeargument Name="userID_author" Value="#Session.userID#">
			<cfinvokeargument Name="addressStatus" Value="1">
			<cfinvokeargument Name="addressName" Value="#Form.addressName#">
			<cfinvokeargument Name="addressDescription" Value="#Form.addressDescription#">
			<cfinvokeargument Name="addressTypeShipping" Value="#Form.addressTypeShipping#">
			<cfinvokeargument Name="addressTypeBilling" Value="#Form.addressTypeBilling#">
			<cfinvokeargument Name="address" Value="#Form.address#">
			<cfinvokeargument Name="address2" Value="#Form.address2#">
			<cfinvokeargument Name="address3" Value="#Form.address3#">
			<cfinvokeargument Name="city" Value="#Form.city#">
			<cfinvokeargument Name="state" Value="#Form.state#">
			<cfinvokeargument Name="zipCode" Value="#Form.zipCode#">
			<cfinvokeargument Name="zipCodePlus4" Value="#Form.zipCodePlus4#">
			<cfinvokeargument Name="county" Value="#Form.county#">
			<cfinvokeargument Name="country" Value="#Form.country#">
			<cfinvokeargument Name="regionID" Value="#Form.regionID#">
			<cfinvokeargument Name="addressID_trend" Value="#Variables.addressID_trend#">
			<cfinvokeargument Name="addressID_parent" Value="#Variables.addressID_parent#">
			<cfinvokeargument Name="addressVersion" Value="#Variables.addressVersion#">
		</cfinvoke>

		<!--- check for trigger --->
		<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
			<cfinvokeargument name="companyID" value="#Session.companyID#">
			<cfinvokeargument name="isWebService" value="False">
			<cfinvokeargument name="doControl" value="#Variables.doControl#">
			<cfinvokeargument name="primaryTargetKey" value="addressID">
			<cfinvokeargument name="targetID" value="#newAddressID#">
			<cfif URL.addressID is not 0>
				<cfset Variables.doAction = "updateAddress">
			<cfelse>
				<cfset Variables.doAction = "insertAddress">
			</cfif>
		</cfinvoke>

		<cflocation url="#Variables.addressActionList#&confirm_address=#URL.action#" AddToken="No">
	</cfif>
</cfif>

<cfif URL.addressID is 0>
	<cfset Variables.formSubmitValue = Variables.lang_insertAddress.formSubmitValue_insert>
<cfelse>
	<cfset Variables.formAction = Variables.formAction & "&addressID=#URL.addressID#">
	<cfset Variables.formSubmitValue = Variables.lang_insertAddress.formSubmitValue_update>
</cfif>

<cfinclude template="../../view/v_address/form_insertAddress.cfm">
