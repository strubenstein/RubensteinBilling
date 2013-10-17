<cfif Not Application.fn_IsIntegerNonNegative(URL.cobrandID)>
	<cflocation url="index.cfm?method=cobrand.listCobrands&error_cobrand=noCobrand" AddToken="No">
<cfelseif URL.cobrandID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="checkCobrandPermission" ReturnVariable="isCobrandPermission">
		<cfinvokeargument Name="cobrandID" Value="#URL.cobrandID#">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID#">
	</cfinvoke>

	<cfif isCobrandPermission is False>
		<cflocation url="index.cfm?method=cobrand.listCobrands&error_cobrand=invalidCobrand" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="selectCobrand" ReturnVariable="qry_selectCobrand">
			<cfinvokeargument Name="cobrandID" Value="#URL.cobrandID#">
		</cfinvoke>

		<cfif URL.control is "company" and qry_selectCobrand.companyID is not URL.companyID>
			<cflocation url="index.cfm?method=cobrand.listCobrands&error_cobrand=invalidCobrand" AddToken="No">
		</cfif>
	</cfif>
<cfelseif Not ListFind("listCobrands,listCompanyCobrands,insertCobrand", Variables.doAction)>
	<cflocation url="index.cfm?method=cobrand.listCobrands&error_cobrand=noCobrand" AddToken="No">
</cfif>
