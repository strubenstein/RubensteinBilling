<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectUserCompanyList_company" ReturnVariable="qry_selectUserCompanyList_company">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	<cfinvokeargument Name="userCompanyStatus" Value="1">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectUserCompanyList_company" ReturnVariable="qry_selectUserCompanyList_customer">
	<cfinvokeargument Name="companyID" Value="#URL.companyID#">
	<cfinvokeargument Name="userCompanyStatus" Value="1">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="selectSubscriberList" ReturnVariable="qry_selectSubscriberList">
	<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
	<cfinvokeargument Name="companyID" Value="#URL.companyID#">
	<cfinvokeargument Name="queryOrderBy" Value="subscriberName">
	<cfinvokeargument Name="queryDisplayPerPage" Value="0">
	<cfinvokeargument Name="queryPage" Value="0">
</cfinvoke>

<cfinclude template="../../include/function/fn_datetime.cfm">
<cfinvoke component="#Application.billingMapping#data.CommissionCustomer" method="maxlength_CommissionCustomer" returnVariable="maxlength_CommissionCustomer" />
<cfinclude template="formParam_insertCommissionCustomer.cfm">
<cfinclude template="../../view/v_commission/lang_insertCommissionCustomer.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitCommissionCustomer")>
	<cfinclude template="formValidate_insertCommissionCustomer.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfset Variables.primaryTargetID_user = Application.fn_GetPrimaryTargetID("userID")>

		<cfif Variables.doAction is "updateCommissionCustomer">
			<cfinvoke Component="#Application.billingMapping#data.CommissionCustomer" Method="updateCommissionCustomer" ReturnVariable="isCommissionCustomerUpdated">
				<cfinvokeargument Name="commissionCustomerID" Value="#URL.commissionCustomerID#">
				<cfinvokeargument Name="commissionCustomerStatus" Value="0">
				<cfinvokeargument Name="userID_author" Value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<cfinvoke Component="#Application.billingMapping#data.CommissionCustomer" Method="insertCommissionCustomer" ReturnVariable="isCommissionCustomerInserted">
			<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
			<cfinvokeargument Name="userID_author" Value="#Session.userID#">
			<cfinvokeargument Name="companyID" Value="#URL.companyID#">
			<cfinvokeargument Name="userID" Value="#Form.userID#">
			<cfinvokeargument Name="subscriberID" Value="#Form.subscriberID#">
			<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID_user#">
			<cfinvokeargument Name="targetID" Value="#Form.targetID#">
			<cfinvokeargument Name="commissionCustomerDateBegin" Value="#Form.commissionCustomerDateBegin#">
			<cfinvokeargument Name="commissionCustomerDateEnd" Value="#Form.commissionCustomerDateEnd#">
			<cfinvokeargument Name="commissionCustomerStatus" Value="1">
			<cfinvokeargument Name="commissionCustomerPercent" Value="#Evaluate(Form.commissionCustomerPercent / 100)#">
			<cfinvokeargument Name="commissionCustomerPrimary" Value="#Form.commissionCustomerPrimary#">
			<cfinvokeargument Name="commissionCustomerDescription" Value="#Form.commissionCustomerDescription#">
		</cfinvoke>

		<cflocation url="index.cfm?method=#URL.control#.viewCommissionCustomer#Variables.urlParameters#&confirm_commission=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formName = "commissionCustomer">
<cfset Variables.formAction = "index.cfm?method=#URL.method##Variables.urlParameters#">

<cfif Variables.doAction is "updateCommissionCustomer">
	<cfset Variables.formAction = Variables.formAction & "&commissionCustomerID=#URL.commissionCustomerID#">
	<cfset Variables.formSubmitValue = Variables.lang_insertCommissionCustomer.formSubmitValue_update>
<cfelse>
	<cfset Variables.formSubmitValue = Variables.lang_insertCommissionCustomer.formSubmitValue_insert>
</cfif>

<cfinclude template="../../view/v_commission/form_insertCommissionCustomer.cfm">
