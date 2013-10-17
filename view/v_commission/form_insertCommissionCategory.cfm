<cfoutput>
<form method="post" name="#Variables.formName#" action="#Variables.formAction#">
<cfif Variables.formAction is not "">
	<input type="hidden" name="isFormSubmitted" value="True">
</cfif>

<table border="0" cellspacing="0" cellpadding="3" class="TableText">
<cfif Variables.formAction is not "">
	<tr>
		<th colspan="2" height="50" valign="middle"><input type="submit" name="submitCommissionCategory" value="Update Commission Category(s)"></th>
	</tr>
</cfif>
<tr valign="bottom" class="TableHeader">
	<th align="left">&nbsp; &nbsp; &nbsp; &nbsp; Category Name</th>
	<th>Product<br>Listings?</th>
	<th>&nbsp; Apply to Products<br>in Category? &nbsp;</th>
	<th>Include Products in<br>Sub-Categories?</th>
</tr>

<cfloop Query="qry_selectCategoryList">
	<cfif qry_selectCategoryList.categoryHasChildren is 0><cfset folderLink = "closedFolder.gif"><cfelse><cfset folderLink = "openfolder.gif"></cfif>
	<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
	<td><cfif qry_selectCategoryList.categoryLevel gt 2>#RepeatString("<img src=""#Application.billingUrlroot#/images/vertline.gif"" width=16 height=22 border=0>", qry_selectCategoryList.categoryLevel - 2)#</cfif><cfif qry_selectCategoryList.categoryLevel is not 1><img src="#Application.billingUrlroot#/images/node.gif" width="16" height="22" alt="" border="0"></cfif><img src="#Application.billingUrlroot#/images/#folderLink#" width="24" height="22" alt="" border="0">#qry_selectCategoryList.categoryName#</td>
	<td align="center"><cfif qry_selectCategoryList.categoryAcceptListing is 1>Yes<cfelse>-</cfif></td>
	<td align="center"><input type="checkbox" name="categoryID" value="#qry_selectCategoryList.categoryID#"<cfif ListFind(Form.categoryID, qry_selectCategoryList.categoryID) is not 0> checked</cfif>></td>
	<td>
		<cfif qry_selectCategoryList.categoryHasChildren is 0>
			&nbsp;
		<cfelse>
			<label><input type="checkbox" name="categoryID_children" value="#qry_selectCategoryList.categoryID#"<cfif ListFind(Form.categoryID_children, qry_selectCategoryList.categoryID)> checked</cfif>> Include sub-categories?</label>
		</cfif>
	</td>
	</tr>
</cfloop>

<cfif Variables.formAction is not "">
	<tr>
		<th colspan="2" height="50" valign="middle"><input type="submit" name="submitCommissionCategory" value="Update Commission Category(s)"></th>
	</tr>
</cfif>
</table>

</form>
</cfoutput>
