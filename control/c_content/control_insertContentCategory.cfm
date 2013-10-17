<cfinvoke component="#Application.billingMapping#data.ContentCategory" method="maxlength_ContentCategory" returnVariable="maxlength_ContentCategory" />
<cfinclude template="formParam_insertUpdateContentCategory.cfm">

<cfinvoke Component="#Application.billingMapping#data.ContentCategory" Method="selectContentCategoryList" ReturnVariable="qry_selectContentCategoryList" />

<cfinclude template="../../view/v_content/lang_insertUpdateContentCategory.cfm">
<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitContentCategory")>
	<cfinclude template="formValidate_insertUpdateContentCategory.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfif qry_selectContentCategoryList.RecordCount is 0>
			<cfset Form.contentCategoryOrder = 1>
			<cfset Variables.incrementOrder = False>
		<cfelseif Form.contentCategoryOrder is not 0>
			<cfset Variables.incrementOrder = True>
		<cfelse>
			<cfset Form.contentCategoryOrder = IncrementValue(qry_selectContentCategoryList.contentCategoryOrder[qry_selectContentCategoryList.RecordCount])>
			<cfset Variables.incrementOrder = False>
		</cfif>

		<cfinvoke Component="#Application.billingMapping#data.ContentCategory" Method="insertContentCategory" ReturnVariable="contentCategoryID">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="contentCategoryName" Value="#Form.contentCategoryName#">
			<cfinvokeargument Name="contentCategoryCode" Value="#Form.contentCategoryCode#">
			<cfinvokeargument Name="contentCategoryDescription" Value="#Form.contentCategoryDescription#">
			<cfinvokeargument Name="contentCategoryStatus" Value="#Form.contentCategoryStatus#">
			<cfinvokeargument Name="contentCategoryOrder" Value="#Form.contentCategoryOrder#">
		</cfinvoke>

		<cfif Variables.incrementOrder is True>
			<cfinvoke Component="#Application.billingMapping#data.ContentCategory" Method="updateContentCategoryOrder" ReturnVariable="isContentCategoryOrderUpdated">
				<cfinvokeargument Name="contentCategoryID" Value="#contentCategoryID#">
				<cfinvokeargument Name="contentCategoryOrder_min" Value="#Form.contentCategoryOrder#">
				<cfinvokeargument Name="contentCategoryOrder_direction" Value="down">
			</cfinvoke>
		</cfif>

		<cflocation url="index.cfm?method=content.#Variables.doAction#&confirm_content=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = "index.cfm?method=content.#Variables.doAction#">
<cfset Variables.formSubmitValue = Variables.lang_insertUpdateContentCategory.formSubmitValue_insert>
<cfinclude template="../../view/v_content/form_insertUpdateContentCategory.cfm">
