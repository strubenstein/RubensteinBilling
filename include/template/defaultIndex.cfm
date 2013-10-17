<cfinvoke Component="##Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog#" Method="selectCategoryList" ReturnVariable="qry_selectCategoryList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
	<cfif IsDefined("URL.categoryOrderByManual") and ListFindNoCase("True,False", URL.categoryOrderByManual)>
		<cfinvokeargument Name="categoryOrderByManual" Value="#URL.categoryOrderByManual#">
	</cfif>
</cfinvoke>

<cfif (qry_selectCategoryList.RecordCount mod 2) is 0>
	<cfset Variables.halfway = qry_selectCategoryList.RecordCount \ 2>
<cfelse>
	<cfset Variables.halfway = 1 + (qry_selectCategoryList.RecordCount \ 2)>
</cfif>

<table width="790" height="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
  <td colspan="4" rowspan="7" valign="top">
	<p class="SubTitle">Welcome to our online store!</p>

	<p class="MainText"><b>Please select a category below, or use the search form on the left.</b></p>

	<table border="0" cellspacing="0" cellpadding="2"><tr valign="top" class="MainText"><td>
	<cfoutput Query="qry_selectCategoryList">
		<a href="category.cfm/categoryID/#qry_selectCategoryList.categoryID#.cfm">#qry_selectCategoryList.categoryTitle#</a><br>
		<cfif CurrentRow is Variables.halfway></td><td width="15">&nbsp;</td><td></cfif>
	</cfoutput>
	</td></tr></table>

	<p class="TableText">
	<b>Category Order:</b> 
	&nbsp; &nbsp; <a href="index.cfm?categoryOrderByManual=False"><cfif Not IsDefined("URL.categoryOrderByManual") or URL.categoryOrderByManual is not True><b>Alphabetical</b><cfelse>Alphabetical</cfif></a> | 
	&nbsp; &nbsp; <a href="index.cfm?categoryOrderByManual=True"><cfif IsDefined("URL.categoryOrderByManual") and URL.categoryOrderByManual is True><b>As Listed In Catalog</b><cfelse>As Listed In Catalog</cfif></a>
	</p>
  </td>
  <!--- <th colspan="3" bgcolor="FF0000" class="SubTitle">SPECIALS</th> --->
</tr>

<!--- 
<tr>
<!--- select 5 random special items --->
<cfinclude template="../../control/c_shopping/c_shoppingCatalog/control_getSpecials.cfm">
<!--- display the 5 random special items --->
<cfinclude template="../../view/v_shopping/v_shoppingCatalog/dsp_getSpecials.cfm">

<tr>
	<td bgcolor="FF0000">&nbsp;</td>
	<td bgcolor="FF0000" align="center"><a href="specials.cfm"><font color="0000FF" size="2" face="Arial, Helvetica, sans-serif"><strong>more specials&gt;</strong></font></a></td>
	<td width="1" bgcolor="FF0000">&nbsp;</td>
</tr>
--->
</table>
