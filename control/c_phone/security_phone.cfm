<cfif Not Application.fn_IsIntegerNonNegative(URL.phoneID)>
	<cflocation url="#Variables.phoneActionList#&error_phone=noPhone" AddToken="No">
<cfelseif Not Application.fn_IsIntegerNonNegative(URL.companyID) or (URL.companyID is not 0 and Not ListFind("company,user", URL.control))>
	<cflocation url="#Variables.phoneActionList#&error_phone=invalidCompany" AddToken="No">
<cfelseif Not Application.fn_IsIntegerNonNegative(URL.userID) or (URL.userID is not 0 and Not ListFind("user,company", URL.control))>
	<cflocation url="#Variables.phoneActionList#&error_phone=invalidUser" AddToken="No">
<cfelseif URL.userID is 0 and URL.companyID is 0>
	<cflocation url="#Variables.phoneActionList#&error_phone=invalidCompany" AddToken="No">
<cfelseif URL.phoneID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Phone" Method="checkPhonePermission" ReturnVariable="isPhonePermission">
		<cfinvokeargument Name="phoneID" Value="#URL.phoneID#">
		<cfinvokeargument Name="companyID" Value="#URL.companyID#">
		<cfif URL.userID is not 0>
			<cfinvokeargument Name="userID" Value="#URL.userID#">
		</cfif>
	</cfinvoke>

	<cfif isPhonePermission is False>
		<cflocation url="#Variables.phoneActionList#&error_phone=invalidPhone" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Phone" Method="selectPhone" ReturnVariable="qry_selectPhone">
			<cfinvokeargument Name="phoneID" Value="#URL.phoneID#">
		</cfinvoke>

		<cfif qry_selectPhone.companyID is not URL.companyID and qry_selectPhone.userID is not URL.userID>
			<cflocation url="#Variables.phoneActionList#&error_phone=invalidPhone" AddToken="No">
		<cfelseif qry_selectPhone.phoneStatus is 0 and Variables.doAction is "insertPhone">
			<cflocation url="#Variables.phoneActionList#&error_phone=invalidPhoneStatus" AddToken="No">
		</cfif>
	</cfif>
<cfelseif Not ListFind("listPhones,listPhonesAll,insertPhone", Variables.doAction)>
	<cflocation url="#Variables.phoneActionList#&error_phone=noPhone" AddToken="No">
</cfif>