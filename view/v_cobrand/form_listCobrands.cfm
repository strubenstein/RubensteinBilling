<cfoutput>
<p>
<!--- Basic Search Form --->
<table border="0" cellspacing="0" cellpadding="2" class="TableText" width="800"><tr bgcolor="ccccff" valign="middle" id="basicSearch"<cfif Session.showAdvancedSearch is True> style="display:none;"</cfif>>
<form method="post" name="cobrandListBasic" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">
<input type="hidden" name="queryOrderBy" value="#HTMLEditFormat(Form.queryOrderBy)#">
<input type="hidden" name="showAdvancedSearch" value="False">
<input type="hidden" name="searchField" value="cobrandName,cobrandCode,cobrandURL,cobrandID_custom,cobrandDomain,cobrandTitle">
<td>
	Display Per Page: <input type="text" name="queryDisplayPerPage" value="#HTMLEditFormat(Form.queryDisplayPerPage)#" size="2" class="TableText"> &nbsp; &nbsp; &nbsp; &nbsp; 
	Search Text: <input type="text" name="searchText" value="#HTMLEditFormat(Form.searchText)#" size="25" class="TableText"> <input type="submit" name="submitCobrandList" value="Submit">
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
				<label><input type="checkbox" name="searchField" value="cobrandName"<cfif ListFind(Form.searchField, "cobrandName")> checked</cfif>>Name</label><br>
				<label><input type="checkbox" name="searchField" value="cobrandTitle"<cfif ListFind(Form.searchField, "cobrandTitle")> checked</cfif>>Title</label><br>
				<label><input type="checkbox" name="searchField" value="cobrandCode"<cfif ListFind(Form.searchField, "cobrandCode")> checked</cfif>>Code</label><br>
			</td>
			<td>
				<label><input type="checkbox" name="searchField" value="cobrandURL"<cfif ListFind(Form.searchField, "cobrandURL")> checked</cfif>>URL</label><br>
				<label><input type="checkbox" name="searchField" value="cobrandID_custom"<cfif ListFind(Form.searchField, "cobrandID_custom")> checked</cfif>>Custom ID</label><br>
				<label><input type="checkbox" name="searchField" value="cobrandDomain"<cfif ListFind(Form.searchField, "cobrandDomain")> checked</cfif>>Domain</label><br>
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
		<cfif Application.fn_IsUserAuthorized("exportCobrands")>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<select name="cobrandIsExported" size="1" class="SearchSelect">
			<option value="-1">-- SELECT EXPORT STATUS --</option>
			<option value=""<cfif Form.cobrandIsExported is ""> selected</cfif>>Not Exported</option>
			<option value="0"<cfif Form.cobrandIsExported is 0> selected</cfif>>Exported - Awaiting Import Confirmation</option>
			<option value="1"<cfif Form.cobrandIsExported is 1> selected</cfif>>Exported - Import Confirmed</option>
			</select><br>
		</cfif>
	</td>

	<cfset Variables.booleanList_value = "cobrandStatus,cobrandHasCode,cobrandHasCustomID,cobrandHasURL,cobrandHasUser,cobrandNameIsCompanyName,cobrandHasCustomer,cobrandHasActiveSubscriber,cobrandHasCustomPricing,cobrandHasCommission">
	<cfset Variables.booleanList_label = "Is Active,Has Code,Has Custom ID,Has URL,Has Contact,Name = Company Name,Has Customer,Has Subscriber,Has Custom Pricing,Receives Commission">

	<td align="center">
		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr class="TableText"><th>&nbsp;</th><th>Yes&nbsp;No</th></tr>
		<cfloop Index="count" From="1" To="#ListLen(Variables.booleanList_value)#">
			<cfset thisBoolean = ListGetAt(Variables.booleanList_value, count)>
			<tr onMouseOver="bgColor='FFFFCC'" onMouseOut="bgColor='E7D8F3'"><td nowrap>&nbsp; #ListGetAt(Variables.booleanList_label, count)#</td>
			<td><input type="checkbox" name="#thisBoolean#" value="1"<cfif Form[thisBoolean] is 1> checked</cfif> onClick="javascript:checkUncheck('#thisBoolean#', 0)"><input type="checkbox" name="#thisBoolean#" value="0"<cfif Form[thisBoolean] is 0> checked</cfif> onClick="javascript:checkUncheck('#thisBoolean#', 1)"></td></tr>
			<cfif ListFind("5", count)></table></td><td align="center" valign="top"><table border="0" cellspacing="0" cellpadding="0" class="TableText"><tr class="TableText"><th>&nbsp;</th><th>Yes&nbsp;No</th></tr></cfif>
		</cfloop>
		</table>
	</td>
</tr>
<tr>
	<td colspan="5" bgcolor="ccccff" align="center">
		Display Per Page: <input type="text" name="queryDisplayPerPage" value="#HTMLEditFormat(Form.queryDisplayPerPage)#" size="2" class="TableText"> &nbsp; &nbsp; 
		<input type="submit" name="submitCobrandList" value="Submit"> &nbsp; &nbsp; <input type="reset" value="Reset">
	</td>
</tr>
</form>
</table>
</p>
</cfoutput>
