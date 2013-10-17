<cfinclude template="../../include/function/fn_datetime.cfm">
<cfinclude template="../../view/v_shipping/var_shippingCarrierList.cfm">
<cfinclude template="../../view/v_shipping/var_shippingMethodList.cfm">

<cfinclude template="formParam_insertUpdateShipping.cfm">
<cfinvoke component="#Application.billingMapping#data.Shipping" method="maxlength_Shipping" returnVariable="maxlength_Shipping" />
<cfinclude template="../../view/v_shipping/lang_insertUpdateShipping.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitInsertShipping")>
	<cfinclude template="formValidate_insertUpdateShipping.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Shipping" Method="insertShipping" ReturnVariable="newShippingID">
			<cfif Variables.doAction is "updateShipping">
				<cfinvokeargument Name="shippingID" Value="#URL.shippingID#">
			</cfif>
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfif Form.shippingCarrier is "">
				<cfinvokeargument Name="shippingCarrier" Value="#Form.shippingCarrierOther#">
			<cfelse>
				<cfinvokeargument Name="shippingCarrier" Value="#Form.shippingCarrier#">
			</cfif>
			<cfif Form.shippingMethod is "">
				<cfinvokeargument Name="shippingMethod" Value="#Form.shippingMethodOther#">
			<cfelse>
				<cfinvokeargument Name="shippingMethod" Value="#Form.shippingMethod#">
			</cfif>
			<cfif Not IsNumeric(Form.shippingWeight)>
				<cfinvokeargument Name="shippingWeight" Value="0">
			<cfelse>
				<cfinvokeargument Name="shippingWeight" Value="#Form.shippingWeight#">
			</cfif>
			<cfinvokeargument Name="shippingTrackingNumber" Value="#Form.shippingTrackingNumber#">
			<cfinvokeargument Name="shippingInstructions" Value="#Form.shippingInstructions#">
			<cfinvokeargument Name="shippingSent" Value="#Form.shippingSent#">
			<cfinvokeargument Name="shippingDateSent" Value="#Form.shippingDateSent#">
			<cfinvokeargument Name="shippingReceived" Value="#Form.shippingReceived#">
			<cfinvokeargument Name="shippingDateReceived" Value="#Form.shippingDateReceived#">
			<cfinvokeargument Name="shippingStatus" Value="#Form.shippingStatus#">
		</cfinvoke>

		<cfif Variables.doAction is "insertShipping">
			<cfinvoke Component="#Application.billingMapping#data.Shipping" Method="insertShippingInvoice" ReturnVariable="isShippingInvoiceInserted">
				<cfinvokeargument Name="shippingID" Value="#newShippingID#">
				<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
			</cfinvoke>
		</cfif>

		<!--- check for trigger --->
		<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
			<cfinvokeargument name="companyID" value="#Session.companyID#">
			<cfinvokeargument name="doAction" value="#Variables.doAction#">
			<cfinvokeargument name="isWebService" value="False">
			<cfinvokeargument name="doControl" value="#Variables.doControl#">
			<cfinvokeargument name="primaryTargetKey" value="shippingID">
			<cfinvokeargument name="targetID" value="#URL.shippingID#">
		</cfinvoke>

		<cflocation url="#Variables.shippingActionList#&confirm_shipping=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formName = "insertShipping">
<cfif Variables.doAction is "insertShipping">
	<cfset Variables.formAction = "index.cfm?method=#URL.control#.#Variables.doAction#&invoiceID=#URL.invoiceID#">
	<cfset Variables.formSubmitValue = Variables.lang_insertUpdateShipping.formSubmitValue_insert>
<cfelse>
	<cfset Variables.formAction = "index.cfm?method=#URL.control#.#Variables.doAction#&invoiceID=#URL.invoiceID#&shippingID=#URL.shippingID#">
	<cfset Variables.formSubmitValue = Variables.lang_insertUpdateShipping.formSubmitValue_update>
</cfif>

<cfinclude template="../../view/v_shipping/form_insertUpdateShipping.cfm">
