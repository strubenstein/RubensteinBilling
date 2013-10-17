<!--- separate file for extended product form --->
<cfinclude template="../../include/function/fn_images.cfm">
<cfset Variables.imageTag = fn_ImageTag(Form.imageURL, Form.imageHeight, Form.imageWidth, Form.imageAlt, Form.imageBorder, Form.imageOther)>

<!--- insert image --->
<cfif Form.imageURL is not "">
	<cfinvoke Component="#Application.billingMapping#data.Image" Method="insertImage" ReturnVariable="newImageID">
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
		<cfinvokeargument Name="imageStatus" Value="1">
		<cfinvokeargument Name="imageOrder" Value="0">
		<cfinvokeargument Name="imageHasThumbnail" Value="#Iif(Variables.isThumbnail is True, 1, 0)#">
		<cfinvokeargument Name="imageIsThumbnail" Value="0">
		<cfinvokeargument Name="imageID_parent" Value="0">
		<cfinvokeargument Name="imageUploaded" Value="#Form.imageUploaded#">
		<cfinvokeargument Name="imageDisplayCategory" Value="#Form.imageDisplayCategory#">
	</cfinvoke>
</cfif>

<cfif Variables.isThumbnail is True>
	<cfset Variables.imageTag = fn_ImageTag(Form.imageURL_thumbnail, Form.imageHeight_thumbnail, Form.imageWidth_thumbnail, Form.imageAlt_thumbnail, Form.imageBorder_thumbnail, Form.imageOther_thumbnail)>
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
		<cfinvokeargument Name="imageOrder" Value="0">
		<cfinvokeargument Name="imageHasThumbnail" Value="0">
		<cfif Form.imageURL is not "">
			<cfinvokeargument Name="imageIsThumbnail" Value="1">
			<cfinvokeargument Name="imageID_parent" Value="#newImageID#">
		<cfelse>
			<cfinvokeargument Name="imageIsThumbnail" Value="0">
			<cfinvokeargument Name="imageID_parent" Value="0">
		</cfif>
		<cfinvokeargument Name="imageUploaded" Value="#Form.imageUploaded_thumbnail#">
		<cfinvokeargument Name="imageDisplayCategory" Value="#Form.imageDisplayCategory_thumbnail#">
	</cfinvoke>
</cfif>

<cfif (Form.imageURL is not "" or Variables.isThumbnail is True)
		and URL.control is "product" and IsDefined("URL.productID") and Application.fn_IsIntegerPositive(URL.productID)>
	<cfinvoke Component="#Application.billingMapping#data.Product" Method="updateProduct" ReturnVariable="isProductUpdated">
		<cfinvokeargument Name="productID" Value="#URL.productID#">
		<cfinvokeargument Name="productHasImage" Value="1">
	</cfinvoke>
</cfif>
