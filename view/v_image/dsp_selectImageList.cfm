<cfoutput>
<p class="MainText">Clicking on the image filename will scroll you down to the bottom of the page where the images are displayed.</p>

<table border="1" cellspacing="2" cellpadding="2">
<tr valign="bottom" class="TableHeader">
	<th>##</th>
	<th>Image<br>Filename</th>
	<th>Height<br>x Width</th>
	<th>Size<br>(k)</th>
	<th>Alternate<br>Text</th>
	<th>Up-<br>load?</th>
	<th>Created</th>
	<cfif ListFind(Variables.permissionActionList, "separateImage")>
		<th>Thumb-<br>nail?</th>
	</cfif>
	<cfif ListFind(Variables.permissionActionList, "moveImageDown") and ListFind(Variables.permissionActionList, "moveImageUp")>
		<th>Switch<br>Order</th>
	</cfif>
	<th>Current<br>Status</th>
	<cfif ListFind(Variables.permissionActionList, "hideImage") or ListFind(Variables.permissionActionList, "unhideImage")>
		<th>Change<br>Status</th>
	</cfif>
	<cfif ListFind(Variables.permissionActionList, "updateImage")>
		<th>Update</th>
	</cfif>
	<th>Display On<br>Category?</th>
</tr>

<cfset Variables.currentRowCount = 1>
<cfloop Query="qry_selectImageList">
	<cfset Variables.rowspan = 1>
	<cfif qry_selectImageList.imageHasThumbnail is 1 and CurrentRow is not RecordCount>
		<cfif qry_selectImageList.imageID is qry_selectImageList.imageID_parent[CurrentRow + 1]>
			<cfset Variables.rowspan = 2>
		</cfif>
	<cfelseif qry_selectImageList.imageIsThumbnail is 1 and CurrentRow is not 1>
		<cfif qry_selectImageList.imageID_parent is qry_selectImageList.imageID[CurrentRow - 1]>
			<cfset Variables.rowspan = 0>
		</cfif>
	</cfif>

	<cfif qry_selectImageList.imageIsThumbnail is 0 or CurrentRow is 1>
		<cfset Variables.currentRowCount = Variables.currentRowCount + 1>
	<cfelseif qry_selectImageList.imageID_parent is not qry_selectImageList.imageID[CurrentRow - 1]>
		<cfset Variables.currentRowCount = Variables.currentRowCount + 1>
	</cfif>

	<tr valign="top" class="TableText"<cfif (Variables.currentRowCount mod 2) is 0> bgcolor="f4f4ff"</cfif>>
	<cfif Variables.rowspan is not 0>
		<td rowspan="#Variables.rowspan#">#qry_selectImageList.imageOrder#</td>
	</cfif>
	<td><a href="###CurrentRow#">#ListLast(qry_selectImageList.imageURL, "/")#</a></td>
	<td>
		<cfif qry_selectImageList.imageHeight is 0>?<cfelse>#qry_selectImageList.imageHeight#</cfif>
		x
		<cfif qry_selectImageList.imageWidth is 0>?<cfelse>#qry_selectImageList.imageWidth#</cfif>
	</td>
	<td><cfif qry_selectImageList.imageSize is 0>&nbsp;<cfelse>#Round(qry_selectImageList.imageSize / 1000)#k</cfif></td>
	<td><cfif qry_selectImageList.imageAlt is "">&nbsp;<cfelse>#qry_selectImageList.imageAlt#</cfif></td>
	<td><cfif qry_selectImageList.imageUploaded is 1>Yes<cfelse>&nbsp;</cfif></td>
	<td nowrap>#DateFormat(qry_selectImageList.imageDateCreated, "mm-dd-yy")#</td>
	<cfif ListFind(Variables.permissionActionList, "separateImage")>
		<td class="SmallText"><cfif qry_selectImageList.imageIsThumbnail is 0>&nbsp;<cfelse><a href="index.cfm?method=#URL.control#.separateImage#Variables.urlParameters#&imageID=#qry_selectImageList.imageID#">Separate</a></cfif></td>
	</cfif>
	<cfif Variables.rowspan is not 0>
		<cfif ListFind(Variables.permissionActionList, "moveImageDown") and ListFind(Variables.permissionActionList, "moveImageUp")>
			<td rowspan="#Variables.rowspan#">
				<cfif CurrentRow is RecordCount or (CurrentRow is DecrementValue(RecordCount) and Variables.rowspan is 2)>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=#URL.control#.moveImageDown#Variables.urlParameters#&imageID=#qry_selectImageList.imageID#"><img src="#Application.billingUrlRoot#/images/arrow_down.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
				<cfif CurrentRow is 1>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=#URL.control#.moveImageUp#Variables.urlParameters#&imageID=#qry_selectImageList.imageID#"><img src="#Application.billingUrlRoot#/images/arrow_up.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
			</td>
		</cfif>
		<td rowspan="#Variables.rowspan#"><cfif qry_selectImageList.imageStatus is 1>Live<cfelse>Hidden</cfif></td>
		<cfif ListFind(Variables.permissionActionList, "hideImage") or ListFind(Variables.permissionActionList, "unhideImage")>
			<td rowspan="#Variables.rowspan#" class="SmallText">
				<cfif qry_selectImageList.imageStatus is 1 and ListFind(Variables.permissionActionList, "hideImage")>
					<a href="index.cfm?method=#URL.control#.hideImage#Variables.urlParameters#&imageID=#qry_selectImageList.imageID#" class="plainlink">Hide</a>
				<cfelseif qry_selectImageList.imageStatus is 0 and ListFind(Variables.permissionActionList, "unhideImage")>
					<a href="index.cfm?method=#URL.control#.unhideImage#Variables.urlParameters#&imageID=#qry_selectImageList.imageID#" class="plainlink">Unhide</a>
				</cfif>
			</td>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "updateImage")>
			<td rowspan="#Variables.rowspan#" class="SmallText"><a href="index.cfm?method=#URL.control#.updateImage#Variables.urlParameters#&imageID=#qry_selectImageList.imageID#" class="plainlink">Update</a></td>
		</cfif>
	</cfif>
	<td class="SmallText" nowrap>
		<font class="TableText"><cfif qry_selectImageList.imageDisplayCategory is 1>Yes<cfelse>No</cfif></font>&nbsp;
		<cfif ListFind(Variables.permissionActionList, "imageDisplayCategory")>
			(<a href="index.cfm?method=#URL.control#.imageDisplayCategory#Variables.urlParameters#&imageID=#qry_selectImageList.imageID#" class="plainlink"><cfif qry_selectImageList.imageDisplayCategory is 1>Un-Display<cfelse>Display</cfif></a>)
		</cfif>
	</td>
	</tr>
</cfloop>
</table>

<cfloop Query="qry_selectImageList">
	<p><a name="#CurrentRow#">#qry_selectImageList.imageOrder#.</a> #qry_selectImageList.imageURL# <cfif qry_selectImageList.imageIsThumbnail is 1> (<i>thumbnail for above image</i>)</cfif><br>
	#qry_selectImageList.imageTag#</p>
</cfloop>
</cfoutput>

