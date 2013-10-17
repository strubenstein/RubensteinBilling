<cfif URL.control is not "company">
	<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompany" ReturnVariable="qry_selectCompany">
		<cfinvokeargument Name="companyID" Value="#qry_selectVendor.companyID#">
	</cfinvoke>
</cfif>

<cfif qry_selectVendor.userID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectUser">
		<cfinvokeargument Name="userID" Value="#qry_selectVendor.userID#">
	</cfinvoke>
</cfif>

<cfinclude template="../../view/v_vendor/dsp_selectVendor.cfm">
