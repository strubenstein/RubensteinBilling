<cfif Not Application.fn_IsIntegerNonNegative(URL.companyID)>
	<cflocation url="index.cfm?method=company.listCompanies&error_company=noCompany" AddToken="No">
<cfelseif URL.companyID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Company" Method="checkCompanyPermission" ReturnVariable="isCompanyPermission">
		<cfinvokeargument Name="companyID" Value="#URL.companyID#">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
		<cfif Session.companyID is not Session.companyID_author>
			<cfinvokeargument Name="cobrandID" Value="#Session.cobrandID_list#">
			<cfinvokeargument Name="affiliateID" Value="#Session.affiliateID_list#">
		</cfif>
	</cfinvoke>

	<cfif isCompanyPermission is False and Session.companyID_author is not Application.billingSuperuserCompanyID>
		<cflocation url="index.cfm?method=company.listCompanies&error_company=invalidCompany" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompany" ReturnVariable="qry_selectCompany">
			<cfinvokeargument Name="companyID" Value="#URL.companyID#">
		</cfinvoke>
	</cfif>
<cfelseif Not ListFind("listCompanies,insertCompany", Variables.doAction)>
	<cflocation url="index.cfm?method=company.listCompanies&error_company=noCompany" AddToken="No">
</cfif>

