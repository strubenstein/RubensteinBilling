
<cfinvoke Component="#Application.billingMapping#data.CommissionCustomer" Method="updateCommissionCustomer" ReturnVariable="isCommissionCustomerUpdated">
	<cfinvokeargument Name="commissionCustomerID" Value="#URL.commissionCustomerID#">
	<cfinvokeargument Name="commissionCustomerStatus" Value="0">
	<cfinvokeargument Name="userID_author" Value="#Session.userID#">
</cfinvoke>

<cflocation url="index.cfm?method=#URL.control#.viewCommissionCustomer#Variables.urlParameters#&confirm_commission=#Variables.doAction#" AddToken="No">

