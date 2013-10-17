<cfoutput>
<script language="Javascript" src="#Application.billingUrlroot#/js/popcalendar.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_layers.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_menu.js"></script>

<!--- Basic Search Form --->
<p>
<table border="0" cellspacing="0" cellpadding="2" class="TableText" width="800"><tr bgcolor="ccccff" valign="top" id="basicSearch"<cfif Session.showAdvancedSearch is True> style="display:none;"</cfif>>
<form method="post" name="invoiceListBasic" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">
<input type="hidden" name="showAdvancedSearch" value="False">
<input type="hidden" name="queryOrderBy" value="#HTMLEditFormat(Form.queryOrderBy)#">
<td width="600">
	Display Per Page: <input type="text" name="queryDisplayPerPage" value="#HTMLEditFormat(Form.queryDisplayPerPage)#" size="2" class="TableText"> 	<input type="submit" name="submitInvoiceList" value="Submit">
	&nbsp; &nbsp; &nbsp; &nbsp; 
	<font class="TableText">Date Closed: 
	<a href="index.cfm?method=#URL.control#.listInvoices" class="plainlink"><cfif URL.displayInvoiceSpecial is ""><b>All</b><cfelse>All</cfif></a> | 
	<a href="index.cfm?method=#URL.control#.listInvoices&displayInvoiceSpecial=yesterday" class="plainlink"><cfif URL.displayInvoiceSpecial is "yesterday"><b>Yesterday</b><cfelse>Yesterday</cfif></a> | 
	<a href="index.cfm?method=#URL.control#.listInvoices&displayInvoiceSpecial=today" class="plainlink"><cfif URL.displayInvoiceSpecial is "today"><b>Today</b><cfelse>Today</cfif></a> | 
	<a href="index.cfm?method=#URL.control#.listInvoices&displayInvoiceSpecial=thisWeek" class="plainlink"><cfif URL.displayInvoiceSpecial is "thisWeek"><b>This Week</b><cfelse>This Week</cfif></a> | 
	<a href="index.cfm?method=#URL.control#.listInvoices&displayInvoiceSpecial=thisMonth" class="plainlink"><cfif URL.displayInvoiceSpecial is "thisMonth"><b>This Month</b><cfelse>This Month</cfif></a>
	</font><br>
	<label><input type="checkbox" name="showGraphicsResults" value="True"<cfif IsDefined("Form.showGraphicsResults") and Form.showGraphicsResults is True> checked</cfif>>Display graphical results summary instead of invoice list</label>
</td>
<td width="200" align="right" class="TableText">[ <a href="javascript:void(0);" class="plainlink" onClick="toggle('advancedSearch');toggle('basicSearch');">Show Advanced Search</a> ]</td>
</tr>
</form>
</table>

<!--- Advanced Search Form --->
<table border="0" cellspacing="0" cellpadding="2" class="TableText" width="830" id="advancedSearch"<cfif Session.showAdvancedSearch is False> style="display:none;"</cfif>>
<form method="post" name="#Variables.formName#" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">
<input type="hidden" name="queryOrderBy" value="#HTMLEditFormat(Form.queryOrderBy)#">
<input type="hidden" name="showAdvancedSearch" value="True">
<tr bgcolor="ccccff" class="MainText">
	<td colspan="2"><b>Advanced Search</b></td>
	<td colspan="4" align="right" class="TableText">[ <a href="javascript:void(0);" class="plainlink" onClick="toggle('advancedSearch');toggle('basicSearch');">Return to Basic Search</a> ]</td>
</tr>
<tr bgcolor="E7D8F3" valign="top"><!--- CCCC99 --->
	<td>
		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr>
			<td>From:&nbsp;</td>
			<td nowrap>#fn_FormSelectDateTime(Variables.formName, "invoiceDateFrom_date", Form.invoiceDateFrom_date, "invoiceDateFrom_hh", Form.invoiceDateFrom_hh, False, 0, "invoiceDateFrom_tt", Form.invoiceDateFrom_tt, True)#</td>
		</tr>

		<tr>
			<td align="right">To:&nbsp;</td>
			<td nowrap>#fn_FormSelectDateTime(Variables.formName, "invoiceDateTo_date", Form.invoiceDateTo_date, "invoiceDateTo_hh", Form.invoiceDateTo_hh, False, 0, "invoiceDateTo_tt", Form.invoiceDateTo_tt, True)#</td>
		</tr>
		</table>

		<table border="0" cellspacing="2" cellpadding="2" class="SmallText">
		<tr valign="top">
			<td>
				<label><input type="checkbox" name="invoiceDateType" value="invoiceDateCreated"<cfif ListFind(Form.invoiceDateType, "invoiceDateCreated")> checked</cfif>>Opened</label><br>
				<label><input type="checkbox" name="invoiceDateType" value="invoiceDateClosed"<cfif ListFind(Form.invoiceDateType, "invoiceDateClosed")> checked</cfif>>Closed</label><br>
				<label><input type="checkbox" name="invoiceDateType" value="shippingDateSent"<cfif ListFind(Form.invoiceDateType, "shippingDateSent")> checked</cfif>>Shipped</label><br>
				<label><input type="checkbox" name="invoiceDateType" value="invoiceDateCompleted"<cfif ListFind(Form.invoiceDateType, "invoiceDateCompleted")> checked</cfif>>Fully Processed</label><br>
			</td>
			<td>
				<label><input type="checkbox" name="invoiceDateType" value="paymentDateScheduled"<cfif ListFind(Form.invoiceDateType, "paymentDateScheduled")> checked</cfif>>Payment Scheduled</label><br>
				<label><input type="checkbox" name="invoiceDateType" value="invoiceDateDue"<cfif ListFind(Form.invoiceDateType, "invoiceDateDue")> checked</cfif>>Payment Due</label><br>
				<label><input type="checkbox" name="invoiceDateType" value="invoiceDatePaid"<cfif ListFind(Form.invoiceDateType, "invoiceDatePaid")> checked</cfif>>Fully Paid</label><br>
				<cfif Application.fn_IsUserAuthorized("exportInvoices")><label><input type="checkbox" name="invoiceDateType" value="invoiceDateExported"<cfif ListFind(Form.invoiceDateType, "invoiceDateExported")> checked</cfif>>Exported</label><br></cfif>
			</td>
		</tr>
		</table>
	</td>

	<td>
		&nbsp; Total: 
		$<input type="text" name="invoiceTotal_min" value="#HTMLEditFormat(Form.invoiceTotal_min)#" size="7" class="TableText">
		 to 
		$<input type="text" name="invoiceTotal_max" value="#HTMLEditFormat(Form.invoiceTotal_max)#" size="7" class="TableText"><br>

		<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="6" alt="" border="0"><br>
		<select name="invoiceShippingMethod" size="1" class="SearchSelect">
		<option value="">-- ALL SHIPPING METHODS --</option>
		<cfloop Index="count" From="1" To="#ListLen(Variables.shippingMethodList_value)#">
			<option value="#ListGetAt(Variables.shippingMethodList_value, count)#"<cfif Form.invoiceShippingMethod is ListGetAt(Variables.shippingMethodList_value, count)> selected</cfif>>#HTMLEditFormat(ListGetAt(Variables.shippingMethodList_label, count))#</option>
		</cfloop>
		</select><br>

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
		<cfif Application.fn_IsUserAuthorized("exportInvoices")>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<select name="invoiceIsExported" size="1" class="SearchSelect">
			<option value="-1">-- SELECT EXPORT STATUS --</option>
			<option value=""<cfif Form.invoiceIsExported is ""> selected</cfif>>Not Exported</option>
			<option value="0"<cfif Form.invoiceIsExported is 0> selected</cfif>>Exported - Awaiting Import Confirmation</option>
			<option value="1"<cfif Form.invoiceIsExported is 1> selected</cfif>>Exported - Import Confirmed</option>
			</select><br>
		</cfif>
	</td>

	<cfset Variables.booleanList_value = "invoiceClosed,invoiceCompleted,invoicePaid,invoiceShipped,invoiceStatus,invoiceManual,invoiceSent,invoiceHasCustomID,invoiceHasMultipleItems,invoiceHasCustomPrice,invoiceHasInstructions,invoiceHasPaymentCredit">
	<cfset Variables.booleanList_label = "Is Closed,Is Fully Processed,Is Paid For,Is Shipped,Is Active,Created Manually,Notification Sent,Has Custom ID,Has Multiple Items,Has Custom Price,Has Instructions,Has Payment Credit(s)">

	<td align="center" valign="top">
		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr class="TableText"><th>&nbsp;</th><th>Yes&nbsp;No</th></tr>
		<cfloop Index="count" From="1" To="#ListLen(Variables.booleanList_value)#">
			<cfset thisBoolean = ListGetAt(Variables.booleanList_value, count)>
			<tr onMouseOver="bgColor='FFFFCC'" onMouseOut="bgColor='E7D8F3'"><td nowrap>&nbsp; #ListGetAt(Variables.booleanList_label, count)#</td>
			<td><input type="checkbox" name="#thisBoolean#" value="1"<cfif Form[thisBoolean] is 1> checked</cfif> onClick="javascript:checkUncheck('#thisBoolean#', 0)"><input type="checkbox" name="#thisBoolean#" value="0"<cfif Form[thisBoolean] is 0> checked</cfif> onClick="javascript:checkUncheck('#thisBoolean#', 1)"></td></tr>
			<cfif ListFind("6", count)></table></td><td align="center" valign="top"><table border="0" cellspacing="0" cellpadding="0" class="TableText"><tr class="TableText"><th>&nbsp;</th><th>Yes&nbsp;No</th></tr></cfif>
		</cfloop>
		</table>
	</td>
</tr>
<tr>
	<td colspan="5" bgcolor="ccccff" align="center">
		Display Per Page: <input type="text" name="queryDisplayPerPage" value="#HTMLEditFormat(Form.queryDisplayPerPage)#" size="2" class="TableText"> &nbsp; &nbsp; 
		<input type="submit" name="submitInvoiceList" value="Submit">
		 &nbsp; &nbsp; 
		<input type="reset" value="Reset"><br>
		<label><input type="checkbox" name="showGraphicsResults" value="True"<cfif IsDefined("Form.showGraphicsResults") and Form.showGraphicsResults is True> checked</cfif>>Display graphical results summary instead of invoice list</label>
	</td>
</tr>
</form>
</table>
</p>
<!--- <div class="SmallText">&nbsp; &nbsp; <i>Submitted</i> means the customer has confirmed order. It is not simply a saved or abandoned shopping cart.</div> --->
</cfoutput>

