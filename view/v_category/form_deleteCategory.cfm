<cfoutput>
<p class="SubTitle">Delete Category - #qry_selectCategory.categoryName#</p>

<p class="MainText"><a href="index.cfm?method=category.listCategories" class="plainlink"><b>Do NOT Delete Category</b></a> (returns you to the list of categories)</p>

<form method="post" name="deleteCategory" action="index.cfm?method=category.deleteCategory&categoryID=#URL.categoryID#">
<input type="hidden" name="isFormSubmitted" value="True">
<input type="checkbox" name="okDelete" value="1"> Must be checked to delete category.<br>
<input type="submit" name="submitDeleteCategory" value="Delete Category">
</form>
</cfoutput>