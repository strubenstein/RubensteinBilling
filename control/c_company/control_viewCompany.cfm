<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompanySummary" ReturnVariable="qry_selectCompanySummary">
	<cfinvokeargument Name="companyID" Value="#URL.companyID#">
</cfinvoke>

<cfset Variables.primaryTargetArray = ArrayNew(1)>
<cfset Variables.primaryTargetArray[1] = Application.fn_GetPrimaryTargetID("companyID") & "," & URL.companyID>

<cfset Variables.displayAffiliate = False>
<cfif qry_selectCompany.affiliateID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="selectAffiliate" ReturnVariable="qry_selectAffiliate">
		<cfinvokeargument Name="affiliateID" Value="#qry_selectCompany.affiliateID#">
	</cfinvoke>

	<cfif qry_selectAffiliate.RecordCount is not 0>
		<cfset Variables.displayAffiliate = True>
	</cfif>
</cfif>

<cfset Variables.displayCobrand = False>
<cfif qry_selectCompany.cobrandID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="selectCobrand" ReturnVariable="qry_selectCobrand">
		<cfinvokeargument Name="cobrandID" Value="#qry_selectCompany.cobrandID#">
	</cfinvoke>

	<cfif qry_selectCobrand.RecordCount is not 0>
		<cfset Variables.displayCobrand = True>
	</cfif>
</cfif>

<cfset Variables.displayUser = False>
<cfif qry_selectCompany.userID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectUser">
		<cfinvokeargument Name="userID" Value="#qry_selectCompany.userID#">
	</cfinvoke>

	<cfif qry_selectUser.RecordCount is not 0>
		<cfset Variables.displayUser = True>
		<cfset Variables.primaryTargetArray[2] = Application.fn_GetPrimaryTargetID("userID") & "," & qry_selectCompany.userID>
	</cfif>
</cfif>

<cfinclude template="../../view/v_company/dsp_selectCompany.cfm">
