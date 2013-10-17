<cfscript>
function fn_ImageTag (src, height, width, alt, border, other)
{
	var imageURL = "<img src=""#src#"" alt=""#alt#"" border=""#border#""";

	if (IsNumeric(height) and height is not 0)
		imageURL = imageURL & " height=""#height#""";

	if (IsNumeric(width) and width is not 0)
		imageURL = imageURL & " width=""#width#""";

	if (other is not "")
		imageURL = imageURL & " #other#";

	imageURL = imageURL & ">";
	return imageURL;
}
</cfscript>

