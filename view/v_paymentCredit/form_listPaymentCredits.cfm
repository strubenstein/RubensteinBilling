<cfoutput>
<script language="Javascript" src="#Application.billingUrlroot#/js/popcalendar.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_layers.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_menu.js"></script>

<p>
<!--- Basic Search Form --->
<table border="0" cellspacing="0" cellpadding="2" class="TableText" width="800"><tr bgcolor="ccccff" valign="middle" id="basicSearch"<cfif Session.showAdvancedSearch is True> style="display:none;"</cfif>>
<form method="post" name="paymentCreditListBasic" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">
<input type="hidden" name="queryOrderBy" value="#HTMLEditFormat(Form.queryOrderBy)#">
<input type="hidden" name="showAdvancedSearch" value="False">
<input type="hidden" name="searchField" value="paymentCreditName,paymentCreditDescription,paymentCreditID_custom">
<td>
	Display Per Page: <input type="text" name="queryDisplayPerPage" value="#HTMLEditFormat(Form.queryDisplayPerPage)#" size="2" class="TableText"> &nbsp; &nbsp; &nbsp; &nbsp; 
	Search Text: <input type="text" name="searchText" value="#HTMLEditFormat(Form.searchText)#" size="25" class="TableText"> <input type="submit" name="submitPaymentCreditList" value="Submit">
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
		Search Text: <input type="text" name="searchText" value="#HTMLEditFormat(Form.searchText)#" size="20" class="TableText">
		<div class="SmallText">
		<label><input type="checkbox" name="searchField" value="paymentCreditName"<cfif ListFind(Form.searchField, "paymentCreditName")> checked</cfif>>Line Item Text</label> &nbsp;
		<label><input type="checkbox" name="searchField" value="paymentCreditDescription"<cfif ListFind(Form.searchField, "paymentCreditDescription")> checked</cfif>>Description</label><br>
		<label><input type="checkbox" name="searchField" value="paymentCreditID_custom"<cfif ListFind(Form.searchField, "paymentCreditID_custom")> checked</cfif>>Custom ID</label><br>
		</div>

		<cfif qry_selectPaymentCreditAuthorList.RecordCount is not 0>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<select name="userID_author" size="1" class="SmallText" style="width=190">
			<option value="">-- PAYMENT CREDIT CREATOR  --</option>
			<cfloop Query="qry_selectPaymentCreditAuthorList">
				<option value="#qry_selectPaymentCreditAuthorList.userID_author#"<cfif Form.userID_author is qry_selectPaymentCreditAuthorList.userID_author> selected</cfif>>#HTMLEditFormat(qry_selectPaymentCreditAuthorList.lastName)#, #HTMLEditFormat(qry_selectPaymentCreditAuthorList.firstName)#</option>
			</cfloop>
			</select><br>
		</cfif>
		<cfif qry_selectPaymentCategoryList.RecordCount is not 0>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<select name="paymentCategoryID" size="1" class="SmallText" style="width=190">
			<option value="">-- PAYMENT CATEGORY --</option>
			<option value="0">-- NO CATEGORY SPECIFIED --</option>
			<cfloop Query="qry_selectPaymentCategoryList">
				<option value="#qry_selectPaymentCategoryList.paymentCategoryID#"<cfif Form.paymentCategoryID is qry_selectPaymentCategoryList.paymentCategoryID> selected</cfif>>#HTMLEditFormat(qry_selectPaymentCategoryList.paymentCategoryName)#</option>
			</cfloop>
			</select><br>
		</cfif>
		<cfif qry_selectAffiliateList.RecordCount is not 0>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<select name="affiliateID" size="1" class="SmallText" style="width=190">
			<option value="">-- SELECT AFFILIATE --</option>
			<option value="0"<cfif Form.affiliateID is 0> selected</cfif>>-- NO SPECIFIED AFFILIATE --</option>
			<cfloop Query="qry_selectAffiliateList">
				<option value="#qry_selectAffiliateList.affiliateID#"<cfif Form.affiliateID is qry_selectAffiliateList.affiliateID> selected</cfif>>#HTMLEditFormat(Left(qry_selectAffiliateList.affiliateName, 30))#</option>
			</cfloop>
			</select><br>
		</cfif>
		<cfif qry_selectCobrandList.RecordCount is not 0>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<select name="cobrandID" size="1" class="SmallText" style="width=190">
			<option value="">-- SELECT COBRAND --</option>
			<option value="0"<cfif Form.cobrandID is 0> selected</cfif>>-- NO SPECIFIED COBRAND --</option>
			<cfloop Query="qry_selectCobrandList">
				<option value="#qry_selectCobrandList.cobrandID#"<cfif Form.cobrandID is qry_selectCobrandList.cobrandID> selected</cfif>>#HTMLEditFormat(Left(qry_selectCobrandList.cobrandName, 30))#</option>
			</cfloop>
			</select><br>
		</cfif>
		<cfif Application.fn_IsUserAuthorized("exportPaymentCredits")>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<select name="paymentCreditIsExported" size="1" class="SearchSelect">
			<option value="-1">-- SELECT EXPORT STATUS --</option>
			<option value=""<cfif Form.paymentCreditIsExported is ""> selected</cfif>>Not Exported</option>
			<option value="0"<cfif Form.paymentCreditIsExported is 0> selected</cfif>>Exported - Awaiting Import Confirmation</option>
			<option value="1"<cfif Form.paymentCreditIsExported is 1> selected</cfif>>Exported - Import Confirmed</option>
			</select><br>
		</cfif>
	</td>

	<td>
		Amount:&nbsp;
		$<input type="text" name="paymentCreditAmount_min" value="#HTMLEditFormat(Form.paymentCreditAmount_min)#" size="7" class="TableText">
		 to 
		$<input type="text" name="paymentCreditAmount_max" value="#HTMLEditFormat(Form.paymentCreditAmount_max)#" size="7" class="TableText"><br>
		<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="6" alt="" border="0"><br>

		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr vailgn="top">
			<td>From:&nbsp;</td>
			<td nowrap>#fn_FormSelectDateTime(Variables.formName, "paymentCreditDateFrom_date", Form.paymentCreditDateFrom_date, "paymentCreditDateFrom_hh", Form.paymentCreditDateFrom_hh, False, 0, "paymentCreditDateFrom_tt", Form.paymentCreditDateFrom_tt, True)#</td>
		</tr>

		<tr vailgn="top">
			<td align="right">To:&nbsp;</td>
			<td>#fn_FormSelectDateTime(Variables.formName, "paymentCreditDateTo_date", Form.paymentCreditDateTo_date, "paymentCreditDateTo_hh", Form.paymentCreditDateTo_hh, False, 0, "paymentCreditDateTo_tt", Form.paymentCreditDateTo_tt, True)#</td>
		</tr>
		</table>

		<table border="0" cellspacing="2" cellpadding="2" class="SmallText">
		<tr valign="top">
			<td width="20">&nbsp;</td>
			<td>
				<label><input type="checkbox" name="paymentCreditDateType" value="paymentCreditDateBegin"<cfif ListFind(Form.paymentCreditDateType, "paymentCreditDateBegin")> checked</cfif>>Begins</label><br>
				<label><input type="checkbox" name="paymentCreditDateType" value="paymentCreditDateEnd"<cfif ListFind(Form.paymentCreditDateType, "paymentCreditDateEnd")> checked</cfif>>Expires</label><br>
				<cfif Application.fn_IsUserAuthorized("exportPaymentCredits")><label><input type="checkbox" name="paymentCreditDateType" value="paymentCreditDateExported"<cfif ListFind(Form.paymentCreditDateType, "paymentCreditDateExported")> checked</cfif>>Exported</label><br></cfif>
			</td>
			<td>
				<label><input type="checkbox" name="paymentCreditDateType" value="paymentCreditDateCreated"<cfif ListFind(Form.paymentCreditDateType, "paymentCreditDateCreated")> checked</cfif>>Created</label><br>
				<label><input type="checkbox" name="paymentCreditDateType" value="paymentCreditDateUpdated"<cfif ListFind(Form.paymentCreditDateType, "paymentCreditDateUpdated")> checked</cfif>>Last Updated</label><br>
			</td>
		</tr>
		</table>
	</td>


	<cfset Variables.booleanList_value = "paymentCreditStatus,paymentCreditCompleted,paymentCreditRollover,paymentCreditHasRolledOver,paymentCreditHasName,paymentCreditHasCustomID,paymentCreditHasDescription,paymentCreditHasBeginDate,paymentCreditHasEndDate,paymentCreditAppliedMaximumMultiple,paymentCreditApplied,paymentCreditAppliedCountMultiple,paymentCreditAppliedRemaining,paymentCreditNegativeInvoice">
	<cfset Variables.booleanList_label = "Is Active,Is Fully Used,Allows Rollover,Has Rolled Over,Has Line Item Text,Has Custom ID,Has Description,Has Begin Date,Has Expiration Date,To Be Applied 2+,Has Been Applied,Has Been Applied 2+,To Apply Remaining,Allows Negative Invoice">

	<td align="center">
		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr class="TableText"><th>&nbsp;</th><th>Yes&nbsp;No</th></tr>
		<cfloop Index="count" From="1" To="#ListLen(Variables.booleanList_value)#">
			<cfset thisBoolean = ListGetAt(Variables.booleanList_value, count)>
			<tr onMouseOver="bgColor='FFFFCC'" onMouseOut="bgColor='E7D8F3'"><td nowrap>&nbsp; #ListGetAt(Variables.booleanList_label, count)#</td>
			<cfif Not ListFind(Variables.booleanList_value, thisBoolean)><cfset valueTrue = 1><cfset valueFalse = 0><cfelse><cfset valueTrue = 0><cfset valueFalse = 1></cfif>
			<td><input type="checkbox" name="#thisBoolean#" value="#valueTrue#"<cfif Form[thisBoolean] is valueTrue> checked</cfif> onClick="javascript:checkUncheck('#thisBoolean#', 0)"><input type="checkbox" name="#thisBoolean#" value="#valueFalse#"<cfif Form[thisBoolean] is valueFalse> checked</cfif> onClick="javascript:checkUncheck('#thisBoolean#', 1)"></td></tr>
			<cfif ListFind("7", count)></table></td><td align="center" valign="top"><table border="0" cellspacing="0" cellpadding="0" class="TableText"><tr class="TableText"><th>&nbsp;</th><th>Yes&nbsp;No</th></tr></cfif>
		</cfloop>
		</table>
	</td>
</tr>
<tr bgcolor="ccccff">
	<td align="center" colspan="4">
		<b>Display Per Page:</b> <input type="text" name="queryDisplayPerPage" value="#HTMLEditFormat(Form.queryDisplayPerPage)#" size="2" class="TableText">  &nbsp; &nbsp; 
		<input type="submit" name="submitPaymentCreditList" value="Submit"> &nbsp; &nbsp; <input type="reset" value="Reset">
	</td>
</tr>
</table>
</form>
</cfoutput>
