<cfoutput>
<cfif qry_selectPayflowList.RecordCount is 0>
	<p class="ErrorMessage">There are currently no subscription processing methods.</p>
<cfelse>
	<script language="Javascript" src="#Application.billingUrlroot#/js/popcalendar.js"></script>
	<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_layers.js"></script>
	<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_menu.js"></script>

	<p class="MainText">You may choose multiple subscription processing methods for this company, but the dates cannot overlap.<br>
	Only one may have a blank end date, i.e., be open-ended. To schedule a new processing method to begin<br>
	after an existing one, choose for the next one to begin on the day <i>after</i> the previous one ends (not the same day).</p>

	<cfif URL.control is "company" and IsDefined("qry_selectPayflowForCompany")>
		<p class="MainText">Based on the company and group settings, this company is processed using: <i>#qry_selectPayflowForCompany.payflowName#</i></p>
	</cfif>

	<form method="post" name="#Variables.formName#" action="#Variables.formAction#">
	<input type="hidden" name="isFormSubmitted" value="True">

	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.columnCount, 0, 0, 0, Variables.columnHeaderList, "", False)#
	<cfloop Query="qry_selectPayflowList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td align="right">#qry_selectPayflowList.payflowOrder#</td><td>&nbsp;</td>
		<td>#qry_selectPayflowList.payflowName#</td>
		<cfif Variables.displayPayflowID_custom is True>
			<td>&nbsp;</td>
			<td><cfif qry_selectPayflowList.payflowID_custom is "">&nbsp;<cfelse>#qry_selectPayflowList.payflowID_custom#</cfif></td>
		</cfif>
		<td>&nbsp;</td>
		<td align="center" class="SmallText"><cfif qry_selectPayflowList.payflowDefault is 0>&nbsp;<cfelse>Default</cfif></td><td>&nbsp;</td>
		<td align="center" class="SmallText"><cfif qry_selectPayflowList.payflowStatus is 0><font color="red">Inactive</font><cfelse><font color="green">Active</font></cfif></td><td>&nbsp;</td>
		<td align="center"><input type="checkbox" name="payflowID" value="#qry_selectPayflowList.payflowID#"<cfif ListFind(Form.payflowID, qry_selectPayflowList.payflowID)> checked</cfif>></td><td>&nbsp;</td>
		<td>#fn_FormSelectDateTime(Variables.formName, "payflowTargetDateBegin#qry_selectPayflowList.payflowID#_date", Form["payflowTargetDateBegin#qry_selectPayflowList.payflowID#_date"], "", 0, "", 0, "", "am", True)#</td><td>&nbsp;</td>
		<td>#fn_FormSelectDateTime(Variables.formName, "payflowTargetDateEnd#qry_selectPayflowList.payflowID#_date", Form["payflowTargetDateEnd#qry_selectPayflowList.payflowID#_date"], "", "0", "", 0, "", "am", True)#</td>
		</tr>
	</cfloop>

	<cfif Variables.formSubmitValue is not "">
		<tr height="40" valign="bottom">
			<td colspan="#Variables.columnCount#" align="center"><input type="submit" name="#Variables.formSubmitName#" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
		</tr>
	</cfif>
	</table>
	</form>
</cfif>
</cfoutput>
