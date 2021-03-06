'##############################################################################################
' File name				: Class object to handle global variables and utility functions
' Description			: It handles the global variables and functions
' Functions it contains	: CreateTextFile, WriteLog and WriteStatus
' Date of creation		: 9th May 2017
' Developed by			: Santhosh Reddy
'##############################################################################################

'Initiate class object
Set UtilFunction = New ComUtilFunction

Class ComUtilFunction
	Dim pathDownloadFolder
	Dim strTestCaseStatus
	Dim strLogFile,detailedResults
	Dim strFileNameAsDate
	Dim strStatus
	Dim strStatusDetails
	Dim DataDrivenResults, ErrSreenShots
	Dim strTCID, strTCName
	Dim StartTime, EndTime, ElapsedTime
	Dim intPassCount, intFailCount, intWarningCount, intSkipCount, intDoneCount, intInfoCount
	'Adding global variable for country - 11/14/17
	Dim strCountry	
	Dim strhtmlpath
	Dim varhtmlReport1path, varhtmlReport2path, varhtmlReport3apath, varhtmlReport4apath,varhtmlReport3bpath, varhtmlReport4bpath
	Dim inthtmlPassCount, inthtmlFailCount, inthtmlSkipCount, inthtmlTotalCount
	Dim strResExcelChartTemplate, strResExcelChart, intchartPass, intchartFail, intchartSkip
	
	Function CreateTextFile(strFileName)
		On Error Resume Next
		Dim objFSO: Set objFSO = CreateObject("Scripting.FileSystemObject")
		Dim objTextFile: Set objTextFile = objFSO.CreateTextFile(strFileName,true)
		objTextFile.Close
		Set objTextFile = Nothing
		Set objFSO = Nothing
		On Error GoTo 0
	End Function
	
	Function WriteLog(strMsg)
		Dim objFSO: Set objFSO = CreateObject("Scripting.FileSystemObject")
		Dim objTextFile: Set objTextFile = objFSO.OpenTextFile(UtilFunction.strLogFile, 8, True)
		objTextFile.WriteLine Now()&": "&strMsg
		objTextFile.Close
		Set objTextFile = Nothing
		Set objFSO = Nothing
	End Function
	Function WriteStatus(strStatus, strTCID, strTCName, strStatusDetails)
		Dim objFSO: Set objFSO = CreateObject("Scripting.FileSystemObject")
		Dim objTextFile: Set objTextFile = objFSO.OpenTextFile(UtilFunction.strLogFile, 8, True)
		objTextFile.WriteBlankLines(1)
		objTextFile.WriteLine "*************************** "& strTCName&" execution details**********************"
		objTextFile.WriteLine Now()&": *******Test status - "&strStatus
		objTextFile.WriteLine Now()&": ******Test Case ID - "&strTCID
		objTextFile.WriteLine Now()&": *****Test CaseName - "&strTCName
		objTextFile.WriteLine Now()&": Test StatusDetails - "&strStatusDetails
		objTextFile.WriteLine "**********************************************************************************"
		objTextFile.Close
		Set objTextFile = Nothing
		Set objFSO = Nothing
		Select Case Lcase(strStatus)
			Case "pass"
				intPassCount = intPassCount+1
			Case "fail"
				intFailCount = intFailCount+1
		End Select
	End Function

End Class
