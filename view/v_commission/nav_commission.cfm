<cfif ListFind("category,commission,product", URL.control)>
	<cfoutput>
	<div class="SubNav">
	<span class="SubNavTitle">Sales Commission Plans: </span><br>
	<cfif Application.fn_IsUserAuthorized("listCommissions")><a href="index.cfm?method=#URL.control#.listCommissions#Variables.urlParameters#" title="List existing commission plans" class="SubNavLink<cfif Variables.doAction is "listCommissions">On</cfif>">List Existing Commission Plans</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertCommission")> | <a href="index.cfm?method=#URL.control#.insertCommission#Variables.urlParameters#" title="Add new commission plan" class="SubNavLink<cfif Variables.doAction is "insertCommission">On</cfif>">Create New Commission Plan</a></cfif>
	<cfif URL.commissionID is not 0>
		<br><img src="#Application.billingUrlRoot#/images/grayline.jpg" width="100%" height="1" vspace="3" alt="" border="0"><br>
		<span class="SubNavObject">Commission Plan:</span> 
		<span class="SubNavName">
		<cfif qry_selectCommission.commissionID_custom is not "">#qry_selectCommission.commissionID_custom#. </cfif>
		<cfif qry_selectCommission.commissionName is "">(no name)<cfelse>#qry_selectCommission.commissionName#</cfif>
		</span><br>
		<cfset Variables.navCommissionAction = "index.cfm?method=commission.#Variables.doAction#&commissionID=#URL.commissionID#">
		<cfif Application.fn_IsUserAuthorized("viewCommission")><a href="#Replace(Variables.navCommissionAction, Variables.doAction, "viewCommission", "ONE")#" title="View existing commission plan" class="SubNavLink<cfif Variables.doAction is "viewCommission">On</cfif>">View</a> | </cfif>
		<cfif Application.fn_IsUserAuthorized("updateCommission")><a href="#Replace(Variables.navCommissionAction, Variables.doAction, "updateCommission", "ONE")#" title="Update existing commission plan" class="SubNavLink<cfif Variables.doAction is "updateCommission">On</cfif>">Update</a></cfif>
		<cfif qry_selectCommission.commissionAppliesToInvoice is 1>
			<cfif Application.fn_IsUserAuthorized("insertCommissionCategory")> | <font color="black">Apply to Categories</font></cfif>
			<cfif Application.fn_IsUserAuthorized("listCommissionProducts")> | <font color="black">Existing Products</font></cfif>
			<cfif Application.fn_IsUserAuthorized("insertCommissionProduct")> | <font color="black">Apply to Products</font></cfif>
		<cfelse>
			<cfif Application.fn_IsUserAuthorized("insertCommissionCategory")> | <a href="#Replace(Variables.navCommissionAction, Variables.doAction, "insertCommissionCategory", "ONE")#" title="Determine product categories to which commission plan may be applied" class="SubNavLink<cfif Variables.doAction is "insertCommissionCategory">On</cfif>">Apply to Categories</a></cfif>
			<cfif Application.fn_IsUserAuthorized("listCommissionProducts")> | <a href="#Replace(Variables.navCommissionAction, Variables.doAction, "listCommissionProducts", "ONE")#" title="List products to which commission plan may be applied" class="SubNavLink<cfif Variables.doAction is "listCommissionProducts">On</cfif>">Existing Products</a></cfif>
			<cfif Application.fn_IsUserAuthorized("insertCommissionProduct")> | <a href="#Replace(Variables.navCommissionAction, Variables.doAction, "insertCommissionProduct", "ONE")#" title="Add products to which commission plan may be applied" class="SubNavLink<cfif Variables.doAction is "insertCommissionProduct">On</cfif>">Apply to Products</a></cfif>
		</cfif>
		<cfif Application.fn_IsUserAuthorized("listCommissionTargets")> | <a href="#Replace(Variables.navCommissionAction, Variables.doAction, "listCommissionTargets", "ONE")#" title="List targets that receive this commission plan" class="SubNavLink<cfif Variables.doAction is "listCommissionTargets">On</cfif>">List Existing Salesperson Targets</a></cfif>
		<cfif Application.fn_IsUserAuthorized("insertCommissionTargetCompany") or Application.fn_IsUserAuthorized("insertCommissionTargetGroup") or Application.fn_IsUserAuthorized("insertCommissionTargetUser") or Application.fn_IsUserAuthorized("insertCommissionTargetCobrand") or Application.fn_IsUserAuthorized("insertCommissionTargetAffiliate") or Application.fn_IsUserAuthorized("insertCommissionTargetRegion")>
			<br><i>Add New Salesperson Target</i>: 
			<cfif Application.fn_IsUserAuthorized("insertCommissionTargetGroup")><a href="#Replace(Variables.navCommissionAction, Variables.doAction, "insertCommissionTargetGroup", "ONE")#" title="Add group as target eligible to receive commission plan" class="SubNavLink<cfif Variables.doAction is "insertCommissionTargetGroup">On</cfif>">Group</a></cfif>
			<!--- <cfif Application.fn_IsUserAuthorized("insertCommissionTargetCompany")> | <a href="#Replace(Variables.navCommissionAction, Variables.doAction, "insertCommissionTargetCompany", "ONE")#" title="Add company as target eligible to receive commission plan" class="SubNavLink<cfif Variables.doAction is "insertCommissionTargetCompany">On</cfif>">Company</a></cfif> --->
			<cfif Application.fn_IsUserAuthorized("insertCommissionTargetUser")> | <a href="#Replace(Variables.navCommissionAction, Variables.doAction, "insertCommissionTargetUser", "ONE")#" title="Add user as target eligible to receive commission plan" class="SubNavLink<cfif Variables.doAction is "insertCommissionTargetUser">On</cfif>">User</a></cfif>
			<cfif Application.fn_IsUserAuthorized("insertCommissionTargetCobrand")> | <a href="#Replace(Variables.navCommissionAction, Variables.doAction, "insertCommissionTargetCobrand", "ONE")#" title="Add cobrand as target eligible to receive commission plan" class="SubNavLink<cfif Variables.doAction is "insertCommissionTargetCobrand">On</cfif>">Cobrand</a></cfif>
			<cfif Application.fn_IsUserAuthorized("insertCommissionTargetAffiliate")> | <a href="#Replace(Variables.navCommissionAction, Variables.doAction, "insertCommissionTargetAffiliate", "ONE")#" title="Add affiliate as target eligible to receive commission plan" class="SubNavLink<cfif Variables.doAction is "insertCommissionTargetAffiliate">On</cfif>">Affiliate</a></cfif>
			<cfif Application.fn_IsUserAuthorized("insertCommissionTargetVendor")> | <a href="#Replace(Variables.navCommissionAction, Variables.doAction, "insertCommissionTargetVendor", "ONE")#" title="Add vendor as target eligible to receive commission plan" class="SubNavLink<cfif Variables.doAction is "insertCommissionTargetVendor">On</cfif>">Vendor</a></cfif>
		</cfif>
	</cfif>
	</div><br>
	</cfoutput>
<cfelseif ListFind("company,subscription", URL.control) and ListFind("insertCommissionCustomer,updateCommissionCustomer,viewCommissionCustomer", Variables.doAction)>
	<cfoutput>
	<div class="SubNav">
	<cfif Application.fn_IsUserAuthorized("viewCommissionCustomer")><a href="index.cfm?method=#URL.control#.viewCommissionCustomer#Variables.urlParameters#" title="View salesperson(s) for this customer" class="SubNavLink<cfif Variables.doAction is "viewCommissionCustomer">On</cfif>">View Salesperson(s)</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertCommissionCustomer")> | <a href="index.cfm?method=#URL.control#.insertCommissionCustomer#Variables.urlParameters#" title="Update salesperson(s) for this customer" class="SubNavLink<cfif Variables.doAction is "insertCommissionCustomer">On</cfif>">Add/Update Salesperson(s)</a></cfif>
	</div><br>
	</cfoutput>
</cfif>

