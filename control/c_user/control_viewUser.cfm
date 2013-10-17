<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUserSummary" ReturnVariable="qry_selectUserSummary">
	<cfinvokeargument Name="userID" Value="#URL.userID#">
</cfinvoke>

<cfset Variables.displayCompany = False>
<cfif qry_selectUser.companyID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompany" ReturnVariable="qry_selectCompany">
		<cfinvokeargument Name="companyID" Value="#qry_selectUser.companyID#">
	</cfinvoke>

	<cfif qry_selectCompany.RecordCount is not 0>
		<cfset Variables.displayCompany = True>
	</cfif>
</cfif>

<cfinclude template="../../view/v_user/dsp_selectUser.cfm">
