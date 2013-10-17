<cfinvoke Component="#Application.billingMapping#data.Image" Method="selectImageList" ReturnVariable="qry_selectImageList">
	<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
	<cfinvokeargument Name="targetID" Value="#Variables.targetID#">
</cfinvoke>

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("insertImage,separateImage,moveImageDown,moveImageUp,hideImage,unhideImage,updateImage,imageDisplayCategory")>

<cfinclude template="../../view/v_image/dsp_selectImageList.cfm">
