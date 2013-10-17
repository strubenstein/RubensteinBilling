<cfoutput>
<script language="Javascript" src="#Application.billingUrlroot#/js/popcalendar.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_layers.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_menu.js"></script>

<p>
<!--- Basic Search Form --->
<table border="0" cellspacing="0" cellpadding="2" class="TableText" width="800"><tr bgcolor="ccccff" valign="middle" id="basicSearch"<cfif Session.showAdvancedSearch is True> style="display:none;"</cfif>>
<form method="post" name="priceListBasic" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">
<input type="hidden" name="queryOrderBy" value="#HTMLEditFormat(Form.queryOrderBy)#">
<input type="hidden" name="showAdvancedSearch" value="False">
<input type="hidden" name="searchTextType" value="contactMessage,contactSubject,newsletterDescription">
<td>
	Display Per Page: <input type="text" name="queryDisplayPerPage" value="#HTMLEditFormat(Form.queryDisplayPerPage)#" size="2" class="TableText"> &nbsp; &nbsp; &nbsp; &nbsp; 
	Search Text: <input type="text" name="searchText" value="#HTMLEditFormat(Form.searchText)#" size="25" class="TableText"> <input type="submit" name="submitNewsletterList" value="Submit">
</td>
<td align="right" class="TableText">[ <a href="javascript:void(0);" class="plainlink" onClick="toggle('advancedSearch');toggle('basicSearch');">Show Advanced Search</a> ]</td>
</tr>
</form>
</table>

<!--- Advanced Search Form --->
<table border="0" cellspacing="0" cellpadding="2" class="TableText" width="800" id="advancedSearch"<cfif Session.showAdvancedSearch is False> style="display:none;"</cfif>>
<form method="post" name="#Variables.formName#" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">
<input type="hidden" name="queryOrderBy" value="#HTMLEditFormat(Form.queryOrderBy)#">
<input type="hidden" name="showAdvancedSearch" value="True">
<tr bgcolor="ccccff" class="MainText">
	<td colspan="2"><b>Advanced Search</b></td>
	<td colspan="4" align="right" class="TableText">[ <a href="javascript:void(0);" class="plainlink" onClick="toggle('advancedSearch');toggle('basicSearch');">Return to Basic Search</a> ]</td>
</tr>

<tr bgcolor="E7D8F3" valign="top">
	<td>
		Search Text: <input type="text" name="searchText" size="20" value="#HTMLEditFormat(Form.searchText)#"><br>
		<label><input type="checkbox" name="searchTextType" value="contactMessage"<cfif ListFind(Form.searchTextType, "contactMessage")> checked</cfif>>Message</label> &nbsp; 
		<label><input type="checkbox" name="searchTextType" value="contactSubject"<cfif ListFind(Form.searchTextType, "contactSubject")> checked</cfif>>Subject</label> &nbsp; 
		<label><input type="checkbox" name="searchTextType" value="newsletterDescription"<cfif ListFind(Form.searchTextType, "newsletterDescription")> checked</cfif>>Description</label><br>

		<cfif qry_selectContactTemplateList.RecordCount is not 0>
			<select name="contactTemplateID" size="1" class="TableText">
			<option value="">-- SELECT TEMPLATE --</option>
			<option value="0"<cfif Form.contactTemplateID is 0> selected</cfif>>-- NO SPECIFIED TEMPLATE --</option>
			<cfloop Query="qry_selectContactTemplateList">
				<option value="#qry_selectContactTemplateList.contactTemplateID#"<cfif Form.contactTemplateID is qry_selectContactTemplateList.contactTemplateID> selected</cfif>>#HTMLEditFormat(qry_selectContactTemplateList.contactTemplateName)#</option>
			</cfloop>
			</select>
		</cfif>
	</td>

	<td>
		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr>
			<td>From:&nbsp;</td>
			<td>#fn_FormSelectDateTime(Variables.formName, "contactDateFrom_date", Form.contactDateFrom_date, "contactDateFrom_hh", Form.contactDateFrom_hh, False, 0, "contactDateFrom_tt", Form.contactDateFrom_tt, True)#</td>
		</tr>

		<tr>
			<td align="right">To:&nbsp;</td>
			<td>#fn_FormSelectDateTime(Variables.formName, "contactDateTo_date", Form.contactDateTo_date, "contactDateTo_hh", Form.contactDateTo_hh, False, 0, "contactDateTo_tt", Form.contactDateTo_tt, True)#</td>
		</tr>
		</table>
		<label><input type="checkbox" name="contactDateType" value="contactDateCreated"<cfif ListFind(Form.contactDateType, "contactDateCreated")> checked</cfif>>Date Started</label> &nbsp; 
		<label><input type="checkbox" name="contactDateType" value="contactDateUpdated"<cfif ListFind(Form.contactDateType, "contactDateUpdated")> checked</cfif>>Last Updated</label> &nbsp; 
		<label><input type="checkbox" name="contactDateType" value="contactDateSent"<cfif ListFind(Form.contactDateType, "contactDateSent")> checked</cfif>>Date Sent</label><br>
	</td>

	<td>
		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr class="TableText">
			<th>&nbsp;</th>
			<th>Yes&nbsp;No</th>
		</tr>
		<tr onMouseOver="bgColor='FFFFCC'" onMouseOut="bgColor='E7D8F3'">
			<td nowrap>&nbsp; Is Sent</td>
			<td><input type="checkbox" name="contactIsSent" value="1"<cfif Form.contactIsSent is 1> checked</cfif> onClick="javascript:checkUncheck('contactIsSent', 0)"><input type="checkbox" name="contactIsSent" value="0"<cfif Form.contactIsSent is 0> checked</cfif> onClick="javascript:checkUncheck('contactIsSent', 1)"></td>
		</tr>
		<tr onMouseOver="bgColor='FFFFCC'" onMouseOut="bgColor='E7D8F3'">
			<td>&nbsp; HTML Format</td>
			<td><input type="checkbox" name="contactHtml" value="1"<cfif Form.contactHtml is 1> checked</cfif> onClick="javascript:checkUncheck('contactHtml', 0)"><input type="checkbox" name="contactHtml" value="0"<cfif Form.contactHtml is 0> checked</cfif> onClick="javascript:checkUncheck('contactHtml', 1)"></td>
		</tr>
		<tr onMouseOver="bgColor='FFFFCC'" onMouseOut="bgColor='E7D8F3'">
			<td>&nbsp; Has Custom ID</td>
			<td><input type="checkbox" name="contactHasCustomID" value="1"<cfif Form.contactHasCustomID is 1> checked</cfif> onClick="javascript:checkUncheck('contactHasCustomID', 0)"><input type="checkbox" name="contactHasCustomID" value="0"<cfif Form.contactHasCustomID is 0> checked</cfif> onClick="javascript:checkUncheck('contactHasCustomID', 1)"></td>
		</tr>
		</table>
	</td>
</tr>
<tr>
	<td colspan="5" bgcolor="ccccff" align="center">
		Display Per Page: <input type="text" name="queryDisplayPerPage" value="#HTMLEditFormat(Form.queryDisplayPerPage)#" size="2" class="TableText"> &nbsp; &nbsp; 
		<input type="submit" name="submitNewsletterList" value="Submit"> &nbsp; &nbsp; <input type="reset" value="Reset">
	</td>
</tr>
</form>
</table>
</p>
</cfoutput>
