<cfdirectory Action="list" Name="qry_selectImageDirectoryList" Directory="#Variables.companyImageDirectoryPath#" Sort="dirname ASC">

<cfset Variables.imageSubDirectoryList = "">
<cfloop Query="qry_selectImageDirectoryList">
	<cfif qry_selectImageDirectoryList.type is "Dir">
		<cfset Variables.imageSubDirectoryList = ListAppend(Variables.imageSubDirectoryList, qry_selectImageDirectoryList.Name)>
	</cfif>
</cfloop>

<cfif ListFind("updateImage,updateProduct", Variables.doAction) and IsDefined("qry_selectImage") and Not IsDefined("Form.submitImage")>
	<cfloop Query="qry_selectImage">
		<cfif qry_selectImage.imageIsThumbnail is 0>
			<cfset thumb = "">
		<cfelse>
			<cfset thumb = "_thumbnail">
		</cfif>
		<cfparam Name="Form.imageURL#thumb#" Default="#qry_selectImage.imageURL#">
		<cfparam Name="Form.imageAlt#thumb#" Default="#qry_selectImage.imageAlt#">
		<cfparam Name="Form.imageHeight#thumb#" Default="#qry_selectImage.imageHeight#">
		<cfparam Name="Form.imageWidth#thumb#" Default="#qry_selectImage.imageWidth#">
		<cfparam Name="Form.imageBorder#thumb#" Default="#qry_selectImage.imageBorder#">
		<cfparam Name="Form.imageOther#thumb#" Default="#qry_selectImage.imageOther#">
		<cfparam Name="Form.imageOrder#thumb#" Default="#qry_selectImage.imageOrder#">
		<cfif Not IsDefined("Form.isFormSubmitted")>
			<cfparam Name="Form.imageDisplayCategory#thumb#" Default="#qry_selectImage.imageDisplayCategory#">
		</cfif>
		<cfif FindNoCase(Variables.companyImageDirectoryURL, qry_selectImage.imageURL) and ListLen(qry_selectImage.imageURL, "/") gt 1>
			<cfparam Name="Form.imageDirectory#thumb#" Default="#ListGetAt(qry_selectImage.imageURL, ListLen(qry_selectImage.imageURL, "/") - 1, "/")#">
		</cfif>
	</cfloop>
</cfif>

<cfparam Name="Form.imageURL" Default="">
<cfparam Name="Form.imageAlt" Default="">
<cfparam Name="Form.imageHeight" Default="">
<cfparam Name="Form.imageWidth" Default="">
<cfparam Name="Form.imageBorder" Default="0">
<cfparam Name="Form.imageOther" Default="">
<cfparam Name="Form.imageOrder" Default="0">
<cfparam Name="Form.imageDisplayCategory" Default="0">
<cfparam Name="Form.imageDirectory" Default="">

<cfparam Name="Form.imageURL_thumbnail" Default="">
<cfparam Name="Form.imageAlt_thumbnail" Default="">
<cfparam Name="Form.imageHeight_thumbnail" Default="">
<cfparam Name="Form.imageWidth_thumbnail" Default="">
<cfparam Name="Form.imageBorder_thumbnail" Default="0">
<cfparam Name="Form.imageOther_thumbnail" Default="">
<cfparam Name="Form.imageOrder_thumbnail" Default="0">
<cfparam Name="Form.imageDisplayCategory_thumbnail" Default="0">
<cfparam Name="Form.imageDirectory_thumbnail" Default="">

<cfif Form.imageHeight is 0>
	<cfset Form.imageHeight = "">
</cfif>
<cfif Form.imageWidth is 0>
	<cfset Form.imageWidth = "">
</cfif>

<cfif Form.imageHeight_thumbnail is 0>
	<cfset Form.imageHeight_thumbnail = "">
</cfif>
<cfif Form.imageWidth_thumbnail is 0>
	<cfset Form.imageWidth_thumbnail = "">
</cfif>