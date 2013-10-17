<cfoutput>
<script language="Javascript" src="#Application.billingUrlRoot#/js/popcalendar.js"></script>
<script language="JavaScript" src="#Application.billingUrlRoot#/js/lw_layers.js"></script>
<script language="JavaScript" src="#Application.billingUrlRoot#/js/lw_menu.js"></script>

<form method="post" name="#Variables.formName#" action="#Variables.formAction#">
<input type="hidden" name="isSubmitted" value="True">

<p>
<table border="0" cellspacing="2" cellpadding="2" class="TableText">
<tr>
	<td colspan="2">
		<table border="0" cellspacing="2" cellpadding="2" class="TableText">
		<tr>
			<td>From:&nbsp;</td>
			<td>#fn_FormSelectDateTime(Variables.formName, "loginSessionDateBegin_from", Form.loginSessionDateBegin_from, "", 0, False, 0, "", "am", True)#</td>
			<td> &nbsp; &nbsp; To:</td>
			<td>#fn_FormSelectDateTime(Variables.formName, "loginSessionDateBegin_to", Form.loginSessionDateBegin_to, "", 0, False, 0, "", "am", True)#</td>
		</tr>
		</table>
		<i>To view most recent login session only, leave date fields blank.</i>
	</td>
</tr>
<tr>
	<td>User(s): </td>
	<td>
		<select name="userID" size="1" class="TableText">
		<option value="0"<cfif Form.userID is 0> selected</cfif>>-- ALL USERS --</option>
		<cfloop query="qry_selectUserList"><option value="#qry_selectUserList.userID#"<cfif Form.userID is qry_selectUserList.userID> selected</cfif>>#HTMLEditFormat(qry_selectUserList.lastName)#, #HTMLEditFormat(qry_selectUserList.firstName)#</option></cfloop>
		</select> &nbsp; &nbsp; <input type="submit" name="submitLoginSessions" value="Submit">
	</td>
</tr>
</table>
</p>

</form>
</cfoutput>