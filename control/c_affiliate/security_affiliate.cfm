<cfif Not Application.fn_IsIntegerNonNegative(URL.affiliateID)>
	<cflocation url="index.cfm?method=affiliate.listAffiliates&error_affiliate=noAffiliate" AddToken="No">
<cfelseif URL.affiliateID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="checkAffiliatePermission" ReturnVariable="isAffiliatePermission">
		<cfinvokeargument Name="affiliateID" Value="#URL.affiliateID#">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID#">
	</cfinvoke>

	<cfif isAffiliatePermission is False>
		<cflocation url="index.cfm?method=affiliate.listAffiliates&error_affiliate=invalidAffiliate" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="selectAffiliate" ReturnVariable="qry_selectAffiliate">
			<cfinvokeargument Name="affiliateID" Value="#URL.affiliateID#">
		</cfinvoke>

		<cfif URL.control is "company" and qry_selectAffiliate.companyID is not URL.companyID>
			<cflocation url="index.cfm?method=affiliate.listAffiliates&error_affiliate=invalidAffiliate" AddToken="No">
		</cfif>
	</cfif>
<cfelseif Not ListFind("listAffiliates,listCompanyAffiliates,insertAffiliate", Variables.doAction)>
	<cflocation url="index.cfm?method=affiliate.listAffiliates&error_affiliate=noAffiliate" AddToken="No">
</cfif>
