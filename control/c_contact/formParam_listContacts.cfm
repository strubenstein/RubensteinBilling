<cfinclude template="../../include/function/act_urlToForm.cfm">

<cfparam Name="Form.statusID" Default="">
<cfparam Name="Form.groupID" Default="">
<cfparam Name="Form.affiliateID" Default="">
<cfparam Name="Form.cobrandID" Default="">
<cfparam Name="Form.userID_author" Default="">

<cfparam Name="Form.contactTemplateID" Default="">
<cfparam Name="Form.contactTopicID" Default="">

<cfparam Name="Form.contactDateType" Default="">
<cfparam Name="Form.contactDateFrom_date" Default="">
<cfparam Name="Form.contactDateFrom_hh" Default="12">
<cfparam Name="Form.contactDateFrom_mm" Default="00">
<cfparam Name="Form.contactDateFrom_tt" Default="am">
<cfparam Name="Form.contactDateTo_date" Default="">
<cfparam Name="Form.contactDateTo_hh" Default="12">
<cfparam Name="Form.contactDateTo_mm" Default="00">
<cfparam Name="Form.contactDateTo_tt" Default="am">

<cfparam Name="Form.searchText" Default="">
<cfparam Name="Form.searchTextType" Default="">
<cfparam Name="Form.searchEmail" Default="">
<cfparam Name="Form.searchEmailType" Default="">

<cfparam Name="Form.contactByCustomer" Default="">
<cfparam Name="Form.contactIsSent" Default="">
<cfparam Name="Form.contactHasCustomID" Default="">
<cfparam Name="Form.contactID_orig" Default="">
<cfparam Name="Form.contactReplied" Default="">
<cfparam Name="Form.contactStatus" Default="">
<cfparam Name="Form.contactHtml" Default="">
<cfparam Name="Form.contactToMultiple" Default="">
<cfparam Name="Form.contactHasCC" Default="">
<cfparam Name="Form.contactHasBCC" Default="">
<cfparam Name="Form.contactEmail" Default="">
<cfparam Name="Form.contactFax" Default="">
<cfparam Name="Form.contactIsReply" Default="">
<cfparam Name="Form.returnContactMessage" Default="False">

<cfparam Name="Form.queryOrderBy" Default="contactDateSent_d">
<cfparam Name="Form.queryPage" Default="1">
<cfparam Name="Form.queryDisplayPerPage" Default="20">

