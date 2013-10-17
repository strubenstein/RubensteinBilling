<cfoutput>
<div class="SubNav">
<span class="SubNavTitle">Content Management: </span>
<cfif Application.fn_IsUserAuthorized("listContentCategories")><a href="index.cfm?method=content.listContentCategories" title="List existing content categories" class="SubNavLink<cfif Variables.doAction is "listContentCategories">On</cfif>">List Existing Content Categories</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertContentCategory")> | <a href="index.cfm?method=content.insertContentCategory" title="Create new content category" class="SubNavLink<cfif Variables.doAction is "insertContentCategory">On</cfif>">Create New Content Category</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertContent")> | <a href="index.cfm?method=content.insertContent" title="Add new content listing (to an existing category)" class="SubNavLink<cfif Variables.doAction is "insertContent" and URL.contentCategoryID is 0>On</cfif>">Create New Content Listing</a></cfif>
<cfif URL.contentCategoryID is not 0 and IsDefined("qry_selectContentCategory.contentCategoryName") and IsDefined("qry_selectContentCategory.contentCategoryCode")>
	<br><img src="#Application.billingUrlRoot#/images/grayline.jpg" width="100%" height="1" vspace="3" alt="" border="0"><br>
	<span class="SubNavObject">Content Category:</span> 
	<span class="SubNavName">#qry_selectContentCategory.contentCategoryName#<cfif qry_selectContentCategory.contentCategoryCode is not ""> (<i>#qry_selectContentCategory.contentCategoryCode#</i>)</cfif></span><br>
	<cfif Application.fn_IsUserAuthorized("updateContentCategory")><a href="index.cfm?method=content.updateContentCategory&contentCategoryID=#URL.contentCategoryID#" title="Update content category information" class="SubNavLink<cfif Variables.doAction is "updateContentCategory">On</cfif>">Update Content Category</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("listContent")><a href="index.cfm?method=content.listContent&contentCategoryID=#URL.contentCategoryID#" title="View existing listings in this content category" class="SubNavLink<cfif Variables.doAction is "listContent">On</cfif>">List Existing Content</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("insertContent")><a href="index.cfm?method=content.insertContent&contentCategoryID=#URL.contentCategoryID#" title="Add new content listing in this category" class="SubNavLink<cfif Variables.doAction is "insertContent">On</cfif>">Create New Content</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("viewContentCompany")><a href="index.cfm?method=content.viewContentCompany&contentCategoryID=#URL.contentCategoryID#" title="Preview the current version of the content listings in this category" class="SubNavLink<cfif Variables.doAction is "viewContentCompany">On</cfif>">Preview Content</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("insertContentCompany")><a href="index.cfm?method=content.insertContentCompany&contentCategoryID=#URL.contentCategoryID#" title="Update the values of the content listings in this category" class="SubNavLink<cfif Variables.doAction is "insertContentCompany">On</cfif>">Update Content</a></cfif>
</cfif>
</div><br>
</cfoutput>

