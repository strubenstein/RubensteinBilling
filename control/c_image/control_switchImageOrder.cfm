<cfset Variables.exitURL = "index.cfm?method=#URL.control#.listImages#Variables.urlParameters#">

<cfif Not IsDefined("URL.imageID") or Not Application.fn_IsIntegerPositive(URL.imageID)>
	<cflocation url="#Variables.exitURL#&error_image=noImage" AddToken="No">
</cfif>

<cfinvoke Component="#Application.billingMapping#data.Image" Method="selectImage" ReturnVariable="qry_selectImage">
	<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
	<cfinvokeargument Name="targetID" Value="#Variables.targetID#">
	<cfinvokeargument Name="imageID" Value="#URL.imageID#">
	<cfinvokeargument Name="isSelectImageThumbnail" Value="False">
</cfinvoke>

<cfif qry_selectImage.RecordCount is 0>
	<cflocation url="#Variables.exitURL#&error_image=invalidImage" AddToken="No">
</cfif>

<cfinvoke Component="#Application.billingMapping#data.Image" Method="switchImageOrder" ReturnVariable="isImageOrderSwitched">
	<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
	<cfinvokeargument Name="targetID" Value="#Variables.targetID#">
	<cfinvokeargument Name="imageID" Value="#URL.imageID#">
	<cfinvokeargument Name="imageOrder_direction" Value="#Variables.doAction#">
</cfinvoke>

<cflocation url="#Variables.exitURL#&confirm_image=#Variables.doAction#" AddToken="No">
