<cfparam Name="URL.salesCommissionID" Default="0">
<cfparam Name="Variables.urlParameters" Default="">

<cfinclude template="security_salesCommission.cfm">

<cfif URL.salesCommissionID gt 0>
	<cfset Variables.navSalesCommissionAction = "index.cfm?" & CGI.Query_String>
	<cfif FindNoCase("confirm_salesCommission=", Variables.navSalesCommissionAction) and IsDefined("URL.confirm_salesCommission")>
		<cfset Variables.confirmPosition = ListFind(Variables.navSalesCommissionAction, "confirm_salesCommission=#URL.confirm_salesCommission#", "&")>
		<cfif Variables.confirmPosition is not 0>
			<cfset Variables.navSalesCommissionAction = ListDeleteAt(Variables.navSalesCommissionAction, Variables.confirmPosition, "&")>
		</cfif>
	</cfif>

	<cfif Not Find("salesCommissionID=", CGI.Query_String)>
		<cfset Variables.navSalesCommissionAction = navSalesCommissionAction & "&salesCommissionID=" & URL.salesCommissionID>
	</cfif>
</cfif>

<cfinclude template="../../view/v_salesCommission/nav_salesCommission.cfm">
<cfif IsDefined("URL.confirm_salesCommission")>
	<cfinclude template="../../view/v_salesCommission/confirm_salesCommission.cfm">
</cfif>
<cfif IsDefined("URL.error_salesCommission")>
	<cfinclude template="../../view/v_salesCommission/error_salesCommission.cfm">
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="listSalesCommissions">
	<cfinclude template="control_listSalesCommissions.cfm">
</cfcase>

<cfcase value="insertSalesCommission">
	<cfif Not ListFind("affiliate,cobrand,invoice,user,vendor,salesCommission", URL.control)>
		<cfset URL.error_salesCommission = Variables.doAction>
		<cfinclude template="../../view/v_salesCommission/error_salesCommission.cfm">
	<cfelse>
		<cfinclude template="control_insertSalesCommission.cfm">
	</cfif>
</cfcase>

<cfcase value="updateSalesCommission">
	<cfinclude template="control_updateSalesCommission.cfm">
</cfcase>

<cfcase value="viewSalesCommission">
	<cfinclude template="control_viewSalesCommission.cfm">
</cfcase>

<cfdefaultcase>
	<cfset URL.error_salesCommission = "invalidAction">
	<cfinclude template="../../view/v_salesCommission/error_salesCommission.cfm">
</cfdefaultcase>
</cfswitch>
