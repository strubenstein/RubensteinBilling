<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="selectInvoiceLineItemList" ReturnVariable="qry_selectInvoiceLineItemList">
	<cfinvokeargument Name="invoiceID" Value="#Session.invoiceID#">
	<cfinvokeargument Name="invoiceLineItemStatus" Value="1">
</cfinvoke>

<!--- get content options for email confirmation to buyer --->
<cfinvoke Component="#Application.billingMapping#data.ContentCompany" Method="selectContentCompanyList" ReturnVariable="qry_selectContentCompanyList">
	<cfinvokeargument Name="contentCode" Value="confirmVendorEmailFromName,confirmVendorEmailFromAddress,confirmVendorEmailReplyTo,confirmVendorEmailSubject,confirmVendorEmailHeader,confirmVendorEmailFooter,confirmVendorEmailCC,confirmVendorEmailBCC">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
	<cfinvokeargument Name="languageID" Value="">
	<cfinvokeargument Name="contentCompanyStatus" Value="1">
</cfinvoke>

<!--- if vendor email exists AND any vendor-supplied products --->
<cfif qry_selectContentCompanyList.RecordCount is not 0 and REFind("[1-9]", ValueList(qry_selectInvoiceLineItemList.vendorID))>
	<!--- select vendor-supplied products --->
	<cfquery Name="qry_selectVendorsFromInvoice" DBType="query">
		SELECT *
		FROM qry_selectInvoiceLineItemList
		WHERE vendorID <> 0
		ORDER BY vendorID, productID
	</cfquery>

	<!--- Select vendors --->
	<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="selectVendor" ReturnVariable="qry_selectVendorList">
		<cfinvokeargument Name="vendorID" Value="#ValueList(qry_selectVendorsFromInvoice.vendorID)#">
	</cfinvoke>

	<!--- Select contact at each vendor --->
	<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectUserList">
		<cfinvokeargument Name="userID" Value="#ValueList(qry_selectVendorList.userID)#">
	</cfinvoke>

	<cfset Variables.contentCodeRow = StructNew()>
	<cfloop Query="qry_selectContentCompanyList">
		<cfset Variables.contentCodeRow[qry_selectContentCompanyList.contentCode] = qry_selectContentCompanyList.CurrentRow>
	</cfloop>

	<cfset Variables.emailFrom = fn_EmailFrom(qry_selectContentCompanyList.contentCompanyText[Variables.contentCodeRow.confirmVendorEmailFromName], qry_selectContentCompanyList.contentCompanyText[Variables.contentCodeRow.confirmVendorEmailFromAddress])>
	<cfset Variables.emailType = "html">

	<cfloop Query="qry_selectVendorList">
		<cfset Variables.userRow = ListFind(ValueList(qry_selectUserList.userID), qry_selectVendorList.userID)>
		<!--- if there is a contact user, send email --->
		<cfif Variables.userRow is not 0>
			<cfset Variables.lineItemRowBegin = ListFind(ValueList(qry_selectVendorsFromInvoice.vendorID), qry_selectVendorList.vendorID)>
			<cfset Variables.lineItemRowEnd = Variables.lineItemRowBegin + ListValueCount(ValueList(qry_selectVendorsFromInvoice.vendorID), qry_selectVendorList.vendorID) - 1>
			<cfinclude template="../../../view/v_shopping/v_shoppingCheckout/email_notifyVendorOfPurchase.cfm">
		</cfif>
	</cfloop>
</cfif>
