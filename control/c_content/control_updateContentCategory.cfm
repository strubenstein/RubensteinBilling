<cfinvoke Component="#Application.billingMapping#data.ContentCategory" Method="selectContentCategory" ReturnVariable="qry_selectContentCategory">
	<cfinvokeargument Name="contentCategoryID" Value="#URL.contentCategoryID#">
</cfinvoke>

<cfinvoke component="#Application.billingMapping#data.ContentCategory" method="maxlength_ContentCategory" returnVariable="maxlength_ContentCategory" />
<cfinclude template="formParam_insertUpdateContentCategory.cfm">

<cfinclude template="../../view/v_content/lang_insertUpdateContentCategory.cfm">
<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitContentCategory")>
	<cfinclude template="formValidate_insertUpdateContentCategory.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.ContentCategory" Method="updateContentCategory" ReturnVariable="isContentCategoryUpdated">
			<cfinvokeargument Name="contentCategoryID" Value="#URL.contentCategoryID#">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="contentCategoryName" Value="#Form.contentCategoryName#">
			<cfinvokeargument Name="contentCategoryCode" Value="#Form.contentCategoryCode#">
			<cfinvokeargument Name="contentCategoryDescription" Value="#Form.contentCategoryDescription#">
			<cfinvokeargument Name="contentCategoryStatus" Value="#Form.contentCategoryStatus#">
		</cfinvoke>

		<cflocation url="index.cfm?method=content.#Variables.doAction#&contentCategoryID=#URL.contentCategoryID#&confirm_content=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = "index.cfm?method=content.#Variables.doAction#&contentCategoryID=#URL.contentCategoryID#">
<cfset Variables.formSubmitValue = Variables.lang_insertUpdateContentCategory.formSubmitValue_update>
<cfinclude template="../../view/v_content/form_insertUpdateContentCategory.cfm">
