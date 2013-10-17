<cfoutput>
<p class="TableText">
<b>Price Stages: </b><br>
- Used for subscriptions only<br>
- Allow pricing to vary during subscription, such as offering a free trial or introductory pricing<br>
- If not using stages, just leave interval for stage ##1 blank.<br>
- If using stages, leave interval blank for last stage.<br>
<br>
<b>Price Stated As:</b><br>
- Percent discount from the normal price (e.g,. 10% discount off normal $5.00 <b>where the percentage is entered as 10</b>)<br>
- Percent of the normal price (e.g,. 90% of normal $5.00)<br>
- Dollar deduction from normal amount (e.g,. $0.50 off of normal $5.00)<br>
- Dollar amount (e.g,. $4.50 instead of normal $5.00; available on individual products only)<br>
</p>

<p class="TableText">
<b>Volume Discount Option:</b><br>
Step Pricing:<br>
&nbsp; &nbsp; No - Use price based on total quantity in order for all units ordered<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; (e.g., charge $4.50 for all units in the order).<br>
&nbsp; &nbsp; Yes - Apply price at each level within the same order<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; (e.g., charge $5.00 each for the first 5 items, $4.75 each for the next 5, and $4.50 each after that).<br>
<br>
Enter the minimum quantity <!--- / dollar value --->that applies to each volume discount level, generally beginning at 0 or 1.<br>
Then enter the new/deducted price/percentage (10% = 10, <i>not</i> 0.10) at each quantity/dollar value.<br>
If first minimum quantity is not 0:<br>
&nbsp; &nbsp; Non-step: Normal price is used for all quantities below the first minimum.<br>
&nbsp; &nbsp; Step: $0 is is used for all quantities below the first minimum.<br>
</p>

<p>
<table border="1" cellspacing="0" cellpadding="2" class="TableText">
<tr class="TableHeader" valign="bottom">
	<th>First Min. Qty.</th>
	<th align="left">&nbsp; Meaning</th>
</tr>
<tr>
	<td>0</td>
	<td>
		Minimum charge even if no unit quantity specified (but could be $0).<br>
		<div class="SmallText">
		ex. 1. Cel phone plan where you are charged $50 per month even if no usage.<br>
		ex. 2. Directory information where the first 2 calls each month are free.
		</div>
	</td>
</tr>
<tr>
	<td>0.0001 - 1</td>
	<td>No charge for 0 quantity, but allows fractional units such as weight or time.</td>
</tr>
<tr>
	<td>1</td>
	<td>No charge if 0 or a fraction of 1 unit is purchased. Generally for situations where units are integers.</td>
</tr>
<tr>
	<td>1.0001 + </td>
	<td>Step: No charge for 1 unit or less. Non-Step: Normal price is used.</td>
</tr>
</table>
</p>

<p class="TableText">
The system will stop at the first blank quantity field. So if there are 5 volume discount levels,<br>
but you only wish to use 3, just leave the last 2 blank.<br>
<br>
Total Price:<br>
&nbsp; &nbsp; Charge designated price at the quantity level, not price per unit.<br>
&nbsp; &nbsp; Ex., charge $100 for up to 50 units, $40 for units 51-75, and $1 each for units 76+.<br>
&nbsp; &nbsp; Requires selecting the price stated as &quot;dollar amount&quot; <i>and</i> step pricing.<br>
&nbsp; &nbsp; Can only be used when creating a custom price for an individual product.
</p>
</cfoutput>