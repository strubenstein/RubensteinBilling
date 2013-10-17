<!--- 
Company fields - custom fields, companyName, companyDBA, companyURL, companyID_custom, companyIsTaxExempt
	parent company (companyID_parent) 
	Affiliate (affiliateID) - affiliateCode, affiliateName, affiliateURL, affiliateID_custom
	Cobrand (cobrandID) - cobrandName, cobrandCode, cobrandImage, cobrandURL, cobrandTitle, cobrandDomain, cobrandID_custom
User fields - custom fields, firstName, lastName, suffix, salutation, email, userID_custom, jobTitle, jobDepartment, jobDivision
Subscriber fields - custom fields, subscriberName, subscriberID_custom, subscriberCompleted, subscriberDateProcessNext, subscriberDateProcessLast
Invoice fields - custom fields, invoiceID, invoiceDateClosed, invoiceDatePaid, invoicePaid, invoiceTotal, invoiceTotalTax, invoiceTotalLineItem, invoiceTotalPaymentCredit, invoiceTotalShipping, invoiceShipped, invoiceDateDue, invoiceID_custom, invoiceManual, invoiceShippingMethod, invoiceInstructions, invoiceDateCreated
Address - shipping, billing (addressID_shipping, addressID_billing)
	addressName,addressDescription,address,address2,address3,city,state,zipCode,zipCodePlus4, county, country
Phone - 
Line Item fields - invoiceLineItemName, invoiceLineItemDescription, invoiceLineItemQuantity, invoiceLineItemPriceUnit, invoiceLineItemPriceNormal, invoiceLineItemSubTotal, invoiceLineItemDiscount, invoiceLineItemTotal, invoiceLineItemTotalTax, invoiceLineItemOrder, invoiceLineItemProductID_custom, invoiceLineItemDateBegin, invoiceLineItemDateEnd, invoiceLineItemDateCreated
	Parameters
	Exception
	Region
	Price - priceStageText, priceStageDescription
	Category - categoryName
	Subscription - subscriptionCompleted, subscriptionDateBegin, subscriptionDateEnd, subscriptionAppliedMaximum, subscriptionAppliedCount, subscriptionIntervalType, subscriptionInterval, subscriptionQuantity, subscriptionQuantityVaries, subscriptionID_custom, subscriptionDescription, subscriptionDateProcessNext, subscriptionDateProcessLast, subscriptionProRate, subscriptionEndByDateOrAppliedMaximum, subscriptionContinuesAfterEnd,
		manual or via subscription
	Vendor - vendorName, vendorCode, vendorURL
	Product - productWeight
Credits - invoicePaymentCreditManual, invoicePaymentCreditDate, invoicePaymentCreditText, invoicePaymentCreditAmount, invoicePaymentCreditRolloverPrevious, invoicePaymentCreditRolloverNext
	Main Credit - paymentCreditAmount, paymentCreditName, paymentCreditID_custom, paymentCreditDescription, paymentCreditDateBegin, paymentCreditDateEnd, paymentCreditAppliedMaximum, paymentCreditAppliedCount, paymentCreditCompleted, paymentCreditDateCreated
	Payment category (paymentCategoryID)
Taxes
Payments & Refunds - invoicePaymentManual, invoicePaymentAmount, invoicePaymentDate
	Main payment/refund - paymentManual, paymentCheckNumber, paymentID_custom, paymentApproved, paymentAmount, paymentDescription, paymentMethod, paymentDateReceived, paymentDateScheduled
	Payment category (paymentCategoryID)
	Credit (creditCardID) - creditCardName, creditCardNumber (last 4), creditCardType, creditCardExpirationMonth, creditCardExpirationYear, creditCardDescription, creditCardRetain
	Bank (bankID) - bankName, bankBranch, bankBranchCity, bankBranchState, bankBranchCountry, bankAccountNumber, bankAccountName (or first/last X numbers), bankDescription, bankAccountType, bankRetain

Custom message
Credit card expiration message
--->

<cfoutput>
<script language="JavaScript">
<!-- Begin
function move(optionValue,optionLabel,selectBox) {
var i = 0;
var isBoxSelected = 0;

for(var i=0; i<selectBox.options.length; i++) 
	{
	if(selectBox.options[i].value == optionValue)
		{
		isBoxSelected = 1;
		selectBox.options[i].value = "";
		selectBox.options[i].text = "";
		BumpUp(selectBox);
		}
	}

if (isBoxSelected == 0)
	{
	var no = new Option();
	no.value = optionValue;
	no.text = optionLabel;
	selectBox.options[selectBox.options.length] = no;
	}
}

function remove(box)
{
for(var i=0; i<box.options.length; i++) 
	{
	if(box.options[i].selected && box.options[i] != "")
		{
		box.options[i].value = "";
		box.options[i].text = "";
		}
	}
BumpUp(box);
}

function BumpUp(abox)
{
for(var i = 0; i < abox.options.length; i++)
{
	if(abox.options[i].value == "")
	{
		for(var j = i; j < abox.options.length - 1; j++)
			{
			abox.options[j].value = abox.options[j + 1].value;
			abox.options[j].text = abox.options[j + 1].text;
			}
		var ln = i;
		break;
	}
}
if(ln < abox.options.length)
	{
	abox.options.length -= 1;
	BumpUp(abox);
	}
}

function Moveup(dbox)
{
for(var i = 0; i < dbox.options.length; i++)
{
	if (dbox.options[i].selected && dbox.options[i] != "" && dbox.options[i] != dbox.options[0])
	{
		var tmpval = dbox.options[i].value;
		var tmpval2 = dbox.options[i].text;
		dbox.options[i].value = dbox.options[i - 1].value;
		dbox.options[i].text = dbox.options[i - 1].text
		dbox.options[i-1].value = tmpval;
		dbox.options[i-1].text = tmpval2;
		}
	}
}

function Movedown(ebox)
{
for(var i = 0; i < ebox.options.length; i++)
	{
	if (ebox.options[i].selected && ebox.options[i] != "" && ebox.options[i+1] != ebox.options[ebox.options.length])
		{
		var tmpval = ebox.options[i].value;
		var tmpval2 = ebox.options[i].text;
		ebox.options[i].value = ebox.options[i+1].value;
		ebox.options[i].text = ebox.options[i+1].text
		ebox.options[i+1].value = tmpval;
		ebox.options[i+1].text = tmpval2;
		}
   }
}

function saveFields (field)
{
	for (i = 0; i < field.length; i++)
	{
		field[i].selected = true;
	}
}
//  End -->
</script>

<form method="post" name="#Variables.formName#" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<p>
<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>Document Title: </td>
	<td><input type="text" name="documentTitle" value="#HTMLEditFormat(Form.documentTitle)#" size="40"> <font class="SmallText">(e.g., Invoice, Receipt)</font></td>
</tr>
<tr><td colspan="2"><b>Your Company Information:</b></td></tr>
<tr>
	<td>Company Logo: </td>
	<td><input type="text" name="companyLogo" value="#HTMLEditFormat(Form.companyLogo)#" size="60"></td>
</tr>
<tr>
	<td>Company Name: </td>
	<td><input type="text" name="companyLegalName" value="#HTMLEditFormat(Form.companyLegalName)#" size="60"></td>
</tr>
<tr>
	<td>Company Slogan: </td>
	<td><input type="text" name="companySlogan" value="#HTMLEditFormat(Form.companySlogan)#" size="60"></td>
</tr>
</table>
<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>
		Address:<br>
		<textarea name="companyAddress" rows="4" cols="35" wrap="off">#HTMLEditFormat(Form.companyAddress)#</textarea>
	</td>
	<td>
		Contact Info:<br>
		<textarea name="companyContact" rows="4" cols="35" wrap="off">#HTMLEditFormat(Form.companyContact)#</textarea>
	</td>
</tr>
</table>
</p>

<p>
<div class="MainText"><b>Customer Information:</b></div>
<table border="0" cellspacing="0" cellpadding="2" class="MainText">
<tr class="TableHeader">
	<th>Field</th>
	<th>Display?</th>
	<th>Field Header</th>
	<th align="left">&nbsp;Format Options</th>
</tr>
<tr>
	<td>Company Name</td>
	<td align="center"><input type="checkbox" name="companyFields" value="companyName"<cfif ListFind(Form.companyFields, "companyName")> checked</cfif>></td>
	<td><input type="text" name="companyFields_companyName_header" value="#HTMLEditFormat(Form.companyFields_companyName_header)#" size="40"></td>
	<td>
		<select name="companyFields_companyNameOrDBA" size="1">
			<option value="companyName"<cfif Form.companyFields_companyNameOrDBA is "companyName"> selected</cfif>>Company Name</option>
			<option value="companyDBA"<cfif Form.companyFields_companyNameOrDBA is "companyDBA"> selected</cfif>>Company DBA</option>
			<option value="companyNameThenDBA"<cfif Form.companyFields_companyNameOrDBA is "companyNameThenDBA"> selected</cfif>>Name if not blank, otherwise DBA</option>
			<option value="companyDBAThenName"<cfif Form.companyFields_companyNameOrDBA is "companyDBAThenName"> selected</cfif>>DBA if not blank, otherwise name</option>
			<option value="companyNameAndDBA"<cfif Form.companyFields_companyNameOrDBA is "companyNameAndDBA"> selected</cfif>>Both if both not blank</option>
		</select>
	</td>
</tr>
<tr bgcolor="f4f4ff">
	<td>Company ID</td>
	<td align="center"><input type="checkbox" name="companyFields" value="companyID"<cfif ListFind(Form.companyFields, "companyID")> checked</cfif>></td>
	<td><input type="text" name="companyFields_companyID_header" size="40"></td>
	<td>
		<select name="companyFields_companyIDOrCustomID" size="1">
			<option value="companyID"<cfif Form.companyFields_companyIDOrCustomID is "companyID"> selected</cfif>>Company ID (system-generated)</option>
			<option value="companyID_custom"<cfif Form.companyFields_companyIDOrCustomID is "companyID_custom"> selected</cfif>>Custom ID (assigned by you)</option>
			<option value="companyIDorCustom"<cfif Form.companyFields_companyIDOrCustomID is "companyIDorCustom"> selected</cfif>>Custom ID if exists (otherwise ID)</option>
		</select>
	</td>
</tr>
<tr>
	<td>Contact Name</td>
	<td align="center"><input type="checkbox" name="userFields" value="fullName"<cfif ListFind(Form.userFields, "fullName")> checked</cfif>></td>
	<td><input type="text" name="userFields_fullName_header" value="#HTMLEditFormat(Form.userFields_fullName_header)#" size="40"></td>
	<td>(If user is specified)</td>
</tr>
</table>
</p>

<p>
<div class="MainText"><b>Invoice Fields:</b></div>
<table border="0" cellspacing="0" cellpadding="2" class="MainText">
<tr class="TableHeader" valign="bottom">
	<th align="left">Field</th>
	<th>Display?</th>
	<th>Field Header</th>
	<th align="left">&nbsp;Format Options</th>
</tr>

<tr>
	<td>Invoice ID</td>
	<td align="center"><input type="checkbox" name="invoiceFields" value="invoiceID"<cfif ListFind(Form.invoiceFields, "invoiceID")> checked</cfif>></td>
	<td><input type="text" name="invoiceFields_invoiceID_header" value="#HTMLEditFormat(Form.invoiceFields_invoiceID_header)#" size="40"></td>
	<td>
		<select name="invoiceFields_invoiceIDorCustomID" size="1">
			<option value="invoiceID"<cfif Form.invoiceFields_invoiceIDorCustomID is "invoiceID"> selected</cfif>>Invoice ID (system-generated)</option>
			<option value="invoiceID_custom"<cfif Form.invoiceFields_invoiceIDorCustomID is "invoiceID_custom"> selected</cfif>>Custom ID (assigned by you)</option>
			<option value="invoiceIDorCustom"<cfif Form.invoiceFields_invoiceIDorCustomID is "invoiceIDorCustom"> selected</cfif>>Custom ID if exists (otherwise ID)</option>
		</select>
	</td>
</tr>
<tr valign="top" bgcolor="f4f4ff">
	<td>Invoice Date (date closed)</td>
	<td align="center"><input type="checkbox" name="invoiceFields" value="invoiceDateClosed"<cfif ListFind(Form.invoiceFields, "invoiceDateClosed")> checked</cfif>></td>
	<td><input type="text" name="invoiceFields_invoiceDateClosed_header" value="#HTMLEditFormat(Form.invoiceFields_invoiceDateClosed_header)#" size="40"></td>
	<td>
		<select name="invoiceFields_invoiceDateClosed_dateFormat" size="1">
		<cfloop Index="dateMask" List="#Variables.dateFormatList#" Delimiters="|">
			<option value="#dateMask#"<cfif Form.invoiceFields_invoiceDateClosed_dateFormat is dateMask> selected</cfif>>#DateFormat(Now(), dateMask)#<cfif Find("dd", dateMask) and Find("d/m", dateMask)> (padded, d/m/y)<cfelseif Find("dd", dateMask)> (padded)<cfelseif Find("d/m", dateMask)>(d/m/y)</cfif></option>
		</cfloop>
		</select>
		<div class="SmallText">Padded means zeros in month or day are padded (05/04 instead of 5/4)</div>
	</td>
</tr>
<tr valign="top">
	<td>Payment Due Date</td>
	<td align="center"><input type="checkbox" name="invoiceFields" value="invoiceDateDue"<cfif ListFind(Form.invoiceFields, "invoiceDateDue")> checked</cfif>></td>
	<td><input type="text" name="invoiceFields_invoiceDateDue_header" value="#HTMLEditFormat(Form.invoiceFields_invoiceDateDue_header)#" size="40"></td>
	<td>
		<select name="invoiceFields_invoiceDateDue_dateFormat" size="1">
		<cfloop Index="dateMask" List="#Variables.dateFormatList#" Delimiters="|">
			<option value="#dateMask#"<cfif Form.invoiceFields_invoiceDateDue_dateFormat is dateMask> selected</cfif>>#DateFormat(Now(), dateMask)#<cfif Find("dd", dateMask) and Find("d/m", dateMask)> (padded, d/m/y)<cfelseif Find("dd", dateMask)> (padded)<cfelseif Find("d/m", dateMask)>(d/m/y)</cfif></option>
		</cfloop>
		</select>
	</td>
</tr>

<cfloop Index="count" From="1" To="#ListLen(Variables.invoiceFields_value)#">
	<cfset Variables.thisField = ListGetAt(Variables.invoiceFields_value, count)>
	<tr<cfif (count mod 2) is 1> bgcolor="f4f4ff"</cfif>>
	<td>#ListGetAt(Variables.invoiceFields_label, count)#</td>
	<td align="center"><input type="checkbox" name="invoiceFields" value="#Variables.thisField#"<cfif ListFind(Form.invoiceFields, Variables.thisField)> checked</cfif>></td>
	<td><input type="text" name="invoiceFields_#Variables.thisField#_header" value="#HTMLEditFormat(Form["invoiceFields_#Variables.thisField#_header"])#" size="40"></td>
	<td>&nbsp;</td>
	</tr>
</cfloop>
</table>
</p>


<!--- 
ORDER OF: line items, credits, payments, refundssince, paymentssince
combine into single table?
column order, header
--->

<p>
<div class="MainText"><b>Invoice Line Item Fields:</b></div>
<div class="SmallText">Table headers may include html. To specify a carriage return in the header, use &quot;&lt;br&gt;&quot;.<br>
Options apply to invoice credits as well, which are listed below the line items.</div>
<table border="0" cellspacing="0" cellpadding="2" class="MainText">
<tr class="TableHeader" valign="bottom">
	<th align="left">Field Name</th>
	<th>Display?</th>
	<th>Column Header</th>
	<th width="15">&nbsp;</th>
	<th align="left">Order</th>
</tr>
<cfloop Index="count" From="1" To="#ListLen(Variables.invoiceLineItemFields_value)#">
	<cfset Variables.thisField = ListGetAt(Variables.invoiceLineItemFields_value, count)>
	<cfset Variables.thisLabel = ListGetAt(Variables.invoiceLineItemFields_label, count)>
	<tr<cfif (count mod 2) is 0> bgcolor="f4f4ff"</cfif>>
	<td>#Variables.thisLabel#</td>
	<td align="center"><input type="checkbox" name="invoiceLineItemFields" value="#Variables.thisField#"<cfif ListFind(Form.invoiceLineItemFields, Variables.thisField)> checked</cfif> onClick="move('#Variables.thisField#','#Variables.thisLabel#',document.#Variables.formName#.invoiceLineItemFields_order)"></td>
	<td><input type="text" name="invoiceLineItemFields_#Variables.thisField#_header" value="#HTMLEditFormat(Form["invoiceLineItemFields_#Variables.thisField#_header"])#" size="40"></td>
	<cfif count is 1>
		<td>&nbsp;</td>
		<td rowspan="#ListLen(Variables.invoiceLineItemFields_value)#" valign="top">
			<p class="SmallText">
			As fields are checked, they are<br>
			added to the list below. From<br>
			this list, you can re-order the<br>
			columns by selecting the column<br>
			to move and then clicking the up<br>
			or down button. To remove a column,<br>
			simply un-check the checkbox.
			</p>

			<select name="invoiceLineItemFields_order" size="7" multiple>
			<cfloop Index="field" List="#Form.invoiceLineItemFields_order#">
				<cfset Variables.itemRow = ListFind(Variables.invoiceLineItemFields_value, field)>
				<cfif Variables.itemRow is not 0>
					<option value="#field#">#ListGetAt(Variables.invoiceLineItemFields_label, Variables.itemRow)#</option>
				</cfif>
			</cfloop>
			<cfloop Index="field" List="#Form.invoiceLineItemFields#">
				<cfif Not ListFind(Form.invoiceLineItemFields_order, field)>
					<cfset Variables.itemRow = ListFind(Variables.invoiceLineItemFields_value, field)>
					<cfif Variables.itemRow is not 0>
						<option value="#field#">#ListGetAt(Variables.invoiceLineItemFields_label, Variables.itemRow)#</option>
					</cfif>
				</cfif>
			</cfloop>
			</select><br>
			<input type="button" value="Up" onclick="Moveup(this.form.invoiceLineItemFields_order)" name="B3"> &nbsp; 
			<input type="button" value="Down" onclick="Movedown(this.form.invoiceLineItemFields_order)" name="B4">
		</td>
	</cfif>
	</tr>
</cfloop>
</table>
</p>

<p>
<div class="MainText"><b>Scheduled Payment Information:</b></div>
<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr class="TableHeader" valign="bottom">
	<th align="left">Field Name</th>
	<th align="left">&nbsp;Options</th>
	<th align="left">&nbsp;Available Fields</th>
</tr>
<tr>
	<td>Scheduled Payment Date</td>
	<td>
		<select name="paymentDateScheduled_dateFormat" size="1">
		<cfloop Index="dateMask" List="#Variables.dateFormatList#" Delimiters="|">
			<option value="#dateMask#"<cfif Form.paymentDateScheduled_dateFormat is dateMask> selected</cfif>>#DateFormat(Now(), dateMask)#<cfif Find("dd", dateMask) and Find("d/m", dateMask)> (padded, d/m/y)<cfelseif Find("dd", dateMask)> (padded)<cfelseif Find("d/m", dateMask)>(d/m/y)</cfif></option>
		</cfloop>
		</select>
	</td>
	<td>&lt;&lt;paymentDateScheduled&gt;&gt;</td>
</tr>
<tr valign="top">
	<td>If payment by Credit Card:</td>
	<td><textarea name="paymentMethod_creditCardID_text" rows="5" cols="60">#HTMLEditFormat(Form.paymentMethod_creditCardID_text)#</textarea></td>
	<td class="TableText">
		&lt;&lt;creditCardType&gt;&gt; <font class="SmallText">(<i>e.g., Visa</i>)</font><br>
		&lt;&lt;creditCardNumberLast4&gt;&gt; <font class="SmallText">(<i>1234</i>)</font><br>
	</td>
</tr>
<tr valign="top">
	<td>If payment by Bank:</td>
	<td><textarea name="paymentMethod_bankID_text" rows="5" cols="60">#HTMLEditFormat(Form.paymentMethod_bankID_text)#</textarea></td>
	<td class="TableText">
		&lt;&lt;bankName&gt;&gt; <font class="SmallText">(<i>e.g., Wells Fargo</i>)</font><br>
		&lt;&lt;bankCheckingOrSavings&gt;&gt; <font class="SmallText">(<i>&quot;checking&quot; or &quot;savings&quot;</i>)</font><br>
		&lt;&lt;bankPersonalOrCorporate&gt;&gt; <font class="SmallText">(<i>&quot;personal&nbsp; or &quot;corporate&nbsp;</i>)</font><br>
		&lt;&lt;bankAccountNumberLast4&gt;&gt; <font class="SmallText">(<i>1234</i>)</font><br>
	</td>
</tr>

<tr valign="top">
	<td>If other payment method:</td>
	<td><textarea name="paymentMethod_other_text" rows="5" cols="60">#HTMLEditFormat(Form.paymentMethod_other_text)#</textarea></td>
	<td class="TableText">&lt;&lt;paymentMethod&gt;&gt; <font class="SmallText">(<i>e.g., Check</i>)</font><br></td>
</tr>
</table>
</p>

<p class="MainText">
<b>Invoice Footer:</b><br>
<textarea name="documentFooter" rows="5" cols="80">#HTMLEditFormat(Form.documentFooter)#</textarea>
</p>

<p>
<input type="submit" name="submitCustomizeTemplate" value="#HTMLEditFormat(Variables.formSubmitValue)#" onClick="saveFields(this.form.invoiceLineItemFields_order);">
&nbsp; &nbsp; &nbsp; 
<input type="submit" name="submitPreviewTemplate" value="#HTMLEditFormat(Variables.formPreviewValue)#" onClick="saveFields(this.form.invoiceLineItemFields_order);">
</p>
<p class="TableText">Preview - Displays sample invoice based on these settings, with this form below.<br>
Changes are NOT saved until you click the &quot;Save Changes&quot; button.</p>
</form>
</cfoutput>

<!--- 
<p>
<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr valign="top">
	<td>Credits: </td>
	<td>
		<input type="checkbox" name="paymentCreditFields" value="invoicePaymentCreditDate">Credit Date &nbsp; 
		<input type="checkbox" name="paymentCreditFields" value="invoicePaymentCreditText">Description &nbsp; 
		<input type="checkbox" name="paymentCreditFields" value="invoicePaymentCreditAmount">Amount &nbsp; 
		<input type="checkbox" name="paymentCreditFields" value="paymentCreditID_custom">Custom ID &nbsp; 
	</td>
</tr>
<tr valign="top" bgcolor="f4f4f4">
	<td>Payments For<br>This Invoice: </td>
	<td>
		<input type="checkbox" name="paymentFields" value="paymentAmount">Full Payment Amount &nbsp; 
		<input type="checkbox" name="paymentFields" value="invoicePaymentAmount">Amount applied to this invoice<br>
		<input type="checkbox" name="paymentFields" value="paymentMethod">Payment Method &nbsp; 
		<input type="checkbox" name="paymentFields" value="paymentDateScheduled">Scheduled Payment Date &nbsp; 
		<input type="checkbox" name="paymentFields" value="paymentCheckNumber">Check Number &nbsp; 
		<input type="checkbox" name="paymentFields" value="paymentDateReceived">Date Payment Was Received&nbsp; 
	</td>
</tr>
<tr valign="top">
	<td>Payments Since<br>Last Invoice: </td>
	<td>
		<input type="checkbox" name="paymentSinceLastInvoiceFields" value="paymentAmount">Full Payment Amount &nbsp; 
		<input type="checkbox" name="paymentSinceLastInvoiceFields" value="invoicePaymentAmount">Amount applied to this invoice<br>
		<input type="checkbox" name="paymentSinceLastInvoiceFields" value="paymentMethod">Payment Method &nbsp; 
		<input type="checkbox" name="paymentSinceLastInvoiceFields" value="paymentDateScheduled">Scheduled Payment Date &nbsp; 
		<input type="checkbox" name="paymentSinceLastInvoiceFields" value="paymentCheckNumber">Check Number &nbsp; 
		<input type="checkbox" name="paymentSinceLastInvoiceFields" value="paymentDateReceived">Date Payment Was Received&nbsp; 
	</td>
</tr>
<tr valign="top" bgcolor="f4f4f4">
	<td>Refunds Since<br>Last Invoice: </td>
	<td>
		<input type="checkbox" name="paymentRefundSinceLastInvoiceFields" value="paymentAmount">Refund Amount &nbsp; 
		<input type="checkbox" name="paymentRefundSinceLastInvoiceFields" value="paymentMethod">Refund Method &nbsp; 
		<input type="checkbox" name="paymentRefundSinceLastInvoiceFields" value="paymentDateScheduled">Scheduled Refund Date &nbsp; 
		<input type="checkbox" name="paymentRefundSinceLastInvoiceFields" value="paymentDateReceived">Date Payment Was Received&nbsp; 
	</td>
</tr>
</table>
--->

