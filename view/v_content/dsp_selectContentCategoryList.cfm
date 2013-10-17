<cfoutput>
<cfif qry_selectContentCategoryList.RecordCount is 0>
	<p class="ErrorMessage">There are currently no content categories.</p>
<cfelse>
	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.contentCategoryColumnCount, 0, 0, 0, Variables.contentCategoryColumnList, "", True)#
	<cfloop Query="qry_selectContentCategoryList">
		<cfif qry_selectContentCategoryList.contentCategoryDescription is ""><cfset Variables.showDescription = False><cfelse><cfset Variables.showDescription = True></cfif>
		<cfif (CurrentRow mod 2) is 0><cfset Variables.bgcolor = "f4f4ff"><cfelse><cfset Variables.bgcolor = "ffffff"></cfif>
		<tr class="TableText" valign="top" id="row#CurrentRow#" bgcolor="#Variables.bgcolor#" onMouseOver="fn_toggleBgcolorOver(#CurrentRow#,'#Variables.showDescription#');" onMouseOut="fn_toggleBgcolorOut(#CurrentRow#,'#Variables.showDescription#','#Variables.bgcolor#');">
		<td>#qry_selectContentCategoryList.contentCategoryOrder#</td>
		<td>&nbsp;</td>
		<td>#qry_selectContentCategoryList.contentCategoryName#<cfif qry_selectContentCategoryList.contentCategoryCode is not ""><br><i>#qry_selectContentCategoryList.contentCategoryCode#</i></cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectContentCategoryList.contentCategoryStatus is 1>Active<cfelse>Inactive</cfif></td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectContentCategoryList.contentCategoryDateCreated, "mm-dd-yy")#</td>
		<cfif ListFind(Variables.permissionActionList, "moveContentCategoryDown") and ListFind(Variables.permissionActionList, "moveContentCategoryUp")>
			<td>&nbsp;</td>
			<td>
				<cfif CurrentRow is RecordCount>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=content.moveContentCategoryDown&contentCategoryID=#qry_selectContentCategoryList.contentCategoryID#"><img src="#Application.billingUrlRoot#/images/arrow_down.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
				<cfif CurrentRow is 1>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=content.moveContentCategoryUp&contentCategoryID=#qry_selectContentCategoryList.contentCategoryID#"><img src="#Application.billingUrlRoot#/images/arrow_up.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
			</td>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "updateContentCategory") or ListFind(Variables.permissionActionList, "deleteContentCategory")>
			<td>&nbsp;</td>
			<td class="SmallText">
				<cfif ListFind(Variables.permissionActionList, "updateContentCategory")>
					<a href="index.cfm?method=content.updateContentCategory&contentCategoryID=#qry_selectContentCategoryList.contentCategoryID#" class="plainlink">Update</a><br>
				</cfif>
				<cfif qry_selectContentCategoryList.contentCount is 0 and ListFind(Variables.permissionActionList, "deleteContentCategory")>
					<a href="index.cfm?method=content.deleteContentCategory&contentCategoryID=#qry_selectContentCategoryList.contentCategoryID#" class="plainlink">Delete</a>
				</cfif>
			</td>
		</cfif>
		<td>&nbsp;</td>
		<td>#qry_selectContentCategoryList.contentCount#</td>
		<cfif ListFind(Variables.permissionActionList, "listContent") or ListFind(Variables.permissionActionList, "viewContentCompany")>
			<td>&nbsp;</td>
			<td class="SmallText">
				<cfif qry_selectContentCategoryList.contentCount is 0>
					-<br>-
				<cfelse>
					<cfif ListFind(Variables.permissionActionList, "listContent")>
						<a href="index.cfm?method=content.listContent&contentCategoryID=#qry_selectContentCategoryList.contentCategoryID#" class="plainlink">View Listings</a><br>
					</cfif>
					<cfif ListFind(Variables.permissionActionList, "viewContentCompany")>
						<a href="index.cfm?method=content.viewContentCompany&contentCategoryID=#qry_selectContentCategoryList.contentCategoryID#" class="plainlink"><i>Preview Content</i></a>
					</cfif>
				</cfif>
			</td>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "insertContent") or ListFind(Variables.permissionActionList, "insertContentCompany")>
			<td>&nbsp;</td>
			<td class="SmallText">
				<cfif ListFind(Variables.permissionActionList, "insertContent")>
					<a href="index.cfm?method=content.insertContent&contentCategoryID=#qry_selectContentCategoryList.contentCategoryID#" class="plainlink">Add Listing</a><br>
				</cfif>
				<cfif ListFind(Variables.permissionActionList, "insertContentCompany")>
					<cfif qry_selectContentCategoryList.contentCount is 0>-<cfelse><a href="index.cfm?method=content.insertContentCompany&contentCategoryID=#qry_selectContentCategoryList.contentCategoryID#" class="plainlink"><i>Update Content</i></a></cfif>
				</cfif>
			</td>
		</cfif>
		</tr>

		<cfif Variables.showDescription is True>
			<tr class="SmallText" valign="top" id="row#CurrentRow#a" bgcolor="#Variables.bgcolor#" onMouseOver="fn_toggleBgcolorOver(#CurrentRow#,'True');" onMouseOut="fn_toggleBgcolorOut(#CurrentRow#,'True','#Variables.bgcolor#');">
			<td colspan="2">&nbsp;</td>
			<td colspan="#Variables.contentCategoryColumnCount - 2#"><i>Description</i>: #qry_selectContentCategoryList.contentCategoryDescription#</td>
			</tr>
		</cfif>
	</cfloop>
	</table>
</cfif>
</cfoutput>

