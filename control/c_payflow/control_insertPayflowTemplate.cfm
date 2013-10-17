<cfinvoke Component="#Application.billingMapping#data.PayflowTemplate" Method="selectPayflowTemplateList" ReturnVariable="qry_selectPayflowTemplateList">
	<cfinvokeargument Name="payflowID" Value="#URL.payflowID#">
	<cfinvokeargument Name="payflowTemplateStatus" Value="1">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Template" Method="selectTemplateList" ReturnVariable="qry_selectTemplateList">
	<cfinvokeargument Name="companyID" Value="0,#Session.companyID_author#">
	<cfinvokeargument Name="templateType" Value="Invoice">
	<cfinvokeargument Name="returnTemplateXML" Value="False">
</cfinvoke>

<cfinclude template="../../view/v_payment/var_paymentMethodList.cfm">
<cfinclude template="../../view/v_payflow/var_payflowTemplateNotifyMethodList.cfm">
<cfinclude template="../../view/v_payflow/var_payflowTemplateTypeList.cfm">

<!--- default all are checked? --->
<cfinclude template="formParam_insertPayflowTemplate.cfm">

<cfif Variables.doAction is "insertPayflowTemplate" and IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitPayflowTemplate")>
	<cfinclude template="../../view/v_payflow/lang_insertPayflowTemplate.cfm">
	<cfinvoke component="#Application.billingMapping#data.PayflowTemplate" method="maxlength_PayflowTemplate" returnVariable="maxlength_PayflowTemplate" />
	<!--- for now, it is ok to repeat a payment method / notify method combination in case 2 templates should be generated --->
	<cfinclude template="formValidate_insertPayflowTemplate.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<!--- ? delete all existing templates, or archive them? --->
		<cfloop Index="count0" From="1" To="#ListLen(Variables.payflowTemplateTypeList_value)#">
			<cfset type = ListGetAt(Variables.payflowTemplateTypeList_value, count0)>
			<cfloop Index="count1" From="1" To="#Form["#type#Count"]#">
				<cfif Form["templateID_#type##count1#"] gt 0 and Form["payflowTemplateNotifyMethod_#type##count1#"] is not "" and Form["payflowTemplatePaymentMethod_#type##count1#"] is not "">
					<cfinvoke Component="#Application.billingMapping#data.PayflowTemplate" Method="insertPayflowTemplate" ReturnVariable="isPayflowTemplateInserted">
						<cfinvokeargument Name="payflowID" Value="#URL.payflowID#">
						<cfinvokeargument Name="userID" Value="#Session.userID#">
						<cfinvokeargument Name="templateID" Value="#Form["templateID_#type##count1#"]#">
						<cfinvokeargument Name="payflowTemplateType" Value="#type#">
						<cfinvokeargument Name="payflowTemplatePaymentMethod" Value="#Form["payflowTemplatePaymentMethod_#type##count1#"]#">
						<cfinvokeargument Name="payflowTemplateNotifyMethod" Value="#Form["payflowTemplateNotifyMethod_#type##count1#"]#">
						<cfinvokeargument Name="payflowTemplateStatus" Value="1">
					</cfinvoke>
				</cfif>
			</cfloop>
		</cfloop>

		<cflocation url="index.cfm?method=payflow.#Variables.doAction##Variables.urlParameters#&payflowID=#URL.payflowID#&confirm_payflow=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfif Variables.doAction is "listPayflowTemplates">
	<cfset Variables.formAction = "">
</cfif>

<cfinclude template="../../view/v_payflow/form_insertPayflowTemplate.cfm">

