<cfoutput>
<cfset Variables.isImageParent = False>
<cfloop Query="qry_selectImageList">
	<!--- image is thumbnail of next image --->
	<cfif qry_selectImageList.imageIsThumbnail is 0>
		<p>#qry_selectImageList.imageTag#</p>
	</cfif>
	<!--- 
	<cfif qry_selectImageList.imageIsThumbnail is 1 and CurrentRow is not RecordCount and qry_selectImageList.imageID_parent is qry_selectImageList.imageID[CurrentRow + 1]>
		<cfset Variables.isImageParent = True>
		<p class="TableText"><a href="#qry_selectImageList.imageURL[CurrentRow + 1]#" target="productImage">#qry_selectImageList.imageTag#<br>
		(Click for larger image.)</a></p>
	<cfelseif Variables.isImageParent is True><!--- image is full-sized image of previous thumbnail; do not display --->
		<cfset Variables.isImageParent = False>
	<cfelse><!--- display image (no thumbnail) --->
		<p>#qry_selectImageList.imageTag#</p>
	</cfif>
	--->
</cfloop>
</cfoutput>