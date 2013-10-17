<cfoutput>
<p>
<!--- Basic Search Form --->
<table border="0" cellspacing="0" cellpadding="2" class="TableText" width="800"><tr bgcolor="ccccff" valign="middle" id="basicSearch"<cfif Session.showAdvancedSearch is True> style="display:none;"</cfif>>
<form method="post" name="vendorListBasic" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">
<input type="hidden" name="queryOrderBy" value="#HTMLEditFormat(Form.queryOrderBy)#">
<input type="hidden" name="showAdvancedSearch" value="False">
<input type="hidden" name="searchField" value="vendorName,vendorCode,vendorURL,vendorID_custom,vendorDescription">
<td>
	Display Per Page: <input type="text" name="queryDisplayPerPage" value="#HTMLEditFormat(Form.queryDisplayPerPage)#" size="2" class="TableText"> &nbsp; &nbsp; &nbsp; &nbsp; 
	Search Text: <input type="text" name="searchText" value="#HTMLEditFormat(Form.searchText)#" size="25" class="TableText"> <input type="submit" name="submitVendorList" value="Submit">
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
		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr>
			<td colspan="2">Text Search:<br><input type="text" name="searchText" value="#HTMLEditFormat(Form.searchText)#" size="30" class="TableText"></td>
		</tr>
		<tr>
			<td>
				<label><input type="checkbox" name="searchField" value="vendordName"<cfif ListFind(Form.searchField, "vendorName")> checked</cfif>>Name</label><br>
				<label><input type="checkbox" name="searchField" value="vendorCode"<cfif ListFind(Form.searchField, "vendorCode")> checked</cfif>>Code</label><br>
				<label><input type="checkbox" name="searchField" value="vendorDescription"<cfif ListFind(Form.searchField, "vendorDescription")> checked</cfif>>Description</label><br>
			</td>
			<td valign="top">
				<label><input type="checkbox" name="searchField" value="vendorURL"<cfif ListFind(Form.searchField, "vendorURL")> checked</cfif>>URL</label><br>
				<label><input type="checkbox" name="searchField" value="vendorID_custom"<cfif ListFind(Form.searchField, "vendorID_custom")> checked</cfif>>Custom ID</label><br>
			</td>
		</tr>
		</table>
	</td>

	<td>
		<br>
		<cfif qry_selectStatusList.RecordCount is not 0>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<select name="statusID" size="1" class="SearchSelect">
			<option value="">-- SELECT CUSTOM STATUS --</option>
			<option value="0"<cfif Form.statusID is 0> selected</cfif>>-- NO SPECIFIED STATUS --</option>
			<cfloop Query="qry_selectStatusList">
				<option value="#qry_selectStatusList.statusID#"<cfif Form.statusID is qry_selectStatusList.statusID> selected</cfif>>#qry_selectStatusList.statusOrder#. #HTMLEditFormat(Left(qry_selectStatusList.statusTitle, 30))#</option>
			</cfloop>
			</select><br>
		</cfif>
		<cfif qry_selectGroupList.RecordCount is not 0>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<select name="groupID" size="1" class="SearchSelect">
			<option value="">-- SELECT GROUP --</option>
			<option value="0"<cfif Form.groupID is 0> selected</cfif>>-- NO SPECIFIED GROUP --</option>
			<cfloop Query="qry_selectGroupList">
				<option value="#qry_selectGroupList.groupID#"<cfif Form.groupID is qry_selectGroupList.groupID> selected</cfif>>#HTMLEditFormat(Left(qry_selectGroupList.groupName, 30))#</option>
			</cfloop>
			</select><br>
		</cfif>
		<cfif Application.fn_IsUserAuthorized("exportVendors")>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<select name="vendorIsExported" size="1" class="SearchSelect">
			<option value="-1">-- SELECT EXPORT STATUS --</option>
			<option value=""<cfif Form.vendorIsExported is ""> selected</cfif>>Not Exported</option>
			<option value="0"<cfif Form.vendorIsExported is 0> selected</cfif>>Exported - Awaiting Import Confirmation</option>
			<option value="1"<cfif Form.vendorIsExported is 1> selected</cfif>>Exported - Import Confirmed</option>
			</select><br>
		</cfif>
	</td>

	<cfset Variables.booleanList_value = "vendorStatus,vendorHasCode,vendorHasCustomID,vendorHasURL,vendorHasUser,vendorNameIsCompanyName">
	<cfset Variables.booleanList_label = "Is Active,Has Code,Has Custom ID,Has URL,Has Contact,Name = Company Name">

	<td align="center">
		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr class="TableText"><th>&nbsp;</th><th>Yes&nbsp;No</th></tr>
		<cfloop Index="count" From="1" To="#ListLen(Variables.booleanList_value)#">
			<cfset thisBoolean = ListGetAt(Variables.booleanList_value, count)>
			<tr onMouseOver="bgColor='FFFFCC'" onMouseOut="bgColor='E7D8F3'"><td nowrap>&nbsp; #ListGetAt(Variables.booleanList_label, count)#</td>
			<td><input type="checkbox" name="#thisBoolean#" value="1"<cfif Form[thisBoolean] is 1> checked</cfif> onClick="javascript:checkUncheck('#thisBoolean#', 0)"><input type="checkbox" name="#thisBoolean#" value="0"<cfif Form[thisBoolean] is 0> checked</cfif> onClick="javascript:checkUncheck('#thisBoolean#', 1)"></td></tr>
			<cfif ListFind("3", count)></table></td><td align="center" valign="top"><table border="0" cellspacing="0" cellpadding="0" class="TableText"><tr class="TableText"><th>&nbsp;</th><th>Yes&nbsp;No</th></tr></cfif>
		</cfloop>
		</table>
	</td>
</tr>
<tr>
	<td colspan="5" bgcolor="ccccff" align="center">
		Display Per Page: <input type="text" name="queryDisplayPerPage" value="#HTMLEditFormat(Form.queryDisplayPerPage)#" size="2" class="TableText"> &nbsp; &nbsp; 
		<input type="submit" name="submitVendorList" value="Submit"> &nbsp; &nbsp; <input type="reset" value="Reset">
	</td>
</tr>
</form>
</table>
</p>
</cfoutput>
