<cfinvoke Component="#Application.billingMapping#data.Scheduler" Method="insertScheduler" ReturnVariable="newSchedulerID">
	<cfinvokeargument Name="companyID" Value="0">
	<cfinvokeargument Name="userID" Value="0">
	<cfinvokeargument Name="schedulerStatus" Value="1">
	<cfinvokeargument Name="schedulerName" Value="#Variables.schedulerName#">
	<cfinvokeargument Name="schedulerDescription" Value="">
	<cfinvokeargument Name="schedulerURL" Value="#Variables.schedulerURL#">
	<cfinvokeargument Name="schedulerDateBegin" Value="#Variables.schedulerDateBegin#">
	<cfinvokeargument Name="schedulerDateEnd" Value="">
	<cfinvokeargument Name="schedulerInterval" Value="#Variables.schedulerInterval#">
	<cfinvokeargument Name="schedulerRequestTimeOut" Value="500">
</cfinvoke>

<cfschedule
	Action="Update"
	Task="#Variables.schedulerName#"
	Operation="HTTPRequest"
	StartDate="#DateFormat(Variables.schedulerDateBegin, "mm/dd/yyyy")#"
	StartTime="#TimeFormat(Variables.schedulerDateBegin, "hh:mm tt")#"
	EndDate=""
	EndTime=""
	URL="#Variables.schedulerURL#"
	Publish="No"
	Interval="#Variables.schedulerInterval#"
	RequestTimeOut="500">

