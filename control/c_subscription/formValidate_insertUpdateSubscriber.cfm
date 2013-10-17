<cfset errorMessage_fields = StructNew()>

<cfif Variables.displayCompanyList is True and Not ListFind(ValueList(qry_selectUserCompanyList_user.companyID), Form.companyID)>
	<cfset errorMessage_fields.companyID = Variables.lang_insertUpdateSubscriber.companyID>
</cfif>

<cfif Form.userID is not 0 and Not ListFind(ValueList(qry_selectUserCompanyList_company.userID), Form.userID)>
	<cfset errorMessage_fields.userID = Variables.lang_insertUpdateSubscriber.userID>
</cfif>

<cfif Len(Form.subscriberName) gt maxlength_Subscriber.subscriberName>
	<cfset errorMessage_fields.subscriberName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateSubscriber.subscriberName_maxlength, "<<MAXLENGTH>>", maxlength_Subscriber.subscriberName, "ALL"), "<<LEN>>", Len(Form.subscriberName), "ALL")>
</cfif>

<cfif Len(Form.subscriberID_custom) gt maxlength_Subscriber.subscriberID_custom>
	<cfset errorMessage_fields.subscriberID_custom = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateSubscriber.subscriberID_custom_maxlength, "<<MAXLENGTH>>", maxlength_Subscriber.subscriberID_custom, "ALL"), "<<LEN>>", Len(Form.subscriberID_custom), "ALL")>
</cfif>

<cfif Not ListFind("0,1", Form.subscriberStatus)>
	<cfset errorMessage_fields.subscriberStatus = Variables.lang_insertUpdateSubscriber.subscriberStatus>
</cfif>

<cfif Not ListFind("0,1", Form.subscriberCompleted)>
	<cfset errorMessage_fields.subscriberCompleted = Variables.lang_insertUpdateSubscriber.subscriberCompleted>
</cfif>

<cfloop Index="dateField" List="#Variables.subscriberDateFieldList#">
	<cfset Form[dateField] = "">
	<cfif Form["#dateField#_date"] is not "">
		<cfset dateResponse = fn_FormValidateDateTime("begin", "#dateField#_date", Form["#dateField#_date"], "#dateField#_hh", Form["#dateField#_hh"], "#dateField#_mm", Form["#dateField#_mm"], "#dateField#_tt", Form["#dateField#_tt"])>
		<cfif IsDate(dateResponse)>
			<cfset Form[dateField] = dateResponse>
		<cfelse><!--- IsStruct(dateResponse) --->
			<cfloop Collection="#dateResponse#" Item="field">
				<cfset errorMessage_fields["#field#"] = StructFind(dateResponse, field)>
			</cfloop>
		</cfif>
	</cfif>
</cfloop>

<cfif Form.bankID is not 0 and Not ListFind(ValueList(qry_selectBankList.bankID), Form.bankID)>
	<cfset errorMessage_fields.bankID = Variables.lang_insertUpdateSubscriber.bankID>
</cfif>

<cfif Form.creditCardID is not 0 and Not ListFind(ValueList(qry_selectCreditCardList.creditCardID), Form.creditCardID)>
	<cfset errorMessage_fields.creditCardID = Variables.lang_insertUpdateSubscriber.creditCardID>
</cfif>

<cfif Form.creditCardID is not 0 and Form.bankID is not 0>
	<cfset errorMessage_fields.creditCardAndBank = Variables.lang_insertUpdateSubscriber.creditCardAndBank>
</cfif>

<cfif Form.addressID_billing is not 0 and Not ListFind(ValueList(qry_selectBillingAddressList.addressID), Form.addressID_billing)>
	<cfset errorMessage_fields.addressID_billing = Variables.lang_insertUpdateSubscriber.addressID_billing>
</cfif>
<cfif Form.addressID_shipping is not 0 and Not ListFind(ValueList(qry_selectShippingAddressList.addressID), Form.addressID_shipping)>
	<cfset errorMessage_fields.addressID_shipping = Variables.lang_insertUpdateSubscriber.addressID_shipping>
</cfif>

<!--- Validate custom fields and custom status if applicable (and not via web service) --->
<cfif GetFileFromPath(GetBaseTemplatePath()) is "index.cfm">
	<cfif isCustomFieldValueExist is True>
		<cfinvoke component="#objInsertCustomFieldValue#" method="formValidate_insertCustomFieldValue" returnVariable="errorMessageStruct_customField" />
		<cfif Not StructIsEmpty(errorMessageStruct_customField)>
			<cfset errorMessage_fields = StructAppend(errorMessage_fields, errorMessageStruct_customField)>
		</cfif>
	</cfif>

	<cfif isStatusExist is True>
		<cfinvoke component="#objInsertStatusHistory#" method="formValidate_insertStatusHistory" returnVariable="errorMessageStruct_status" />
		<cfif Not StructIsEmpty(errorMessageStruct_status)>
			<cfset errorMessage_fields = StructAppend(errorMessage_fields, errorMessageStruct_status)>
		</cfif>
	</cfif>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertSubscriber">
		<cfset errorMessage_title = Variables.lang_insertUpdateSubscriber.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertUpdateSubscriber.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdateSubscriber.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdateSubscriber.errorFooter>
</cfif>
