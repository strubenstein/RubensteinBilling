<!--- separate file for extended product form --->
<cfinclude template="../../include/function/fn_images.cfm">
<cfset Variables.imageTag = fn_ImageTag(Form.imageURL, Form.imageHeight, Form.imageWidth, Form.imageAlt, Form.imageBorder, Form.imageOther)>

<!--- update image --->
<cfif Form.imageURL is "" and URL.imageID is not 0><!--- no image, but previously existed --->
	<cfinvoke Component="#Application.billingMapping#data.Image" Method="updateImage" ReturnVariable="isImageUpdated">
		<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
		<cfinvokeargument Name="targetID" Value="#Variables.targetID#">
		<cfinvokeargument Name="imageID" Value="#URL.imageID#">
		<cfinvokeargument Name="imageStatus" Value="0">
	</cfinvoke>
	<cfset URL.imageID = 0>
<cfelseif Form.imageURL is not ""><!--- image exists --->
	<cfif URL.imageID is 0>
		<cfset Variables.imageAction = "insertImage">
	<cfelse>
		<cfset Variables.imageAction = "updateImage">
	</cfif>

	<cfinvoke Component="#Application.billingMapping#data.Image" Method="#Variables.imageAction#" ReturnVariable="newImageID">
		<cfif Variables.imageAction is "insertImage">
			<cfinvokeargument Name="imageOrder" Value="0">
		<cfelse>
			<cfinvokeargument Name="imageID" Value="#URL.imageID#">
		</cfif>
		<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
		<cfinvokeargument Name="targetID" Value="#Variables.targetID#">
		<cfinvokeargument Name="userID" Value="#Session.userID#">
		<cfinvokeargument Name="imageURL" Value="#Form.imageURL#">
		<cfinvokeargument Name="imageAlt" Value="#Form.imageAlt#">
		<cfif IsNumeric(Form.imageHeight)>
			<cfinvokeargument Name="imageHeight" Value="#Form.imageHeight#">
		</cfif>
		<cfif IsNumeric(Form.imageWidth)>
			<cfinvokeargument Name="imageWidth" Value="#Form.imageWidth#">
		</cfif>
		<cfinvokeargument Name="imageSize" Value="#Variables.imageSize#">
		<cfinvokeargument Name="imageBorder" Value="#Form.imageBorder#">
		<cfinvokeargument Name="imageWidth" Value="#Form.imageWidth#">
		<cfinvokeargument Name="imageOther" Value="#Form.imageOther#">
		<cfinvokeargument Name="imageTag" Value="#Variables.imageTag#">
		<cfinvokeargument Name="imageHasThumbnail" Value="#Iif(Variables.isThumbnail is True, 1, 0)#">
		<cfinvokeargument Name="imageIsThumbnail" Value="0">
		<cfinvokeargument Name="imageID_parent" Value="0">
		<cfinvokeargument Name="imageUploaded" Value="#Form.imageUploaded#">
		<cfinvokeargument Name="imageDisplayCategory" Value="#Form.imageDisplayCategory#">
		<cfinvokeargument Name="imageStatus" Value="1">
	</cfinvoke>

	<cfif Variables.imageAction is "insertImage">
		<cfset URL.imageID = newImageID>
	</cfif>
</cfif>

<!--- 
Thumbnail previously existed, but removed (deleteImage,updateImage hasThumbnail)
Thumbnail prevous existed, and updated (updateImage)
Thumbnail did not previously exist, and still doesn't (nothing)
Thumbnail did not previously exist, but does now (insertImage)
--->
<cfif qry_selectImage.RecordCount is 2>
	<cfset Variables.isThumbnailOriginal = True>
<cfelse>
	<cfset Variables.isThumbnailOriginal = False>
</cfif>

<cfif isThumbnail is True>
	<cfset Variables.imageTag = fn_ImageTag(Form.imageURL_thumbnail, Form.imageHeight_thumbnail, Form.imageWidth_thumbnail, Form.imageAlt_thumbnail, Form.imageBorder_thumbnail, Form.imageOther_thumbnail)>
</cfif>

<cfif Variables.isThumbnailOriginal is True><!--- previously existed --->
	<cfinvoke Component="#Application.billingMapping#data.Image" Method="updateImage" ReturnVariable="isImageUpdated">
		<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
		<cfinvokeargument Name="targetID" Value="#Variables.targetID#">
		<cfinvokeargument Name="imageID" Value="#qry_selectImage.imageID[2]#">
		<cfinvokeargument Name="userID" Value="#Session.userID#">
		<cfif isThumbnail is False>
			<cfinvokeargument Name="imageStatus" Value="0">
			<cfinvokeargument Name="imageIsThumbnail" Value="0">
			<cfinvokeargument Name="imageID_parent" Value="0">
		<cfelse>
			<cfinvokeargument Name="imageURL" Value="#Form.imageURL_thumbnail#">
			<cfinvokeargument Name="imageAlt" Value="#Form.imageAlt_thumbnail#">
			<cfif IsNumeric(Form.imageHeight_thumbnail)>
				<cfinvokeargument Name="imageHeight" Value="#Form.imageHeight_thumbnail#">
			</cfif>
			<cfif IsNumeric(Form.imageWidth_thumbnail)>
				<cfinvokeargument Name="imageWidth" Value="#Form.imageWidth_thumbnail#">
			</cfif>
			<cfinvokeargument Name="imageSize" Value="#Variables.imageSize_thumbnail#">
			<cfinvokeargument Name="imageBorder" Value="#Form.imageBorder_thumbnail#">
			<cfinvokeargument Name="imageOther" Value="#Form.imageOther_thumbnail#">
			<cfinvokeargument Name="imageTag" Value="#Variables.imageTag#">
			<cfinvokeargument Name="imageUploaded" Value="#Form.imageUploaded_thumbnail#">
			<cfinvokeargument Name="imageDisplayCategory" Value="#Form.imageDisplayCategory_thumbnail#">
			<cfif URL.imageID is 0>
				<cfinvokeargument Name="imageIsThumbnail" Value="0">
				<cfinvokeargument Name="imageID_parent" Value="0">
			</cfif>
		</cfif>
	</cfinvoke>
<cfelseif Variables.isThumbnail is True>
	<!--- insert thumbnail --->
	<cfinvoke Component="#Application.billingMapping#data.Image" Method="insertImage" ReturnVariable="newImageID_thumbnail">
		<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
		<cfinvokeargument Name="targetID" Value="#Variables.targetID#">
		<cfinvokeargument Name="userID" Value="#Session.userID#">
		<cfinvokeargument Name="imageURL" Value="#Form.imageURL_thumbnail#">
		<cfinvokeargument Name="imageAlt" Value="#Form.imageAlt_thumbnail#">
		<cfif IsNumeric(Form.imageHeight_thumbnail)>
			<cfinvokeargument Name="imageHeight" Value="#Form.imageHeight_thumbnail#">
		</cfif>
		<cfif IsNumeric(Form.imageWidth_thumbnail)>
			<cfinvokeargument Name="imageWidth" Value="#Form.imageWidth_thumbnail#">
		</cfif>
		<cfinvokeargument Name="imageSize" Value="#Variables.imageSize_thumbnail#">
		<cfinvokeargument Name="imageBorder" Value="#Form.imageBorder_thumbnail#">
		<cfinvokeargument Name="imageOther" Value="#Form.imageOther_thumbnail#">
		<cfinvokeargument Name="imageTag" Value="#Variables.imageTag#">
		<cfinvokeargument Name="imageStatus" Value="1">
		<cfif qry_selectImage.RecordCount is 0>
			<cfinvokeargument Name="imageOrder" Value="0">
		<cfelse>
			<cfinvokeargument Name="imageOrder" Value="#qry_selectImage.imageOrder[1]#">
		</cfif>
		<cfinvokeargument Name="imageHasThumbnail" Value="0">
		<cfif Form.imageURL is not "">
			<cfinvokeargument Name="imageIsThumbnail" Value="1">
			<cfinvokeargument Name="imageID_parent" Value="#URL.imageID#">
		<cfelse>
			<cfinvokeargument Name="imageIsThumbnail" Value="0">
			<cfinvokeargument Name="imageID_parent" Value="0">
		</cfif>
		<cfinvokeargument Name="imageUploaded" Value="#Form.imageUploaded_thumbnail#">
		<cfinvokeargument Name="imageDisplayCategory" Value="#Form.imageDisplayCategory_thumbnail#">
	</cfinvoke>
</cfif>
