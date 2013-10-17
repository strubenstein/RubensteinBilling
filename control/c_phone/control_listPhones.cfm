<cfinvoke Component="#Application.billingMapping#data.Phone" Method="selectPhoneList" ReturnVariable="qry_selectPhoneList">
	<cfinvokeargument Name="companyID" Value="#URL.companyID#">
	<cfif Variables.doControl is "user" or URL.userID is not 0>
		<cfinvokeargument Name="userID" Value="#URL.userID#">
		<cfinvokeargument Name="companyIDorUserID" Value="False">
	</cfif>
	<cfif Variables.doAction is not "listPhonesAll">
		<cfinvokeargument Name="phoneStatus" Value="1">
	</cfif>
</cfinvoke>

<cfinclude template="../../view/v_phone/lang_listPhones.cfm">

<cfset Variables.phoneActionUpdate = Replace(Variables.formAction, URL.action, "insertPhone", "ONE")>
<cfset Variables.phoneActionList = Replace(Variables.formAction, URL.action, "listPhones", "ONE")>
<cfset Variables.phoneActionListAll = Replace(Variables.formAction, URL.action, "listPhonesAll", "ONE")>

<cfset Variables.phoneActionStatusActive = Replace(Variables.formAction, URL.action, "updatePhoneStatus1", "ONE")>
<cfset Variables.phoneActionStatusArchived = Replace(Variables.formAction, URL.action, "updatePhoneStatus0", "ONE")>

<cfset Variables.phoneColumnList = Variables.lang_listPhones_title.phoneType
		& "^" &  Variables.lang_listPhones_title.phoneVersion
		& "^" &  Variables.lang_listPhones_title.phoneUserCompany
		& "^" &  Variables.lang_listPhones_title.phoneStatus
		& "^" &  Variables.lang_listPhones_title.phoneAreaCode
		& "^" &  Variables.lang_listPhones_title.phoneNumber
		& "^" &  Variables.lang_listPhones_title.phoneExtension
		& "^" &  Variables.lang_listPhones_title.phoneDescription
		& "^" &  Variables.lang_listPhones_title.phoneDateCreated
		& "^" &  Variables.lang_listPhones_title.phoneDateUpdated>

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("insertPhone,listPhones,listPhonesAll,updatePhoneStatus1,updatePhoneStatus0")>

<cfif ListFind(Variables.permissionActionList, "insertPhone")>
	<cfset Variables.phoneColumnList = Variables.phoneColumnList & "^" & Variables.lang_listPhones_title.insertPhone>
</cfif>

<cfset Variables.phoneColumnCount = DecrementValue(2 * ListLen(Variables.phoneColumnList, "^"))>

<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../view/v_phone/dsp_selectPhoneList.cfm">
