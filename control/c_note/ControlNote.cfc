<cfcomponent displayName="ControlNote" hint="Manages all note requests to make it easy to access all note functions from another module">

<!---
URL variables:
noteID
userID
companyID

Session variables:
userID
companyID

Unused variables:
hideNavigation

Variables.primaryTargetID
Variables.targetID
Variables.userID
Variables.companyID
Variables.invoiceID
Variables.shippingID
Variables.urlParameters
Variables.productID
--->

<cffunction name="controlNote" access="public" output="yes" returnType="string" hint="Manages access to all note functions">
	<cfargument name="doControl" type="string" required="yes">
	<cfargument name="doAction" type="string" required="yes">
	<cfargument name="formAction" type="string" required="no" default="">
	<cfargument name="urlParameters" type="string" required="no" default="">
	<cfargument name="primaryTargetKey" type="string" required="no" default="" hint="Type of object that note is for, e.g., invoiceID. Blank means generic.">
	<cfargument name="targetID" type="numeric" required="no" default="0" hint="ID of object that note is for, i.e., the invoiceID">
	<cfargument name="primaryTargetKey_partner" type="string" required="no" default="" hint="Target type of partner that this note was recorded in reference to so that it is accessible via that partner as well.">
	<cfargument name="targetID_partner" type="numeric" required="no" default="0" hint="ID of partner that note was recorded in reference to.">
	<cfargument name="userID_partner" type="numeric" required="no" default="0" hint="Contact person at partner that note was recorded in reference to.">
	<cfargument name="userID_target" type="numeric" required="yes" default="0" hint="ID of user that note is for, e.g., the user an invoice is for">
	<cfargument name="companyID_target" type="numeric" required="no" default="0" hint="ID of company that note is for, e.g., the company an invoice is for">
	<cfargument name="hideSubnavigation" type="boolean" required="no" default="False">

	<cfset var returnValue = "">
	<cfset var methodStruct = StructNew()>
	<cfset var primaryTargetID = Application.fn_GetPrimaryTargetID(Arguments.primaryTargetKey)>
	<cfset var primaryTargetID_partner = Application.fn_GetPrimaryTargetID(Arguments.primaryTargetKey_partner)>
	<cfset var errorMessage_fields = StructNew()>
	<cfset var lang_listNotes = StructNew()>
	<cfset var lang_insertUpdateNote = StructNew()>
	<cfset var lang_listNotes_title = StructNew()>
	<cfset var listNotesStruct = StructNew()>

	<cfparam name="URL.noteID" default="0">
	<cfinclude template="security_note.cfm">

	<cfif Arguments.hideSubnavigation is False or Not IsDefined("URL.hideSubnavigation") or URL.hideSubnavigation is not "True">
		<cfinclude template="../../view/v_note/nav_note.cfm">
	</cfif>
	<cfif IsDefined("URL.confirm_note")>
		<cfinclude template="../../view/v_note/confirm_note.cfm">
	</cfif>
	<cfif IsDefined("URL.error_note")>
		<cfinclude template="../../view/v_note/error_note.cfm">
	</cfif>

	<cfswitch expression="#Arguments.doAction#">
	<cfcase value="listNotes">
		<cfinclude Template="../../include/function/fn_datetime.cfm">
		<cfinclude Template="formParam_listNotes.cfm">

		<cfinvoke Component="#Application.billingMapping#data.UserCompany" Method="selectUserCompanyList_company" ReturnVariable="qry_selectUserCompanyList_company">
			<cfinvokeargument Name="companyID" Value="#Session.companyID#">
			<cfinvokeargument Name="userCompanyStatus" Value="1">
		</cfinvoke>

		<cfset methodStruct.formName = "listNotes">

		<cfinvoke component="#Application.billingMapping#include.function.ListObjectsJS" method="listObjectsJS" returnVariable="isObjectsListed">
			<cfinvokeargument name="formName" value="#methodStruct.formName#">
		</cfinvoke>

		<cfinclude Template="../../view/v_note/form_listNotes.cfm">
		<cfinclude Template="../../view/v_note/lang_listNotes.cfm">
		<cfinclude Template="formValidate_listNotes.cfm">

		<cfif methodStruct.isAllFormFieldsOk is False>
			<cfinclude Template="../../view/error_formValidation.cfm">
		<cfelse>
			<cfset methodStruct.queryViewAction = "index.cfm?method=#Arguments.doControl#.#Arguments.doAction#&queryDisplayPerPage=#Form.queryDisplayPerPage#" & Arguments.urlParameters>

			<cfif primaryTargetID is not 0>
				<cfset listNotesStruct.primaryTargetID = primaryTargetID>
			</cfif>
			<cfif Arguments.targetID is not 0>
				<cfset listNotesStruct.targetID = targetID>
			</cfif>
			<cfloop Index="field" List="noteID,userID_author,userID_target,companyID_target">
				<cfif IsDefined("Form.#field#") and Form[field] is not 0 and Application.fn_IsIntegerList(Form[field])>
					<cfset methodStruct.queryViewAction &= "&#field#=#Form[field]#">
					<cfset listNotesStruct[field] = Form[field]>
				</cfif>
			</cfloop>
			<cfif IsDefined("Form.noteMessage") and Trim(Form.noteMessage) is not "">
				<cfset methodStruct.queryViewAction &= "&noteMessage=#URLEncodedFormat(Form.noteMessage)#">
				<cfset listNotesStruct.noteMessage = Form.noteMessage>
			</cfif>
			<cfloop Index="field" List="noteDateCreated_from,noteDateCreated_to">
				<cfif IsDefined("Form.#field#") and IsDate(Form[field])>
					<cfset methodStruct.queryViewAction &= "&#field#=#Form[field]#">
					<cfset listNotesStruct[field] = Form[field]>
				</cfif>
			</cfloop>

			<cfinvoke Component="#Application.billingMapping#data.Note" Method="selectNoteCount" ReturnVariable="qryTotalRecords" argumentCollection="#listNotesStruct#" />
			<cfinvoke Component="#Application.billingMapping#data.Note" Method="selectNoteList" ReturnVariable="qry_selectNoteList" argumentCollection="#listNotesStruct#">
				<cfinvokeargument Name="queryOrderBy" Value="#Form.queryOrderBy#">
				<cfinvokeargument Name="queryDisplayPerPage" Value="#Form.queryDisplayPerPage#">
				<cfinvokeargument Name="queryPage" Value="#Form.queryPage#">
			</cfinvoke>

			<cfset methodStruct.queryViewAction_orderBy = methodStruct.queryViewAction & "&queryOrderBy=#URLEncodedFormat(Form.queryOrderBy)#">
			<cfset methodStruct.firstRecord = (Form.queryDisplayPerPage * DecrementValue(Form.queryPage)) + 1>
			<cfset methodStruct.totalRecords = qryTotalRecords>
			<cfset methodStruct.lastRecord = Min(Form.queryDisplayPerPage * Form.queryPage, methodStruct.totalRecords)>
			<cfif (methodStruct.totalRecords mod Form.queryDisplayPerPage) is 0>
				<cfset methodStruct.totalPages = methodStruct.totalRecords \ Form.queryDisplayPerPage>
			<cfelse>
				<cfset methodStruct.totalPages = (methodStruct.totalRecords \ Form.queryDisplayPerPage) + 1>
			</cfif>

			<cfset methodStruct.columnHeaderList = lang_listNotes_title.lastName & "^" &  lang_listNotes_title.noteDateCreated
					& "^" &  lang_listNotes_title.noteMessage>
			<cfset methodStruct.columnOrderByList = "lastName^noteDateCreated^False">
			<cfset methodStruct.columnCount = DecrementValue(2 * ListLen(methodStruct.columnHeaderList, "^"))>

			<cfinclude Template="../../include/function/fn_DisplayOrderByNav.cfm">

			<cfinclude Template="../../view/v_note/dsp_listNotes.cfm">
		</cfif>
	</cfcase>

	<cfcase value="insertNote">
		<cfinclude Template="act_getNotePartners.cfm">
		<cfinclude Template="formParam_insertUpdateNote.cfm">
		<cfinclude Template="../../view/v_note/lang_insertUpdateNote.cfm">

		<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.noteMessage") and Trim(Form.noteMessage) is not "">
			<cfinclude Template="formValidate_insertUpdateNote.cfm">

			<cfif methodStruct.isAllFormFieldsOk is False>
				<cfinvoke component="#Application.billingMapping#include.function.ErrorFormValidation" method="errorFormValidation" returnVariable="isErrorDisplay">
					<cfinvokeargument name="errorMessage_fields" value="#errorMessage_fields#">
				</cfinvoke>
			<cfelse>
				<cfinvoke Component="#Application.billingMapping#data.Note" Method="insertNote" ReturnVariable="isNoteInserted">
					<cfinvokeargument Name="userID_author" Value="#Session.userID#">
					<cfinvokeargument Name="userID_target" Value="#Arguments.userID_target#">
					<cfinvokeargument Name="companyID_target" Value="#Arguments.companyID_target#">
					<cfinvokeargument Name="primaryTargetID" Value="#primaryTargetID#">
					<cfinvokeargument Name="targetID" Value="#Arguments.targetID#">
					<cfinvokeargument Name="noteMessage" Value="#Form.noteMessage#">
					<cfinvokeargument Name="noteStatus" Value="1">
					<cfinvokeargument Name="primaryTargetID_partner" Value="#primaryTargetID_partner#">
					<cfinvokeargument Name="targetID_partner" Value="#Arguments.targetID_partner#">
					<cfinvokeargument Name="userID_partner" Value="#Arguments.userID_partner#">
				</cfinvoke>

				<cflocation url="index.cfm?method=#Arguments.doControl#.#Arguments.doAction##Arguments.urlParameters#&confirm_note=#Arguments.doAction#" AddToken="No">
			</cfif>
		</cfif>

		<cfset methodStruct.formSubmitValue = lang_insertUpdateNote.formSubmitValue_insert>
		<cfinclude Template="../../view/v_note/form_insertUpdateNote.cfm">
	</cfcase>

	<cfcase value="updateNote">
		<cfinclude template="act_getNotePartners.cfm">
		<cfinclude template="formParam_insertUpdateNote.cfm">
		<cfinclude template="../../view/v_note/lang_insertUpdateNote.cfm">

		<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitNote")>
			<cfinclude Template="formValidate_insertUpdateNote.cfm">

			<cfif methodStruct.isAllFormFieldsOk is False>
				<cfinvoke component="#Application.billingMapping#include.function.ErrorFormValidation" method="errorFormValidation" returnVariable="isErrorDisplay">
					<cfinvokeargument name="errorMessage_fields" value="#errorMessage_fields#">
				</cfinvoke>
			<cfelse>
				<cfinvoke Component="#Application.billingMapping#data.Note" Method="updateNote" ReturnVariable="isNoteUpdated">
					<cfinvokeargument Name="note" Value="#URL.noteID#">
					<cfinvokeargument Name="userID_author" Value="#Session.userID#">
					<cfinvokeargument Name="primaryTargetID" Value="#primaryTargetID#">
					<cfinvokeargument Name="targetID" Value="#Arguments.targetID#">
					<cfinvokeargument Name="noteMessage" Value="#Form.noteMessage#">
					<cfinvokeargument Name="noteStatus" Value="1">
					<cfinvokeargument Name="primaryTargetID_partner" Value="#primaryTargetID_partner#">
					<cfinvokeargument Name="targetID_partner" Value="#Arguments.targetID_partner#">
					<cfinvokeargument Name="userID_partner" Value="#Arguments.userID_partner#">
				</cfinvoke>

				<cflocation url="index.cfm?method=#Arguments.doControl#.#Arguments.doAction##Arguments.urlParameters#&confirm_note=#Arguments.doAction#" AddToken="No">
			</cfif>
		</cfif>

		<cfset methodStruct.formSubmitValue = lang_insertUpdateNote.formSubmitValue_update>
		<cfset Arguments.formAction &= "&noteID=#URL.noteID#">
		<cfinclude Template="../../view/v_note/form_insertUpdateNote.cfm">
	</cfcase>

	<cfdefaultcase>
		<cfset URL.error_note = "invalidAction">
		<cfinclude template="../../view/v_note/error_note.cfm">
	</cfdefaultcase>
	</cfswitch>

	<cfreturn returnValue>
</cffunction>

</cfcomponent>
