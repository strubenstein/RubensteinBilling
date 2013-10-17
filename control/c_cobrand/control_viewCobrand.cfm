<cfif URL.control is not "company">
	<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompany" ReturnVariable="qry_selectCompany">
		<cfinvokeargument Name="companyID" Value="#qry_selectCobrand.companyID#">
	</cfinvoke>
</cfif>

<cfif qry_selectCobrand.userID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectUser">
		<cfinvokeargument Name="userID" Value="#qry_selectCobrand.userID#">
	</cfinvoke>
</cfif>

<cfinvoke Component="#Application.billingMapping#data.HeaderFooter" Method="selectHeaderFooter" ReturnVariable="qry_selectHeaderFooter">
	<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID("cobrandID")#">
	<cfinvokeargument Name="targetID" Value="#URL.cobrandID#">
	<cfinvokeargument Name="headerFooterStatus" Value="1">
</cfinvoke>

<cfset Variables.headerRow = 0>
<cfset Variables.footerRow = 0>
<cfloop Query="qry_selectHeaderFooter">
	<cfif qry_selectHeaderFooter.headerFooterIndicator is 0>
		<cfset Variables.headerRow = CurrentRow>
	<cfelse>
		<cfset Variables.footerRow = CurrentRow>
	</cfif>
</cfloop>

<cfinclude template="../../view/v_cobrand/dsp_selectCobrand.cfm">
