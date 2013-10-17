<cfset Variables.doAction = "insertPhone">
<cfset URL.phoneID = 0>

<cfinvoke component="#Application.billingMapping#data.Phone" method="maxlength_Phone" returnVariable="maxlength_Phone" />
<cfinclude template="../../view/v_phone/var_phoneTypeList.cfm">
<cfinclude template="../../view/v_phone/lang_insertPhone.cfm">
<cfinclude template="../../control/c_phone/formValidate_insertPhone.cfm">

<cfif isAllFormFieldsOk is False>
	<cfset returnValue = -1>
	<cfset returnError = "">
	<cfloop Collection="#errorMessage_fields#" Item="field">
		<cfset returnError = ListAppend(returnError, StructFind(errorMessage_fields, field), Chr(10))>
	</cfloop>
<cfelse>
	<cfif URL.phoneID is not 0>
		<cfinvoke Component="#Application.billingMapping#data.Phone" Method="updatePhone" ReturnVariable="isPhoneUpdated">
			<cfinvokeargument Name="phoneID" Value="#URL.phoneID#">
			<cfinvokeargument Name="phoneStatus" Value="0">
		</cfinvoke>
	</cfif>

	<cfinvoke Component="#Application.billingMapping#data.Phone" Method="insertPhone" ReturnVariable="newPhoneID">
		<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
		<cfinvokeargument Name="userID" Value="#Arguments.userID#">
		<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
		<cfinvokeargument Name="phoneStatus" Value="1">
		<cfif URL.phoneID is 0>
			<cfinvokeargument Name="phoneID_trend" Value="0">
			<cfinvokeargument Name="phoneID_parent" Value="0">
			<cfinvokeargument Name="phoneVersion" Value="1">
		<cfelse>
			<cfinvokeargument Name="phoneID_trend" Value="#qry_selectPhone.phoneID_trend#">
			<cfinvokeargument Name="phoneID_parent" Value="#URL.phoneID#">
			<cfinvokeargument Name="phoneVersion" Value="#IncrementValue(qry_selectPhone.phoneVersion)#">
		</cfif>
		<cfinvokeargument Name="phoneAreaCode" Value="#Arguments.phoneAreaCode#">
		<cfinvokeargument Name="phoneNumber" Value="#Arguments.phoneNumber#">
		<cfinvokeargument Name="phoneExtension" Value="#Arguments.phoneExtension#">
		<cfinvokeargument Name="phoneType" Value="#Arguments.phoneType#">
		<cfinvokeargument Name="phoneDescription" Value="#Arguments.phoneDescription#">
	</cfinvoke>

	<cfset returnValue = newPhoneID>
</cfif>

