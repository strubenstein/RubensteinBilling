<cfif URL.control is not "company">
	<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompany" ReturnVariable="qry_selectCompany">
		<cfinvokeargument Name="companyID" Value="#qry_selectAffiliate.companyID#">
	</cfinvoke>
</cfif>

<cfif qry_selectAffiliate.userID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectUser">
		<cfinvokeargument Name="userID" Value="#qry_selectAffiliate.userID#">
	</cfinvoke>
</cfif>

<cfinclude template="../../view/v_affiliate/dsp_selectAffiliate.cfm">
