<cfoutput>
<script language="Javascript" src="#Application.billingUrlroot#/js/popcalendar.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_layers.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_menu.js"></script>

<script language="JavaScript" type="text/javascript">
<!-- Begin
function checkInvoiceDate (countOn, countOff)
{
	if (countOn != 3)
		document.#Variables.formName#.newsletterSubscriberDateType[3].checked = false;
	if (countOn != 4)
		document.#Variables.formName#.newsletterSubscriberDateType[4].checked = false;
	if (countOn != 5)
		document.#Variables.formName#.newsletterSubscriberDateType[5].checked = false;
}
//  End -->
</script>

<cfif Variables.doAction is "listNewsletterSubscribers">
	<form method="post" name="#Variables.formName#" action="#Variables.formAction#">
	<input type="hidden" name="isFormSubmitted" value="True">
	<input type="hidden" name="queryOrderBy" value="#HTMLEditFormat(Form.queryOrderBy)#">
</cfif>

<!--- Advanced Search Form --->
<table border="0" cellspacing="0" cellpadding="2" class="TableText" width="800">
<tr bgcolor="ccccff" class="MainText">
	<td colspan="3"><b>Advanced Search</b></td>
</tr>

<tr bgcolor="E7D8F3" valign="top">
	<td>
		Search Email Address: <input type="text" name="newsletterSubscriberEmail" size="25" value="#HTMLEditFormat(Form.newsletterSubscriberEmail)#"><br>
		<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="5" alt="" border="0"><br>
		<cfif qry_selectGroupList.RecordCount is not 0>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<select name="groupID" size="1" class="SearchSelect">
			<option value="">-- SELECT GROUP --</option>
			<option value="0"<cfif Form.groupID is 0> selected</cfif>>-- NO SPECIFIED GROUP --</option>
			<cfloop Query="qry_selectGroupList">
				<option value="#qry_selectGroupList.groupID#"<cfif Form.groupID is qry_selectGroupList.groupID> selected</cfif>>#HTMLEditFormat(Left(qry_selectGroupList.groupName,30))#</option>
			</cfloop>
			</select><br>
		</cfif>
		<cfif qry_selectAffiliateList.RecordCount is not 0>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<select name="affiliateID" size="1" class="SearchSelect">
			<option value="">-- SELECT AFFILIATE --</option>
			<option value="0"<cfif Form.affiliateID is 0> selected</cfif>>-- NO SPECIFIED AFFILIATE --</option>
			<cfloop Query="qry_selectAffiliateList">
				<option value="#qry_selectAffiliateList.affiliateID#"<cfif Form.affiliateID is qry_selectAffiliateList.affiliateID> selected</cfif>>#HTMLEditFormat(Left(qry_selectAffiliateList.affiliateName,30))#</option>
			</cfloop>
			</select><br>
		</cfif>
		<cfif qry_selectCobrandList.RecordCount is not 0>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<select name="cobrandID" size="1" class="SearchSelect">
			<option value="">-- SELECT COBRAND --</option>
			<option value="0"<cfif Form.cobrandID is 0> selected</cfif>>-- NO SPECIFIED COBRAND --</option>
			<cfloop Query="qry_selectCobrandList">
				<option value="#qry_selectCobrandList.cobrandID#"<cfif Form.cobrandID is qry_selectCobrandList.cobrandID> selected</cfif>>#HTMLEditFormat(Left(qry_selectCobrandList.cobrandName,30))#</option>
			</cfloop>
			</select><br>
		</cfif>
		<cfif Application.fn_IsUserAuthorized("exportNewsletterSubscribers")>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<select name="newsletterSubscriberIsExported" size="1" class="SearchSelect">
			<option value="-1">-- SELECT EXPORT STATUS --</option>
			<option value=""<cfif Form.newsletterSubscriberIsExported is ""> selected</cfif>>Not Exported</option>
			<option value="0"<cfif Form.newsletterSubscriberIsExported is 0> selected</cfif>>Exported - Awaiting Import Confirmation</option>
			<option value="1"<cfif Form.newsletterSubscriberIsExported is 1> selected</cfif>>Exported - Import Confirmed</option>
			</select><br>
		</cfif>

		<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="8" alt="" border="0"><br>
		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr valign="top">
			<td>From:&nbsp;</td>
			<td colspan="2">#fn_FormSelectDateTime(Variables.formName, "newsletterSubscriberDateFrom_date", Form.newsletterSubscriberDateFrom_date, "newsletterSubscriberDateFrom_hh", Form.newsletterSubscriberDateFrom_hh, False, 0, "newsletterSubscriberDateFrom_tt", Form.newsletterSubscriberDateFrom_tt, True)#</td>
		</tr>

		<tr valign="top">
			<td align="right">To:&nbsp;</td>
			<td colspan="2">#fn_FormSelectDateTime(Variables.formName, "newsletterSubscriberDateTo_date", Form.newsletterSubscriberDateTo_date, "newsletterSubscriberDateTo_hh", Form.newsletterSubscriberDateTo_hh, False, 0, "newsletterSubscriberDateTo_tt", Form.newsletterSubscriberDateTo_tt, True)#</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td class="SmallText">
				<label><input type="checkbox" name="newsletterSubscriberDateType" value="newsletterSubscriberDateCreated"<cfif ListFind(Form.newsletterSubscriberDateType, "newsletterSubscriberDateCreated")> checked</cfif>>Date Subscribed</label><br>
				<!--- <label><input type="checkbox" name="newsletterSubscriberDateType" value="newsletterSubscriberDateUpdated"<cfif ListFind(Form.newsletterSubscriberDateType, "newsletterSubscriberDateUpdated")> checked</cfif>>Date Last Updated</label><br> --->
				<label><input type="checkbox" name="newsletterSubscriberDateType" value="userDateCreated"<cfif ListFind(Form.newsletterSubscriberDateType, "userDateCreated")> checked</cfif>>Date User Created/Subscribed</label><br>
				<label><input type="checkbox" name="newsletterSubscriberDateType" value="companyDateCreated"<cfif ListFind(Form.newsletterSubscriberDateType, "companyDateCreated")> checked</cfif>>Date Company Created</label>
			</td>
			<td class="SmallText" valign="top">
				<label><input type="checkbox" name="newsletterSubscriberDateType" value="invoiceDateClosed" onClick="javascript:checkInvoiceDate(3)"<cfif ListFind(Form.newsletterSubscriberDateType, "invoiceDateClosed")> checked</cfif>>Any Purchase Date</label><br>
				<label><input type="checkbox" name="newsletterSubscriberDateType" value="invoiceDateClosed_first" onClick="javascript:checkInvoiceDate(4)"<cfif ListFind(Form.newsletterSubscriberDateType, "invoiceDateClosed_first")> checked</cfif>>First Purchase Date</label><br>
				<label><input type="checkbox" name="newsletterSubscriberDateType" value="invoiceDateClosed_last" onClick="javascript:checkInvoiceDate(5)"<cfif ListFind(Form.newsletterSubscriberDateType, "invoiceDateClosed_last")> checked</cfif>>Last Purchase Date</label><br>
			</td>
		</tr>
		</table>
	</td>

	<cfset Variables.booleanList_value = "newsletterSubscriberHtml,newsletterSubscriberStatus,subscriberIsUser,newsletterSubscriberRegistered">
	<cfset Variables.booleanList_label = "HTML Format,Is Subscribed,Is Registered User,Registered After Subscribing*">

	<td align="center">
		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr><td colspan="2"><b>Newsletter Subscribers</b></td></tr>
		<tr class="TableText"><th>&nbsp;</th><th>Yes&nbsp;No</th></tr>
		<cfloop Index="count" From="1" To="#ListLen(Variables.booleanList_value)#">
			<cfset thisBoolean = ListGetAt(Variables.booleanList_value, count)>
			<tr onMouseOver="bgColor='FFFFCC'" onMouseOut="bgColor='E7D8F3'"><td nowrap>&nbsp; #ListGetAt(Variables.booleanList_label, count)#</td>
			<td><input type="checkbox" name="#thisBoolean#" value="1"<cfif Form[thisBoolean] is 1> checked</cfif> onClick="javascript:checkUncheck('#thisBoolean#', 0)"><input type="checkbox" name="#thisBoolean#" value="0"<cfif Form[thisBoolean] is 0> checked</cfif> onClick="javascript:checkUncheck('#thisBoolean#', 1)"></td></tr>
		</cfloop>
		</table>
		<br>
		<table border="0" cellspacing="0" cellpadding="0" class="SmallText"><tr><td width="175">
		* Subscribers who registered after subscribing are no longer <i>subscribed</i> as a newsletter subscriber only, but as a registered user instead.
		</td></tr></table>
	</td>

	<cfset Variables.booleanList_value = "userIsInMyCompany,companyIsCustomer,companyIsVendor,companyIsCobrand,companyIsAffiliate,companyHasMultipleUsers,companyHasCustomPricing,companyHasCustomID,userHasCustomID,companyIsTaxExempt">
	<cfset Variables.booleanList_label = "Is My Company,Is Customer,Is Affiliate,Is Cobrand,Is Vendor,Company Has Multiple Users,Has Custom Pricing,Company Has Custom ID,User Has Custom ID,Is Tax-Exempt">

	<td align="center">
		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr><td colspan="2"><b>Registered Users &amp; Companies</b></td></tr>
		<tr class="TableText"><th>&nbsp;</th><th>Yes&nbsp;No</th></tr>
		<cfloop Index="count" From="1" To="#ListLen(Variables.booleanList_value)#">
			<cfset thisBoolean = ListGetAt(Variables.booleanList_value, count)>
			<tr onMouseOver="bgColor='FFFFCC'" onMouseOut="bgColor='E7D8F3'"><td nowrap>&nbsp; #ListGetAt(Variables.booleanList_label, count)#</td>
			<td><input type="checkbox" name="#thisBoolean#" value="1"<cfif Form[thisBoolean] is 1> checked</cfif> onClick="javascript:checkUncheck('#thisBoolean#', 0)"><input type="checkbox" name="#thisBoolean#" value="0"<cfif Form[thisBoolean] is 0> checked</cfif> onClick="javascript:checkUncheck('#thisBoolean#', 1)"></td></tr>
		</cfloop>
		</table>
	</td>
</tr>

<cfif Variables.doAction is "listNewsletterSubscribers">
	<tr bgcolor="ccccff">
		<td align="center" colspan="3">
			<b>Display Per Page:</b> <input type="text" name="queryDisplayPerPage" value="#HTMLEditFormat(Form.queryDisplayPerPage)#" size="2" class="TableText"> &nbsp; &nbsp; 
			<input type="submit" name="submitNewsletterSubscriberList" value="Submit"> &nbsp; &nbsp; <input type="reset" value="Reset">
		</td>
	</tr>
</cfif>
</table>
</form>
</cfoutput>

