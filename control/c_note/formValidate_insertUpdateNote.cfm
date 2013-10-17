<!--- <cfset errorMessage_fields = StructNew()> --->

<cfif Trim(Form.noteMessage) is "">
	<cfset errorMessage_fields.noteMessage = lang_insertUpdateNote.noteMessage_blank>
</cfif>

<cfset methodStruct.primaryTargetID_partner = 0>
<cfset methodStruct.targetID_partner = 0>
<cfset methodStruct.userID_partner = 0>

<cfif Form.primaryTargetKey_targetID_userID_partner is not "">
	<cfif Not ListLen(Form.primaryTargetKey_targetID_userID_partner, "_") is 3
			or Not Application.fn_IsIntegerNonNegative(ListGetAt(Form.primaryTargetKey_targetID_userID_partner, 2, "_"))
			or Not Application.fn_IsIntegerNonNegative(ListGetAt(Form.primaryTargetKey_targetID_userID_partner, 3, "_"))>
		<cfset errorMessage_fields.partnerTarget = lang_insertUpdateNote.partnerTarget_valid>
	<cfelse>
		<cfset methodStruct.testPrimaryTargetID_partner = Application.fn_GetPrimaryTargetID(ListFirst(Form.primaryTargetKey_targetID_userID_partner, "_"))>
		<cfset methodStruct.testTargetID_partner = ListGetAt(Form.primaryTargetKey_targetID_userID_partner, 2, "_")>
		<cfset methodStruct.testUserID_partner = ListGetAt(Form.primaryTargetKey_targetID_userID_partner, 3, "_")>

		<cfswitch expression="#ListFirst(Form.primaryTargetKey_targetID_userID_partner, "_")#">
		<cfcase value="affiliateID">
			<cfif methodStruct.displayAffiliate is False or methodStruct.testTargetID_partner is not qry_selectCompany.affiliateID
					or Not ListFind("0,#qry_selectAffiliateList.userID#", methodStruct.testUserID_partner)>
				<cfset errorMessage_fields.partnerTarget = lang_insertUpdateNote.partnerTarget_affiliate>
			</cfif>
		</cfcase>
		<cfcase value="cobrandID">
			<cfif methodStruct.displayCobrand is False or methodStruct.testTargetID_partner is not qry_selectCompany.cobrandID
					or Not ListFind("0,#qry_selectCobrandList.userID#", methodStruct.testUserID_partner)>
				<cfset errorMessage_fields.partnerTarget = lang_insertUpdateNote.partnerTarget_cobrand>
			</cfif>
		</cfcase>
		<cfcase value="salespersonID">
			<cfif methodStruct.displaySalesperson is False or methodStruct.testTargetID_partner is not 0
					or Not ListFind(ValueList(qry_selectCommissionCustomerList.targetID), methodStruct.testUserID_partner)>
				<cfset errorMessage_fields.partnerTarget = lang_insertUpdateNote.partnerTarget_salesperson>
			</cfif>
		</cfcase>
		<cfcase value="vendorID">
			<cfset methodStruct.vendorRow = ListFind(ValueList(qry_selectVendorList.vendorID), methodStruct.testTargetID_partner)>
			<cfif methodStruct.displayVendor is False or methodStruct.vendorRow is 0
					or Not ListFind("0,#qry_selectVendorList.userID[vendorRow]#", methodStruct.testUserID_partner)>
				<cfset errorMessage_fields.partnerTarget = lang_insertUpdateNote.partnerTarget_vendor>
			</cfif>
		</cfcase>
		<cfdefaultcase>
			<cfset errorMessage_fields.partnerTarget = lang_insertUpdateNote.partnerTarget_valid>
		</cfdefaultcase>
		</cfswitch>

		<cfif Not StructKeyExists(errorMessage_fields, "partnerTarget")>
			<cfset methodStruct.primaryTargetID_partner = methodStruct.testPrimaryTargetID_partner>
			<cfset methodStruct.targetID_partner = methodStruct.testTargetID_partner>
			<cfset methodStruct.userID_partner = methodStruct.testUserID_partner>
		</cfif>
	</cfif>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset methodStruct.isAllFormFieldsOk = True>
<cfelse>
	<cfset methodStruct.isAllFormFieldsOk = False>
	<cfif Arguments.doAction is "insertNote">
		<cfset errorMessage_title = lang_insertUpdateNote.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = lang_insertUpdateNote.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = lang_insertUpdateNote.errorHeader>
	<cfset errorMessage_footer = lang_insertUpdateNote.errorFooter>
</cfif>

