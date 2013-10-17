<cfparam Name="URL.categoryID" Default="0">
<cfparam Name="URL.productID" Default="0">
<cfparam Name="URL.commissionID" Default="0">
<cfparam Name="Variables.urlParameters" Default="">

<cfinclude template="security_commission.cfm">

<cfif URL.commissionID gt 0>
	<cfset Variables.navCommissionAction = "index.cfm?" & CGI.Query_String>
	<cfif FindNoCase("confirm_commission=", Variables.navCommissionAction) and IsDefined("URL.confirm_commission")>
		<cfset Variables.confirmPosition = ListFind(Variables.navCommissionAction, "confirm_commission=#URL.confirm_commission#", "&")>
		<cfif Variables.confirmPosition is not 0>
			<cfset Variables.navCommissionAction = ListDeleteAt(Variables.navCommissionAction, Variables.confirmPosition, "&")>
		</cfif>
	</cfif>

	<cfif Not Find("commissionID=", CGI.Query_String)>
		<cfset Variables.navCommissionAction = navCommissionAction & "&commissionID=" & URL.commissionID>
	</cfif>
</cfif>

<cfinclude template="../../view/v_commission/nav_commission.cfm">
<cfif IsDefined("URL.confirm_commission")>
	<cfinclude template="../../view/v_commission/confirm_commission.cfm">
</cfif>
<cfif IsDefined("URL.error_commission")>
	<cfinclude template="../../view/v_commission/error_commission.cfm">
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="listCommissions">
	<cfinclude template="control_listCommissions.cfm">
</cfcase>

<cfcase value="insertCommission,updateCommission">
	<cfinclude template="control_insertUpdateCommission.cfm">
</cfcase>

<cfcase value="viewCommission">
	<cfinclude template="control_viewCommission.cfm">
</cfcase>

<cfcase value="listCommissionTargets">
	<cfinclude template="control_listCommissionTargets.cfm">
</cfcase>

<cfcase value="updateCommissionStatus">
	<cfinvoke Component="#Application.billingMapping#data.Commission" Method="updateCommission" ReturnVariable="isCommissionUpdated">
		<cfinvokeargument Name="commissionID" Value="#URL.commissionID#">
		<cfinvokeargument Name="commissionStatus" Value="0">
	</cfinvoke>

	<cflocation url="index.cfm?method=#URL.control#.listCommissions#Variables.urlParameters#&confirm_commission=#Variables.doAction#" AddToken="No">
</cfcase>

<cfcase value="updateCommissionTargetStatus0"><!--- ,updateCommissionTargetStatus1 --->
	<cfinclude template="control_updateCommissionTargetStatus.cfm">
</cfcase>

<cfcase value="insertCommissionTargetGroup">
	<cfinclude template="control_insertCommissionTargetGroup.cfm">
</cfcase>

<cfcase value="insertCommissionTargetCompany,insertCommissionTargetUser,insertCommissionTargetAffiliate,insertCommissionTargetCobrand,insertCommissionTargetVendor">
	<cfinclude template="control_insertCommissionTarget.cfm">
</cfcase>

<cfcase value="insertCommissionCategory,viewCommissionCategory">
	<cfif qry_selectCommission.commissionAppliesToInvoice is 1>
		<cfset URL.error_commission = Variables.doAction>
		<cfinclude template="../../view/v_commission/error_commission.cfm">
	<cfelse>
		<cfinclude template="control_insertCommissionCategory.cfm">
	</cfif>
</cfcase>

<cfcase value="insertCommissionProduct,listCommissionProducts,updateCommissionProduct">
	<cfif qry_selectCommission.commissionAppliesToInvoice is 1>
		<cfset URL.error_commission = Variables.doAction>
		<cfinclude template="../../view/v_commission/error_commission.cfm">
	<cfelse>
		<cfswitch expression="#Variables.doAction#">
		<cfcase value="insertCommissionProduct">
			<cfinclude template="control_insertCommissionProduct.cfm">
		</cfcase>
		<cfcase value="listCommissionProducts">
			<cfset URL.categoryID = "">
			<cfset Variables.doControl = "product">
			<cfset Variables.doAction = "listProducts">
			<cfinclude template="../control.cfm">
		</cfcase>
		<cfcase value="updateCommissionProduct">
			<cfinclude template="control_updateCommissionProduct.cfm">
		</cfcase>
		</cfswitch>
	</cfif>
</cfcase>

<cfcase value="insertCommissionCustomer">
	<cfif Not ListFind("company,subscription", URL.control)>
		<cfset URL.error_commission = Variables.doAction>
		<cfinclude template="../../view/v_commission/error_commission.cfm">
	<cfelse>
		<cfset URL.commissionCustomerID = 0>
		<cfinclude template="control_insertCommissionCustomer.cfm">
	</cfif>
</cfcase>

<cfcase value="updateCommissionCustomer,updateCommissionCustomerStatus">
	<cfif Not IsDefined("URL.commissionCustomerID") or Not Application.fn_IsIntegerPositive(URL.commissionCustomerID)>
		<cfset URL.error_commission = Variables.doAction & "_blank">
		<cfinclude template="../../view/v_commission/error_commission.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.CommissionCustomer" Method="selectCommissionCustomer" ReturnVariable="qry_selectCommissionCustomer">
			<cfinvokeargument Name="commissionCustomerID" Value="#URL.commissionCustomerID#">
		</cfinvoke>

		<cfif qry_selectCommissionCustomer.RecordCount is 0>
			<cfset URL.error_commission = Variables.doAction & "_exist">
			<cfinclude template="../../view/v_commission/error_commission.cfm">
		<cfelseif qry_selectCommissionCustomer.commissionCustomerStatus is 0>
			<cfset URL.error_commission = Variables.doAction & "_status">
			<cfinclude template="../../view/v_commission/error_commission.cfm">
		<cfelseif Variables.doAction is "updateCommissionCustomer">
			<cfinclude template="control_insertCommissionCustomer.cfm">
		<cfelse><!--- updateCustomerCommissionStatus --->
			<cfinclude template="control_updateCommissionCustomerStatus.cfm">
		</cfif>
	</cfif>
</cfcase>

<cfcase value="viewCommissionCustomer">
	<cfif Not ListFind("company,user,subscription", URL.control)>
		<cfset URL.error_commission = Variables.doAction>
		<cfinclude template="../../view/v_commission/error_commission.cfm">
	<cfelse>
		<cfinclude template="control_viewCommissionCustomer.cfm">
	</cfif>
</cfcase>

<cfdefaultcase>
	<cfset URL.error_commission = "invalidAction">
	<cfinclude template="../../view/v_commission/error_commission.cfm">
</cfdefaultcase>
</cfswitch>
