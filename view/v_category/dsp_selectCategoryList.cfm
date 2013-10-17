<!--- 
Display category if level 1 or parent category is open
Display open folder if category has sub-categories that are displayed
	If open folder: link to close (including all sub-cats)
Display closed folder if category has no sub-categories or they are not currently displayed
	If closed folder and has subcategories, link to open
--->

<cfoutput>
<cfif Application.fn_IsUserAuthorized("listAllCategories") or Application.fn_IsUserAuthorized("listCategoriesManual")>
	<div class="TableText">
	<cfif Application.fn_IsUserAuthorized("listAllCategories")>
		[<a href="index.cfm?method=category.listAllCategories" class="plainlink"><cfif Variables.doAction is "listAllCategories"><b>Expand All Categories</b><cfelse>Expand All Categories</cfif></a>]
	</cfif>
	<cfif Application.fn_IsUserAuthorized("listCategoriesManual")>
		[<a href="index.cfm?method=category.listCategoriesManual" class="plainlink"><cfif Variables.doAction is "listCategoriesManual"><b>Display Categories In Manual Order</b><cfelse>Display Categories In Manual Order</cfif></a>]
	</cfif>
	</div>
</cfif>

#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.categoryColumnCount, 0, 0, 0, Variables.categoryColumnList, "", True)#
<cfloop Query="qry_selectCategoryList">
	<cfif qry_selectCategoryList.categoryLevel is 1 or ListFind(URL.categoryID_expand, qry_selectCategoryList.categoryID_parent) or IsDefined("URL.showAll")>
		<cfset currentRowCount = currentRowCount + 1>
		<cfif qry_selectCategoryList.categoryHasChildren is 0><!--- no subcategories / closed folder with no link --->
			<cfset folderLink = "<img src=""#Application.billingUrlroot#/images/closedFolder.gif"" width=""24"" height=""22"" alt="""" border=""0"">">
		<cfelseif Not ListFind(URL.categoryID_expand, qry_selectCategoryList.categoryID)><!--- closed folder with link to open --->
			<cfset folderLink = "<a href=""index.cfm?method=category.listCategories&categoryID_expand=#ListAppend(URL.categoryID_expand, qry_selectCategoryList.categoryID)#""><img src=""#Application.billingUrlroot#/images/closedFolder.gif"" width=""24"" height=""22"" alt="""" border=""0""></a>">
		<cfelse><!--- open folder with link to close --->
			<cfset newCategoryID_expand = "">
			<cfset currentCategoryID = qry_selectCategoryList.categoryID>
			<cfloop Index="catID" List="#URL.categoryID_expand#">
				<cfif Not ListFind(subcatStruct["cat#currentCategoryID#"], catID)>
					<cfset newCategoryID_expand = ListAppend(newCategoryID_expand, catID)>
				</cfif>
			</cfloop>
			<cfset folderLink = "<a href=""index.cfm?method=category.listCategories&categoryID_expand=#newCategoryID_expand#""><img src=""#Application.billingUrlroot#/images/openfolder.gif"" width=""24"" height=""22"" alt="""" border=""0""></a>">
		</cfif>

		<tr class="TableText" valign="bottom"<cfif (currentRowCount mod 2) is 0> bgcolor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (currentRowCount mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<cfif Variables.doAction is "listCategoriesManual">
			<td align="right">#qry_selectCategoryList.categoryOrder_manual#</td>
			<td>&nbsp;</td>
		</cfif>
		<td valign="center" colspan="2" align="right"><cfif qry_selectCategoryList.categoryHasChildren is 1>+<cfelse>-</cfif></td>
		<td><cfif qry_selectCategoryList.categoryLevel gt 2>#RepeatString("<img src=""#Application.billingUrlroot#/images/vertline.gif"" width=16 height=22 border=0>", qry_selectCategoryList.categoryLevel - 2)#</cfif><cfif qry_selectCategoryList.categoryLevel is not 1><img src="#Application.billingUrlroot#/images/node.gif" width="16" height="22" alt="" border="0"></cfif>#folderLink##qry_selectCategoryList.categoryName#</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectCategoryList.categoryCode is "">&nbsp;<cfelse>#qry_selectCategoryList.categoryCode#</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectCategoryList.categoryStatus is 1>Live<cfelse>Disabled</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectCategoryList.categoryAcceptListing is 1>Accepts<cfelse>-</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectCategoryList.categoryIsListed is 1>Listed<cfelse>-</cfif></td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectCategoryList.categoryDateCreated, "mm-dd-yy")#</td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectCategoryList.categoryDateUpdated, "mm-dd-yy")#</td>
		<cfif Variables.displayCategoryViewCount is True>
			<td>&nbsp;</td>
			<td>#qry_selectCategoryList.categoryViewCount#</td>
		</cfif>
		<cfif Variables.doAction is "listCategoriesManual" and ListFind(Variables.permissionActionList, "moveCategoryDown") and ListFind(Variables.permissionActionList, "moveCategoryUp")>
			<td>&nbsp;</td>
			<td>
				<cfif CurrentRow is RecordCount>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=category.moveCategoryDown&categoryID=#qry_selectCategoryList.categoryID#"><img src="#Application.billingUrlRoot#/images/arrow_down.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
				<cfif CurrentRow is 1>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=category.moveCategoryUp&categoryID=#qry_selectCategoryList.categoryID#"><img src="#Application.billingUrlRoot#/images/arrow_up.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
			</td>
		</cfif>
		<cfif Variables.manageAction is not "">
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=category.#Variables.manageAction#&categoryID=#qry_selectCategoryList.categoryID#" class="plainlink">Manage</a></td>
		</cfif>
		<!--- 
		<cfif ListFind(Variables.permissionActionList, "updateCategory")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=category.updateCategory&categoryID=#qry_selectCategoryList.categoryID#" class="plainlink">Update</a></td>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "listPrices")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=category.listPrices&categoryID=#qry_selectCategoryList.categoryID#" class="plainlink">Pricing</a></td>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "deleteCategory")>
			<td>&nbsp;</td>
			<td class="SmallText">
				<cfif qry_selectCategoryList.categoryHasChildren is 1 or qry_selectCategoryList.categoryStatus is 1>
					-
				<cfelse>
					<a href="index.cfm?method=category.deleteCategory&categoryID=#qry_selectCategoryList.categoryID#" class="plainlink">Delete</a>
				</cfif>
			</td>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "insertCategory")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=category.insertCategory&categoryID_sub=#qry_selectCategoryList.categoryID#" class="plainlink">Sub-Cat</a></td>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "listProducts")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=category.listProducts&categoryID=#qry_selectCategoryList.categoryID#" class="plainlink">Products</a></td>
		</cfif>
		--->
		</tr>
	</cfif>
</cfloop>
</table>
</cfoutput>

