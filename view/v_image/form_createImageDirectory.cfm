<cfoutput>
<form method="post" action="index.cfm?method=image.createImageDirectory">
<input type="hidden" name="isFormSubmitted">

<p class="MainText">
Enter the name of the new image sub-directory. A valid directory name:<br>
1. Begins with a letter or number.<br>
2. Contains only letters, numbers and the underscore (_).<br>
3. Has a maximum of 25 characters.
</p>

<font class="MainText">Directory Name: </font>
<input type="text" name="directoryName" size="25" maxlength="25"> 
<input type="submit" name="submitCreateImageDirectory" value="Create Image Directory">
</form>
</cfoutput>
