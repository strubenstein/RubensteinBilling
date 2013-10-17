<cfset Variables.newStatus = Iif(Variables.doAction is "hideImage", 0, 1)>
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
<cfelseif qry_selectImage.imageStatus is Variables.newStatus>
	<cflocation url="#Variables.exitURL#&error_image=#Variables.doAction#" AddToken="No">
</cfif>

<cfloop Query="qry_selectImage">
	<cfinvoke Component="#Application.billingMapping#data.Image" Method="updateImage" ReturnVariable="isImageUpdated">
		<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
		<cfinvokeargument Name="targetID" Value="#Variables.targetID#">
		<cfinvokeargument Name="imageID" Value="#qry_selectImage.imageID#">
		<cfinvokeargument Name="imageStatus" Value="#Variables.newStatus#">
	</cfinvoke>
</cfloop>

<cflocation url="#Variables.exitURL#&confirm_image=#Variables.doAction#" AddToken="No">
