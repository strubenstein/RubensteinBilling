<!--- subscriptionInterval,subscriptionAppliedMaximum,nextProcessDateIsNull,multipleSubscription,multipleQuantity,subscriptionQuantity,subscriptionQuantity_min,subscriptionQuantity_max --->
<cfoutput>
<script language="Javascript" src="#Application.billingUrlroot#/js/popcalendar.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_layers.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_menu.js"></script>

<p>
<!--- Basic Search Form --->
<table border="0" cellspacing="0" cellpadding="2" class="TableText" width="800"><tr bgcolor="ccccff" valign="middle" id="basicSearch"<cfif Session.showAdvancedSearch is True> style="display:none;"</cfif>>
<form method="post" name="subscriberListBasic" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">
<input type="hidden" name="queryOrderBy" value="#HTMLEditFormat(Form.queryOrderBy)#">
<input type="hidden" name="showAdvancedSearch" value="False">
<input type="hidden" name="searchField" value="subscriberName,subscriptionName,subscriptionDescription,subscriberID_custom,subscriptionID_custom,subscriptionProductID_custom">
<td>
	<div align="left">
	<i>(To Be) Processed</i>: 
	<a href="index.cfm?method=#URL.control#.listSubscribers&companyID=#URL.companyID#&userID=#URL.userID#" class="plainlink"><cfif URL.displaySubscriberSpecial is ""><b>All</b><cfelse>All</cfif></a> | 
	<a href="index.cfm?method=#URL.control#.listSubscribers&companyID=#URL.companyID#&userID=#URL.userID#&displaySubscriberSpecial=lastWeek" class="plainlink"><cfif URL.displaySubscriberSpecial is "lastWeek"><b>Last Week</b><cfelse>Last Week</cfif></a> | 
	<a href="index.cfm?method=#URL.control#.listSubscribers&companyID=#URL.companyID#&userID=#URL.userID#&displaySubscriberSpecial=yesterday" class="plainlink"><cfif URL.displaySubscriberSpecial is "yesterday"><b>Yesterday</b><cfelse>Yesterday</cfif></a> | 
	<a href="index.cfm?method=#URL.control#.listSubscribers&companyID=#URL.companyID#&userID=#URL.userID#&displaySubscriberSpecial=today" class="plainlink"><cfif URL.displaySubscriberSpecial is "today"><b>Today</b><cfelse>Today</cfif></a> | 
	<a href="index.cfm?method=#URL.control#.listSubscribers&companyID=#URL.companyID#&userID=#URL.userID#&displaySubscriberSpecial=tomorrow" class="plainlink"><cfif URL.displaySubscriberSpecial is "tomorrow"><b>Tomorrow</b><cfelse>Tomorrow</cfif></a> | 
	<a href="index.cfm?method=#URL.control#.listSubscribers&companyID=#URL.companyID#&userID=#URL.userID#&displaySubscriberSpecial=thisWeek" class="plainlink"><cfif URL.displaySubscriberSpecial is "thisWeek"><b>This Week</b><cfelse>This Week</cfif></a> | 
	<a href="index.cfm?method=#URL.control#.listSubscribers&companyID=#URL.companyID#&userID=#URL.userID#&displaySubscriberSpecial=nextWeek" class="plainlink"><cfif URL.displaySubscriberSpecial is "nextWeek"><b>Next Week</b><cfelse>Next Week</cfif></a>
	</div>
	Display Per Page: <input type="text" name="queryDisplayPerPage" value="#HTMLEditFormat(Form.queryDisplayPerPage)#" size="2" class="TableText"> &nbsp; &nbsp; &nbsp; &nbsp; 
	Search Text: <input type="text" name="searchText" value="#HTMLEditFormat(Form.searchText)#" size="25" class="TableText"> <input type="submit" name="submitSubscriberList" value="Submit"><br>
</td>
<td valign="top" align="right" class="TableText">[ <a href="javascript:void(0);" class="plainlink" onClick="toggle('advancedSearch');toggle('basicSearch');">Show Advanced Search</a> ]</td>
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
		Text Search: <input type="text" name="searchText" value="#HTMLEditFormat(Form.searchText)#" size="25" class="TableText">
		<table border="0" cellspacing="0" cellpadding="0" class="SmallText">
		<tr>
			<td nowrap>
				<label><input type="checkbox" name="searchField" value="subscriberName"<cfif ListFind(Form.searchField, "subscriberName")> checked</cfif>>Subscriber Name</label><br>
				<label><input type="checkbox" name="searchField" value="subscriptionName"<cfif ListFind(Form.searchField, "subscriptionName")> checked</cfif>>Product Name</label><br>
				<label><input type="checkbox" name="searchField" value="subscriptionDescription"<cfif ListFind(Form.searchField, "subscriptionDescription")> checked</cfif>>Product Description</label>
			</td>
			<td nowrap>
				<label><input type="checkbox" name="searchField" value="subscriberID_custom"<cfif ListFind(Form.searchField, "subscriberID_custom")> checked</cfif>>Custom Subscriber ID</label><br>
				<label><input type="checkbox" name="searchField" value="subscriptionID_custom"<cfif ListFind(Form.searchField, "subscriptionID_custom")> checked</cfif>>Custom Subscription ID</label><br>
				<label><input type="checkbox" name="searchField" value="subscriptionProductID_custom"<cfif ListFind(Form.searchField, "subscriptionProductID_custom")> checked</cfif>>Custom Product ID</label>
			</td>
		</tr>
		</table>
		<br>
		<cfif qry_selectStatusList_subscriber.RecordCount is not 0>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<select name="statusID_subscriber" size="1" class="SearchSelect">
			<option value="">-- CUSTOM SUBSCRIBER STATUS --</option>
			<option value="0"<cfif Form.statusID_subscriber is 0> selected</cfif>>-- NO SPECIFIED STATUS --</option>
			<cfloop Query="qry_selectStatusList_subscriber">
				<option value="#qry_selectStatusList_subscriber.statusID#"<cfif Form.statusID_subscriber is qry_selectStatusList_subscriber.statusID> selected</cfif>>#qry_selectStatusList_subscriber.statusOrder#. #HTMLEditFormat(Left(qry_selectStatusList_subscriber.statusTitle, 30))#</option>
			</cfloop>
			</select><br>
		</cfif>
		<cfif qry_selectStatusList_subscription.RecordCount is not 0>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<select name="statusID_subscription" size="1" class="SearchSelect">
			<option value="">-- CUSTOM SUBSCRIPTION STATUS --</option>
			<option value="0"<cfif Form.statusID_subscription is 0> selected</cfif>>-- NO SPECIFIED STATUS --</option>
			<cfloop Query="qry_selectStatusList_subscription">
				<option value="#qry_selectStatusList_subscription.statusID#"<cfif Form.statusID_subscription is qry_selectStatusList_subscription.statusID> selected</cfif>>#qry_selectStatusList_subscription.statusOrder#. #HTMLEditFormat(Left(qry_selectStatusList_subscription.statusTitle, 30))#</option>
			</cfloop>
			</select><br>
		</cfif>
		<cfif qry_selectAffiliateList.RecordCount is not 0>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<select name="affiliateID" size="1" class="SearchSelect">
			<option value="">-- SELECT AFFILIATE --</option>
			<option value="0"<cfif Form.affiliateID is 0> selected</cfif>>-- NO SPECIFIED AFFILIATE --</option>
			<cfloop Query="qry_selectAffiliateList">
				<option value="#qry_selectAffiliateList.affiliateID#"<cfif Form.affiliateID is qry_selectAffiliateList.affiliateID> selected</cfif>>#HTMLEditFormat(Left(qry_selectAffiliateList.affiliateName, 30))#</option>
			</cfloop>
			</select><br>
		</cfif>
		<cfif qry_selectCobrandList.RecordCount is not 0>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<select name="cobrandID" size="1" class="SearchSelect">
			<option value="">-- SELECT COBRAND --</option>
			<option value="0"<cfif Form.cobrandID is 0> selected</cfif>>-- NO SPECIFIED COBRAND --</option>
			<cfloop Query="qry_selectCobrandList">
				<option value="#qry_selectCobrandList.cobrandID#"<cfif Form.cobrandID is qry_selectCobrandList.cobrandID> selected</cfif>>#HTMLEditFormat(Left(qry_selectCobrandList.cobrandName, 30))#</option>
			</cfloop>
			</select><br>
		</cfif>
		<cfif Application.fn_IsUserAuthorized("exportSubscribers")>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<select name="subscriberIsExported" size="1" class="SearchSelect">
			<option value="-1">-- SELECT EXPORT STATUS --</option>
			<option value=""<cfif Form.subscriberIsExported is ""> selected</cfif>>Not Exported</option>
			<option value="0"<cfif Form.subscriberIsExported is 0> selected</cfif>>Exported - Awaiting Import Confirmation</option>
			<option value="1"<cfif Form.subscriberIsExported is 1> selected</cfif>>Exported - Import Confirmed</option>
			</select><br>
		</cfif>
		<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="6" alt="" border="0"><br>
		<select name="categoryID" size="1" class="SearchSelect">
		<option value="">-- SELECT CATEGORY --</option>
		<option value="0"<cfif Form.categoryID is -1> selected</cfif>>-- NOT LISTED IN ANY CATEGORIES --</option>
		<cfloop Query="qry_selectCategoryList">
			<option value="#qry_selectCategoryList.categoryID#"<cfif Form.categoryID is qry_selectCategoryList.categoryID> selected</cfif>>#RepeatString(" - ", qry_selectCategoryList.categoryLevel - 1)##HTMLEditFormat(Left(qry_selectCategoryList.categoryName, 25))#</option>
		</cfloop>
		</select><br>
		<label><input type="checkbox" name="categoryID_sub" value="1"<cfif Form.categoryID_sub is 1> checked</cfif>>Include sub-categories</label><br>
		<br>
		$<input type="text" name="searchPrice_min" value="#HTMLEditFormat(Form.searchPrice_min)#" size="5" class="TableText">
		 to 
		$<input type="text" name="searchPrice_max" value="#HTMLEditFormat(Form.searchPrice_max)#" size="5" class="TableText">
		<div class="SmallText">
		<label><input type="checkbox" name="searchPriceField" value="subscriptionPriceUnit"<cfif ListFind(Form.searchPriceField, "subscriptionPriceUnit")> checked</cfif>>Unit Price</label> &nbsp; 
		<label><input type="checkbox" name="searchPriceField" value="subscriptionTotal"<cfif ListFind(Form.searchPriceField, "subscriptionTotal")> checked</cfif>>Subscription Total</label><br>
		<label><input type="checkbox" name="searchPriceField" value="subscriberLineItemTotal"<cfif ListFind(Form.searchPriceField, "subscriberLineItemTotal")> checked</cfif>>Invoice Total</label><br>
		</div>
	</td>

	<td>
		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr>
			<td>From:&nbsp;</td>
			<td nowrap>#fn_FormSelectDateTime(Variables.formName, "subscriberDateFrom_date", Form.subscriberDateFrom_date, "", 0, "", 0, "", "", True)#</td>
		</tr>

		<tr>
			<td align="right">To:&nbsp;</td>
			<td>#fn_FormSelectDateTime(Variables.formName, "subscriberDateTo_date", Form.subscriberDateTo_date, "", 0, "", 0, "", "", True)#</td>
		</tr>
		<tr>
			<!--- <td>&nbsp;</td> --->
			<td class="SmallText" colspan="2">
				<label><input type="checkbox" name="subscriberDateType" value="subscriberDateProcessNext"<cfif ListFind(Form.subscriberDateType, "subscriberDateProcessNext")> checked</cfif>>Next invoice date</label><br>
				<label><input type="checkbox" name="subscriberDateType" value="subscriberDateProcessLast"<cfif ListFind(Form.subscriberDateType, "subscriberDateProcessLast")> checked</cfif>>Most recent invoice date</label><br>
				<label><input type="checkbox" name="subscriberDateType" value="subscriberDateCreated"<cfif ListFind(Form.subscriberDateType, "subscriberDateCreated")> checked</cfif>>Date subscriber added</label><br>
				<label><input type="checkbox" name="subscriberDateType" value="subscriptionDateCreated"<cfif ListFind(Form.subscriberDateType, "subscriptionDateCreated")> checked</cfif>>Product subscription added</label><br>
				<label><input type="checkbox" name="subscriberDateType" value="subscriptionDateBegin"<cfif ListFind(Form.subscriberDateType, "subscriptionDateBegin")> checked</cfif>>Product subscription begins</label><br>
				<label><input type="checkbox" name="subscriberDateType" value="subscriptionDateEnd"<cfif ListFind(Form.subscriberDateType, "subscriptionDateEnd")> checked</cfif>>Product subscription ends</label><br>
				<cfif Application.fn_IsUserAuthorized("exportSubscribers")><label><input type="checkbox" name="subscriberDateType" value="subscriptionDateExported"<cfif ListFind(Form.subscriberDateType, "subscriptionDateExported")> checked</cfif>>Date subscriber exported</label><br></cfif>
			</td>
		</tr>
		</table>
		<br>
		Max. Times Applied:<br>
		&nbsp; 
		<input type="text" name="subscriptionAppliedMaximum_min" value="#HTMLEditFormat(Form.subscriptionAppliedMaximum_min)#" size="2" class="TableText">
		 to 
		<input type="text" name="subscriptionAppliedMaximum_max" value="#HTMLEditFormat(Form.subscriptionAppliedMaximum_max)#" size="2" class="TableText"><br>

		<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="6" alt="" border="0"><br>
		## Periods Remaining:<br>
		&nbsp; 
		<input type="text" name="subscriptionAppliedRemaining_min" value="#HTMLEditFormat(Form.subscriptionAppliedRemaining_min)#" size="1" class="TableText">
		 to 
		<input type="text" name="subscriptionAppliedRemaining_max" value="#HTMLEditFormat(Form.subscriptionAppliedRemaining_max)#" size="1" class="TableText"><br>
	</td>

	<cfset Variables.booleanList_value = "False,subscriberStatus,subscriberCompleted,subscriberHasCustomID,False,subscriberPaymentExists,subscriberPaymentHasCreditCardID,subscriberPaymentHasBankID,False,subscriberNotifyMultipleUser,subscriberNotifyEmail,subscriberNotifyEmailHtml,subscriberNotifyPdf,subscriberNotifyDoc,subscriberNotifyPhoneID,subscriberNotifyAddressID,False,subscriptionStatus,subscriptionCompleted,subscriptionIsCustomProduct,subscriptionHasPrice,subscriptionHasParameter,subscriptionHasParameterException,subscriptionHasDescription,subscriptionDescriptionHtml,subscriptionHasCustomID,subscriptionQuantityVaries,subscriptionContinuesAfterEnd,subscriptionHasEndDate,subscriptionHasMaximum,subscriptionIsRollup">
	<cfset Variables.booleanList_label = "<b><i>Subscribers</i></b>,Is Active,Is Completed,Has Custom ID,<b><i>Automated Payments</i></b>,Auto Pay Enabled,Via Credit Card,Via Bank (ACH),<b><i>Notification</i></b>,Notify Multiple Users,Via Email,Via HTML Email,PDF File,Word Document,Via Fax,Via Postal Mail,<b><i>Subscription</i></b>,Is Active,Is Completed,Is Custom Product,Has Custom Price,Has Parameter(s),Has Parameter Exception,Has Description,Has HTML Description,Has Custom ID,Quantity Varies,Continues Indefinitely,Has Specified End Date,Has Max. Times Applied,Has Roll-Up">

	<td align="center">
		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr class="TableText"><th>&nbsp;</th><th>Yes&nbsp;No</th></tr>
		<cfloop Index="count" From="1" To="#ListLen(Variables.booleanList_value)#">
			<cfset thisBoolean = ListGetAt(Variables.booleanList_value, count)>
			<tr<cfif thisBoolean is not False> onMouseOver="bgColor='FFFFCC'" onMouseOut="bgColor='E7D8F3'"</cfif>><td nowrap>&nbsp; #ListGetAt(Variables.booleanList_label, count)#</td>
			<td><cfif thisBoolean is False>&nbsp;<cfelse><input type="checkbox" name="#thisBoolean#" value="1"<cfif Form[thisBoolean] is 1> checked</cfif> onClick="javascript:checkUncheck('#thisBoolean#', 0)"><input type="checkbox" name="#thisBoolean#" value="0"<cfif Form[thisBoolean] is 0> checked</cfif> onClick="javascript:checkUncheck('#thisBoolean#', 1)"></cfif></td></tr>
			<cfif ListFind("16", count)></table></td><td align="center" valign="top"><table border="0" cellspacing="0" cellpadding="0" class="TableText"><tr class="TableText"><th>&nbsp;</th><th>Yes&nbsp;No</th></tr></cfif>
		</cfloop>
		</table>
	</td>
</tr>

<tr bgcolor="E7D8F3" valign="top">
	<td colspan="2">
		Subscription Interval: 
		<input type="text" name="subscriptionInterval_min" value="#HTMLEditFormat(Form.subscriptionInterval_min)#" size="2" class="TableText">
		 to 
		<input type="text" name="subscriptionInterval_max" value="#HTMLEditFormat(Form.subscriptionInterval_max)#" size="2" class="TableText">
		<select name="subscriptionIntervalType" size="1">
		<option value="">-- INTERVAL --</option>
		<cfloop Index="count" From="1" To="#ListLen(Variables.subscriptionIntervalTypeList_value)#">
			<option value="#ListGetAt(Variables.subscriptionIntervalTypeList_value, count)#"<cfif Form.subscriptionIntervalType is ListGetAt(Variables.subscriptionIntervalTypeList_value, count)> selected</cfif>>#HTMLEditFormat(ListGetAt(Variables.subscriptionIntervalTypeList_label, count))#(s)</option>
		</cfloop>
		</select> 
	</td>
	<td colspan="2" onMouseOver="bgColor='FFFFCC'" onMouseOut="bgColor='E7D8F3'" nworap>
		<label style="font-weight: bold"><input type="checkbox" name="subscriberProcessAllQuantitiesEntered" value="0"<cfif Form.subscriberProcessAllQuantitiesEntered is 0> checked</cfif>> Subscriber Processing - Awaiting Subscription Quantity</label>
		<div class="SmallText">
			&nbsp; &nbsp; Subscriber has at least one variable-quantity subscription and still needs<br>
			&nbsp; &nbsp; final quantity value(s) for billing period before subscriber can be processed.
		</div>
	</td>
</tr>

<tr>
	<td colspan="5" bgcolor="ccccff" align="center">
		Display Per Page: <input type="text" name="queryDisplayPerPage" value="#HTMLEditFormat(Form.queryDisplayPerPage)#" size="2" class="TableText"> &nbsp; &nbsp; 
		<input type="submit" name="submitSubscriberList" value="Submit"> &nbsp; &nbsp; <input type="reset" value="Reset">
	</td>
</tr>
</form>
</table>
</p>
</cfoutput>
