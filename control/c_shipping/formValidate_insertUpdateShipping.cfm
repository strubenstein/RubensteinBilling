<cfset errorMessage_fields = StructNew()>

<cfif Form.shippingCarrier is not "" and Not ListFind(Variables.shippingCarrierList_value, Form.shippingCarrier)>
	<cfset errorMessage_fields.shippingCarrier = Variables.lang_insertUpdateShipping.shippingCarrier>
<cfelseif Len(Form.shippingCarrierOther) gt maxlength_Shipping.shippingCarrier>
	<cfset errorMessage_fields.shippingCarrier = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateShipping.shippingCarrier_maxlength, "<<MAXLENGTH>>", maxlength_Shipping.shippingCarrier, "ALL"), "<<LEN>>", Len(Form.shippingCarrier), "ALL")>
</cfif>

<cfif Form.shippingMethod is not "" and Not ListFind(Variables.shippingMethodList_value, Form.shippingMethod)>
	<cfset errorMessage_fields.shippingMethod = Variables.lang_insertUpdateShipping.shippingMethod>
<cfelseif Len(Form.shippingMethodOther) gt maxlength_Shipping.shippingMethod>
	<cfset errorMessage_fields.shippingMethod = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateShipping.shippingMethod_maxlength, "<<MAXLENGTH>>", maxlength_Shipping.shippingMethod, "ALL"), "<<LEN>>", Len(Form.shippingMethod), "ALL")>
</cfif>

<cfif Form.shippingWeight is not "" and (Form.shippingWeight lt 0 or Not IsNumeric(Form.shippingWeight))>
	<cfset errorMessage_fields.shippingWeight = Variables.lang_insertUpdateShipping.shippingWeight_valid>
<cfelseif Find(".", Form.shippingWeight) and Len(ListLast(Form.shippingWeight, ".")) gt maxlength_Shipping.shippingWeight>
	<cfset errorMessage_fields.shippingWeight = Variables.lang_insertUpdateShipping.shippingWeight_maxlength>
</cfif>

<cfif Len(Form.shippingTrackingNumber) gt maxlength_Shipping.shippingTrackingNumber>
	<cfset errorMessage_fields.shippingTrackingNumber = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateShipping.shippingTrackingNumber_maxlength, "<<MAXLENGTH>>", maxlength_Shipping.shippingTrackingNumber, "ALL"), "<<LEN>>", Len(Form.shippingTrackingNumber), "ALL")>
</cfif>

<cfif Len(Form.shippingInstructions) gt maxlength_Shipping.shippingInstructions>
	<cfset errorMessage_fields.shippingInstructions = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateShipping.shippingInstructions_maxlength, "<<MAXLENGTH>>", maxlength_Shipping.shippingInstructions, "ALL"), "<<LEN>>", Len(Form.shippingInstructions), "ALL")>
</cfif>

<cfif Not ListFind("0,1", Form.shippingSent)>
	<cfset errorMessage_fields.shippingSent = Variables.lang_insertUpdateShipping.shippingSent>
</cfif>

<cfset Form.shippingDateSent = "">
<cfset dateBeginResponse = fn_FormValidateDateTime("begin", "shippingDateSent_date", Form.shippingDateSent_date, "shippingDateSent_hh", Form.shippingDateSent_hh, "shippingDateSent_mm", Form.shippingDateSent_mm, "shippingDateSent_tt", Form.shippingDateSent_tt)>
<cfif IsDate(dateBeginResponse)>
	<cfset Form.shippingDateSent = dateBeginResponse>
<cfelseif IsStruct(dateBeginResponse)>
	<cfloop Collection="#dateBeginResponse#" Item="field">
		<cfset errorMessage_fields["#field#"] = StructFind(dateBeginResponse, field)>
	</cfloop>
</cfif>

<cfif Not ListFind("0,1", Form.shippingReceived)>
	<cfset errorMessage_fields.shippingReceived = Variables.lang_insertUpdateShipping.shippingReceived>
</cfif>

<cfset Form.shippingDateReceived = "">
<cfset Variables.dateBeginResponse = fn_FormValidateDateTime("begin", "shippingDateReceived_date", Form.shippingDateReceived_date, "shippingDateReceived_hh", Form.shippingDateReceived_hh, "shippingDateReceived_mm", Form.shippingDateReceived_mm, "shippingDateReceived_tt", Form.shippingDateReceived_tt)>
<cfif IsDate(Variables.dateBeginResponse)>
	<cfset Form.shippingDateReceived = Variables.dateBeginResponse>
<cfelseif IsStruct(Variables.dateBeginResponse)>
	<cfloop Collection="#Variables.dateBeginResponse#" Item="field">
		<cfset errorMessage_fields["#field#"] = StructFind(Variables.dateBeginResponse, field)>
	</cfloop>
</cfif>

<cfif Not ListFind("0,1", Form.shippingStatus)>
	<cfset errorMessage_fields.shippingStatus = Variables.lang_insertUpdateShipping.shippingStatus>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertShipping">
		<cfset errorMessage_title = Variables.lang_insertUpdateShipping.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertUpdateShipping.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdateShipping.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdateShipping.errorFooter>
</cfif>

