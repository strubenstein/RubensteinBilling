<cfif Not ListFind(Arguments.useCustomIDFieldList, "affiliateID") and Not ListFind(Arguments.useCustomIDFieldList, "affiliateID_custom")>
	<cfif Arguments.affiliateID is 0 or Not Application.fn_IsIntegerList(Arguments.affiliateID)>
		<cfset returnValue = 0>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="checkAffiliatePermission" ReturnVariable="isAffiliatePermission">
			<cfinvokeargument Name="companyID_author" Value="#Arguments.companyID_author#">
			<cfinvokeargument Name="affiliateID" Value="#Arguments.affiliateID#">
		</cfinvoke>

		<cfif isAffiliatePermission is False>
			<cfset returnValue = 0>
		<cfelse>
			<cfset returnValue = Arguments.affiliateID>
		</cfif>
	</cfif>
<cfelseif Trim(Arguments.affiliateID_custom) is "">
	<cfset returnValue = 0>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="selectAffiliateIDViaCustomID" ReturnVariable="affiliateIDViaCustomID">
		<cfinvokeargument Name="companyID_author" Value="#Arguments.companyID_author#">
		<cfinvokeargument Name="affiliateID_custom" Value="#Arguments.affiliateID_custom#">
	</cfinvoke>

	<cfset returnValue = affiliateIDViaCustomID>
</cfif>

