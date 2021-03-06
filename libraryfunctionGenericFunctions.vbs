'#############################################################################################################
' Function/sub name	 : KillProcess
' Description		 : It kills the 
' Input arguments	 : ProcessName
' Output/return value: -
' Date of creation	 : 8th May 2017
' Developed by		 : Santhosh Reddy
'#############################################################################################################
Function KillProcess(ByVal ProcessName)
	On Error Resume Next
	UtilFunction.WriteLog "Killing the opened "&ProcessName&" process"
	Wait(1)
	Dim objWMIService : Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
	Wait(1)
	Dim Processes : Set Processes = objWMIService.EXECQuery("SELECT * FROM Win32_Process WHERE NAME='"&ProcessName&"'")
	For Each objProcess in Processes
		objProcess.Terminate
	Wait(1)
	Next
	If Err <> 0 Then
		UtilFunction.WriteLog "Issue with Killing excel process: "&Err.description
		UtilFunction.WriteLog "Trying to close the excel process again"
		Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
		Set Processes = objWMIService.EXECQuery("SELECT * FROM Win32_Process WHERE NAME='"&ProcessName&"'")
		For Each objProcess in Processes
			objProcess.Terminate
		Next
		If Err <> 0 Then
			UtilFunction.WriteLog "Issue with Killing excel process for 2nd time: "&Err.description
		Else
			KillProcess = "Success"
		End If
	Else
		KillProcess = "Success"
	End If
	On Error GoTo 0
End Function

'#############################################################################################################
' Function/sub name	 : TestInitialization
' Description		 : start of the test execution
' Input arguments	 : -
' Output/return value: -
' Date of creation	 : 10th May 2017
' Developed by		 : Santhosh Reddy
'#############################################################################################################
Function TestInitialization()
	UtilFunction.StartTime = Time()
	UtilFunction.intPassCount = 0
	UtilFunction.intFailCount = 0
	UtilFunction.WriteLog "Starting the execution........."
	
End Function

'#############################################################################################################
' Function/sub name	 : TestClosure
' Description		 : Closing the execution
' Input arguments	 : -
' Output/return value: -
' Date of creation	 : 10th May 2017
' Developed by		 : Santhosh Reddy
'#############################################################################################################
Function TestClosure(intTerminate)
	Dim intTotalTests
	UtilFunction.EndTime = Time()
	UtilFunction.ElapsedTime = Datediff("n", UtilFunction.StartTime, UtilFunction.EndTime)
	intTotalTests = UtilFunction.intPassCount+UtilFunction.intFailCount
	UtilFunction.WriteLog "Closing the execution........!"
	UtilFunction.WriteLog "*************************************************************"
	UtilFunction.WriteLog "**Total Tests executed : "&intTotalTests
	UtilFunction.WriteLog "**********Passed Tests : "&UtilFunction.intPassCount
	UtilFunction.WriteLog "**********Failed Tests : "&UtilFunction.intFailCount
	UtilFunction.WriteLog "*****Execution started : "&UtilFunction.StartTime
	UtilFunction.WriteLog "****Execution end time :"&UtilFunction.EndTime
	UtilFunction.WriteLog "Execution elapsed time : "&UtilFunction.ElapsedTime&" minutes"
	UtilFunction.WriteLog "*************************************************************"
	SystemUtil.CloseDescendentProcesses
	
	'Sending results to stakholders
	Dim strArrayRec(1)
	strArrayRec(0) = "sr59298@imceu.eu.ssmb.com"
	strArrayRec(1) = "sr59298@imceu.eu.ssmb.com"
	Call StatusMail(strArrayRec, "Runbook status", "Please find the status as attachments. Thanks", UtilFunction.detailedResults, UtilFunction.strTestCaseStatus, UtilFunction.strhtmlpath)
	If intTerminate = 0 Then
		ExitTest()
	End If
	
End Function


'#############################################################################################################
' Function/sub name  	 : StatusMail
' Description		 : It send the status to stackholders upon completion of the test execution
' Input arguments	 : RecipientsList, MailSubject, MailBody, Mailattachpath
' Output/return value: -
' Date of creation	 : 8th May 2017
' Developed by		 : Santhosh Reddy
'#############################################################################################################
Function StatusMail(RecipientsList, MailSubject, MailBody, LoggerPath, TCStatus, htmlreport)
	Dim objOut, objMail
	Set objOut = CreateObject("Outlook.Application")
	Set objMail = objOut.CreateItem(0)
	objMail.To = "sr59298@imceu.eu.ssmb.com"
	'Adding multiple Recipients to outlook
'	For Each MailID in RecipientsList
'		objMail.Recipients.Add(MailID)
'	Next
	'objMail.Recipients.Add("sr59298@imceu.eu.ssmb.com")
	'objMail.cc = "sr59298@imceu.eu.ssmb.com"
	objMail.Subject = MailSubject
	objMail.Body = MailBody
	objMail.Attachments.Add(LoggerPath)
	objMail.Attachments.Add(TCStatus)
	objMail.Attachments.Add(htmlreport)
	'objMail.Display
	objMail.Send
	Set objOut = Nothing
	Set objMail = Nothing
End Function
 
Function RecoveryFunction1(Object, Method, Arguments, retVal)
Desktop.CaptureBitmap UtilFunction.ErrSreenShots&"/CalendarSetUp-"&Replace(Replace(Replace(now(),"/","-"),":","-")," ","-")&".png", true
End Function 
 
