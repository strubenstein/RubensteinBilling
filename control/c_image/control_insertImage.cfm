<cfinclude template="act_getCompanyImageDirectory.cfm">
<cfinclude template="formParam_insertUpdateImage.cfm">
<cfinvoke component="#Application.billingMapping#data.Image" method="maxlength_Image" returnVariable="maxlength_Image" />
<cfinclude template="../../view/v_image/lang_insertUpdateImage.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitImage")>
	<cfinclude template="formValidate_insertUpdateImage.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<!--- separate file for extended product form --->
		<cfinclude template="act_insertImage.cfm">

		<cflocation url="index.cfm?method=#URL.control#.insertImage#Variables.urlParameters#&confirm_image=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = "index.cfm?method=#URL.control#.#Variables.doAction##Variables.urlParameters#">
<cfset Variables.formSubmitValue = Variables.lang_insertUpdateImage.formSubmitValue_insert>
<cfinclude template="../../view/v_image/form_insertUpdateImage.cfm">
