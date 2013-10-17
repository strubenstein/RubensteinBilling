<!---
Latest information on this project can be found at http://www.strubenstein.com/

Copyright (c) 2013 Steven Rubenstein

Permission is hereby granted, free of charge, to any person obtaining a 
copy of this software and associated documentation files (the "Software"), 
to deal in the Software without restriction, including without limitation 
the rights to use, copy, modify, merge, publish, distribute, sublicense, 
and/or sell copies of the Software, and to permit persons to whom the Software 
is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all 
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 
--->

<cfif Not Application.fn_IsUserAuthorized(Variables.doAction)>
	<cfif URL.method is "user.updateUser" and IsDefined("URL.userID") and URL.userID is Session.userID>
		<cfset Variables.okToUpdateUser = True>
	<cfelse>
		<cfset URL.error_admin = "noPermissionForAction">
		<cfoutput><h1>#Variables.doAction#</h1></cfoutput>
		<cfinclude template="../view/v_adminMain/error_admin.cfm">
		<cfinclude template="../view/v_adminMain/footer_admin.cfm">
		<cfabort>
	</cfif>
</cfif>

<cfswitch expression="#Variables.doControl#">
<cfcase value="admin"><cfinclude template="c_adminMain/control_adminMain.cfm"></cfcase>
<cfcase value="address"><cfinclude template="c_address/control_address.cfm"></cfcase>
<cfcase value="affiliate"><cfinclude template="c_affiliate/control_affiliate.cfm"></cfcase>
<cfcase value="bank"><cfinclude template="c_bank/control_bank.cfm"></cfcase>
<cfcase value="category"><cfinclude template="c_category/control_category.cfm"></cfcase>
<cfcase value="cobrand"><cfinclude template="c_cobrand/control_cobrand.cfm"></cfcase>
<cfcase value="commission"><cfinclude template="c_commission/control_commission.cfm"></cfcase>
<cfcase value="company"><cfinclude template="c_company/control_company.cfm"></cfcase>
<cfcase value="contact"><cfinclude template="c_contact/control_contact.cfm"></cfcase>
<cfcase value="contactTopic"><cfinclude template="c_contactTopic/control_contactTopic.cfm"></cfcase>
<cfcase value="contactTemplate"><cfinclude template="c_contactTemplate/control_contactTemplate.cfm"></cfcase>
<cfcase value="content"><cfinclude template="c_content/control_content.cfm"></cfcase>
<cfcase value="creditCard"><cfinclude template="c_creditCard/control_creditCard.cfm"></cfcase>
<cfcase value="customField"><cfinclude template="c_customField/control_customField.cfm"></cfcase>
<cfcase value="export"><cfinclude template="c_export/control_export.cfm"></cfcase>
<cfcase value="group"><cfinclude template="c_group/control_group.cfm"></cfcase>
<cfcase value="image"><cfinclude template="c_image/control_image.cfm"></cfcase>
<cfcase value="import"><cfinclude template="c_import/control_import.cfm"></cfcase>
<cfcase value="invoice"><cfinclude template="c_invoice/control_invoice.cfm"></cfcase>
<cfcase value="IPaddress"><cfinclude template="c_IPaddress/control_IPaddress.cfm"></cfcase>
<cfcase value="merchant"><cfinclude template="c_merchant/control_merchant.cfm"></cfcase>
<cfcase value="newsletter"><cfinclude template="c_newsletter/control_newsletter.cfm"></cfcase>
<cfcase value="note"><cfinclude template="c_note/control_note.cfm"></cfcase>
<cfcase value="payflow"><cfinclude template="c_payflow/control_payflow.cfm"></cfcase>
<cfcase value="payment"><cfinclude template="c_payment/control_payment.cfm"></cfcase>
<cfcase value="paymentCategory"><cfinclude template="c_paymentCategory/control_paymentCategory.cfm"></cfcase>
<cfcase value="paymentCredit"><cfinclude template="c_paymentCredit/control_paymentCredit.cfm"></cfcase>
<cfcase value="permission"><cfinclude template="c_permission/control_permission.cfm"></cfcase>
<cfcase value="phone"><cfinclude template="c_phone/control_phone.cfm"></cfcase>
<cfcase value="primaryTarget"><cfinclude template="c_primaryTarget/control_primaryTarget.cfm"></cfcase>
<cfcase value="price"><cfinclude template="c_price/control_price.cfm"></cfcase>
<cfcase value="product"><cfinclude template="c_product/control_product.cfm"></cfcase>
<cfcase value="salesCommission"><cfinclude template="c_salesCommission/control_salesCommission.cfm"></cfcase>
<cfcase value="scheduler"><cfinclude template="c_scheduler/control_scheduler.cfm"></cfcase>
<cfcase value="shipping"><cfinclude template="c_shipping/control_shipping.cfm"></cfcase>
<cfcase value="subscription"><cfinclude template="c_subscription/control_subscription.cfm"></cfcase>
<cfcase value="status"><cfinclude template="c_status/control_status.cfm"></cfcase>
<cfcase value="task"><cfinclude template="c_task/control_task.cfm"></cfcase>
<cfcase value="template"><cfinclude template="c_template/control_template.cfm"></cfcase>
<cfcase value="trigger"><cfinclude template="c_trigger/control_trigger.cfm"></cfcase>
<cfcase value="user"><cfinclude template="c_user/control_user.cfm"></cfcase>
<cfcase value="vendor"><cfinclude template="c_vendor/control_vendor.cfm"></cfcase>
<!--- <cfcase value="project"><cfinclude template="c_project/control_project.cfm"></cfcase> --->
<cfcase value="loginSession"><cfinclude template="c_loginSession/control_loginSession.cfm"></cfcase>

<cfdefaultcase>
	<cfset URL.error_admin = "invalidControl">
	<cfinclude template="../view/v_adminMain/error_admin.cfm">
	<cfinclude template="../view/v_adminMain/footer_admin.cfm">
	<cfabort>
</cfdefaultcase>
</cfswitch>

