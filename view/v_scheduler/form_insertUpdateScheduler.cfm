<cfoutput>
<form method="post" name="#Variables.formName#" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>Status: </td>
	<td>
		<label style="color: green"><input type="radio" name="schedulerStatus" value="1"<cfif Form.schedulerStatus is 1> checked</cfif>>Active</label> &nbsp; 
		<label style="color: red"><input type="radio" name="schedulerStatus" value="0"<cfif Form.schedulerStatus is not 1> checked</cfif>>Inactive/Deleted</label>
	</td>
</tr>
<tr>
	<td>Name: </td>
	<td>
		<cfif Variables.doAction is "insertScheduler">
			<input type="text" name="schedulerName" value="#HTMLEditFormat(Form.schedulerName)#" size="40" maxlength="#maxlength_Scheduler.schedulerName#"> (must be unique; cannot be changed)
		<cfelse>
			#Form.schedulerName#
		</cfif>
	</td>
</tr>
<tr>
	<td>Description: </td>
	<td><input type="text" name="schedulerDescription" value="#HTMLEditFormat(Form.schedulerDescription)#" size="40" maxlength="#maxlength_Scheduler.schedulerDescription#"> (internal use)</td>
</tr>
<tr>
	<td>URL: </td>
	<td><input type="text" name="schedulerURL" value="#HTMLEditFormat(Form.schedulerURL)#" size="80" maxlength="#maxlength_Scheduler.schedulerURL#"></td>
</tr>
<tr>
	<td>Time Out: </td>
	<td><input type="text" name="schedulerRequestTimeOut" value="#HTMLEditFormat(Form.schedulerRequestTimeOut)#" size="5"> (in seconds; 500 max)</td>
</tr>
<tr>
	<td>Begins: </td>
	<td>#fn_FormSelectDateTime(Variables.formName, "schedulerDateBegin_date", Form.schedulerDateBegin_date, "schedulerDateBegin_hh", Form.schedulerDateBegin_hh, "schedulerDateBegin_mm", Form.schedulerDateBegin_mm, "schedulerDateBegin_tt", Form.schedulerDateBegin_tt, True)# (default is now)</td>
</tr>
<tr>
	<td>Ends: </td>
	<td>#fn_FormSelectDateTime(Variables.formName, "schedulerDateEnd_date", Form.schedulerDateEnd_date, "schedulerDateEnd_hh", Form.schedulerDateEnd_hh, "schedulerDateEnd_mm", Form.schedulerDateEnd_mm, "schedulerDateEnd_tt", Form.schedulerDateEnd_tt, True)#</td>
</td>
</tr>
<tr valign="top">
	<td>Interval: </td>
	<td class="TableText">
		<label><input type="radio" name="schedulerInterval_method" value="once"<cfif Form.schedulerInterval_method is ""> checked</cfif>> Once</label><br>
		<label><input type="radio" name="schedulerInterval_method" value="daily"<cfif Form.schedulerInterval_method is ""> checked</cfif>> Daily</label><br>
		<label><input type="radio" name="schedulerInterval_method" value="weekly"<cfif Form.schedulerInterval_method is ""> checked</cfif>> Weekly</label><br>
		<label><input type="radio" name="schedulerInterval_method" value="monthly"<cfif Form.schedulerInterval_method is ""> checked</cfif>> Monthly</label><br>
		<label><input type="radio" name="schedulerInterval_method" value=""<cfif Form.schedulerInterval_method is ""> checked</cfif>> Every:</label> 
		Hours: <input type="text" name="schedulerInterval_hours" value="#HTMLEditFormat(Form.schedulerInterval_hours)#" size="2" maxlength="2"> &nbsp; &nbsp; 
		Minutes: <input type="text" name="schedulerInterval_minutes" value="#HTMLEditFormat(Form.schedulerInterval_minutes)#" size="2" maxlength="2"> &nbsp; &nbsp; 
		Seconds: <input type="text" name="schedulerInterval_seconds" value="#HTMLEditFormat(Form.schedulerInterval_seconds)#" size="2" maxlength="2"><br>
	</td>
</tr>

<tr>
	<td></td>
	<td><input type="submit" name="submitScheduler" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>

</form>
</cfoutput>
