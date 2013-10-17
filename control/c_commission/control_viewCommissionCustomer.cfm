<cfif ListFind("company,subscription", URL.control)>
	<cfset Variables.displaySalesperson = True>
<cfelse>
	<cfset Variables.displaySalesperson = False>
</cfif>

<cfinvoke Component="#Application.billingMapping#data.CommissionCustomer" Method="selectCommissionCustomerList" ReturnVariable="qry_selectCommissionCustomerList">
	<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
	<cfif Variables.displaySalesperson is True>
		<cfinvokeargument Name="companyID" Value="#URL.companyID#">
		<cfif URL.control is "subscription">
			<cfinvokeargument Name="subscriberID" Value="#URL.subscriberID#">
		</cfif>
	<cfelse>
		<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
		<cfinvokeargument Name="targetID" Value="#Variables.targetID#">
	</cfif>
</cfinvoke>

<cfset Variables.commissionUserStruct = StructNew()>
<cfset Variables.commissionSubscriberStruct = StructNew()>

<cfif qry_selectCommissionCustomerList.RecordCount is not 0>
	<cfinvoke Component="#Application.billingMapping#data.CommissionCustomer" Method="selectCommissionCustomerUser" ReturnVariable="qry_selectCommissionCustomerUser">
		<cfinvokeargument Name="commissionCustomerID" Value="#ValueList(qry_selectCommissionCustomerList.commissionCustomerID)#">
	</cfinvoke>

	<cfloop Query="qry_selectCommissionCustomerUser">
		<cfif Not StructKeyExists(Variables.commissionUserStruct, "commissionCustomer#qry_selectCommissionCustomerUser.commissionCustomerID#")>
			<cfset Variables.commissionUserStruct["commissionCustomer#qry_selectCommissionCustomerUser.commissionCustomerID#"] = qry_selectCommissionCustomerUser.CurrentRow>
		</cfif>
	</cfloop>

	<cfinvoke Component="#Application.billingMapping#data.CommissionCustomer" Method="selectCommissionCustomerSubscriber" ReturnVariable="qry_selectCommissionCustomerSubscriber">
		<cfinvokeargument Name="commissionCustomerID" Value="#ValueList(qry_selectCommissionCustomerList.commissionCustomerID)#">
	</cfinvoke>

	<cfloop Query="qry_selectCommissionCustomerSubscriber">
		<cfif Not StructKeyExists(Variables.commissionSubscriberStruct, "commissionCustomer#qry_selectCommissionCustomerSubscriber.commissionCustomerID#")>
			<cfset Variables.commissionSubscriberStruct["commissionCustomer#qry_selectCommissionCustomerSubscriber.commissionCustomerID#"] = qry_selectCommissionCustomerSubscriber.CurrentRow>
		</cfif>
	</cfloop>
</cfif>

<cfinclude template="../../view/v_commission/lang_viewCommissionCustomer.cfm">

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("viewUser,viewCompany,viewSubscriber,updateCommissionCustomer,updateCommissionCustomerStatus")>

<cfset Variables.columnHeaderList = Variables.lang_viewCommissionCustomer_title.commissionCustomer
		& "^" & Variables.lang_viewCommissionCustomer_title.commissionPercent
		& "^" & Variables.lang_viewCommissionCustomer_title.commissionPrimary
		& "^" & Variables.lang_viewCommissionCustomer_title.commissionDateBegin
		& "^" & Variables.lang_viewCommissionCustomer_title.commissionDateEnd
		& "^" & Variables.lang_viewCommissionCustomer_title.commissionStatus
		& "^" & Variables.lang_viewCommissionCustomer_title.commissionDateCreated
		& "^" & Variables.lang_viewCommissionCustomer_title.commissionDateUpdated>

<cfif Variables.displaySalesperson is True>
	<cfset Variables.columnHeaderList = Variables.lang_viewCommissionCustomer_title.salesperson & "^" & Variables.columnHeaderList>
</cfif>
<cfif ListFind(Variables.permissionActionList, "updateCommissionCustomer")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_viewCommissionCustomer_title.updateCommissionCustomer>
</cfif>

<cfset Variables.columnCount = DecrementValue(2 * ListLen(columnHeaderList, "^"))>

<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../include/function/fn_toggleBgcolor.cfm">
<cfinclude template="../../view/v_commission/dsp_selectCommissionCustomer.cfm">