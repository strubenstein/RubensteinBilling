<cfset Variables.exitURL = "index.cfm?method=#URL.control#.listImages#Variables.urlParameters#">

<cfif Not IsDefined("URL.imageID") or Not Application.fn_IsIntegerPositive(URL.imageID)>
	<cflocation url="#Variables.exitURL#&error_image=noImage" AddToken="No">
</cfif>

<cfinvoke Component="#Application.billingMapping#data.Image" Method="selectImageList" ReturnVariable="qry_selectImageList">
	<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
	<cfinvokeargument Name="targetID" Value="#Variables.targetID#">
</cfinvoke>

<cfset Variables.imageDisplayRow_new = ListFind(ValueList(qry_selectImageList.imageID), URL.imageID)>

<cfif Variables.imageDisplayRow_new is 0>
	<cflocation url="#Variables.exitURL#&error_image=invalidImage" AddToken="No">
<cfelseif qry_selectImageList.imageDisplayCategory[Variables.imageDisplayRow_new] is 1>
	<cfinvoke Component="#Application.billingMapping#data.Image" Method="updateImage" ReturnVariable="isImageUpdated">
		<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
		<cfinvokeargument Name="targetID" Value="#Variables.targetID#">
		<cfinvokeargument Name="imageID" Value="#URL.imageID#">
		<cfinvokeargument Name="imageDisplayCategory" Value="0">
	</cfinvoke>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Image" Method="updateImage" ReturnVariable="isImageUpdated">
		<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
		<cfinvokeargument Name="targetID" Value="#Variables.targetID#">
		<cfinvokeargument Name="imageID" Value="#URL.imageID#">
		<cfinvokeargument Name="imageDisplayCategory" Value="1">
	</cfinvoke>

	<cfset Variables.imageDisplayRow_old = 0>
	<cfloop Query="qry_selectImageList">
		<cfif qry_selectImageList.imageDisplayCategory is 1>
			<cfinvoke Component="#Application.billingMapping#data.Image" Method="updateImage" ReturnVariable="isImageUpdated">
				<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
				<cfinvokeargument Name="targetID" Value="#Variables.targetID#">
				<cfinvokeargument Name="imageID" Value="#qry_selectImageList.imageID#">
				<cfinvokeargument Name="imageDisplayCategory" Value="0">
			</cfinvoke>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

<cflocation url="#Variables.exitURL#&confirm_image=#Variables.doAction#" AddToken="No">
