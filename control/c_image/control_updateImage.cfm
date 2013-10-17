<cfset Variables.exitURL = "index.cfm?method=#URL.control#.listImages#Variables.urlParameters#">

<cfif Not IsDefined("URL.imageID") or Not Application.fn_IsIntegerPositive(URL.imageID)>
	<cflocation url="#Variables.exitURL#&error_image=noImage" AddToken="No">
</cfif>

<cfinvoke Component="#Application.billingMapping#data.Image" Method="selectImage" ReturnVariable="qry_selectImage">
	<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
	<cfinvokeargument Name="targetID" Value="#Variables.targetID#">
	<cfinvokeargument Name="imageID" Value="#URL.imageID#">
	<cfinvokeargument Name="isSelectImageThumbnail" Value="True">
</cfinvoke>

<cfif qry_selectImage.RecordCount is 0>
	<cflocation url="#Variables.exitURL#&error_image=invalidImage" AddToken="No">
</cfif>

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
		<cfinclude template="act_updateImage.cfm">

		<cflocation url="#Variables.exitURL#&confirm_image=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = Variables.doURL & Variables.urlParameters & "&imageID=#URL.imageID#">
<cfset Variables.formSubmitValue = Variables.lang_insertUpdateImage.formSubmitValue_update>
<cfinclude template="../../view/v_image/form_insertUpdateImage.cfm">
