<cfoutput>
<p class="TableText">
<b>Commission Stages: </b><br>
- Used for subscriptions only<br>
- Allow commissions to vary during subscription, such as offering a one-time bonus or reduced commissions over time<br>
- If not using stages, just leave interval for stage ##1 blank.<br>
- If using stages, leave interval blank for last stage.<br>
<br>
<b>Commission Stated As:</b><br>
- Percent of revenue (e.g,. 5% of the revenue)<br>
- Dollar amount (e.g,. $5.00 regardless of revenue)<br>
</p>

<p class="TableText">
<b>Volume Option:</b><br>
Step Commission:<br>
&nbsp; &nbsp; No - Use commission based on total quantity in order for all units ordered<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; (e.g., charge 5% for all revenue).<br>
&nbsp; &nbsp; Yes - Apply commission at each level within the same order<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; (e.g., charge 5% for the first $500, 4% for the next $1000, and 2% after that).<br>
<br>
Enter the minimum quantity <!--- / dollar value --->that applies to each step.<br>
If using step method, first minimum quantity is generally 0 or 1.<br>
If first minimum quantity is not 0, then a price of $0 is used for all quantities below the first minimum.<br>
Then enter the commission amount/percentage (10% = 10, <i>not</i> 0.10).<br>
<br>
The system will stop at the first blank quantity field. So if there are 5 levels,<br>
but you only wish to use 3, just leave the last 2 blank.<br>
<br>
Total Commission:<br>
&nbsp; &nbsp; Apply designated commission at the quantity level, not commission per unit.<br>
&nbsp; &nbsp; Ex., pay $100 for up to 50 units, $40 for units 51-75, and $1 each for units 76+.<br>
&nbsp; &nbsp; Requires selecting the commission stated as &quot;dollar amount&quot; <i>and</i> step method.<br>
</p>
</cfoutput>