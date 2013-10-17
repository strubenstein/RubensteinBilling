<cfif Variables.doAction is "updateCommissionCustomer" and IsDefined("qry_selectCommissionCustomer")>
	<cfparam Name="Form.targetID" Default="#qry_selectCommissionCustomer.targetID#">
	<cfparam Name="Form.commissionCustomerPercent" Default="#Application.fn_setDecimalPrecision(qry_selectCommissionCustomer.commissionCustomerPercent * 100, 4)#">
	<cfparam Name="Form.commissionCustomerPrimary" Default="#qry_selectCommissionCustomer.commissionCustomerPrimary#">
	<cfparam Name="Form.commissionCustomerDescription" Default="#qry_selectCommissionCustomer.commissionCustomerDescription#">
	<cfparam Name="Form.commissionCustomerDateBegin" Default="#DateFormat(qry_selectCommissionCustomer.commissionCustomerDateBegin, "mm/dd/yyyy")#">

	<cfif IsDate(qry_selectCommissionCustomer.commissionCustomerDateEnd)>
		<cfparam Name="Form.commissionCustomerDateEnd" Default="#DateFormat(qry_selectCommissionCustomer.commissionCustomerDateEnd, "mm/dd/yyyy")#">
	<cfelse>
		<cfparam Name="Form.commissionCustomerDateEnd" Default="">
	</cfif>

	<cfif qry_selectCommissionCustomer.commissionCustomerAllUsers is 1>
		<cfparam Name="Form.userID" Default="0">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.CommissionCustomer" Method="selectCommissionCustomerUser" ReturnVariable="qry_selectCommissionCustomerUser">
			<cfinvokeargument Name="commissionCustomerID" Value="#URL.commissionCustomerID#">
		</cfinvoke>

		<cfparam Name="Form.userID" Default="#ValueList(qry_selectCommissionCustomerUser.userID)#">
	</cfif>

	<cfif qry_selectCommissionCustomer.commissionCustomerAllSubscribers is 1>
		<cfparam Name="Form.subscriberID" Default="0">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.CommissionCustomer" Method="selectCommissionCustomerSubscriber" ReturnVariable="qry_selectCommissionCustomerSubscriber">
			<cfinvokeargument Name="commissionCustomerID" Value="#URL.commissionCustomerID#">
		</cfinvoke>

		<cfparam Name="Form.subscriberID" Default="#ValueList(qry_selectCommissionCustomerSubscriber.subscriberID)#">
	</cfif>
</cfif>

<cfparam Name="Form.targetID" Default="0">
<cfparam Name="Form.commissionCustomerPercent" Default="100">
<cfparam Name="Form.commissionCustomerPrimary" Default="0">
<cfparam Name="Form.commissionCustomerDescription" Default="">
<cfparam Name="Form.userID" Default="0">
<cfparam Name="Form.subscriberID" Default="0">
<cfparam Name="Form.commissionCustomerDateBegin" Default="#DateFormat(Now(), "mm/dd/yyyy")#">
<cfparam Name="Form.commissionCustomerDateEnd" Default="">

