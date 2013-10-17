<!--- display parameters, exception price premium/discount? --->
<cfoutput>
<SCRIPT LANGUAGE="JavaScript">
<!-- Begin
var checkflag = "false";
function check(field) {
	if (checkflag == "false") {
		for (i = 0; i < field.length; i++) {
			field[i].checked = true;
		}
		checkflag = "true";
		return "Un-Check All As Not Final"; }
	else {
		for (i = 0; i < field.length; i++) {
			field[i].checked = false; }
		checkflag = "false";
		return "Check All As Final";
	}
}
//  End -->
</SCRIPT>

<p class="MainText" style="width: 700">Below are only those subscriptions with a variable quantity for this subscriber. For each subscription, please update the quantity for this billing period and indicate whether the quantity is the final amount. The subscriber will not be processed until all quantities are marked as final. The default value is the quantity specified for this subscription. To use the default quantity, you may leave the quantity field blank. You only enter need to enter the default quantity into the quantity field IF the subscription would otherwise be pro-rated for this billing period, but should not be.</p>

<p class="MainText"><b>
Billing Period: 
<cfif IsDate(qry_selectSubscriber.subscriberDateProcessLast)>#DateFormat(qry_selectSubscriber.subscriberDateProcessLast, "dddd, mmmm dd, yyyy")#<cfelse>#DateFormat(qry_selectSubscriber.subscriberDateCreated, "dddd, mmmm dd, yyyy")#</cfif>
 - #DateFormat(qry_selectSubscriber.subscriberDateProcessNext, "dddd, mmmm dd, yyyy")#
</b></p>

<form method="post" name="#Variables.formName#" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<p><input type=button value="Check All As Final" onClick="this.value=check(this.form.subscriptionProcessQuantityFinal);">
&nbsp; &nbsp; 
<input type="reset" value="Reset"></p>

#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.columnCount, 0, 0, 0, Variables.columnHeaderList, "", False)#
<cfloop Query="qry_selectSubscriptionList">
	<cfset Variables.thisSubscriptionID = qry_selectSubscriptionList.subscriptionID>
	<cfset Variables.subscriptionRow = qry_selectSubscriptionList.CurrentRow>
	<cfif qry_selectSubscriptionList.subscriptionID_rollup is not 0>
		<cfset Variables.rollupRow = ListFind(ValueList(qry_selectSubscriptionList.subscriptionID), qry_selectSubscriptionList.subscriptionID_rollup)>
	<cfelse>
		<cfset Variables.rollupRow = 0>
	</cfif>

	<cfloop Index="loopPriceStageID" List="#subscriptionID_priceStageIDList["subscription#Variables.thisSubscriptionID#"]#">
		<tr class="TableText" valign="top"<cfif (Variables.subscriptionRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td>#qry_selectSubscriptionList.subscriptionOrder[Variables.subscriptionRow]#.</td>
		<td>&nbsp;</td>
		<td>
			#qry_selectSubscriptionList.subscriptionName[Variables.subscriptionRow]#
			<cfif Variables.rollupRow is not 0><div class="SmallText"><i>Rolls up to: #qry_selectSubscriptionList.subscriptionOrder[Variables.rollupRow]#. #qry_selectSubscriptionList.subscriptionName[Variables.rollupRow]#</i></div></cfif>
		</td>
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectSubscriptionList.priceID[Variables.subscriptionRow] is not 0>
				#DateFormat(priceStageStruct["priceStage#loopPriceStageID#"].priceStageDateBegin, "mm-dd-yy")#
			<cfelseif IsDate(qry_selectSubscriptionList.subscriptionDateProcessLast[Variables.subscriptionRow])>
				#DateFormat(qry_selectSubscriptionList.subscriptionDateProcessLast[Variables.subscriptionRow], "mm-dd-yy")#
			<cfelse>
				#DateFormat(qry_selectSubscriptionList.subscriptionDateBegin[Variables.subscriptionRow], "mm-dd-yy")#
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectSubscriptionList.priceID[Variables.subscriptionRow] is 0>
				<cfif IsDate(qry_selectSubscriptionList.subscriptionDateEnd[Variables.subscriptionRow]) and DateCompare(qry_selectSubscriptionList.subscriptionDateEnd[Variables.subscriptionRow], qry_selectSubscriptionList.subscriptionDateProcessNext[Variables.subscriptionRow]) is -1>
					#DateFormat(qry_selectSubscriptionList.subscriptionDateEnd[Variables.subscriptionRow], "mm-dd-yy")#
				<cfelse>
					#DateFormat(qry_selectSubscriptionList.subscriptionDateProcessNext[Variables.subscriptionRow], "mm-dd-yy")#
				</cfif>
			<cfelseif Not IsDate(priceStageStruct["priceStage#loopPriceStageID#"].priceStageDateEnd)>
				No End Date
			<cfelse>
				#DateFormat(priceStageStruct["priceStage#loopPriceStageID#"].priceStageDateEnd, "mm-dd-yy")#
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectSubscriptionList.priceID[Variables.subscriptionRow] is not 0>$#priceStageStruct["priceStage#loopPriceStageID#"].priceStageText#<cfelse>$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectSubscriptionList.subscriptionPriceUnit[Variables.subscriptionRow])#</cfif></td>
		<td>&nbsp;</td>
		<td>#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectSubscriptionList.subscriptionQuantity[Variables.subscriptionRow])#</td>
		<td>&nbsp;</td>
		<cfif qry_selectSubscriptionList.subscriptionIsRollup[Variables.subscriptionRow] is 1>
			<td colspan="3"><b>Rolled To</b></td>
		<cfelse>
			<td><input type="text" name="subscriptionProcessQuantity#Variables.thisSubscriptionID#_#loopPriceStageID#" size="6"<cfif IsNumeric(Form["subscriptionProcessQuantity#Variables.thisSubscriptionID#_#loopPriceStageID#"])> value="#Application.fn_LimitPaddedDecimalZerosQuantity(Form["subscriptionProcessQuantity#Variables.thisSubscriptionID#_#loopPriceStageID#"])#"</cfif>></td>
			<td>&nbsp;</td>
			<td><input type="checkbox" name="subscriptionProcessQuantityFinal" value="#Variables.thisSubscriptionID#_#loopPriceStageID#"<cfif ListFind(Form.subscriptionProcessQuantityFinal, Variables.thisSubscriptionID & "_" & loopPriceStageID)> checked</cfif>></td>
		</cfif>
		</tr>
	</cfloop>
</cfloop>
<tr height="40"><td colspan="#Variables.columnCount#" align="right"><input type="submit" name="submitSubscriptionProcess" value="Update Subscription Quantities"></td></tr>
</table>

</form>
</cfoutput>

