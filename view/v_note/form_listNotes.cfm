<cfoutput>
<script language="Javascript" src="#Application.billingUrlroot#/js/popcalendar.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_layers.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_menu.js"></script>

<p>
<!--- Basic Search Form --->
<table border="0" cellspacing="0" cellpadding="2" class="TableText" width="800"><tr bgcolor="ccccff" valign="middle" id="basicSearch"<cfif Session.showAdvancedSearch is True> style="display:none;"</cfif>>
<form method="post" name="companyListBasic" action="#Arguments.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">
<input type="hidden" name="queryOrderBy" value="#HTMLEditFormat(Form.queryOrderBy)#">
<input type="hidden" name="showAdvancedSearch" value="False">
<input type="hidden" name="searchField" value="companyName,companyDBA,companyURL,companyID_custom">
<td>
	Display Per Page: <input type="text" name="queryDisplayPerPage" value="#HTMLEditFormat(Form.queryDisplayPerPage)#" size="2" class="TableText"> &nbsp; &nbsp; &nbsp; &nbsp; 
	Search Text: <input type="text" name="noteMessage" value="#HTMLEditFormat(Form.noteMessage)#" size="25" class="TableText"> <input type="submit" name="submitNoteList" value="Submit">
</td>
<td align="right" class="TableText">[ <a href="javascript:void(0);" class="plainlink" onClick="toggle('advancedSearch');toggle('basicSearch');">Show Advanced Search</a> ]</td>
</tr>
</form>
</table>

<!--- Advanced Search Form --->
<table border="0" cellspacing="0" cellpadding="2" class="TableText" width="800" id="advancedSearch"<cfif Session.showAdvancedSearch is False> style="display:none;"</cfif>>
<form method="post" name="#methodStruct.formName#" action="#Arguments.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">
<input type="hidden" name="queryOrderBy" value="#HTMLEditFormat(Form.queryOrderBy)#">
<input type="hidden" name="showAdvancedSearch" value="True">
<tr bgcolor="ccccff" class="MainText">
	<td><b>Advanced Search</b></td>
	<td colspan="2" align="right" class="TableText">[ <a href="javascript:void(0);" class="plainlink" onClick="toggle('advancedSearch');toggle('basicSearch');">Return to Basic Search</a> ]</td>
</tr>

<tr bgcolor="E7D8F3" valign="top">
	<td>Search Text: <input type="text" name="noteMessage" size="25" value="#HTMLEditFormat(Form.noteMessage)#"></td>
	<cfif IsDefined("qry_selectUserCompanyList_company") and qry_selectUserCompanyList_company.RecordCount is not 0>
		<td>
			Author: 
			<select name="userID_author" size="1" class="TableText">
			<option value="0">-- SELECT AUTHOR --</option>
			<cfloop Query="qry_selectUserCompanyList_company">
				<option value="#qry_selectUserCompanyList_company.userID#"<cfif Form.userID_author is qry_selectUserCompanyList_company.userID> selected</cfif>>#HTMLEditFormat(qry_selectUserCompanyList_company.lastName)#, #HTMLEditFormat(qry_selectUserCompanyList_company.firstName)#</option>
			</cfloop>
			</select>
		</td>
	</cfif>
	<td>
		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr>
			<td>From:&nbsp;</td>
			<td>#fn_FormSelectDateTime(methodStruct.formName, "noteDateFrom_date", Form.noteDateFrom_date, "noteDateFrom_hh", Form.noteDateFrom_hh, False, 0, "noteDateFrom_tt", Form.noteDateFrom_tt, True)#</td>
		</tr>
		<tr>
			<td align="right">To:&nbsp;</td>
			<td>#fn_FormSelectDateTime(methodStruct.formName, "noteDateTo_date", Form.noteDateTo_date, "noteDateTo_hh", Form.noteDateTo_hh, False, 0, "noteDateTo_tt", Form.noteDateTo_tt, True)#</td>
		</tr>
		</table>
	</td>
</tr>
<tr bgcolor="ccccff" valign="top">
	<td colspan="3" align="center">
		<b>Display Per Page:</b> <input type="text" name="queryDisplayPerPage" value="#HTMLEditFormat(Form.queryDisplayPerPage)#" size="2" class="TableText"> 
		<input type="submit" name="submitNoteList" value="Submit">
	</td>
</tr>
</form>
</table>
</p>
</cfoutput>

