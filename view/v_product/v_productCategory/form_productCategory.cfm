<cfoutput>
<script language="Javascript" src="#Application.billingUrlroot#/js/popcalendar.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_layers.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_menu.js"></script>

<script language="JavaScript">
function toggle(target)
{ obj=(document.all) ? document.all[target] : document.getElementById(target);
  obj.style.display=(obj.style.display=='none') ? 'inline' : 'none';
}
</script>

<p class="MainText">
To specify the begin/end date that a product is included in a category, first check<br>
the checkbox to list the product in that category. The date fields will then appear.<br>
If no begin date is specified, the default is now. The end date is optional. The<br>
product is only listed in the category if checked and within the date range.
</p>

<form method="post" name="#Variables.formName#" action="#Variables.formAction#">
<cfif Variables.formAction is not "">
	<input type="hidden" name="isFormSubmitted" value="True">
</cfif>

<table border="0" cellspacing="0" cellpadding="0" class="TableText">
<cfif Variables.formAction is not "">
	<tr>
		<th colspan="2" height="50" valign="middle"><input type="submit" name="submitProductCategory" value="Update Product Category(s)"></th>
	</tr>
</cfif>
<tr valign="bottom" class="TableHeader">
	<th>Category Name</th>
	<th>&nbsp; Include? &nbsp;</th>
	<cfif Variables.switchProductCategoryOrder is True>
		<th>Change Product<br>Order in Category</th>
	</cfif>
	<th>Begin &amp; End Date/Time<div class="TableText">(appears if category is checked)</div></th>
</tr>

<cfloop Query="qry_selectCategoryList">
	<cfif qry_selectCategoryList.categoryHasChildren is 0><cfset folderLink = "closedFolder.gif"><cfelse><cfset folderLink = "openfolder.gif"></cfif>
	<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
	<td><cfif qry_selectCategoryList.categoryLevel gt 2>#RepeatString("<img src=""#Application.billingUrlroot#/images/vertline.gif"" width=16 height=22 border=0>", qry_selectCategoryList.categoryLevel - 2)#</cfif><cfif qry_selectCategoryList.categoryLevel is not 1><img src="#Application.billingUrlroot#/images/node.gif" width="16" height="22" alt="" border="0"></cfif><img src="#Application.billingUrlroot#/images/#folderLink#" width="24" height="22" alt="" border="0">#qry_selectCategoryList.categoryName#</td>
	<td align="center">
		<cfset Variables.catRow = ListFind(Form.categoryID, qry_selectCategoryList.categoryID)>
		<cfif qry_selectCategoryList.categoryAcceptListing is 0>
			-
		<cfelse>
			<input type="checkbox" name="categoryID" value="#qry_selectCategoryList.categoryID#"<cfif Variables.catRow is not 0> checked</cfif> onClick="toggle('category#qry_selectCategoryList.categoryID#')">
			<cfif qry_selectCategoryList.categoryAcceptListing is 0 and Variables.catRow is not 0> <font class="SmallText">(no longer accepts listings)</font></cfif>
		</cfif>
	</td>
	<cfif Variables.switchProductCategoryOrder is True>
		<cfif Not StructKeyExists(Variables.productCategoryOrder_categoryID, "cat#qry_selectCategoryList.categoryID#") or Variables.productCategoryOrder_categoryID["cat#qry_selectCategoryList.categoryID#"] lt 20>
			<cfset Variables.queryPage = 1>
		<cfelse>
			<cfset Variables.queryPage = Variables.productCategoryOrder_categoryID["cat#qry_selectCategoryList.categoryID#"] \ 20>
		</cfif>
		<td align="center" class="SmallText"><a href="index.cfm?method=product.listProducts&categoryID=#qry_selectCategoryList.categoryID#&queryOrderBy=productCategoryOrder&queryPage=#Variables.queryPage#" class="plainlink">Change Order</a></td>
	</cfif>
	<td id="category#qry_selectCategoryList.categoryID#" <cfif Not ListFind(Form.categoryID, qry_selectCategoryList.categoryID)> style="display:none;"</cfif>>
		Begins: #fn_FormSelectDateTime(Variables.formName, "productCategoryDateBegin#qry_selectCategoryList.categoryID#_date", Form["productCategoryDateBegin#qry_selectCategoryList.categoryID#_date"], "productCategoryDateBegin#qry_selectCategoryList.categoryID#_hh", Form["productCategoryDateBegin#qry_selectCategoryList.categoryID#_hh"], "productCategoryDateBegin#qry_selectCategoryList.categoryID#_mm", Form["productCategoryDateBegin#qry_selectCategoryList.categoryID#_mm"], "productCategoryDateBegin#qry_selectCategoryList.categoryID#_tt", Form["productCategoryDateBegin#qry_selectCategoryList.categoryID#_tt"], True)#&nbsp;<br>
		Ends: &nbsp;&nbsp; #fn_FormSelectDateTime(Variables.formName, "productCategoryDateEnd#qry_selectCategoryList.categoryID#_date", Form["productCategoryDateEnd#qry_selectCategoryList.categoryID#_date"], "productCategoryDateEnd#qry_selectCategoryList.categoryID#_hh", Form["productCategoryDateEnd#qry_selectCategoryList.categoryID#_hh"], "productCategoryDateEnd#qry_selectCategoryList.categoryID#_mm", Form["productCategoryDateEnd#qry_selectCategoryList.categoryID#_mm"], "productCategoryDateEnd#qry_selectCategoryList.categoryID#_tt", Form["productCategoryDateEnd#qry_selectCategoryList.categoryID#_tt"], True)#
	</td>
	</tr>
</cfloop>

<cfif Variables.formAction is not "">
	<tr>
		<th colspan="2" height="50" valign="middle"><input type="submit" name="submitProductCategory" value="Update Product Category(s)"></th>
	</tr>
</cfif>
</table>

</form>
</cfoutput>

