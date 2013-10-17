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
<cfelseif qry_selectImage.imageIsThumbnail is 0 or qry_selectImage.imageID_parent is 0>
	<cflocation url="#Variables.exitURL#&error_image=imageNotThumbnail" AddToken="No">
</cfif>

<cfinvoke Component="#Application.billingMapping#data.Image" Method="updateImage" ReturnVariable="isImageUpdated">
	<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
	<cfinvokeargument Name="targetID" Value="#Variables.targetID#">
	<cfinvokeargument Name="imageID" Value="#URL.imageID#">
	<cfinvokeargument Name="imageIsThumbnail" Value="0">
	<cfinvokeargument Name="imageID_parent" Value="0">
	<cfinvokeargument Name="imageOrder" Value="#IncrementValue(qry_selectImage.imageOrder)#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Image" Method="updateImageOrder" ReturnVariable="isImageOrderUpdated">
	<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
	<cfinvokeargument Name="targetID" Value="#Variables.targetID#">
	<cfinvokeargument Name="imageOrder" Value="#IncrementValue(qry_selectImage.imageOrder)#">
	<cfinvokeargument Name="imageOrder_direction" Value="moveImageDown">
	<cfinvokeargument Name="imageID" Value="#URL.imageID#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Image" Method="updateImage" ReturnVariable="isImageUpdated">
	<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
	<cfinvokeargument Name="targetID" Value="#Variables.targetID#">
	<cfinvokeargument Name="imageID" Value="#qry_selectImage.imageID_parent#">
	<cfinvokeargument Name="imageHasThumbnail" Value="0">
</cfinvoke>

<cflocation url="#Variables.exitURL#&confirm_image=#Variables.doAction#" AddToken="No">
