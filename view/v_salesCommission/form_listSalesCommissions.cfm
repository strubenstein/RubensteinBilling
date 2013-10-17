<cfoutput>
<script language="Javascript" src="#Application.billingUrlroot#/js/popcalendar.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_layers.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_menu.js"></script>

<p>
<!--- Basic Search Form --->
<table border="0" cellspacing="0" cellpadding="2" class="TableText" width="800"><tr bgcolor="ccccff" valign="middle" id="basicSearch"<cfif Session.showAdvancedSearch is True> style="display:none;"</cfif>>
<form method="post" name="salesCommissionListBasic" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">
<input type="hidden" name="queryOrderBy" value="#HTMLEditFormat(Form.queryOrderBy)#">
<input type="hidden" name="showAdvancedSearch" value="False">
<td>
	Display Per Page: <input type="text" name="queryDisplayPerPage" value="#HTMLEditFormat(Form.queryDisplayPerPage)#" size="2" class="TableText"> 
	<input type="submit" name="submitSalesCommissionList" value="Submit">
	<font class="TableText">Date Finalized: 
	<a href="index.cfm?method=#URL.control#.listSalesCommissions" class="plainlink"><cfif URL.displaySalesCommissionSpecial is ""><b>All</b><cfelse>All</cfif></a> | 
	<a href="index.cfm?method=#URL.control#.listSalesCommissions&displaySalesCommissionSpecial=yesterday" class="plainlink"><cfif URL.displaySalesCommissionSpecial is "yesterday"><b>Yesterday</b><cfelse>Yesterday</cfif></a> | 
	<a href="index.cfm?method=#URL.control#.listSalesCommissions&displaySalesCommissionSpecial=today" class="plainlink"><cfif URL.displaySalesCommissionSpecial is "today"><b>Today</b><cfelse>Today</cfif></a> | 
	<a href="index.cfm?method=#URL.control#.listSalesCommissions&displaySalesCommissionSpecial=thisWeek" class="plainlink"><cfif URL.displaySalesCommissionSpecial is "thisWeek"><b>This Week</b><cfelse>This Week</cfif></a> | 
	<a href="index.cfm?method=#URL.control#.listSalesCommissions&displaySalesCommissionSpecial=thisMonth" class="plainlink"><cfif URL.displaySalesCommissionSpecial is "thisMonth"><b>This Month</b><cfelse>This Month</cfif></a>
	</font>	
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
	<td colspan="2" align="right" class="TableText">[ <a href="javascript:void(0);" class="plainlink" onClick="toggle('advancedSearch');toggle('basicSearch');">Return to Basic Search</a> ]</td>
</tr>

<tr bgcolor="E7D8F3" valign="top">
	<td>
		Basis Total:<br>
		&nbsp; &nbsp;<input type="text" name="salesCommissionBasisTotal_min" value="#HTMLEditFormat(Form.salesCommissionBasisTotal_min)#" size="4"> to 
		<input type="text" name="salesCommissionBasisTotal_max" value="#HTMLEditFormat(Form.salesCommissionBasisTotal_max)#" size="4"><br>

		Commission Total:<br>
		&nbsp; &nbsp;<input type="text" name="salesCommissionAmount_min" value="#HTMLEditFormat(Form.salesCommissionAmount_min)#" size="4"> to 
		<input type="text" name="salesCommissionAmount_max" value="#HTMLEditFormat(Form.salesCommissionAmount_max)#" size="4"><br>
	</td>
	<td>
		<cfif Not ListFind("affiliateID,cobrandID,companyID,userID,vendorID", URL.control)>
			<select name="primaryTargetID" size="1" class="SearchSelect">
			<option value="">-- RECIPIENT TYPE --</option>
			<cfloop Index="type" List="Affiliate,Cobrand,Company,User,Vendor">
				<cfset Variables.thisPrimaryTargetID = Application.fn_GetPrimaryTargetID("#LCase(type)#ID")>
				<option value="#Variables.thisPrimaryTargetID#"<cfif Form.primaryTargetID is Variables.thisPrimaryTargetID> selected</cfif>>#type#</option>
			</cfloop>
			</select><br>
		</cfif>

		<cfif IsDefined("qry_selectStatusList") and qry_selectStatusList.RecordCount is not 0>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<select name="statusID" size="1" class="SearchSelect">
			<option value="">-- CUSTOM STATUS --</option>
			<option value="0"<cfif Form.statusID is 0> selected</cfif>>-- NO SPECIFIED STATUS --</option>
			<cfloop Query="qry_selectStatusList">
				<option value="#qry_selectStatusList.statusID#"<cfif Form.statusID is qry_selectStatusList.statusID> selected</cfif>>#qry_selectStatusList.statusOrder#. #HTMLEditFormat(Left(qry_selectStatusList.statusTitle, 30))#</option>
			</cfloop>
			</select><br>
		</cfif>
		<cfif IsDefined("qry_selectAffiliateList") and qry_selectAffiliateList.RecordCount is not 0>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<cfif URL.control is "affiliate" and IsDefined("qry_selectAffiliate")>
				<b><i>Affiliate</i>: #qry_selectAffiliate.affiliateName#</b><br>
			<cfelse>
				<select name="affiliateID" size="1" class="SearchSelect">
				<option value="">-- CUSTOMER AFFILIATE --</option>
				<cfloop Query="qry_selectAffiliateList">
					<option value="#qry_selectAffiliateList.affiliateID#"<cfif Form.affiliateID is qry_selectAffiliateList.affiliateID> selected</cfif>>#HTMLEditFormat(Left(qry_selectAffiliateList.affiliateName, 30))#</option>
				</cfloop>
				</select><br>
			</cfif>
		</cfif>
		<cfif IsDefined("qry_selectCobrandList") and qry_selectCobrandList.RecordCount is not 0>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<cfif URL.control is "cobrand" and IsDefined("qry_selectCobrand")>
				<b><i>Cobrand</i>: #qry_selectCobrand.cobrandName#</b><br>
			<cfelse>
				<select name="cobrandID" size="1" class="SearchSelect">
				<option value="">-- CUSTOMER COBRAND --</option>
				<cfloop Query="qry_selectCobrandList">
					<option value="#qry_selectCobrandList.cobrandID#"<cfif Form.cobrandID is qry_selectCobrandList.cobrandID> selected</cfif>>#HTMLEditFormat(Left(qry_selectCobrandList.cobrandName, 30))#</option>
				</cfloop>
				</select><br>
			</cfif>
		</cfif>
		<cfif Application.fn_IsUserAuthorized("exportSalesCommissions")>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<select name="salesCommissionIsExported" size="1" class="SearchSelect">
			<option value="-1">-- SELECT EXPORT STATUS --</option>
			<option value=""<cfif Form.salesCommissionIsExported is ""> selected</cfif>>Not Exported</option>
			<option value="0"<cfif Form.salesCommissionIsExported is 0> selected</cfif>>Exported - Awaiting Import Confirmation</option>
			<option value="1"<cfif Form.salesCommissionIsExported is 1> selected</cfif>>Exported - Import Confirmed</option>
			</select><br>
		</cfif>
	</td>
	<td rowspan="2">
		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr>
			<td>From:&nbsp;</td>
			<td colspan="2" nowrap>#fn_FormSelectDateTime(Variables.formName, "salesCommissionDateFrom_date", Form.salesCommissionDateFrom_date, "salesCommissionDateFrom_hh", Form.salesCommissionDateFrom_hh, False, 0, "salesCommissionDateFrom_tt", Form.salesCommissionDateFrom_tt, True)#</td>
		</tr>
		<tr>
			<td align="right">To:&nbsp;</td>
			<td colspan="2">#fn_FormSelectDateTime(Variables.formName, "salesCommissionDateTo_date", Form.salesCommissionDateTo_date, "salesCommissionDateTo_hh", Form.salesCommissionDateTo_hh, False, 0, "salesCommissionDateTo_tt", Form.salesCommissionDateTo_tt, True)#</td>
		</tr>
		<tr class="TableText" valign="top">
			<td>&nbsp;</td>
			<td>
				<label><input type="checkbox" name="salesCommissionDateType" value="salesCommissionDateCreated"<cfif ListFind(Form.salesCommissionDateType, "salesCommissionDateCreated")> checked</cfif>>Created</label><br>
				<label><input type="checkbox" name="salesCommissionDateType" value="salesCommissionDateFinalized"<cfif ListFind(Form.salesCommissionDateType, "salesCommissionDateFinalized")> checked</cfif>>Finalized</label><br>
				<label><input type="checkbox" name="salesCommissionDateType" value="salesCommissionDatePaid"<cfif ListFind(Form.salesCommissionDateType, "salesCommissionDatePaid")> checked</cfif>>Paid</label><br>
				<cfif Application.fn_IsUserAuthorized("exportSalesCommissions")><label><input type="checkbox" name="salesCommissionDateType" value="salesCommissionDateExported"<cfif ListFind(Form.salesCommissionDateType, "salesCommissionDateExported")> checked</cfif>>Exported</label><br></cfif>
			</td>
			<td>
				<label><input type="checkbox" name="salesCommissionDateType" value="salesCommissionDateBegin"<cfif ListFind(Form.salesCommissionDateType, "salesCommissionDateBegin")> checked</cfif>>Period Begins</label><br>
				<label><input type="checkbox" name="salesCommissionDateType" value="salesCommissionDateEnd"<cfif ListFind(Form.salesCommissionDateType, "salesCommissionDateEnd")> checked</cfif>>Period Ends</label><br>
				<label><input type="checkbox" name="salesCommissionDateType" value="salesCommissionDateUpdated"<cfif ListFind(Form.salesCommissionDateType, "salesCommissionDateUpdated")> checked</cfif>>Updated / Made Inactive</label><br>
			</td>
		</tr>
		</table>
	</td>

	<cfset Variables.booleanList_value = "salesCommissionStatus,salesCommissionManual,salesCommissionFinalized,salesCommissionPaid">
	<cfset Variables.booleanList_label = "Status is active,Added manually,Is Finalized,Is Paid">

	<td rowspan="2" align="center">
		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr class="TableText"><th>&nbsp;</th><th>Yes&nbsp;No</th></tr>
		<cfloop Index="count" From="1" To="#ListLen(Variables.booleanList_value)#">
			<cfset thisBoolean = ListGetAt(Variables.booleanList_value, count)>
			<tr onMouseOver="bgColor='FFFFCC'" onMouseOut="bgColor='E7D8F3'"><td nowrap>&nbsp; #ListGetAt(Variables.booleanList_label, count)#</td>
			<td><input type="checkbox" name="#thisBoolean#" value="1"<cfif Form[thisBoolean] is 1> checked</cfif> onClick="javascript:checkUncheck('#thisBoolean#', 0)"><input type="checkbox" name="#thisBoolean#" value="0"<cfif Form[thisBoolean] is 0> checked</cfif> onClick="javascript:checkUncheck('#thisBoolean#', 1)"></td></tr>
		</cfloop>
		</table>
	</td>
</tr>
<tr bgcolor="E7D8F3">
	<td colspan="2">
		<label><input type="checkbox" name="returnSalesCommissionSum" value="True"<cfif Form.returnSalesCommissionSum is True> checked</cfif>> 
		Display sum of sales commissions for each target,<br>
		&nbsp; &nbsp; &nbsp; &nbsp; not individual sales commission calculations</label>
	</td>
</tr>
<tr bgcolor="ccccff"><!--- lime --->
	<td align="center" colspan="4">
		<b>Display Per Page:</b> <input type="text" name="queryDisplayPerPage" value="#HTMLEditFormat(Form.queryDisplayPerPage)#" size="2" class="TableText"> &nbsp; &nbsp; 
		<input type="submit" name="submitSalesCommissionList" value="Submit"> &nbsp; &nbsp; <input type="reset" value="Reset">
	</td>
</tr>
</table>
</form>
</cfoutput>
