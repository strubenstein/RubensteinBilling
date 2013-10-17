<cfoutput>
<script language="Javascript" src="#Application.billingUrlroot#/js/popcalendar.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_layers.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_menu.js"></script>

<form method="post" name="#taskStruct.formName#" action="#taskStruct.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">

<tr>
	<td valign="top">Status: </td>
	<td>
		<label><input type="checkbox" name="taskCompleted" value="1"<cfif Form.taskCompleted is 1> checked</cfif>> Completed</label> &nbsp; &nbsp; 
		<label><input type="checkbox" name="taskStatus" value="0"<cfif Form.taskStatus is 0> checked</cfif>> Ignored</label>
	</td>
</tr>
<tr>
	<td valign="top">Task Description: <br><br>(<i>Max. #maxlength_Task.taskMessage#<br>characters</i>)</td>
	<td class="TableText"><textarea name="taskMessage" rows="5" cols="40" wrap="soft">#HTMLEditFormat(Form.taskMessage)#</textarea></td>
</tr>
<cfif taskStruct.insertUpdateTaskForOthers is True>
	<tr>
		<td>Assigned To: </td>
		<td>
			<select name="userID_agent" size="1">
			<option value="0">-- SELECT ASSIGNED USER --</option>
			<cfloop Query="qry_selectUserList">
				<option value="#qry_selectUserList.userID#"<cfif Form.userID_agent is qry_selectUserList.userID> selected</cfif>>#HTMLEditFormat(qry_selectUserList.lastName)#, #HTMLEditFormat(qry_selectUserList.firstName)#</option>
			</cfloop>
			</select>
		</td>
	</tr>
</cfif>
<tr>
	<td valign="top">Task Date: </td>
	<td>#fn_FormSelectDateTime(taskStruct.formName, "taskDateScheduled_date", Form.taskDateScheduled_date, "taskDateScheduled_hh", Form.taskDateScheduled_hh, "taskDateScheduled_mm", Form.taskDateScheduled_mm, "taskDateScheduled_tt", Form.taskDateScheduled_tt, True)#</td>
</tr>
<tr>
	<td></td>
	<td><input type="submit" name="submitTask" value="#HTMLEditFormat(taskStruct.formSubmitValue)#"></td>
</tr>
</table>
</form>
</cfoutput>

