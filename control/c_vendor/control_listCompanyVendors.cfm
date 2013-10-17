<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="selectVendorList" ReturnVariable="qry_selectCompanyVendorList">
	<cfinvokeargument Name="companyID_author" Value="#Session.companyID#">
	<cfinvokeargument Name="companyID" Value="#URL.companyID#">
</cfinvoke>

<cfinclude template="../../view/v_vendor/lang_listCompanyVendors.cfm">
<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("viewVendor,updateVendor")>

<cfset Variables.vendorColumnList = Variables.lang_listCompanyVendors_title.vendorID_custom
		& "^" & Variables.lang_listCompanyVendors_title.vendorName
		& "^" & Variables.lang_listCompanyVendors_title.vendorStatus
		& "^" & Variables.lang_listCompanyVendors_title.vendorCode
		& "^" & Variables.lang_listCompanyVendors_title.vendorURLdisplay
		& "^" & Variables.lang_listCompanyVendors_title.vendorDescriptionDisplay
		& "^" & Variables.lang_listCompanyVendors_title.vendorDateCreated
		& "^" & Variables.lang_listCompanyVendors_title.vendorDateUpdated>

<cfif ListFind(Variables.permissionActionList, "viewVendor")>
	<cfset Variables.vendorColumnList = Variables.vendorColumnList & "^" & Variables.lang_listCompanyVendors_title.viewVendor>
</cfif>
<!--- 
<cfif ListFind(Variables.permissionActionList, "updateVendor")>
	<cfset Variables.vendorColumnList = Variables.vendorColumnList & "^" & Variables.lang_listCompanyVendors_title.updateVendor>
</cfif>
--->

<cfset Variables.vendorColumnCount = DecrementValue(2 * ListLen(Variables.vendorColumnList, "^"))>

<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../view/v_vendor/dsp_selectCompanyVendorList.cfm">
