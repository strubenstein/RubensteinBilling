<cfset errorMessage_fields = StructNew()>

<cfloop Index="count0" From="1" To="#ListLen(Variables.payflowTemplateTypeList_value)#">
	<cfset type = ListGetAt(Variables.payflowTemplateTypeList_value, count0)>
	<cfset typeLabel = ListGetAt(Variables.payflowTemplateTypeList_label, count0)>

	<cfloop Index="count1" From="1" To="#Form["#type#Count"]#">
		<!--- if no template selected, but notify and/or payment method are checked --->
		<cfif Form["templateID_#type##count1#"] is 0>
			<cfif Form["payflowTemplatePaymentMethod_#type##count1#"] is not "">
				<cfset errorMessage_fields["payflowTemplatePaymentMethod_#type##count1#"] = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertPayflowTemplate.payflowTemplatePaymentMethod_notBlank, "<<COUNT>>", count1, "ALL"), "<<TYPE>>", typeLabel, "ALL")>
			</cfif>
			<cfif Form["payflowTemplateNotifyMethod_#type##count1#"] is not "">
				<cfset errorMessage_fields["payflowTemplateNotifyMethod_#type##count1#"] = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertPayflowTemplate.payflowTemplateNotifyMethod_notBlank, "<<COUNT>>", count1, "ALL"), "<<TYPE>>", typeLabel, "ALL")>
			</cfif>

		<cfelse><!--- template is selected --->
			<cfif Not IsNumeric(Form["templateID_#type##count1#"]) or Not ListFind(ValueList(qry_selectTemplateList.templateID), Form["templateID_#type##count1#"])>
				<cfset errorMessage_fields["templateID_#type##count1#"] = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertPayflowTemplate.templateID_valid, "<<COUNT>>", count1, "ALL"), "<<TYPE>>", typeLabel, "ALL")>>
			</cfif>

			<cfif Form["payflowTemplatePaymentMethod_#type##count1#"] is "">
				<cfset errorMessage_fields["payflowTemplatePaymentMethod_#type##count1#"] = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertPayflowTemplate.payflowTemplatePaymentMethod_blank, "<<COUNT>>", count1, "ALL"), "<<TYPE>>", typeLabel, "ALL")>
			<cfelseif Len(Form["payflowTemplatePaymentMethod_#type##count1#"]) gt maxlength_PayflowTemplate.payflowTemplatePaymentMethod>
				<cfset errorMessage_fields["payflowTemplatePaymentMethod_#type##count1#"] = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(Variables.lang_insertPayflowTemplate.payflowTemplatePaymentMethod_maxlength, "<<COUNT>>", count1, "ALL"), "<<TYPE>>", typeLabel, "ALL"), "<<LEN>>", Len(Form["payflowTemplatePaymentMethod_#type##count1#"]), "ALL"), "<<MAXLENGTH>>", maxlength_PayflowTemplate.payflowTemplatePaymentMethod, "ALL")>
			<cfelse>
				<cfloop Index="thisPaymentMethod" List="#Form["payflowTemplatePaymentMethod_#type##count1#"]#">
					<cfif Not ListFind(Variables.paymentMethodList_value, thisPaymentMethod)>
						<cfset errorMessage_fields["payflowTemplatePaymentMethod_#type##count1#"] = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertPayflowTemplate.payflowTemplatePaymentMethod_valid, "<<COUNT>>", count1, "ALL"), "<<TYPE>>", typeLabel, "ALL")>
					</cfif>
				</cfloop>
			</cfif>

			<cfif Form["payflowTemplateNotifyMethod_#type##count1#"] is "">
				<cfset errorMessage_fields["payflowTemplateNotifyMethod_#type##count1#"] = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertPayflowTemplate.payflowTemplateNotifyMethod_blank, "<<COUNT>>", count1, "ALL"), "<<TYPE>>", typeLabel, "ALL")>
			<cfelseif Len(Form["payflowTemplateNotifyMethod_#type##count1#"]) gt maxlength_PayflowTemplate.payflowTemplateNotifyMethod>
				<cfset errorMessage_fields["payflowTemplateNotifyMethod_#type##count1#"] = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(Variables.lang_insertPayflowTemplate.payflowTemplateNotifyMethod_maxlength, "<<COUNT>>", count1, "ALL"), "<<TYPE>>", typeLabel, "ALL"), "<<LEN>>", Len(Form["payflowTemplateNotifyMethod_#type##count1#"]), "ALL"), "<<MAXLENGTH>>", maxlength_PayflowTemplate.payflowTemplateNotifyMethod, "ALL")>
			<cfelse>
				<cfloop Index="thisNotifyMethod" List="#Form["payflowTemplateNotifyMethod_#type##count1#"]#">
					<cfif Not ListFind(Variables.payflowTemplateNotifyMethodList_value, thisNotifyMethod)>
						<cfset errorMessage_fields["payflowTemplateNotifyMethod_#type##count1#"] = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertPayflowTemplate.payflowTemplateNotifyMethod_valid, "<<COUNT>>", count1, "ALL"), "<<TYPE>>", typeLabel, "ALL")>
					</cfif>
				</cfloop>
			</cfif>
		</cfif>
	</cfloop>
</cfloop>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfset errorMessage_title = Variables.lang_insertPayflowTemplate.errorTitle>
	<cfset errorMessage_header = Variables.lang_insertPayflowTemplate.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertPayflowTemplate.errorFooter>
</cfif>
