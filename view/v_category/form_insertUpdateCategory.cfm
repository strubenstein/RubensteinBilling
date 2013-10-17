<cfoutput>
<script language="JavaScript">
function setTitle () {
	if (document.insertUpdateCategory.categoryTitle.value == "")
	document.insertUpdateCategory.categoryTitle.value = document.insertUpdateCategory.categoryName.value;
}
</script>

<form method="post" name="insertUpdateCategory" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="0" cellpadding="2" class="TableText">
<tr>
	<td>Sub-Category of: </td>
	<td>
		<select name="categoryID_parent" size="1">
		<option value="0"<cfif Form.categoryID_parent is 0> selected</cfif>>-- MAIN CATEGORY --</option>
		<cfloop Query="qry_selectCategoryList">
			<option value="#qry_selectCategoryList.categoryID#"<cfif Form.categoryID_parent is qry_selectCategoryList.categoryID> selected</cfif>>#RepeatString("&nbsp;-&nbsp; ", qry_selectCategoryList.categoryLevel - 1)# #HTMLEditFormat(qry_selectCategoryList.categoryName)#</option>
		</cfloop>
		</select>
	</td>
</tr>
<cfif Variables.doAction is "insertCategory">
	<tr>
		<td>Manual Order <i>After</i>: </td>
		<td>
			<select name="categoryOrder_manual" size="1">
			<option value="0"<cfif Form.categoryOrder_manual is 0> selected</cfif>>-- CATEGORY ORDER --</option>
			<cfloop Query="qry_selectCategoryList_order">
				<option value="#IncrementValue(qry_selectCategoryList_order.categoryOrder_manual)#"<cfif Form.categoryOrder_manual is IncrementValue(qry_selectCategoryList_order.categoryOrder_manual)> selected</cfif>>#RepeatString("&nbsp;-&nbsp; ", qry_selectCategoryList_order.categoryLevel - 1)# #HTMLEditFormat(qry_selectCategoryList_order.categoryName)#</option>
			</cfloop>
			</select> (AFTER selected category)
		</td>
	</tr>
</cfif>
<tr>
	<td>Status: </td>
	<td>
		<label style="color: green"><input type="radio" name="categoryStatus" value="1"<cfif Form.categoryStatus is 1> checked</cfif>> Live</label> &nbsp; &nbsp; 
		<label style="color: red"><input type="radio" name="categoryStatus" value="0"<cfif Form.categoryStatus is not 1> checked</cfif>> Not Live</label>
	</td>
</tr>
<tr>
	<td>Accepts Listings: </td>
	<td>
		<label style="color: green"><input type="radio" name="categoryAcceptListing" value="1"<cfif Form.categoryAcceptListing is 1> checked</cfif>> Yes</label> &nbsp; &nbsp; 
		<label style="color: red"><input type="radio" name="categoryAcceptListing" value="0"<cfif Form.categoryAcceptListing is not 1> checked</cfif>> No</label>
	</td>
</tr>
<tr>
	<td>Listed On Site: </td>
	<td>
		<label style="color: green"><input type="radio" name="categoryIsListed" value="1"<cfif Form.categoryIsListed is 1> checked</cfif>> Yes</label> &nbsp; &nbsp; 
		<label style="color: red"><input type="radio" name="categoryIsListed" value="0"<cfif Form.categoryIsListed is not 1> checked</cfif>> No (for <i>special</i> categories not in basic list)</label>
	</td>
</tr>

<tr>
	<td>Category Name:&nbsp;</td>
	<td><input type="text" name="categoryName" value="#HTMLEditFormat(Form.categoryName)#" size="50" maxlength="#maxlength_Category.categoryName#" onBlur="javascript:setTitle();"></td>
</tr>
<tr>
	<td>Category Title:&nbsp;</td>
	<td><input type="text" name="categoryTitle" value="#HTMLEditFormat(Form.categoryTitle)#" size="50" maxlength="#maxlength_Category.categoryTitle#"> (as displayed to customer)</td>
</tr>
<tr>
	<td>Description:&nbsp;</td>
	<td><input type="text" name="categoryDescription" value="#HTMLEditFormat(Form.categoryDescription)#" size="50" maxlength="#maxlength_Category.categoryDescription#"> (for internal purposes only)</td>
</tr>
<tr>
	<td>Category Code:&nbsp;</td>
	<td><input type="text" name="categoryCode" value="#HTMLEditFormat(Form.categoryCode)#" size="20" maxlength="#maxlength_Category.categoryCode#"> (enables easy reference to category, e.g, &quot;new&quot; or &quot;specials&quot;)</td>
</tr>

<tr valign="top">
	<td>Template:&nbsp;</td>
	<td>
		<cfset Variables.isCurrentTemplateDisabled = True>
		<select name="templateFilename" size="1">
		<option value="">-- SELECT TEMPLATE --</option>
		<cfloop Query="qry_selectTemplateList">
			<option value="#qry_selectTemplateList.templateFilename#"<cfif Form.templateFilename is qry_selectTemplateList.templateFilename> selected<cfset Variables.isCurrentTemplateDisabled = False></cfif>>#HTMLEditFormat(qry_selectTemplateList.templateName)#</option>
		</cfloop>
		</select> (select template used to display category to customers)
		<cfif URL.categoryID is not 0 and Variables.isCurrentTemplateDisabled is True and Form.templateFilename is not "">
			<div class="MainText"><font color="red"><b>Note: The current template is no longer active. Please select another template.</b></font></div>
		</cfif>
	</td>
</tr>
<tr>
	<td>Display Products: </td>
	<td>
		<select name="itemsPerPage_or_numberOfPages" size="1">
		<option value="categoryItemsPerPage"<cfif Form.itemsPerPage_or_numberOfPages is "categoryItemsPerPage"> selected</cfif>> X items per page</option>
		<option value="categoryNumberOfPages"<cfif Form.itemsPerPage_or_numberOfPages is "categoryNumberOfPages"> selected</cfif>> X pages total</option>
		</select> 
		<input type="text" name="itemsOrPages_value" value="#HTMLEditFormat(Form.itemsOrPages_value)#" size="5">
	</td>
</tr>

<tr><td>&nbsp;</td></tr>
<tr>
	<td>Category Header:&nbsp;</td>
	<td>
		<select name="categoryHeaderHtml" size="1">
		<option value="0"<cfif Form.categoryHeaderHtml is not 1> selected</cfif>>text</option>
		<option value="1"<cfif Form.categoryHeaderHtml is 1> selected</cfif>>html</option>
		</select> (select format type)
	</td>
</tr>
<tr>
	<td colspan="2"><textarea name="categoryHeader" rows="12" cols="80">#HTMLEditFormat(Form.categoryHeader)#</textarea></td>
</tr>

<tr><td>&nbsp;</td></tr>
<tr>
	<td>Category Footer:&nbsp;</td>
	<td>
		<select name="categoryFooterHtml" size="1">
		<option value="0"<cfif Form.categoryFooterHtml is not 1> selected</cfif>>text</option>
		<option value="1"<cfif Form.categoryFooterHtml is 1> selected</cfif>>html</option>
		</select> (select format type)
	</td>
<tr>
	<td colspan="2"><textarea name="categoryFooter" rows="12" cols="80">#HTMLEditFormat(Form.categoryFooter)#</textarea></td>
</tr>

<tr>
	<td></td>
	<td><input type="submit" name="submitInsertUpdateCategory" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>
</form>
</cfoutput>

