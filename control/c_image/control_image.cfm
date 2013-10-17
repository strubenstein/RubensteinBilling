<cfparam Name="Variables.primaryTargetID" Default="0">
<cfparam Name="Variables.targetID" Default="0">
<cfparam Name="Variables.urlParameters" Default="">
<cfset Variables.formAction = Variables.doURL & Variables.urlParameters>

<cfinclude template="security_image.cfm">
<cfinclude template="../../view/v_image/nav_image.cfm">
<cfif IsDefined("URL.confirm_image")>
	<cfinclude template="../../view/v_image/confirm_image.cfm">
</cfif>
<cfif IsDefined("URL.error_image")>
	<cfinclude template="../../view/v_image/error_image.cfm">
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="listImages">
	<cfinclude template="control_listImages.cfm">
</cfcase>

<cfcase value="listImageDirectories">
	<cfinclude template="control_listImageDirectories.cfm">
</cfcase>

<cfcase value="createImageDirectory">
	<cfinclude template="control_createImageDirectory.cfm">
</cfcase>

<cfcase value="deleteImageDirectory">
	<cfinclude template="control_deleteImageDirectory.cfm">
</cfcase>

<cfcase value="insertImage"><!--- add new images --->
	<cfinclude template="control_insertImage.cfm">
</cfcase>

<cfcase value="updateImage"><!--- update existing images --->
	<cfinclude template="control_updateImage.cfm">
</cfcase>

<cfcase value="imageDisplayCategory"><!--- update existing images --->
	<cfinclude template="control_imageDisplayCategory.cfm">
</cfcase>

<cfcase value="moveImageDown,moveImageUp"><!--- change image order --->
	<cfinclude template="control_switchImageOrder.cfm">
</cfcase>

<cfcase value="hideImage,unhideImage"><!--- change image status --->
	<cfinclude template="control_hideImage.cfm">
</cfcase>

<cfcase value="separateImage"><!--- split thumbnail from image --->
	<cfinclude template="control_separateImage.cfm">
</cfcase>

<cfdefaultcase>
	<cfset URL.error_image = "invalidAction">
	<cfinclude template="../../view/v_image/error_image.cfm">
</cfdefaultcase>
</cfswitch>
