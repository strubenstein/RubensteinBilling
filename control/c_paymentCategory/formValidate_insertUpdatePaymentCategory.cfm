autotype turn on/off?

<cfset errorMessage_fields = StructNew()>

<cfif Variables.doAction is "insertPaymentCategory">
	<cfif Not Application.fn_IsIntegerNonNegative(Form.paymentCategoryOrder) or Form.paymentCategoryOrder gt qry_selectPaymentCategoryList.RecordCount>
		<cfset errorMessage_fields.paymentCategoryOrder = Variables.lang_insertUpdatePaymentCategory.paymentCategoryOrder>
	</cfif>
</cfif>

<cfif Not ListFind("0,1", Form.paymentCategoryStatus)>
	<cfset errorMessage_fields.paymentCategoryStatus = Variables.lang_insertUpdatePaymentCategory.paymentCategoryStatus>
</cfif>

<cfif Trim(Form.paymentCategoryName) is "">
	<cfset errorMessage_fields.paymentCategoryName = Variables.lang_insertUpdatePaymentCategory.paymentCategoryName_blank>
<cfelseif Len(Form.paymentCategoryName) gt maxlength_PaymentCategory.paymentCategoryName>
	<cfset errorMessage_fields.paymentCategoryName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePaymentCategory.paymentCategoryName_maxlength, "<<MAXLENGTH>>", maxlength_PaymentCategory.paymentCategoryName, "ALL"), "<<LEN>>", Len(Form.paymentCategoryName), "ALL")>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.PaymentCategory" Method="checkPaymentCategoryNameIsUnique" ReturnVariable="isPaymentCategoryNameUnique">
		<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
		<cfinvokeargument Name="paymentCategoryName" Value="#Form.paymentCategoryName#">
		<cfinvokeargument Name="paymentCategoryType" Value="#URL.paymentCategoryType#">
		<cfif Variables.doAction is "updatePaymentCategory">
			<cfinvokeargument Name="paymentCategoryID" Value="#URL.paymentCategoryID#">
		</cfif>
	</cfinvoke>

	<cfif isPaymentCategoryNameUnique is False>
		<cfset errorMessage_fields.paymentCategoryName = Variables.lang_insertUpdatePaymentCategory.paymentCategoryName_unique>
	</cfif>
</cfif>

<cfif Len(Form.paymentCategoryTitle) gt maxlength_PaymentCategory.paymentCategoryTitle>
	<cfset errorMessage_fields.paymentCategoryTitle = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePaymentCategory.paymentCategoryTitle_maxlength, "<<MAXLENGTH>>", maxlength_PaymentCategory.paymentCategoryTitle, "ALL"), "<<LEN>>", Len(Form.paymentCategoryTitle), "ALL")>
</cfif>

<cfif Len(Form.paymentCategoryID_custom) gt maxlength_PaymentCategory.paymentCategoryID_custom>
	<cfset errorMessage_fields.paymentCategoryID_custom = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePaymentCategory.paymentCategoryID_custom_maxlength, "<<MAXLENGTH>>", maxlength_PaymentCategory.paymentCategoryID_custom, "ALL"), "<<LEN>>", Len(Form.paymentCategoryID_custom), "ALL")>
</cfif>

<cfloop Index="autoMethod" List="#Form.paymentCategoryAutoMethod#">
	<cfif Not ListFind(Variables.paymentMethodList_value, autoMethod)>
		<cfset errorMessage_fields.paymentCategoryAutoMethod = Variables.lang_insertUpdatePaymentCategory.paymentCategoryAutoMethod_valid>
		<cfbreak>
	<cfelseif FindNoCase(autoMethod, ValueList(qry_selectPaymentCategoryList.paymentCategoryAutoMethod))
			and (Variables.doAction is "insertPaymentCategory" or (Variables.doAction is "updatePaymentCategory" and Not ListFind(qry_selectPaymentCategory.paymentCategoryAutoMethod, autoMethod)))>
		<cfset errorMessage_fields.paymentCategoryAutoMethod = ReplaceNoCase(Variables.lang_insertUpdatePaymentCategory.paymentCategoryAutoMethod_repeat, "<<METHOD>>", autoMethod, "ALL")>
		<cfbreak>
	</cfif>
</cfloop>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertPaymentCategory">
		<cfset errorMessage_title = Variables.lang_insertUpdatePaymentCategory.errorTitle_insert>
	<cfelse><!--- updatePaymentCategory --->
		<cfset errorMessage_title = Variables.lang_insertUpdatePaymentCategory.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdatePaymentCategory.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdatePaymentCategory.errorFooter>
</cfif>

