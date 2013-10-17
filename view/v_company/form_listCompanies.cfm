<cfoutput>
<p>
<!--- Basic Search Form --->
<table border="0" cellspacing="0" cellpadding="2" class="TableText" width="800"><tr bgcolor="ccccff" valign="middle" id="basicSearch"<cfif Session.showAdvancedSearch is True> style="display:none;"</cfif>>
<form method="post" name="companyListBasic" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">
<input type="hidden" name="queryOrderBy" value="#HTMLEditFormat(Form.queryOrderBy)#">
<input type="hidden" name="showAdvancedSearch" value="False">
<input type="hidden" name="searchField" value="companyName,companyDBA,companyURL,companyID_custom">
<td>
	Display Per Page: <input type="text" name="queryDisplayPerPage" value="#HTMLEditFormat(Form.queryDisplayPerPage)#" size="2" class="TableText"> &nbsp; &nbsp; &nbsp; &nbsp; 
	Search Text: <input type="text" name="searchText" value="#HTMLEditFormat(Form.searchText)#" size="25" class="TableText"> <input type="submit" name="submitCompanyList" value="Submit">
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
		Text Search:<br>
		<input type="text" name="searchText" value="#HTMLEditFormat(Form.searchText)#" size="30" class="TableText"><br>
		<label><input type="checkbox" name="searchField" value="companyName"<cfif ListFind(Form.searchField, "companyName")> checked</cfif>>Company Name</label><br>
		<label><input type="checkbox" name="searchField" value="companyDBA"<cfif ListFind(Form.searchField, "companyDBA")> checked</cfif>>Company DBA</label><br>
		<label><input type="checkbox" name="searchField" value="companyURL"<cfif ListFind(Form.searchField, "companyURL")> checked</cfif>>Company URL</label><br>
		<label><input type="checkbox" name="searchField" value="companyID_custom"<cfif ListFind(Form.searchField, "companyID_custom")> checked</cfif>>Custom ID</label><br>
	</td>
	<td>
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
		<cfif Not ListFind("group.insertGroupCompany,group.listGroupCompany", URL.method)>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<select name="groupID" size="1" class="SearchSelect">
			<option value="">-- SELECT GROUP --</option>
			<option value="0"<cfif Form.groupID is 0> selected</cfif>>-- NO SPECIFIED GROUP --</option>
			<cfloop Query="qry_selectGroupList">
				<option value="#qry_selectGroupList.groupID#"<cfif Form.groupID is qry_selectGroupList.groupID> selected</cfif>>#HTMLEditFormat(Left(qry_selectGroupList.groupName, 30))#</option>
			</cfloop>
			</select><br>
		</cfif>
		<cfif qry_selectAffiliateList.RecordCount is not 0>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<cfif URL.control is "affiliate" and IsDefined("qry_selectAffiliate")>
				<b><i>Affiliate</i>: #qry_selectAffiliate.affiliateName#</b><br>
			<cfelse>
				<select name="affiliateID" size="1" class="SearchSelect">
				<option value="">-- SELECT AFFILIATE --</option>
				<option value="0"<cfif Form.affiliateID is 0> selected</cfif>>-- NO SPECIFIED AFFILIATE --</option>
				<cfloop Query="qry_selectAffiliateList">
					<option value="#qry_selectAffiliateList.affiliateID#"<cfif Form.affiliateID is qry_selectAffiliateList.affiliateID> selected</cfif>>#HTMLEditFormat(Left(qry_selectAffiliateList.affiliateName, 30))#</option>
				</cfloop>
				</select><br>
			</cfif>
		</cfif>
		<cfif qry_selectCobrandList.RecordCount is not 0>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<cfif URL.control is "cobrand" and IsDefined("qry_selectCobrand")>
				<b><i>Cobrand</i>: #qry_selectCobrand.cobrandName#</b><br>
			<cfelse>
				<select name="cobrandID" size="1" class="SearchSelect">
				<option value="">-- SELECT COBRAND --</option>
				<option value="0"<cfif Form.cobrandID is 0> selected</cfif>>-- NO SPECIFIED COBRAND --</option>
				<cfloop Query="qry_selectCobrandList">
					<option value="#qry_selectCobrandList.cobrandID#"<cfif Form.cobrandID is qry_selectCobrandList.cobrandID> selected</cfif>>#HTMLEditFormat(Left(qry_selectCobrandList.cobrandName, 30))#</option>
				</cfloop>
				</select><br>
			</cfif>
		</cfif>
		<cfif Application.fn_IsUserAuthorized("exportCompanies")>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<select name="companyIsExported" size="1" class="SearchSelect">
			<option value="-1">-- SELECT EXPORT STATUS --</option>
			<option value=""<cfif Form.companyIsExported is ""> selected</cfif>>Not Exported</option>
			<option value="0"<cfif Form.companyIsExported is 0> selected</cfif>>Exported - Awaiting Import Confirmation</option>
			<option value="1"<cfif Form.companyIsExported is 1> selected</cfif>>Exported - Import Confirmed</option>
			</select><br>
		</cfif>
	</td>

	<td width="15">&nbsp;</td>

	<cfset Variables.booleanList_value = "companyStatus,companyIsCustomer,companyIsAffiliate,companyIsCobrand,companyIsVendor,companyIsTaxExempt,companyHasName,companyHasCustomID,companyHasDBA,companyHasURL,companyHasUser,companyHasMultipleUsers,companyIsActiveSubscriber,companyHasCustomPricing">
	<cfset Variables.booleanList_label = "Status is active,Is Customer,Is Affiliate,Is Cobrand,Is Vendor,Is Tax-Exempt,Has Company Name,Has Custom ID,Has DBA,Has URL,Has At Least 1 User,Has Multiple Users,Has Subscription(s),Has Custom Price">
	<!--- If Session.companyID is Application.billingSuperuserCompanyID: Is Primary Company / companyPrimary --->

	<td align="center">
		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr class="TableText"><th>&nbsp;</th><th>Yes&nbsp;No</th></tr>
		<cfloop Index="count" From="1" To="#ListLen(Variables.booleanList_value)#">
			<cfset thisBoolean = ListGetAt(Variables.booleanList_value, count)>
			<tr onMouseOver="bgColor='FFFFCC'" onMouseOut="bgColor='E7D8F3'"><td nowrap>&nbsp; #ListGetAt(Variables.booleanList_label, count)#</td>
			<td><input type="checkbox" name="#thisBoolean#" value="1"<cfif Form[thisBoolean] is 1> checked</cfif> onClick="javascript:checkUncheck('#thisBoolean#', 0)"><input type="checkbox" name="#thisBoolean#" value="0"<cfif Form[thisBoolean] is 0> checked</cfif> onClick="javascript:checkUncheck('#thisBoolean#', 1)"></td></tr>
			<cfif ListFind("8", count)></table></td><td align="center" valign="top"><table border="0" cellspacing="0" cellpadding="0" class="TableText"><tr class="TableText"><th>&nbsp;</th><th>Yes&nbsp;No</th></tr></cfif>
		</cfloop>
		</table>
	</td>
</tr>
<tr>
	<td colspan="5" bgcolor="ccccff" align="center">
		Display Per Page: <input type="text" name="queryDisplayPerPage" value="#HTMLEditFormat(Form.queryDisplayPerPage)#" size="2" class="TableText"> &nbsp; &nbsp; 
		<input type="submit" name="submitCompanyList" value="Submit"> &nbsp; &nbsp; <input type="reset" value="Reset">
	</td>
</tr>
</form>
</table>
</p>
</cfoutput>
