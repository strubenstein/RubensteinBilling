<cfoutput>
<p><table border="0" cellspacing="0" cellpadding="0" width="550"><tr><td class="MainText">
Please select the template to use for each combination of document type, notification method and payment method.
Document types include: invoice, receipt, rejection, and final rejection when the maximum number of rejections per invoice, subscriber or company are reached.
For each document type, you may use multiple templates for different notification/payment method combinations.
To add another template option, enter the new number next to that document type and click the &quot;Go&quot; button to add another option.
</td></tr></table></p>

<form method="post" name="insertPayflowTemplate" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<cfloop Index="count0" From="1" To="#ListLen(Variables.payflowTemplateTypeList_value)#">
	<cfset type = ListGetAt(Variables.payflowTemplateTypeList_value, count0)>
	<p>
	<div class="MainText">
	<b>#ListGetAt(Variables.payflowTemplateTypeList_label, count0)#: </b>
	<input type="text" name="#type#Count" value="#HTMLEditFormat(Form["#type#Count"])#" size="2"> <input type="submit" name="submit#type#Count" value="Go">
	</div>
	<table border="1" cellspacing="0" cellpadding="2" class="TableText">
	<cfloop Index="count" From="1" To="#Form["#type#Count"]#">
		<cfset count1 = count>
		<tr valign="top"<cfif (count mod 2) is 0> bgcolor="f4f4ff"</cfif>>
			<td>Template: </td>
			<td>
				<select name="templateID_#type##count1#" size="1">
				<option value="0">-- SELECT TEMPLATE --</option>
				<cfloop Query="qry_selectTemplateList">
					<cfif qry_selectTemplateList.templateStatus is 1 or Form["templateID_#type##count1#"] is qry_selectTemplateList.templateID>
						<option value="#qry_selectTemplateList.templateID#"<cfif Form["templateID_#type##count1#"] is qry_selectTemplateList.templateID> selected</cfif>>#HTMLEditFormat(qry_selectTemplateList.templateName)#</option>
					</cfif>
				</cfloop>
				</select>
			</td>
		</tr>
		<tr valign="top"<cfif (count mod 2) is 0> bgcolor="f4f4ff"</cfif>>
			<td>Notify Method: </td>
			<td>
				<cfloop Index="count2" From="1" To="#ListLen(Variables.payflowTemplateNotifyMethodList_value)#">
					<label><input type="checkbox" name="payflowTemplateNotifyMethod_#type##count1#" value="#ListGetAt(Variables.payflowTemplateNotifyMethodList_value, count2)#"<cfif ListFind(Form["payflowTemplateNotifyMethod_#type##count1#"], ListGetAt(Variables.payflowTemplateNotifyMethodList_value, count2))> checked</cfif>>#ListGetAt(Variables.payflowTemplateNotifyMethodList_label, count2)#</label> &nbsp; 
				</cfloop>
			</td>
		</tr>
		<tr valign="top"<cfif (count mod 2) is 0> bgcolor="f4f4ff"</cfif>>
			<td>Payment Method: </td>
			<td>
				<cfloop Index="count2" From="1" To="#ListLen(Variables.paymentMethodList_value)#">
					<label><input type="checkbox" name="payflowTemplatePaymentMethod_#type##count1#" value="#ListGetAt(Variables.paymentMethodList_value, count2)#"<cfif ListFind(Form["payflowTemplatePaymentMethod_#type##count1#"], ListGetAt(Variables.paymentMethodList_value, count2))> checked</cfif>>#ListGetAt(Variables.paymentMethodList_label, count2)#</label> &nbsp; 
				</cfloop>
			</td>
		</tr>
	</cfloop>
	</table>
	</p>
</cfloop>

<hr><hr><div class="SubTitle">A Better Way?</div>
<!--- loop thru document type and notify method --->
<cfloop Index="count0" From="1" To="#ListLen(Variables.payflowTemplateTypeList_value)#">
	<cfset type = ListGetAt(Variables.payflowTemplateTypeList_value, count0)>
	<p>
	<div class="MainText"><b>#ListGetAt(Variables.payflowTemplateTypeList_label, count0)#: </b></div>
	<table border="1" cellspacing="0" cellpadding="2" class="TableText">
	<cfloop Index="count" From="1" To="#ListLen(Variables.payflowTemplateNotifyMethodList_value)#">
		<tr valign="top" class="TableText"<cfif (count mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td>#ListGetAt(Variables.payflowTemplateNotifyMethodList_label, count)#: </td>
		<td>
			Template: 
			<select name="templateID_#type##count1#" size="1">
			<option value="0">-- SELECT TEMPLATE --</option>
			<cfloop Query="qry_selectTemplateList">
				<cfif qry_selectTemplateList.templateStatus is 1>
					<option value="#qry_selectTemplateList.templateID#">#HTMLEditFormat(qry_selectTemplateList.templateName)#</option>
				</cfif>
			</cfloop>
			</select><br>
			Payment Method: 
			<cfloop Index="count2" From="1" To="#ListLen(Variables.paymentMethodList_value)#">
				<label><input type="checkbox" name="payflowTemplatePaymentMethod" value="1">#ListGetAt(Variables.paymentMethodList_label, count2)#</label> &nbsp; 
			</cfloop>
		</td>
		</tr>
	</cfloop>
	</table>
	</p>
</cfloop>

<hr><hr><div class="SubTitle">A Best Way?</div>
<p>
<table border="1" cellspacing="0" cellpadding="2">
<tr class="TableHeader" valign="bottom">
	<th>Notification<br>Method</th>
	<th>Template</th>
	<th>Payment Method(s)</th>
</tr>
<cfloop Index="count0" From="1" To="#ListLen(Variables.payflowTemplateTypeList_value)#">
	<cfset type = ListGetAt(Variables.payflowTemplateTypeList_value, count0)>
	<tr class="MainText"><td colspan="3" bgcolor="navy" height="30" valign="bottom"><font color="white"><b>Document Type: #ListGetAt(Variables.payflowTemplateTypeList_label, count0)#</b></font></td></tr>
	<cfloop Index="count" From="1" To="#ListLen(Variables.payflowTemplateNotifyMethodList_value)#">
		<tr valign="center" class="TableText"<cfif (count mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td>#ListGetAt(Variables.payflowTemplateNotifyMethodList_label, count)#: </td>
		<td align="center">
			<select name="templateID_#type##count1#" size="1">
			<option value="0">-- SELECT TEMPLATE --</option>
			<cfloop Query="qry_selectTemplateList">
				<cfif qry_selectTemplateList.templateStatus is 1>
					<option value="#qry_selectTemplateList.templateID#">#HTMLEditFormat(qry_selectTemplateList.templateName)#</option>
				</cfif>
			</cfloop>
			</select>
		</td>
		<td>
			<cfloop Index="count2" From="1" To="#ListLen(Variables.paymentMethodList_value)#">
				<label><input type="checkbox" name="payflowTemplatePaymentMethod" value="1">#ListGetAt(Variables.paymentMethodList_label, count2)#</label><cfif count2 is 5><br><cfelse> &nbsp; </cfif>
			</cfloop>
		</td>
		</tr>
	</cfloop>
</cfloop>
</table>
</p>

<hr><hr><div class="SubTitle">A Better Best Way?</div>
<cfloop Index="count0" From="1" To="#ListLen(Variables.payflowTemplateTypeList_value)#">
	<p>
	<table border="1" cellspacing="0" cellpadding="2">
	<tr class="MainText"><td colspan="3" bgcolor="navy" height="30" valign="bottom"><font color="white"><b>Document Type: #ListGetAt(Variables.payflowTemplateTypeList_label, count0)#</b></font></td></tr>
	<tr class="TableHeader" valign="bottom">
		<th>Notification<br>Method</th>
		<th>Template</th>
		<th>Payment Method(s)</th>
	</tr>
	<cfset type = ListGetAt(Variables.payflowTemplateTypeList_value, count0)>
	<cfloop Index="count" From="1" To="#ListLen(Variables.payflowTemplateNotifyMethodList_value)#">
		<tr valign="center" class="TableText"<cfif (count mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td>#ListGetAt(Variables.payflowTemplateNotifyMethodList_label, count)#: </td>
		<td align="center">
			<select name="templateID_#type##count1#" size="1">
			<option value="0">-- SELECT TEMPLATE --</option>
			<cfloop Query="qry_selectTemplateList">
				<cfif qry_selectTemplateList.templateStatus is 1>
					<option value="#qry_selectTemplateList.templateID#">#HTMLEditFormat(qry_selectTemplateList.templateName)#</option>
				</cfif>
			</cfloop>
			</select>
		</td>
		<td>
			<cfloop Index="count2" From="1" To="#ListLen(Variables.paymentMethodList_value)#">
				<label><input type="checkbox" name="payflowTemplatePaymentMethod" value="1">#ListGetAt(Variables.paymentMethodList_label, count2)#</label><cfif count2 is 5><br><cfelse> &nbsp; </cfif>
			</cfloop>
		</td>
		</tr>
	</cfloop>
	</table>
	</p>
</cfloop>

<cfif Variables.formAction is not "">
	<input type="submit" name="submitPayflowTemplate" value="Update Template Options">
</cfif>
</form>
</cfoutput>
