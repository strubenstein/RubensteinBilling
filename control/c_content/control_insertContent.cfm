<cfinvoke component="#Application.billingMapping#data.Content" method="maxlength_Content" returnVariable="maxlength_Content" />
<cfinvoke component="#Application.billingMapping#data.ContentCompany" method="maxlength_ContentCompany" returnVariable="maxlength_ContentCompany" />

<cfinclude template="formParam_insertUpdateContent.cfm">
<cfinclude template="../../view/v_content/var_contentType_list.cfm">

<cfif URL.contentCategoryID is 0><!--- must select content category --->
	<cfinvoke Component="#Application.billingMapping#data.ContentCategory" Method="selectContentCategoryList" ReturnVariable="qry_selectContentCategoryList" />
	<cfif qry_selectContentCategoryList.RecordCount is 0>
		<cflocation url="index.cfm?method=content.insertContentCategory&error_content=#Variables.doAction#" AddToken="No">
	</cfif>
<cfelse><!--- category pre-selected; may select content listing order --->
	<cfinvoke Component="#Application.billingMapping#data.Content" Method="selectContentList" ReturnVariable="qry_selectContentList">
		<cfinvokeargument Name="contentCategoryID" Value="#URL.contentCategoryID#">
	</cfinvoke>
</cfif>

<cfinclude template="../../view/v_content/lang_insertUpdateContent.cfm">
<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitContent")>
	<cfinclude template="formValidate_insertUpdateContent.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfif Form.contentCategoryID is not URL.contentCategoryID>
			<cfinvoke Component="#Application.billingMapping#data.Content" Method="selectContentList" ReturnVariable="qry_selectContentList">
				<cfinvokeargument Name="contentCategoryID" Value="#Form.contentCategoryID#">
			</cfinvoke>
		</cfif>

		<cfif qry_selectContentList.RecordCount is 0>
			<cfset Form.contentOrder = 1>
			<cfset Variables.incrementOrder = False>
		<cfelseif Form.contentOrder is not 0>
			<cfset Variables.incrementOrder = True>
		<cfelse>
			<cfset Form.contentOrder = IncrementValue(qry_selectContentList.contentOrder[qry_selectContentList.RecordCount])>
			<cfset Variables.incrementOrder = False>
		</cfif>

		<cfinvoke Component="#Application.billingMapping#data.Content" Method="insertContent" ReturnVariable="contentID">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="contentName" Value="#Form.contentName#">
			<cfinvokeargument Name="contentCode" Value="#Form.contentCode#">
			<cfinvokeargument Name="contentDescription" Value="#Form.contentDescription#">
			<cfinvokeargument Name="contentStatus" Value="#Form.contentStatus#">
			<cfinvokeargument Name="contentOrder" Value="#Form.contentOrder#">
			<cfinvokeargument Name="contentCategoryID" Value="#Form.contentCategoryID#">
			<cfinvokeargument Name="contentHtmlOk" Value="#Form.contentHtmlOk#">
			<cfinvokeargument Name="contentRequired" Value="#Form.contentRequired#">
			<cfif Trim(Form.contentTypeOther) is not "">
				<cfinvokeargument Name="contentType" Value="#Form.contentTypeOther#">
			<cfelse>
				<cfinvokeargument Name="contentType" Value="#Form.contentType#">
			</cfif>
			<cfif Not IsNumeric(Form.contentMaxlength)>
				<cfinvokeargument Name="contentMaxlength" Value="0">
			<cfelse>
				<cfinvokeargument Name="contentMaxlength" Value="#Form.contentMaxlength#">
			</cfif>
			<cfinvokeargument Name="contentFilename" Value="#Form.contentFilename#">
		</cfinvoke>

		<cfif Variables.incrementOrder is True>
			<cfinvoke Component="#Application.billingMapping#data.Content" Method="updateContentOrder" ReturnVariable="isContentOrderUpdated">
				<cfinvokeargument Name="contentID" Value="#contentID#">
				<cfinvokeargument Name="contentCategoryID" Value="#contentCategoryID#">
				<cfinvokeargument Name="contentOrder_min" Value="#Form.contentOrder#">
				<cfinvokeargument Name="contentOrder_direction" Value="down">
			</cfinvoke>
		</cfif>

		<cflocation url="index.cfm?method=content.#Variables.doAction#&contentCategoryID=#Form.contentCategoryID#&confirm_content=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfinvoke Component="#Application.billingMapping#data.Content" Method="selectContentTypeList" ReturnVariable="qry_selectContentTypeList" />

<cfset Variables.formAction = "index.cfm?method=content.#Variables.doAction#&contentCategoryID=#URL.contentCategoryID#">
<cfset Variables.formSubmitValue = Variables.lang_insertUpdateContent.formSubmitValue_insert>
<cfinclude template="../../view/v_content/form_insertUpdateContent.cfm">
