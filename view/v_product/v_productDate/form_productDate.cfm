<cfoutput>
<script language="Javascript" src="#Application.billingUrlroot#/js/popcalendar.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_layers.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_menu.js"></script>

<p class="MainText">The begin date is required, but the end date is optional. For both dates, the time is optional. Default is 12:00 am.<br>
To end the availability of a product at the end of a day, select the next date and midnight for the time.<br>
Date format must be: <b>mm/dd/yyyy</b>.</p>

<form name="#Variables.formName#" method="post" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>Begin Date (required): </td>
	<td>#fn_FormSelectDateTime(Variables.formName, "productDateBegin_date", Form.productDateBegin_date, "productDateBegin_hh", Form.productDateBegin_hh, "productDateBegin_mm", Form.productDateBegin_mm, "productDateBegin_tt", Form.productDateBegin_tt, True)#</td>
</tr>

<tr>
	<td>End Date (optional): </td>
	<td>#fn_FormSelectDateTime(Variables.formName, "productDateEnd_date", Form.productDateEnd_date, "productDateEnd_hh", Form.productDateEnd_hh, "productDateEnd_mm", Form.productDateEnd_mm, "productDateEnd_tt", Form.productDateEnd_tt, True)#</td>
</tr>

<tr>
	<td></td>
	<td><input type="submit" name="submitProductDate" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>
</form>
</cfoutput>
