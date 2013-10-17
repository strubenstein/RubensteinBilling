<cfoutput>
<script language="Javascript" src="#Application.billingUrlroot#/js/popcalendar.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_layers.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_menu.js"></script>

<p>
<!--- Basic Search Form --->
<table border="0" cellspacing="0" cellpadding="2" class="TableText" width="800"><tr bgcolor="ccccff" valign="top" id="basicSearch"<cfif Session.showAdvancedSearch is True> style="display:none;"</cfif>>
<form method="post" name="paymentListBasic" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">
<input type="hidden" name="queryOrderBy" value="#HTMLEditFormat(Form.queryOrderBy)#">
<input type="hidden" name="showAdvancedSearch" value="False">
<input type="hidden" name="searchField" value="paymentDescription,paymentID_custom,paymentMessage">
<td>
	Display Per Page: <input type="text" name="queryDisplayPerPage" value="#HTMLEditFormat(Form.queryDisplayPerPage)#" size="2" class="TableText"> &nbsp; &nbsp; &nbsp; &nbsp; 
	Search Text: <input type="text" name="searchText" value="#HTMLEditFormat(Form.searchText)#" size="25" class="TableText"> <input type="submit" name="submitPaymentList" value="Submit"><br>
	<label><input type="checkbox" name="showGraphicsResults" value="True"<cfif IsDefined("Form.showGraphicsResults") and Form.showGraphicsResults is True> checked</cfif>>Display graphical results summary instead of payment/refund list</label>
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
		<label><input type="checkbox" name="searchField" value="paymentDescription"<cfif ListFind(Form.searchField, "paymentDescription")> checked</cfif>>Description</label> &nbsp; 
		<label><input type="checkbox" name="searchField" value="paymentID_custom"<cfif ListFind(Form.searchField, "paymentID_custom")> checked</cfif>>Custom ID</label><br>
		<label><input type="checkbox" name="searchField" value="paymentMessage"<cfif ListFind(Form.searchField, "paymentMessage")> checked</cfif>>Error Message</label>
		</div>
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
		<cfif qry_selectMerchantAccountList.RecordCount is not 0>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<select name="merchantAccountID" size="1" class="SmallText" style="width=190">
			<option value="">-- MERCHANT ACCOUNT --</option>
			<option value="0"<cfif Form.merchantAccountID is 0> selected</cfif>>-- NONE SPECIFIED --</option>
			<cfloop Query="qry_selectMerchantAccountList">
				<option value="#qry_selectMerchantAccountList.merchantAccountID#"<cfif Form.merchantAccountID is qry_selectMerchantAccountList.merchantAccountID> selected</cfif>><cfif qry_selectMerchantAccountList.merchantAccountName is not "">#HTMLEditFormat(Left(qry_selectMerchantAccountList.merchantAccountName, 30))#<cfelse>#HTMLEditFormat(Left(qry_selectMerchantAccountList.merchantTitle, 30))#</cfif></option>
			</cfloop>
			</select><br>
		</cfif>

		<cfif qry_selectPaymentCategoryList.RecordCount is not 0>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<select name="paymentCategoryID" size="1" class="SmallText" style="width=190">
			<option value="">-- PAYMENT CATEGORY --</option>
			<option value="0">-- NO CATEGORY SPECIFIED --</option>
			<cfloop Query="qry_selectPaymentCategoryList">
				<cfif CurrentRow gt 1 and qry_selectPaymentCategoryList.paymentCategoryOrder is 1>
					<option value="">-- REFUND CATEGORY --</option>
					<option value="0">-- NO CATEGORY SPECIFIED --</option>
				</cfif>
				<option value="#qry_selectPaymentCategoryList.paymentCategoryID#"<cfif Form.paymentCategoryID is qry_selectPaymentCategoryList.paymentCategoryID> selected</cfif>>#HTMLEditFormat(qry_selectPaymentCategoryList.paymentCategoryName)#</option>
			</cfloop>
			</select><br>
		</cfif>

		<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
		<select name="paymentApproved" size="1" class="SmallText" style="width=190">
		<option value="-1">-- APPROVAL STATUS --</option>
		<option value=""<cfif Form.paymentApproved is ""> selected</cfif>>Unknown</option>
		<option value="1"<cfif Form.paymentApproved is 1> selected</cfif>>Approved/Cleared</option>
		<option value="0"<cfif Form.paymentApproved is 0> selected</cfif>>Rejected/Bounced</option>
		</select><br>
		<cfif Application.fn_IsUserAuthorized("exportPayments")>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<select name="paymentIsExported" size="1" class="SmallText" style="width=190">
			<option value="-1">-- SELECT EXPORT STATUS --</option>
			<option value=""<cfif Form.paymentIsExported is ""> selected</cfif>>Not Exported</option>
			<option value="0"<cfif Form.paymentIsExported is 0> selected</cfif>>Exported - Awaiting Import Confirmation</option>
			<option value="1"<cfif Form.paymentIsExported is 1> selected</cfif>>Exported - Import Confirmed</option>
			</select><br>
		</cfif>
	</td>

	<td>
		Amount:&nbsp;
		$<input type="text" name="paymentAmount_min" value="#HTMLEditFormat(Form.paymentAmount_min)#" size="7" class="TableText">
		 to 
		$<input type="text" name="paymentAmount_max" value="#HTMLEditFormat(Form.paymentAmount_max)#" size="7" class="TableText"><br>
		<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="6" alt="" border="0"><br>

		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr vailgn="top">
			<td>From:&nbsp;</td>
			<td nowrap>#fn_FormSelectDateTime(Variables.formName, "paymentDateFrom_date", Form.paymentDateFrom_date, "paymentDateFrom_hh", Form.paymentDateFrom_hh, False, 0, "paymentDateFrom_tt", Form.paymentDateFrom_tt, True)#</td>
		</tr>

		<tr vailgn="top">
			<td align="right">To:&nbsp;</td>
			<td>#fn_FormSelectDateTime(Variables.formName, "paymentDateTo_date", Form.paymentDateTo_date, "paymentDateTo_hh", Form.paymentDateTo_hh, False, 0, "paymentDateTo_tt", Form.paymentDateTo_tt, True)#</td>
		</tr>
		</table>

		<table border="0" cellspacing="2" cellpadding="2" class="SmallText">
		<tr valign="top">
			<td>&nbsp;</td>
			<td>
				<label><input type="checkbox" name="paymentDateType" value="paymentDateReceived"<cfif ListFind(Form.paymentDateType, "paymentDateReceived")> checked</cfif>>Received</label><br>
				<label><input type="checkbox" name="paymentDateType" value="paymentDateScheduled"<cfif ListFind(Form.paymentDateType, "paymentDateScheduled")> checked</cfif>>Scheduled</label><br>
				<cfif Application.fn_IsUserAuthorized("exportPayments")><label><input type="checkbox" name="paymentDateType" value="paymentDateExported"<cfif ListFind(Form.paymentDateType, "paymentDateExported")> checked</cfif>>Exported</label><br></cfif>
			</td>
			<td>
				<label><input type="checkbox" name="paymentDateType" value="paymentDateCreated"<cfif ListFind(Form.paymentDateType, "paymentDateCreated")> checked</cfif>>Created</label><br>
				<label><input type="checkbox" name="paymentDateType" value="paymentDateUpdated"<cfif ListFind(Form.paymentDateType, "paymentDateUpdated")> checked</cfif>>Last Updated</label><br>
			</td>
		</tr>
		</table>

		<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
		<select name="paymentMethod_select" size="1" class="SmallText" style="width=190">
		<option value="">-- PAYMENT METHOD --</option>
		<cfloop Index="count" From="1" To="#ListLen(Variables.paymentMethodList_value)#">
			<option value="#ListGetAt(Variables.paymentMethodList_value, count)#"<cfif Form.paymentMethod_select is ListGetAt(Variables.paymentMethodList_label, count)> selected</cfif>>#HTMLEditFormat(ListGetAt(Variables.paymentMethodList_label, count))#</option>
		</cfloop>
		</select><br>
		&nbsp; &nbsp; Other: <input type="text" name="paymentMethod_text" value="#HTMLEditFormat(Form.paymentMethod_text)#" size="15" class="TableText">
	</td>

	<cfset Variables.booleanList_value = "paymentManual,paymentIsScheduled,paymentHasCustomID,paymentHasDescription,paymentHasCheckNumber,paymentStatus,paymentHasBeenRefunded,paymentProcessed,paymentHasCreditCardID,paymentHasBankID,paymentAppliedToInvoice,paymentAppliedToMultipleInvoices,paymentHasMessage,paymentIsFullyApplied">
	<cfset Variables.booleanList_label = "Processed Manually,Is/Was Scheduled,Has Custom ID,Has Description,Has Check Number,Ignored/Refunded,Refunded via Refund,Via Merchant Account,Paid via Credit Card,Paid via Bank/ACH,Applied to Invoice(s),Applied to 2+ Invoice<u>s</u>,Has Error Message,Amount Is Fully Applied<br>&nbsp; &nbsp; To Invoice(s)">
	<cfset Variables.booleanList_valueReverse = "paymentStatus">

	<td align="center">
		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr class="TableText"><th>&nbsp;</th><th>Yes&nbsp;No</th></tr>
		<cfloop Index="count" From="1" To="#ListLen(Variables.booleanList_value)#">
			<cfset thisBoolean = ListGetAt(Variables.booleanList_value, count)>
			<tr valign="top" onMouseOver="bgColor='FFFFCC'" onMouseOut="bgColor='E7D8F3'"><td nowrap>&nbsp; #ListGetAt(Variables.booleanList_label, count)#</td>
			<cfif Not ListFind(Variables.booleanList_valueReverse, thisBoolean)><cfset valueTrue = 1><cfset valueFalse = 0><cfelse><cfset valueTrue = 0><cfset valueFalse = 1></cfif>
			<td><input type="checkbox" name="#thisBoolean#" value="#valueTrue#"<cfif Form[thisBoolean] is valueTrue> checked</cfif> onClick="javascript:checkUncheck('#thisBoolean#', 0)"><input type="checkbox" name="#thisBoolean#" value="#valueFalse#"<cfif Form[thisBoolean] is valueFalse> checked</cfif> onClick="javascript:checkUncheck('#thisBoolean#', 1)"></td></tr>
			<cfif ListFind("7", count)></table></td><td align="center" valign="top"><table border="0" cellspacing="0" cellpadding="0" class="TableText"><tr class="TableText"><th>&nbsp;</th><th>Yes&nbsp;No</th></tr></cfif>
		</cfloop>
		</table>
	</td>
</tr>
<tr bgcolor="ccccff">
	<td align="center" colspan="4">
		<b>Display Per Page:</b> <input type="text" name="queryDisplayPerPage" value="#HTMLEditFormat(Form.queryDisplayPerPage)#" size="2" class="TableText">  &nbsp; &nbsp; 
		<input type="submit" name="submitPaymentList" value="Submit"> &nbsp; &nbsp; <input type="reset" value="Reset"><br>
		<label><input type="checkbox" name="showGraphicsResults" value="True"<cfif IsDefined("Form.showGraphicsResults") and Form.showGraphicsResults is True> checked</cfif>>Display graphical results summary instead of payment/refund list</label>
	</td>
</tr>
</table>
</form>
</cfoutput>
