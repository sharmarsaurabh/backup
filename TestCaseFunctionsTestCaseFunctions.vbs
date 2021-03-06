'#############################################################################################################
' Function/sub name	 : Login
' Description		 : It logs in to RI
' Input arguments	 : strBrowser, strUrl, UserName, Password, strCountry
' Output/return value: -
' Date of creation	 : 12th May 2017
' Developed by		 : Santhosh Reddy
'#############################################################################################################
Function Login(strUrl, UserName, Password, strCountry)
	While Browser("creationtime:=0").Exist(0)
		Browser("creationtime:=0").Close
	Wend
	SystemUtil.Run "chrome.exe", strUrl
	Browser("Single Sign-On").sync
	Wait(1)
	If Not Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("tab-1076-btnInnerEl").Exist(1) Then
		Browser("Single Sign-On").Page("Single Sign-On").WebEdit("USER").Set UserName
		Browser("Single Sign-On").Page("Single Sign-On").WebEdit("PASSWORD").Set Password
		Browser("Single Sign-On").Page("Single Sign-On").WebButton("Sign On").Click	
		'UtilFunction.WriteLog "Login successful"
		'UtilFunction.WriteStatus "Pass", "TS_001", "LogIn", "LogIn is successful"
		'Login = "Passed - LogIn is successful"
		UtilFunction.WriteLog "Login is successful"
	'Else 

'		UtilFunction.WriteLog "Login is not successful"
'		UtilFunction.WriteStatus "Fail", "TS_001", "LogIn", "LogIn is not successful"
'		Login = "Failed - LogIn is not successful"
'		Reporter.ReportEvent 1, "Home page", "Login test"
'		Call TestClosure(0)
	End If
	UtilFunction.WriteLog "Selecting country"
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("entitledCountryCmb-inputEl").Click
	Wait(1)
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebList("boundlist-1096-listEl").Select strCountry
	Wait(1)
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("button-1006-btnInnerEl").Click
	Wait(1)
End Function
'#############################################################################################################
' Function/sub name	 : Login
' Description		 : It logout from from RI
' Input arguments	 : 
' Output/return value: -
' Date of creation	 : 13th April 2018
' Developed by		 : Saurabh Sharma
'#############################################################################################################
Function Logout()
'	While Browser("creationtime:=0").Exist(0)
'		Browser("creationtime:=0").Close
'	Wend
'	SystemUtil.Run "chrome.exe", strUrl
'	Browser("Single Sign-On").sync
'	Wait(1)
	If Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("tab-1076-btnInnerEl").Exist(1) Then
		Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("downarrow").Click
		wait(1)
		Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("Logout").Click
		Browser("creationtime:=0").Close
		UtilFunction.WriteLog "Logout is successful"
	'Else 

'		UtilFunction.WriteLog "Login is not successful"
'		UtilFunction.WriteStatus "Fail", "TS_001", "LogIn", "LogIn is not successful"
'		Login = "Failed - LogIn is not successful"
'		Reporter.ReportEvent 1, "Home page", "Login test"
'		Call TestClosure(0)
	End If
End Function

'#############################################################################################################
' Function/sub name	 : PRSReportGenerator
' Description		 : The reports can be generated in Report generator tab to validate the data.
' Input arguments	 : 
' Output/return value: -
' Date of creation	 : 7/25/2017
' Developed by		 : Santhosh Reddy
' Date of Updation  : 5/5/2018
' Developed by		 : Saurabh Sharma
'#############################################################################################################
Function ReportGenerator(functionalArea,formName,fiscalYear,Period,Frequency,SoloCons,xlStartRow,xlStartCol,exlEndRow,exlEndCol,intCalCounter,adminissueFlag)
On Error Resume Next
'Setting("SnapshotReportMode") = 1
	Dim objWT, objWTName, defaultselect
	defaultselect = "0"
	Set objMClick = CreateObject("Wscript.Shell")
	Dim objFSO, objFileStream
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	'Set objFileStream = objFSO.OpenTextFile(FileLocation&"\ReportGeneratorStatus.txt", 8, True)
	Set objFileStream = objFSO.OpenTextFile(UtilFunction.detailedResults, 8, True)
	UtilFunction.WriteLog "**********************************************************************************************"
	UtilFunction.WriteLog "Executing the reportgenerator for "&intCalCounter&" iteration"
	If intCalCounter = 1 Then
		objFileStream.WriteLine "S.No.	Form	Fiscalyear	Period	Frequency	Solo/Consolidated	Status	downloaded report name	Comments/Data found on downloaded report"
		UtilFunction.WriteLog "Opening left navigation pane"
		Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("west-region-container-splitter").Click
		UtilFunction.WriteLog "Clicking Regulatory Reporting"
		Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("Regulatory Reporting").Click
	End If
	If adminissueFlag = 1 Then
		UtilFunction.WriteLog "Opening left navigation pane"
		Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("west-region-container-splitter").Click
		UtilFunction.WriteLog "Clicking Regulatory Reporting"
		Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("Regulatory Reporting").Click
	End If
	
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("west-region-container-splitter").Click
	
	UtilFunction.WriteLog "Clicking Regulatory Reporting page"
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("Report Generator_2").Click
	Wait(1)
	objMClick.SendKeys"{ESC}",true 'to close if any pop ups existing
	Wait(1)
	UtilFunction.WriteLog "Selecting Functional area"
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("reportGenfunctionalArea").Click
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebList("boundlist-1201-listEl").Select functionalArea '"OPRTNL-RSK"
	wait(1)
	UtilFunction.WriteLog "Selected Functional area: "&Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("reportGenfunctionalArea").GetROProperty("value")
	UtilFunction.WriteLog "Selecting Form: "&Ucase(formName)
	If functionalArea = "STATISTICAL" Then
			If formName = "S.1.9" Then
					Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("combobox-1105-trigger-picker").Click
					Wait(1)
					objMClick.SendKeys"{DOWN 16}",true
					Wait(1)
					objMClick.SendKeys"{ENTER}",true
			ElseIf formName = "S.2.5" Then
					Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("combobox-1105-trigger-picker").Click
					Wait(1)
					objMClick.SendKeys"{DOWN 4}",true
					Wait(1)
					objMClick.SendKeys"{ENTER}",true
			ElseIf formName = "S.3.2-2" Then
					Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("combobox-1105-trigger-picker").Click
					Wait(1)
					objMClick.SendKeys"{DOWN 5}",true
					Wait(1)
					objMClick.SendKeys"{ENTER}",true
			Else
					Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("combobox-1105-trigger-picker").Click
					Browser("Single Sign-On").Page("US Regulatory Reporting").WebList("boundlist-1193-listEl").Select Ucase(formName) '"COREP_OPR_DETAILS_C_1700"
					Wait(1)
			End  If
	Else
	
	
'	Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("formNameGen").Click
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("combobox-1105-trigger-picker").Click
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebList("boundlist-1193-listEl").Select Ucase(formName) '"COREP_OPR_DETAILS_C_1700"
	Wait(1)
	End If
	Dim selectedFormname: selectedFormname = Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("formNameGen").GetROProperty("value")
	UtilFunction.WriteLog "Selected Formname: "&selectedFormname
	If selectedFormname <> Ucase(formName) Then
		objFileStream.WriteLine intCalCounter&"	"&formName&"	"&fiscalYear&"	"&Period&"	"&Frequency&"	"&SoloCons&"	Fail	n/a	selectedFormname is not correct"
		Desktop.CaptureBitmap UtilFunction.ErrSreenShots&"/"&intCalCounter&"-Reportgeneration-"&Replace(Replace(Replace(now(),"/","-"),":","-")," ","-")&".png", true
		UtilFunction.WriteStatus "fail", "TC006", "Report generation", "selectedFormname is not correct"
		ReportGenerator = "Failed - Report generation is not successful"
		Reporter.ReportEvent micFail, "Report generation", strValmsg		
		Exit Function
	End If
	Wait(1)
	Set objWT = Description.Create
	objWT("micclass").Value = "WebTable"
	objWT("html id").Value = "tableview-[0-9]+-record-[0-9]+"
	objWT("class").Value = "x-grid-item"
	' For Luxembourg
	objWT("cols").Value = "6"
	Set objWTName = Browser("Single Sign-On").Page("US Regulatory Reporting").ChildObjects(objWT)
	If Not objWTName(0).ChildItem(1,6,"WebButton",0).Exist(2) Then
		objFileStream.WriteLine intCalCounter&"	"&formName&"	"&fiscalYear&"	"&Period&"	"&Frequency&"	"&SoloCons&"	Fail	n/a	Run button is not existing"
		Desktop.CaptureBitmap UtilFunction.ErrSreenShots&"/"&intCalCounter&"-Reportgeneration-"&Replace(Replace(Replace(now(),"/","-"),":","-")," ","-")&".png", true
		UtilFunction.WriteLog "Run button is not existing"
		UtilFunction.WriteStatus "fail", "TC006", "ReportGenerator", "Run button is not existing"
		ReportGenerator = "Failed - Reports are not found to generate"
		Reporter.ReportEvent micFail, "ReportGenerator", "Run button is not existing"
		Exit Function
	End If
	strExcelName = objWTName(0).ChildItem(1,4,"WebElement",0).GetROProperty("innertext")
	UtilFunction.WriteLog "Clicking Report Run button"
	objWTName(0).ChildItem(1,6,"WebButton",0).Click
	Wait(1)
	UtilFunction.WriteLog "Selecting branch"
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("branch").Click
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebList("boundlist-1228-listEl").Select defaultselect '"ALL"
	UtilFunction.WriteLog "Selecting LVID"
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("lvid").Click
'	Browser("Single Sign-On").Page("US Regulatory Reporting").WebList("boundlist-1438-listEl").Select defaultselect '"CGML"
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebList("boundlist-1438-listEl").Select 0 '"CGME"
	UtilFunction.WriteLog "Selecting Fiscalyear: "&fiscalYear
	Dim selectedFiscalyear
	If Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("fiscalYear").Exist(3) Then
		Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("fiscalYear").Click
		'Adding below object temp just a work around Saurabh (11/4/2018)
		Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("2017").Click
		'commeting the below line as weblist item is not getting selected due to name change every time the scripts runs
		'Browser("Single Sign-On").Page("US Regulatory Reporting").WebList("boundlist-1203-listEl").Select fiscalYear
		Wait(1)
		selectedFiscalyear = Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("fiscalYear").GetROProperty("value")
	ElseIf Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("fiscYear").Exist(3) Then
		Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("fiscYear").Click
		'Adding below object temp just a work around Saurabh (11/4/2018)
		Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("2017").Click
		'commeting the below line as weblist item is not getting selected due to name change every time the scripts runs
		'Browser("Single Sign-On").Page("US Regulatory Reporting").WebList("boundlist-1203-listEl").Select fiscalYear
		Wait(1)
		selectedFiscalyear = Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("fiscYear").GetROProperty("value")
	End If
	
	UtilFunction.WriteLog "Selected Fiscalyear: "&selectedFiscalyear
	UtilFunction.WriteLog "Providing Period: "&Ucase(Period)
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("period").Set Ucase(Period)
	Wait(1)
	Dim selectedPeriod: selectedPeriod = Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("period").GetROProperty("value")
	UtilFunction.WriteLog "Selected Period: "&selectedPeriod
	
	If Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("tab-1811-btnInnerEl").Exist(5) Then
		Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("tab-1811-btnInnerEl").Click
		UtilFunction.WriteLog "Providing Variance period"
'		Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("variancePeriod").Set "31-Aug-2017" 'Ucase(Period)
' Updating variancePeriod to 31-Oct-2017 as per data provided by Ashish Singh
		Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("variancePeriod").Set "29-Dec-2017" 'Ucase(Period)
	End If 	
'	Dim strFiscalyear: strFiscalyear = Browser("Single Sign-On").Page("US Regulatory Reporting").WebList("boundlist-1203-listEl").GetROProperty("outertext")
'	If inStr(strFiscalyear,fiscalYear) > 0 Then 'handling non existing data on the application
'		Browser("Single Sign-On").Page("US Regulatory Reporting").WebList("boundlist-1203-listEl").Select fiscalYear '"2016"
'		UtilFunction.WriteLog "Providing Period: "&Ucase(Period)
'		'Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("period").Click
'		Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("period").Set Ucase(Period)
'	Else
'		Browser("Single Sign-On").Page("US Regulatory Reporting").WebList("boundlist-1203-listEl").Select defaultselect
'		UtilFunction.WriteLog "Input fiscalYear not existing, hence selectinmg default one: "&Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("fiscYear").GetROProperty("value")
'		'Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("period").Click
'		Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("combobox-3065-trigger-picker").Click
'		Browser("Single Sign-On").Page("US Regulatory Reporting").WebList("boundlist-1249-listEl").Select defaultselect '"31-MAR-17"
''		Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("period").Set defaultselect
'		UtilFunction.WriteLog "Input period is not existing, hence selectinmg the default one: "&Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("period").GetROProperty("value")
'	End If
'	UtilFunction.WriteLog "Selected Fiscalyear: "&Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("fiscYear").GetROProperty("value")
	
'	' Not required for Luxembourg 20/11/2018
'	UtilFunction.WriteLog "Selecting Frequency: "&Ucase(Frequency)
'	If Ucase(Frequency) = "MTH" Then
'		Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("FREQ").Click
'		'Browser("Single Sign-On").Page("US Regulatory Reporting").WebList("boundlist-1255-listEl").Select Ucase(Frequency)'For UAT
'		Browser("Single Sign-On").Page("Local Regulatory Reporting").WebList("boundlist-1321-listEl").Select Ucase(Frequency)'For Prod
'		objMClick.SendKeys"{ENTER}",true
'		Wait(1)
'		If Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("FREQ").GetROProperty("value") <> Ucase(Frequency) Then
'					Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("FREQ").Click
'					Wait(1)
'					objMClick.SendKeys"{DOWN 1}",true
'					Wait(1)
'					objMClick.SendKeys"{ENTER}",true
'					'Set objMClick = Nothing
'		End If
'	End If
'	Dim selectedFreq: selectedFreq = Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("FREQ").GetROProperty("value")
'	UtilFunction.WriteLog "Selected Frequency: "&selectedFreq
'	If Ucase(SoloCons) = "SOLO" Then
'		Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("SOLO_OR_CONS_4").Click
'		Browser("Single Sign-On").Page("US Regulatory Reporting").WebList("boundlist-1228-listEl").Select Ucase(SoloCons) '"SOLO"
'		objMClick.SendKeys"{ENTER}",true
'		Wait(1)
'		If Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("SOLO_OR_CONS_4").GetROProperty("value") <> Ucase(SoloCons) Then
'					Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("SOLO_OR_CONS_4").Click
'					Wait(1)
'					objMClick.SendKeys"{DOWN 1}",true
'					Wait(1)
'					objMClick.SendKeys"{ENTER}",true
'					'Set objMClick = Nothing
'		End If
'	End If	
'	Set objMClick = Nothing
'	Dim selectedSoloCons: selectedSoloCons = Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("SOLO_OR_CONS_4").GetROProperty("value")
'	UtilFunction.WriteLog "Selected SOLO_OR_CONS: "&selectedSoloCons
'	If Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("tab-1811-btnInnerEl").Exist(1) Then
'		UtilFunction.WriteLog "Clicking Variance Param"
'		Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("tab-1811-btnInnerEl").Click
'		UtilFunction.WriteLog "Providing Variance period"
''		Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("variancePeriod").Set "31-Aug-2017" 'Ucase(Period)
'' Updating variancePeriod to 31-Oct-2017 as per data provided by Ashish Singh
'		Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("variancePeriod").Set "29-Dec-2017" 'Ucase(Period)
''		If Ucase(Frequency) = "MTH" Then
''			Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("variancePeriod").Set "30-Apr-2017" 'Ucase(Period)
''		ElseIf Ucase(Frequency) = "DLY" Then
''			Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("variancePeriod").Set "30-Apr-2017" 'Ucase(Period)
''		End If
'	End If
	
	Wait(1)
'	Dim objMClick
'	Set objMClick = CreateObject("Wscript.Shell")
'	objMClick.SendKeys"{TAB}",true
'	Set objMClick = Nothing
	UtilFunction.WriteLog "Clicking submit button"
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("primarybutton-1237-btnInnerEl").Click
	UtilFunction.WriteLog "Waiting for report to be generated"
	strValmsg  = Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("messagebox-1001-msg_5").GetROProperty("innertext")
	UtilFunction.WriteLog strValmsg
	While strValmsg  = "Generating Report"
		Wait(5)
		strValmsg  = Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("messagebox-1001-msg_5").GetROProperty("innertext")
	Wend
	If selectedFiscalyear <> fiscalYear OR Ucase(selectedPeriod) <> Ucase(Period) Then
		strValmsg = "Selected fiscalYear and Period data is not matching with input data"
		UtilFunction.WriteLog "Selected fiscalYear and Period data is not matching with input data"
	'ElseIf Browser("Single Sign-On").Page("Local Regulatory Reporting").WebElement("messagebox-1001-msg_2").GetTOProperties("innertext") = "Request failed" Then
	ElseIf strValmsg = "" Then
		UtilFunction.WriteLog "Request failed"
		Desktop.CaptureBitmap UtilFunction.ErrSreenShots&"/"&intCalCounter&"-Reportgeneration-"&Replace(Replace(Replace(now(),"/","-"),":","-")," ","-")&".png", true
		UtilFunction.WriteLog "Closing the Browser as application is not responsive"
		Browser("Single Sign-On").Close
		UtilFunction.WriteStatus "fail", "TC006", "Report generation", "Request failed"
		ReportGenerator = "Request failed"
		Reporter.ReportEvent micFail, "Report generation", strValmsg
		Exit Function
	Else
		UtilFunction.WriteLog strValmsg
	End If
	Dim downloadedfile
	'Added below line for handle Session time pop up. Saurabh 17/4/2018
	Dim tempstrValmsg 
	tempstrValmsg = LEFT(strValmsg,27)
	If tempstrValmsg = "Your session will expire in" Then
		UtilFunction.WriteLog "Request failed"
		Desktop.CaptureBitmap UtilFunction.ErrSreenShots&"/"&intCalCounter&"-Reportgeneration-"&Replace(Replace(Replace(now(),"/","-"),":","-")," ","-")&".png", true
		UtilFunction.WriteLog "Closing the Browser as application is inactive"
		Browser("Single Sign-On").Close
		UtilFunction.WriteStatus "fail", "TC006", "Report generation", "Request failed"
		ReportGenerator = tempstrValmsg
		Reporter.ReportEvent micFail, "Report generation", strValmsg
		Exit Function
	ElseIf strValmsg = "Run Report Failed. Please contact your administrator." Then
		Desktop.CaptureBitmap UtilFunction.ErrSreenShots&"/"&intCalCounter&"-Reportgeneration-"&Replace(Replace(Replace(now(),"/","-"),":","-")," ","-")&".png", true
		UtilFunction.WriteLog "Closing the pop up window of please contact your administrator issue."
		Browser("Single Sign-On").Page("US Regulatory Reporting").Image("AMDAwAAAACH5BAEAAAAALAAAAAABAA_9").Click
		UtilFunction.WriteStatus "fail", "TC006", "Report generation", strValmsg
		ReportGenerator = strValmsg
		Reporter.ReportEvent micFail, "Report generation", strValmsg
		
	ElseIf strValmsg = "Report Generated Successfully. Do you want to navigate to Regulatory Report Store page ?" Then
		
		If Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("button-1006-btnInnerEl").Exist(2) Then
			UtilFunction.WriteLog "Clicking Yes button to open Report store"
			Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("button-1006-btnInnerEl").Click
		Else
			UtilFunction.WriteLog "Yes button not found, hence sending Enter key to open Report store"
			objMClick.SendKeys"{ENTER}",true 'To handle Yes button
		End If
		
		'Checking report store tab
		If Not Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("container-1016-innerCt").Exist(2) Then
			objFileStream.WriteLine intCalCounter&"	"&formName&"	"&fiscalYear&"	"&Period&"	"&Frequency&"	"&SoloCons&"	Fail	n/a	Report store in not opened"
			Desktop.CaptureBitmap UtilFunction.ErrSreenShots&"/"&intCalCounter&"-Reportgeneration-"&Replace(Replace(Replace(now(),"/","-"),":","-")," ","-")&".png", true
			UtilFunction.WriteStatus "fail", "TC006", "Report generation", strValmsg
			ReportGenerator = "Failed - Report generation is not successful"
			Reporter.ReportEvent micFail, "Report generation", strValmsg
		Else
			Wait(1)
			'formName = Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("formName").GetROProperty("value")
			'fiscalYear = Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("fiscYear").GetROProperty("value")
			'Period = Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("period").GetROProperty("value")
			'Frequency = Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("FREQ").GetROProperty("value")
			'SoloCons = Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("SOLO_OR_CONS_4").GetROProperty("value")
			If Browser("Single Sign-On").Page("US Regulatory Reporting").Image("xlsTemplBut").Exist(10) OR Browser("Single Sign-On").Page("US Regulatory Reporting").Image("xlsTemplBut_2").Exist(10) Then
				UtilFunction.WriteLog "Clicking Downloading xml report button"
	 			'Updated button property for temp
	 			Browser("Single Sign-On").Page("US Regulatory Reporting").Image("xlsTemplBut_3").Click
	 			
	 			If Browser("Single Sign-On").Page("US Regulatory Reporting").Image("xlsTemplBut_2").Exist(2) Then
	 				Browser("Single Sign-On").Page("US Regulatory Reporting").Image("xlsTemplBut_2").Click
	 			Else
	 				Browser("Single Sign-On").Page("US Regulatory Reporting").Image("xlsTemplBut").Click
	 			End If
	 			Wait(4)
		 		UtilFunction.WriteLog "Closing Report store tab"
		 		Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("tab-1330-closeEl").Click
		 		downloadedfile = latestExcelFile()
		 		Dim downloadreportflag: downloadreportflag = 0
		 		While InStr(Ucase(downloadedfile),Ucase(formName)) <= 0 AND downloadreportflag < 30 'waiting for 90 secs for the file to be downloaded
		 			Wait(3)
		 			downloadedfile = latestExcelFile()
		 			downloadreportflag = downloadreportflag+1
		 		Wend
		 		UtilFunction.WriteLog "The latest report in the downloaded folder: "&downloadedfile
		 		If  InStr(Ucase(downloadedfile),Ucase(formName)) > 0 Then
		 			UtilFunction.WriteLog "Verifying whether data is present in downloaded file: "&downloadedfile
		 			ReportGenerator = ExcelVerification(downloadedfile,xlStartRow,xlStartCol,exlEndRow,exlEndCol)	
		 			'If  ReportGenerator <> "Data is not present in downloaded excel" AND Left(ReportGenerator,18) = "Data found at row(" Then
		 			If  Left(ReportGenerator,18) = "Data found at row(" Then
		 				UtilFunction.WriteLog "Data is existing in downloaded excel: "&strExcelName
						UtilFunction.WriteStatus "pass", "TC002", "Report generation", "Report Generation is successful"
						objFileStream.WriteLine intCalCounter&"	"&formName&"	"&selectedFiscalyear&"	"&selectedPeriod&"	"&selectedFreq&"	"&selectedSoloCons&"	Pass	"&downloadedfile&"	"&ReportGenerator
						ReportGenerator = "Pass - ReportGenerator is successful"
					Else
						objFileStream.WriteLine intCalCounter&"	"&formName&"	"&fiscalYear&"	"&Period&"	"&Frequency&"	"&SoloCons&"	Fail	"&downloadedfile&"	"&ReportGenerator
						UtilFunction.WriteLog ReportGenerator
		 				UtilFunction.WriteStatus "fail", "TC002", "Report generation","Data is not present in downloaded excel"
		 			End If
		 		Else
		 			objFileStream.WriteLine intCalCounter&"	"&formName&"	"&fiscalYear&"	"&Period&"	"&Frequency&"	"&SoloCons&"	Fail			seems report is not downloaded"
		 			UtilFunction.WriteLog "seems report is not downloaded"
		 			UtilFunction.WriteLog "Closing Report store tab"
		 			Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("tab-1330-closeEl").Click
		 			UtilFunction.WriteStatus "fail", "TC002", "Report generation", "seems report is not downloaded"
		 		End If
		 		
'		 		If  ReportGenerator <> "Data is not present in downloaded excel" AND InStr(Ucase(downloadedfile),Ucase(formName)) > 0 Then
'		 			UtilFunction.WriteLog "Data is existing in downloaded excel: "&strExcelName
'					UtilFunction.WriteStatus "pass", "TC002", "Report generation", "Report Generation is successful"
'					objFileStream.WriteLine intCalCounter&"	"&formName&"	"&selectedFiscalyear&"	"&selectedPeriod&"	"&selectedFreq&"	"&selectedSoloCons&"	Pass	"&downloadedfile&"	"&ReportGenerator
'					ReportGenerator = "Pass - ReportGenerator is successful"
'		 		Else
'		 			'below condition to handles the proper failed message as if report is not downloaded
'		 			If InStr(Ucase(downloadedfile),Ucase(formName)) > 0 Then
'		 				objFileStream.WriteLine intCalCounter&"	"&formName&"	"&fiscalYear&"	"&Period&"	"&Frequency&"	"&SoloCons&"	Fail	"&downloadedfile&"	"&ReportGenerator
'					Else
'						objFileStream.WriteLine intCalCounter&"	"&formName&"	"&fiscalYear&"	"&Period&"	"&Frequency&"	"&SoloCons&"	Fail	"&downloadedfile&"	seems report is not downloaded"
'		 			End If
'		 			
'		 		End If
			Else
	 			objFileStream.WriteLine intCalCounter&"	"&formName&"	"&fiscalYear&"	"&Period&"	"&Frequency&"	"&SoloCons&"			Generated report not found in report store"
	 			UtilFunction.WriteLog "Reports not found in report store"
	 			UtilFunction.WriteLog "Closing pop up window"
				Browser("Single Sign-On").Page("US Regulatory Reporting").Image("AMDAwAAAACH5BAEAAAAALAAAAAABAA_8").Click
				UtilFunction.WriteLog "Closing Report store tab"
		 		Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("tab-1330-closeEl").Click
		 		UtilFunction.WriteStatus "fail", "TC002", "Report generation", "Reports not found in report store"
	 			Desktop.CaptureBitmap UtilFunction.ErrSreenShots&"/"&intCalCounter&"-Reportgeneration-"&Replace(Replace(Replace(now(),"/","-"),":","-")," ","-")&"noreport_rstore.png", true
	 		End If
		End If
	Else
		objFileStream.WriteLine intCalCounter&"	"&formName&"	"&fiscalYear&"	"&Period&"	"&Frequency&"	"&SoloCons&"	Fail		"&strValmsg
		Desktop.CaptureBitmap UtilFunction.ErrSreenShots&"/"&intCalCounter&"-Reportgeneration-"&Replace(Replace(Replace(now(),"/","-"),":","-")," ","-")&".png", true
		UtilFunction.WriteLog "Submit button is not enable, please check the data provided is correct"
		Browser("Single Sign-On").Page("US Regulatory Reporting").Image("AMDAwAAAACH5BAEAAAAALAAAAAABAA_8").Click
		UtilFunction.WriteStatus "fail", "TC006", "Report generation", "Submit button is not enable, please check the data provided is correct"
		ReportGenerator = "Failed - Report generation is not successful"
		Reporter.ReportEvent micFail, "Report generation", "Submit button is not enable, please check the data provided is correct"		
	End If
	Set objFileStream = Nothing
	Set objFSO = Nothing
End Function

Function latestExcelFile()
	'Getting latest file from a folder
	Err.Clear
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	Set folder = objFSO.GetFolder("C:\Users\ss16890\Downloads\")
	'MsgBox folder.Files.Count
	Dim lmodfile, lmodate
	lmodate = #1/1/0001#
	For Each File in folder.Files
		If File.DateCreated > lmodate Then
			lmodfile = File.Name
			'lmodate = File.DateLastModified
			lmodate = File.DateCreated
		End If
	Next
	latestExcelFile = lmodfile
	Set objFSO = Nothing
	Set folder = Nothing
	If Err Then
		UtilFunction.WriteLog "latestExcelFile: "&Err.description
	End If
End Function

Function ExcelVerification(strExcelName,xlStartRow,xlStartCol,exlEndRow,exlEndCol)
'Code to verify data in downloaded excel
On Error Resume Next
Dim DataChecker
	Set objExcel = CreateObject("Excel.Application")
	UtilFunction.WriteLog "Opening the excel: "&strExcelName
	Set objExWkbk = objExcel.Workbooks.Open("C:\Users\ss16890\Downloads\"&strExcelName)
	Set objExwkst = objExWkbk.Worksheets(1)
	If Err Then
		'UtilFunction.WriteStatus "fail", "TC006", "Report generation", Err.description
		Reporter.ReportEvent micFail, "ExcelVerification", Err.description
		UtilFunction.WriteLog "ExcelVerification: Unredable excel format/"&Err.description
		ExcelVerification = "Unredable excel format/"&Err.description
		Exit Function
	End If
	For xlsColIndex = xlStartCol To exlEndCol
		For xlsRowIndex = xlStartRow To exlEndRow
			'If Not IsEmpty(objExwkst.cells(xlsRowIndex,xlsColIndex)) Then
			If IsNumeric(objExwkst.cells(xlsRowIndex,xlsColIndex)) Then
				If Round(objExwkst.cells(xlsRowIndex,xlsColIndex)) <> 0 Then
					UtilFunction.WriteLog "Data found at row("&xlsRowIndex&") and col("&xlsColIndex&") - Value: "&objExwkst.cells(xlsRowIndex,xlsColIndex)
					DataChecker = "Data is present"
					ExcelVerification = "Data found at row("&xlsRowIndex&") and col("&xlsColIndex&") - Value: "&objExwkst.cells(xlsRowIndex,xlsColIndex)
					UtilFunction.WriteLog "Data found at row("&xlsRowIndex&") and col("&xlsColIndex&") - Value: "&objExwkst.cells(xlsRowIndex,xlsColIndex)
					xlsColIndex = exlEndRow+2
					xlsColIndex = exlEndCol+2
				End If
			End If
		Next
	Next
If DataChecker = "Data is present" Then
'	UtilFunction.WriteLog "Data is existing in downloaded excel: "&strExcelName
'	UtilFunction.WriteStatus "pass", "TC002", "Report generation", "Report Generation is successful"
	Reporter.ReportEvent micPass, "Report generation", "Report Generation is successful"
	'ExcelVerification = "Pass - ReportGenerator is successful"
Else
'	UtilFunction.WriteLog "Data is not present in downloaded excel: "&strExcelName
'	UtilFunction.WriteStatus "fail", "TC002", "Report generation", "Data is not present in downloaded excel: "&strExcelName
	Reporter.ReportEvent micFail, "Report generation", "Data is not present in downloaded excel: "&strExcelName
	ExcelVerification = "Data is not present in downloaded excel"
End If
objExWkbk.Save
'objExWkbk.Close
Call KillProcess("EXCEL.EXE")
Set objExwkst = Nothing
Set objExWkbk = Nothing
objExcel.Quit
Set objExcel = Nothing
End Function

'####################################### End Of PRSReportGenerator #########################################

'#############################################################################################################
' Function/sub name	 : FileUpload(Supplementory data load)
' Description		 : System would provide the user with capability to manually upload files for report processing. The user would be provided with 
'						a simple screen UI for uploading of files. Supplementary data load is used when we want to insert any new records, update 
'						the existing records or delete the records of the table.
' Input arguments	 : 
' Output/return value: -
' Date of creation	 : 8/3/2017
' Developed by		 : Santhosh Reddy
'#############################################################################################################
Function FileUpload(functionalArea,formname,period,filetobupload,strUrl, UserName, Password, strCountry,intCalCounter)
defaultselect = "0" 'to select 1st option from dropdown list
	UtilFunction.WriteLog  "Executing FileUpload for "&intCalCounter&" iteration"
	UtilFunction.WriteLog "Opening side navigation pane"
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("west-region-container-splitter").Click
	UtilFunction.WriteLog "Opening Supplementary Data Load page"
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("Supplementary Data Load").Click
	
	UtilFunction.WriteLog "Selecting functionalArea"
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("suppLoadfunctionalArea").Click
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebList("boundlist-1201-listEl").Select functionalArea'"FINANCE"

	UtilFunction.WriteLog "Selecting form name"
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("formNameLrr-trigger-picker").Click
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebList("boundlist-1203-listEl").Select formname'"ES_9_LRR_EMEA_ES_GEN_ESTACON_MAIL"
	
	UtilFunction.WriteLog "Selecting reasdon code"
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("reasonCode").Click
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebList("boundlist-1228-listEl").Select "Mapping adjustments"

	UtilFunction.WriteLog "Setting up date"
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("period_2").Set period'"06/20/2017"
	Wait(1)
	UtilFunction.WriteLog "Opening browse window to select file to be uploaded"
	Dim objMClick
	Set objMClick = CreateObject("Wscript.Shell")
	objMClick.SendKeys"{TAB 3}",true
	objMClick.SendKeys"{ENTER}",true
	Set objMClick = Nothing
	Wait(1)
	Window("Google Chrome").Dialog("Open").WinObject("Items View").WinList("Items View").Activate filetobupload'"FI.4.4_002_11195_1_13114.xlsx"
	
	UtilFunction.WriteLog "Clicking Upload button"
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("suppUploadbuttonIdLrr-btnInner").Click
	strValmsg = Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("messagebox-1001-innerCt_2").GetROProperty("outertext")
	
	If strValmsg = "File uploaded Successfully " Then
		UtilFunction.WriteLog "Closing validation pop up"
		Browser("Single Sign-On").Page("US Regulatory Reporting").Image("AMDAwAAAACH5BAEAAAAALAAAAAABAA_15").Click
		UtilFunction.WriteLog "Done - "&strValmsg
		Reporter.ReportEvent micDone, "File Upload", strValmsg
		Call Login(strUrl, UserName, Password, strCountry)
		FileUpload = UploadFileApprove(functionalArea,formname)
	Else
		Desktop.CaptureBitmap UtilFunction.ErrSreenShots&"/Reportgeneration-"&Replace(Replace(Replace(now(),"/","-"),":","-")," ","-")&".png", true
		UtilFunction.WriteLog "Closing the validation pop up"
		Browser("Single Sign-On").Page("US Regulatory Reporting").Image("AMDAwAAAACH5BAEAAAAALAAAAAABAA_15").Click
		UtilFunction.WriteLog strValmsg
		FileUpload = "Fail - "&strValmsg
		UtilFunction.WriteStatus "fail", "TC006", "File Upload", strValmsg
		Reporter.ReportEvent micFail, "File Upload", strValmsg
	End If
	
End Function

	Function UploadFileApprove(functionalArea,formname)
		Dim defaultselect: defaultselect = "0" 'to select 1st option from dropdown list
		UtilFunction.WriteLog "Opening side navigation pane"
		Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("west-region-container-splitter").Click
		UtilFunction.WriteLog "Opening Supplementary Data Load page"
		Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("Supplementary Data Load").Click
		
		UtilFunction.WriteLog "Selecting functionalArea"
		Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("suppLoadfunctionalArea").Click
		Browser("Single Sign-On").Page("US Regulatory Reporting").WebList("boundlist-1201-listEl").Select functionalArea'"FINANCE"
	
		UtilFunction.WriteLog "Selecting form name"
		Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("formNameLrr-trigger-picker").Click
		Browser("Single Sign-On").Page("US Regulatory Reporting").WebList("boundlist-1203-listEl").Select formname'"ES_9_LRR_EMEA_ES_GEN_ESTACON_MAIL"
		Set objWT = Description.Create
		objWT("micclass").Value = "WebTable"
		objWT("html id").Value = "gridview-[0-9]+-record-[0-9]+"
		objWT("cols").Value = "18"
		Set objWTName = Browser("Single Sign-On").Page("US Regulatory Reporting").ChildObjects(objWT)
		objWTName(0).Childitem(1,1,"WebElement",1).Click
		objWTName(0).Childitem(1,9,"Image",0).Click
		UtilFunction.WriteLog "Providing comments"
		Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("remPopUpTxtArea").Set "Test Fileupload"
		UtilFunction.WriteLog "Clicking approve button"
		Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("html id:=btnApproveWindowSubmit-btnInnerEl","innerhtml:=Approve","outertext:=Approve").Click
		
		strValmsg = Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("messagebox-1001-msg").GetROProperty("outertext")
		If strValmsg = "Approval process initiated." Then
			UtilFunction.WriteLog "Clicking OK of status pop up"
			Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("html id:=button-1005-btnEl","outertext:=OK","role:=presentation").Click
			UtilFunction.WriteLog "pass - "&strValmsg
			UploadFileApprove = "Pass - File upload is successful"
			UtilFunction.WriteStatus "pass", "TC010", "File Upload", strValmsg
			Reporter.ReportEvent micPass, "File Upload", strValmsg
		Else
			Desktop.CaptureBitmap UtilFunction.ErrSreenShots&"/Reportgeneration-"&Replace(Replace(Replace(now(),"/","-"),":","-")," ","-")&".png", true
			UtilFunction.WriteLog "Closing the validation pop up"
			Browser("Single Sign-On").Page("US Regulatory Reporting").Image("AMDAwAAAACH5BAEAAAAALAAAAAABAA_15").Click
			UtilFunction.WriteLog strValmsg
			UploadFileApprove = "Fail - File upload is not successful"
			UtilFunction.WriteStatus "fail", "TC006", "File Upload", strValmsg
			Reporter.ReportEvent micFail, "File Upload", strValmsg
		End If	
	End Function
'################################################### End of File Upload ##################################################################
'#############################################################################################################
' Function/sub name	 : Inquiry FrameWork
' Description		 : RegInsight will provide Ad-Hoc Report generation feature by leveraging Inquiry Framework. For a regulatory requirement which requires ad-hoc reports, 
'						user can use ad-hoc report generation tool to write query. The query can be run over ODS or RDM data. Based on user query and field selection 
'						criterion report will be generated.
' Input arguments	 : Domain,formname,outputformat,Businessdate,CRCY1,GFPID,FREQ,LVID,LV_ID,intCalCounter,FileLocation
' Output/return value: -
' Date of creation	 : 8/8/2017
' Date of updation 	 : 25/6/2018
' Updated by 		 : Saurabh Sharma
' Developed by		 : Santhosh Reddy
'#############################################################################################################
Function InquiryFrameWork(Domain,formname,outputformat,Businessdate,CRCY1,GFPID,FREQ,LVID,LV_ID,intCalCounter,FileLocation)
On Error Resume Next
	Dim objWT, objWTName,Reportstatus,RecordCount,objExcel,objExWkbk,objExwkst,objFSO,folder,objFileStream
	Dim intValueFlag,Lista,Reportname
	Dim colArray,paraArrayTemp
	Set j = 0
	Dim paraArray()
	Dim colNames()
	paraArrayTemp = Array(Businessdate,CRCY1,GFPID,FREQ,LVID,LV_ID)
	' Code for creating a new array for non empty parameters and Col Names passed to the function. -> 25/6/2018 START
	For i = 0 To ubound(paraArrayTemp) Step 1
		If paraArrayTemp(i) = ""  Then
			paraArrayTemp(i) = ""
		else
			j = j + 1
			ReDim preserve paraArray(j)
			ReDim preserve colNames(j)
			paraArray(j-1) = paraArrayTemp(i)
			colNames(j-1) = Datatable.Getsheet("InquiryFramework").Getparameter(i+4).Name
			ReDim preserve paraArray(j-1)
			ReDim preserve colNames(j-1)
		End If
	Next
	' Code for creating a new array for non empty parameters and Col Names passed to the function. -> 25/6/2018 END paraArray created.
	
	
	Set objMClick = CreateObject("Wscript.Shell")
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	Set objFileStream = objFSO.OpenTextFile(FileLocation&"\InquiryFrameworkStatus.txt", 8, True)
	UtilFunction.WriteLog "**********************************************************************************************"
	UtilFunction.WriteLog "Executing "&intCalCounter&" iteration"
	If intCalCounter = 1 Then
		objFileStream.WriteLine "S.No	formname	Businessdate	Frequency	Status	DownloadedReportname	Comments"
		UtilFunction.WriteLog "Opening left navigation pane"
		Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("west-region-container-splitter").Click
	End If
	If Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("tab-1100-closeEl").Exist(2) Then
		UtilFunction.WriteLog "Closing IFW page"
		Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("tab-1100-closeEl").Click
	End If
	
	UtilFunction.WriteLog "Clicking Inquiry Framework link on navigation pane"
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("Inquiry Framework").Click
	wait(10)
	
	UtilFunction.WriteLog "Opening Inquiry Framework page"
	Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame").Image("appbar.page.add").Click
	wait(10)
	
	UtilFunction.WriteLog "Closing Navigation tab"
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("west-region-container-splitter").Click
	wait(2)
	
	UtilFunction.WriteLog "Selecting Application"
	Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame").WebElement("combo-1043-trigger-picker").Click
	Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame_2").WebList("combo-1043-picker-listEl").Select "REGINSIGHT_EMEA"
	wait(2)
	
	UtilFunction.WriteLog "Selecting Domain"
	Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame").WebElement("rpt_form_field_combobox-1072").Click
	wait(2)
	'Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame_2").WebList("rpt_form_field_combobox-1067-p").Select Ucase(Domain) '"SPAIN"
	Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame").WebList("rpt_form_field_combobox-1072-picker").Select Ucase(Domain)
	wait(2)

	UtilFunction.WriteLog "Searching for form name: "&formname
	Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame").WebEdit("textfield-2002-inputEl").Set formname
	wait(2)
		
	UtilFunction.WriteLog "Selecting form"
	Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame").WebElement("class:=x-grid-cell-inner ","innerhtml:="&formname,"innertext:="&formname).Click
	wait(2)

	UtilFunction.WriteLog "Providing Report name: "&formname+Businessdate
	Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame").WebEdit("REPORT_TITLE").Set Replace(formname," ","")+Replace(Businessdate,"-","") '"TestReport627"
	wait(2)
	
	UtilFunction.WriteLog "Selecting Output Format: "&outputformat
	Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame").WebElement("combo-1073-trigger-picker").Click
	Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame").WebList("combo-1073-picker-listEl").Select outputformat
	wait(2)

	' Commenting will add one by one filters ->20/6
'	Set objWT = Description.Create
'	objWT("micclass").Value = "WebList"
'	objWT("html tag").Value = "UL"
'	objWT("html id").Value = "boundlist-[0-9]+-listEl"
'	objWT("role").Value = "listbox"
'	Set objWTName = Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame").ChildObjects(objWT)
'	UtilFunction.WriteLog "No of weblists: "&objWTName.Count
'	If objWTName.Count <> 0 Then
'		objWTName(0).select Split(objWTName(0).GetROProperty("all items"),";")(0)
'		objMClick.SendKeys"^a",true
'		Wait(1)
'		UtilFunction.WriteLog "Clicking Add to Selected buton for 1st filter list"
'		Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame").WebElement("button-1952-btnIconEl").Click
'		Lista = objWTName(1).GetROProperty("all items")
'		Err.Clear
'		objWTName(2).select Split(objWTName(2).GetROProperty("all items"),";")(0)
'		If Err Then
'			UtilFunction.WriteLog "2nd filter list is not existing, Err description: "&Err.Description
'		Else
'			objMClick.SendKeys"^a",true
'			Wait(1)
'			UtilFunction.WriteLog "Clicking Add to Selected buton for 2nd filter list"
'			Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame").WebElement("button-1969-btnIconEl").Click	
'			'UtilFunction.WriteLog "2nd filter list: "&objWTName(3).GetROProperty("all items")
'			Lista = Lista+";"+objWTName(3).GetROProperty("all items")
'		End If
'	Else
'		Lista = "NoFilters"
'	End If
'	Err.Clear
'	Set objWT = Nothing
' Comments ended.-> 20/6
'	strValmsg = Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame").WebElement("label-1943").GetROProperty("outertext")
'	If strValmsg <> "This report is configured to run with no filters, click on Run Report to start." Then
'		UtilFunction.WriteLog "Selecting date"
'		Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame").WebEdit("prompt1").Set AsOfDate '"2017-06-27"
'		UtilFunction.WriteLog "Clicking Form name check box"
'		Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame").WebElement("rpt_form_field_combobox-1982-t").Click
'	End If
'	
	If Businessdate <> "" Then
		UtilFunction.WriteLog "Providing Business date: "&Businessdate
		Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame").WebEdit("prompt1").Set Businessdate'"2017-03-31"
	End If

	If CRCY1 <> "" Then
		UtilFunction.WriteLog "Selecting Currency"
		Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame").WebEdit("GFCID").Set CRCY1
	End If
	
'	If Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame").WebEdit("prompt2").Exist(2) Then'BUS_DT_VAR
'		UtilFunction.WriteLog "Selecting BUS_DT_VAR: "&BUSDTVAR
'		Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame").WebEdit("prompt2").Set BUSDTVAR'"2017-03-31"
'	End If
'	
'	If Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame").WebEdit("prompt5").Exist(2) Then
'		UtilFunction.WriteLog "Selecting Frequency: "&Frequency
'		Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame").WebEdit("prompt5").Set "'"+Frequency+"'"'"'DLY'"
'	End If
'	
'	If Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame").WebEdit("prompt4").Exist(2) Then 'FREQ_VAR
'		UtilFunction.WriteLog "Selecting FREQ_VAR: "&Frequency
'		Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame").WebEdit("prompt4").Set "'"+Frequency+"'"'"'DLY'"
'	End If
'	
'	If Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame").WebEdit("prompt3").Exist(2) Then
'		UtilFunction.WriteLog "Selecting 2nd FREQ_VAR: "&FREQVAR
'		Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame").WebEdit("prompt3").Set "'"+FREQVAR+"'" '"'DLY'" 'WTDA Variance Analysis
'	End If
'	
'	If Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame").WebEdit("prompt6").Exist(2) Then
'		UtilFunction.WriteLog "Selecting BD value: "&BD
'		Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame").WebEdit("prompt6").Set "'"+BD+"'" ''BD10'
'	End If
'	If Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame").WebEdit("prompt3_2").Exist(2) Then
'		UtilFunction.WriteLog "Selecting SOLO_OR_CONS value: "&SOLOORCONS
'		Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame").WebEdit("prompt3_2").Set "'"+SOLOORCONS+"'"
'	End If
	
	
	UtilFunction.WriteLog "Clicking Run Button"
	Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame").WebElement("button-1079-btnInnerEl").Click	
	Wait(3)
	Set objWT = Description.Create
	objWT("micclass").Value = "WebTable"
	objWT("html tag").Value = "TABLE"
	objWT("cols").Value = "2"
	objWT("name").Value = "Image"
	Set objWTName = Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame").ChildObjects(objWT)
	Reportstatus = Right(objWTName(0).GetCellData(1,2),9)
	UtilFunction.WriteLog "Checking competed status"
	Dim timecounter: timecounter = 0
	While Reportstatus <> "Completed"
		Wait(3)
		Set objWTName = Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame").ChildObjects(objWT)
		Reportstatus = Right(objWTName(0).GetCellData(1,2),9)
		If timecounter = 50 Then
			Reportstatus = "Completed"
		Else
			timecounter = timecounter+1
		End If
	Wend
	If Reportstatus = "Completed" AND timecounter <> 50 Then
		UtilFunction.WriteLog "Downloading the report"
		objWTName(0).ChildItem(1,1,"Image",0).Click
		Browser("Single Sign-On").Page("US Regulatory Reporting").Frame("Frame").WebElement("menuitem-1757-textEl").Click
		Wait(4)
		
		UtilFunction.WriteLog "Finding the latest downloaded report"
		Reportname = latestExcelFile()
		Set objExcel = CreateObject("Excel.Application")
		Set objExWkbk = objExcel.Workbooks.Open("C:\Users\ss16890\Downloads\"&Reportname)
		Set objExwkst = objExWkbk.Worksheets(1)
		colCount = objExwkst.UsedRange.columns.Count
		rowCount = objExwkst.UsedRange.rows.Count
		UtilFunction.WriteLog "columns# in the downloaded excel: "&colCount
		objExWkbk.Save
		objExWkbk.Close
		Call KillProcess("EXCEL.EXE")
		Set objExwkst = Nothing
		Set objExWkbk = Nothing
'		objExcel.Quit
		Set objExcel = Nothing
		
		If colCount > 1 Or rowCount > 1 Then
			Dim Filterstatus
			For i = 0 To ubound(paraArray) Step 1
				Filterstatus = FilterCheck(Reportname,colNames(i),paraArray(i))
			
				If Filterstatus = "Fail" Then
					objFileStream.WriteLine intCalCounter&"	"&formname&"	"&Businessdate&"	"&Frequency&"	Fail	"&Reportname&"	Missing filters on report	"&strMissingFilters
					UtilFunction.WriteLog "Selected filters not found in the downloaded report"
					UtilFunction.WriteStatus "fail", "TC007", "Inquiry Framework", "Seleced filters not found in the downloaded report"
					Reporter.ReportEvent micFail, "Inquiry Framework", "Seleced filters not found in the downloaded report"
					InquiryFrameWork = "Failed - Inquiry Framework is not successful"
					Exit Function
				End If
			Next
				If Filterstatus = "Pass" Then
					objFileStream.WriteLine intCalCounter&"	"&formname&"	"&Businessdate&"	"&Frequency&"	Pass	"&Reportname&"	Optional filters have been verified"
					UtilFunction.WriteLog "InquiryFrameWork is successful"
					UtilFunction.WriteStatus "pass", "TC007", "Inquiry Framework", "Inquiry Framework is successful"
					Reporter.ReportEvent micPass, "Inquiry Framework", "Inquiry Framework is successful"
					InquiryFrameWork = "Inquiry Framework is successful"
'				Else
'					objFileStream.WriteLine intCalCounter&"	"&formname&"	"&Businessdate&"	"&Frequency&"	Fail	"&Reportname&"	Missing filters on report	"&strMissingFilters
'					UtilFunction.WriteLog "Selected filters not found in the downloaded report"
'					UtilFunction.WriteStatus "fail", "TC007", "Inquiry Framework", "Seleced filters not found in the downloaded report"
'					Reporter.ReportEvent micFail, "Inquiry Framework", "Seleced filters not found in the downloaded report"
'					InquiryFrameWork = "Failed - Inquiry Framework is not successful"
'					Exit Function
				End If		
			
		'commeting to check the column and column values -> 21/6/2018 Start
'			ReDim dExcelFilters(colCount-1)
'			For exlColIndex = 1 To colCount
'				dExcelFilters(exlColIndex-1) = objExwkst.cells(1,exlColIndex)
'			Next
'			UtilFunction.WriteLog "DownloadFile Filters filters: "&Join(dExcelFilters,";")
'			UtilFunction.WriteLog "Application filters: "&Lista
'			objExWkbk.Save
'			'objExWkbk.Close
'			Call KillProcess("EXCEL.EXE")
'			Set objExwkst = Nothing
'			Set objExWkbk = Nothing
'			objExcel.Quit
'			Set objExcel = Nothing
'			If Lista <> "NoFilters" Then
'				If strComp(Join(dExcelFilters,";"),Lista) = 0 Then
'					'objFileStream.WriteLine intCalCounter&"	"&formname&"	"&Businessdate&"	"&Frequency&"	Pass	"&Reportname&"	Sequence and optional filters have been verified"
'					UtilFunction.WriteLog Replace(Lista,";","	")
'					UtilFunction.WriteLog "Sequence and optional filters have been verified"
'					UtilFunction.WriteLog "InquiryFrameWork is successful"
'					'UtilFunction.WriteStatus "pass", "TC007", "Inquiry Framework", "Inquiry Framework is successful"
'					Reporter.ReportEvent micPass, "Inquiry Framework", "Inquiry Framework is successful"
'					InquiryFrameWork = "Inquiry Framework is successful"
'				Else
'					UtilFunction.WriteLog "Verifying each filter opton as sequence is not same as on application"
'					Dim intLindex,filterOption,filterFailFlag,intDExlIndex,strMissingFilters
'					filterFailFlag = 0
'					appFilterList = Split(Lista,";")
'					For intLindex = 0 To Ubound(appFilterList)'filter option from application
'						filterOption = 0
'						For intDExlIndex = 0 To Ubound(dExcelFilters) 'filter option from downloaded excel
'							If appFilterList(intLindex) = dExcelFilters(intDExlIndex) Then
'								filterOption = 1+filterOption
'							End If
'						Next
'						If filterOption = 1 Then
'							UtilFunction.WriteLog "The filter: "&appFilterList(intLindex)&" has been verified on downloaded report"
'						ElseIf filterOption > 1 Then
'							UtilFunction.WriteLog "The filter: "&appFilterList(intLindex)&" present more then ones on downloaded report"
'						Else
'							filterFailFlag = filterFailFlag+1
'							UtilFunction.WriteLog "The filter: "&appFilterList(intLindex)&" is not found on downloaded report"
'							strMissingFilters = strMissingFilters+";"+appFilterList(intLindex)
'						End If
'					Next
'					If filterFailFlag > 0 Then
'						'objFileStream.WriteLine intCalCounter&"	"&formname&"	"&Businessdate&"	"&Frequency&"	Fail	"&Reportname&"	Missing filters on report	"&strMissingFilters
'						UtilFunction.WriteLog "Seleced filters not found in the downloaded report"
'					'	UtilFunction.WriteStatus "fail", "TC007", "Inquiry Framework", "Seleced filters not found in the downloaded report"
'						Reporter.ReportEvent micFail, "Inquiry Framework", "Seleced filters not found in the downloaded report"
'						InquiryFrameWork = "Failed - Inquiry Framework is not successful"
'					Else
'						'objFileStream.WriteLine intCalCounter&"	"&formname&"	"&Businessdate&"	"&Frequency&"	Pass	"&Reportname&"	Optional filters have been verified"
'						UtilFunction.WriteLog "InquiryFrameWork is successful"
'					'	UtilFunction.WriteStatus "pass", "TC007", "Inquiry Framework", "Inquiry Framework is successful"
'						Reporter.ReportEvent micPass, "Inquiry Framework", "Inquiry Framework is successful"
'						InquiryFrameWork = "Inquiry Framework is successful"
'					End If
'				End If
'			Else
'				'Verification for other filters
'				'objFileStream.WriteLine intCalCounter&"	"&formname&"	"&Businessdate&"	"&Frequency&"	Done	"&Reportname&"	Custom filtes are not existing for this report"
'				UtilFunction.WriteLog "Custom filtes are not existing for this report"
'			End If
'commeting to check the column and column values -> 21/6/2018 -> END
		Else
			objFileStream.WriteLine intCalCounter&"	"&formname&"	"&Businessdate&"	"&Frequency&"	Fail	"&Reportname&"	Report does not contain records"
			UtilFunction.WriteLog "Report does not contain records"
			UtilFunction.WriteStatus "fail", "TC007", "Inquiry Framework", "Report does not contain records"
			Reporter.ReportEvent micFail, "Inquiry Framework", "Report does not contain records"
			InquiryFrameWork = "Failed - Inquiry Framework is not successful"
		End If
	Else
		objFileStream.WriteLine intCalCounter&"	"&formname&"	"&Businessdate&"	"&Frequency&"	Fail	"&Reportname&"	Report is not in Completed state"
		UtilFunction.WriteLog "Report is not in Completed state"
		Desktop.CaptureBitmap UtilFunction.ErrSreenShots&"/Reportgeneration-"&Replace(Replace(Replace(now(),"/","-"),":","-")," ","-")&".png", true
		UtilFunction.WriteStatus "fail", "TC007", "Inquiry Framework", "Report is not in Completed state"
		Reporter.ReportEvent micFail, "Inquiry Framework", "Report is not in Completed state"
		InquiryFrameWork = "Failed - Inquiry Framework is not successful"
	End If
Set objMClick = Nothing
Set objFileStream = Nothing
Set objFSO = Nothing
End Function

'#############################################################################################################
' Function/sub name	 : latestExcelFile
' Description		 : Function used to get the name of the latest file downloaded in the Download folder of the user.
' Input arguments	 : 
' Output/return value: File Name
' Date of creation	 : 22/6/2018
' Developed by		 : Saurabh Sharma
'#############################################################################################################
Function latestExcelFile()
	'Getting latest file from a folder
	Err.Clear
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	Set folder = objFSO.GetFolder("C:\Users\ss16890\Downloads\")
	UtilFunction.WriteLog folder.Files.Count
	Dim lmodfile, lmodate
	lmodate = #1/1/0001#
	For Each File in folder.Files
		If File.DateCreated > lmodate Then
			lmodfile = File.Name
			'lmodate = File.DateLastModified
			lmodate = File.DateCreated
		End If
	Next
	latestExcelFile = lmodfile
	Set objFSO = Nothing
	Set folder = Nothing
	If Err Then
		UtilFunction.WriteLog "latestExcelFile: "&Err.description
	End If
End Function

'#############################################################################################################
' Function/sub name	 : FilterCheck
' Description		 : Function used to check presence of filter col name and col value in the downloaded file.
' Input arguments	 : Reportname,tablecol,paraelement
' Output/return value: Pass / Fail
' Date of creation	 : 25/6/2018
' Developed by		 : Saurabh Sharma
'#############################################################################################################
Function FilterCheck(Reportname,tablecol,paraelement)
		Dim dExcelFilters,flag,tempvalue
		flag = 0
		tempvalue = 0
		Set objExcel = CreateObject("Excel.Application")
		Set objExWkbk = objExcel.Workbooks.Open("C:\Users\ss16890\Downloads\"&Reportname)
		Set objExwkst = objExWkbk.Worksheets(1)
		colCount = objExwkst.UsedRange.columns.Count
		rowCount = objExwkst.UsedRange.rows.Count
		
		If rowCount = 1 Then
			FilterCheck = "Fail"
			objExWkbk.Save
			objExWkbk.Close
			Call KillProcess("EXCEL.EXE")
			Set objExwkst = Nothing
			Set objExWkbk = Nothing
	'		objExcel.Quit
			Set objExcel = Nothing
			Exit Function
		End If
		
		For i = 1 To colCount Step 1
'			UtilFunction.WriteLog objExwkst.Cells(1,i)
			If objExwkst.Cells(1,i) = tablecol Then
				tempvalue = i
			End If
		Next
		
		For j = 2 To rowCount Step 1
			Dim dateflag,dateflagvalue
			dateflag = IsDate(objExwkst.Cells(j,tempvalue))
			If dateflag = "True" Then
				dateflagvalue = Mid(objExwkst.Cells(j,tempvalue),1,10)
			Else
				dateflagvalue = objExwkst.Cells(j,tempvalue)
			End If
			
			If dateflagvalue <> paraelement Then
				FilterCheck = "Fail"
			Else
				FilterCheck = "Pass"
			End If
		Next
		objExWkbk.Save
		objExWkbk.Close
		Call KillProcess("EXCEL.EXE")
		Set objExwkst = Nothing
		Set objExWkbk = Nothing
'		objExcel.Quit
		Set objExcel = Nothing
End Function
'################################# End Of Inquiry Framework ################################################################################


'########################################################################################################################
' Function/sub name	 : TSA and Approvals Online
' Description		 : Top Side Adjustments (TSA) is a possibility for the Business to overwrite a cell or many cells for the reports.
'						With this functionality users can correct any mistakes in the reports without delays in the submission.
'						The TSA Dashboard displays the information and status of adjustments made all the ES reports to be submitted.
' Input arguments	 : 
' Output/return value: -
' Date of creation	 : 6/15/2017
' Developed by		 : Santhosh Reddy
'#############################################################################################################
Function TSAOnline(functionalArea,formName,fiscalYear,accountingPeriod,intCalCounter,url,un,pw,country,FileLocation)
Dim preTSA(3,2),postTSA(3,2),intTSA1,intTSA2,intTSA3,intTSA4,strValMsg
Dim objWT, objWTName,objFSO, objFileStream
intTSA1 = -30
intTSA2 = 70
intTSA3 = -200
intTSA4 = -10

	Set objFSO = CreateObject("Scripting.FileSystemObject")
	Set objFileStream = objFSO.OpenTextFile(FileLocation&"\"&country&"_TSAOnline.txt", 8, True)
	If intCalCounter = 1 Then
		objFileStream.WriteLine "S.No.	FormID	Period	Status	Preval1	TSA1	Postval1	Preval2	TSA2	Postval2	Preval3	TSA3	Postval3	Preval4	TSA4	Postval4	Comments"
	End If
	UtilFunction.WriteLog "*************************************************************************"
UtilFunction.WriteLog "Executing TSAOnline for "&intCalCounter&" iteration"
	Call Login(url,un,pw,country)
	TSAOnline = TSAonlineTable(functionalArea,formName,fiscalYear,accountingPeriod, preTSA,intTSA1,intTSA2,intTSA3,intTSA4)
	If TSAOnline = "Pass - TSAonline is successful" OR TSAOnline = "Adjustment is in pending state for same combination" Then
		Set objWT = Description.Create
		objWT("micclass").Value = "WebTable"
		objWT("html id").Value = "gridview-[0-9]+-record-[0-9]+"
		objWT("cols").Value = "21"
		Set objWTName = Browser("Single Sign-On").Page("US Regulatory Reporting").ChildObjects(objWT)
		UtilFunction.WriteLog "Getting maker name: "&objWTName(0).GetCellData(1,14)
		If TSAOnline = "Adjustment is in pending state for same combination" AND Ucase(objWTName(0).GetCellData(1,14)) <> Ucase(un)  Then
			TSAOnline = ApproveTSAchanges(functionalArea,formName,fiscalYear,accountingPeriod,preTSA,postTSA,"TASOnline")
		Else
			'Call Login("https://reginsight2.uat.emea.citigroup.net/","mk88168","Sept@2017","Spain")
			Call Login("https://reginsight2.uat.emea.citigroup.net/","sr87644","May@2017",country)
			TSAOnline = ApproveTSAchanges(functionalArea,formName,fiscalYear,accountingPeriod,preTSA,postTSA,"TASOnline")
		End If
		If TSAOnline = "Success" Then
			TSAOnline = TSAresVerifyonline(preTSA,postTSA,intTSA1,intTSA2,intTSA3,intTSA4)
			UtilFunction.WriteLog TSAOnline
		End If

	End If
	If TSAOnline = "Pass - TSAonline is successful" Then
		objFileStream.WriteLine	intCalCounter&"	"&formName&"	"&accountingPeriod&"	Pass	"&preTSA(0,0)&"	"&intTSA1&"	"&postTSA(0,0)&"	"&preTSA(1,0)&"	"&intTSA2&"	"&postTSA(1,0)&"	"&preTSA(2,0)&"	"&intTSA3&"	"&postTSA(2,0)&"	"&preTSA(3,0)&"	"&intTSA4&"	"&postTSA(3,0)
	Else
		objFileStream.WriteLine	intCalCounter&"	"&formName&"	"&accountingPeriod&"	Fail	"&preTSA(0,0)&"	"&intTSA1&"	"&postTSA(0,0)&"	"&preTSA(1,0)&"	"&intTSA2&"	"&postTSA(1,0)&"	"&preTSA(2,0)&"	"&intTSA3&"	"&postTSA(2,0)&"	"&preTSA(3,0)&"	"&intTSA4&"	"&postTSA(3,0)&"	"&TSAOnline
	End If
Set objFSO = Nothing
Set objFileStream = Nothing
End Function

Function TSAonlineTable(functionalArea,formName,fiscalYear,accountingPeriod,ByRef arr,intTSA1,intTSA2,intTSA3,intTSA4)
	Dim intValSelect,strValmsg
	intValSelect = "0"
	
	UtilFunction.WriteLog "Opening left navigation pane"
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("west-region-container-splitter").Click
	
	UtilFunction.WriteLog "Clickng Regulatory Reporting page"
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("Topside Adjustment (FAEM)_2").Click
	UtilFunction.WriteLog "Selecting Functional area"
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("functionalArea").Click
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebList("boundlist-1506-listEl").Select functionalArea '"FINANCE" 
	UtilFunction.WriteLog "Selecting Formname: "&formName
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("combobox-1105-trigger-picker").Click
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebList("boundlist-1201-listEl").Select Ucase(formName)
	Wait(1)
	UtilFunction.WriteLog "Selecting Fiscal year name"
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("fiscalYear").Click
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebList("boundlist-1506-listEl").Select fiscalYear

	UtilFunction.WriteLog "Selecting Period: "&Ucase(accountingPeriod)
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebEdit("accountingPeriod").Click
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebList("boundlist-1228-listEl").Select Ucase(accountingPeriod)

	UtilFunction.WriteLog "Clicking Search buton"
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("primarybutton-1128-btnInnerEl").Click
	Wait(1)
	UtilFunction.WriteLog "Clicking Add(plus) button to pass TSAs"
	Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("addAdj-btnIconEl").Click
	If Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("messagebox-1001-msg_13").Exist(2) Then
		strValmsg = Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("messagebox-1001-msg_13").GetROProperty("outertext")
		If  strValmsg = "No data available for the selected combination." Then
			Desktop.CaptureBitmap UtilFunction.ErrSreenShots&"/TSAonline-"&Replace(Replace(Replace(now(),"/","-"),":","-")," ","-")&".png", true
			UtilFunction.WriteLog strValmsg
			Browser("Single Sign-On").Page("US Regulatory Reporting").Image("AMDAwAAAACH5BAEAAAAALAAAAAABAA_14").Click
			Reporter.ReportEvent micFail, "TSA Oline", strValmsg
			TSAonlineTable = strValmsg
			Exit Function
		End If
		
	End If
	Wait(4)
	Dim intai,objTSAWT,objTSAwtn
	intai = 0
	Set objTSAWT = Description.Create
	objTSAWT("micclass").Value = "WebTable"
	objTSAWT("html tag").Value = "TABLE"
	objTSAWT("class").Value = "rulesmap"
	Set objTSAwtn = Browser("Single Sign-On").Page("US Regulatory Reporting").ChildObjects(objTSAWT)
		For inti = 3 To objTSAwtn(0).RowCount Step 2
			intiflag = 0'to take only 2 values per column
			For intj = 2 To objTSAwtn(0).ColumnCount(inti) Step 2
				If IsNumeric(objTSAwtn(0).GetCellData(inti,intj)) AND NOT IsEmpty(objTSAwtn(0).GetCellData(inti,intj)) AND intiflag < 2 Then
					arr(intai,0) = Int(objTSAwtn(0).Childitem(inti,intj+1,"WebEdit",0).GetROProperty("value"))
					arr(intai,1) = inti
					arr(intai,2) = intj+1
					intai = intai+1
					intiflag = intiflag+1
					intValueFlag = intValueFlag+1
				End If
				If intValueFlag = 4 Then
					intj = objTSAwtn(0).ColumnCount(inti)
					inti = objTSAwtn(0).RowCount
				End If
			Next
		Next
			UtilFunction.WriteLog "updating TSAs"
			objTSAwtn(0).Childitem(arr(0,1),arr(0,2),"WebEdit",0).Set intTSA1
			objTSAwtn(0).Childitem(arr(1,1),arr(1,2),"WebEdit",0).Set intTSA2
			objTSAwtn(0).Childitem(arr(2,1),arr(2,2),"WebEdit",0).Set intTSA3
			objTSAwtn(0).Childitem(arr(3,1),arr(3,2),"WebEdit",0).Set intTSA4
			UtilFunction.WriteLog "Clicking Submit button"	
			Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("primarybutton-1237-btnInnerEl").Click
			strValmsg = Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("messagebox-1001-msg_13").GetROProperty("outertext")
			If strValmsg = "Adjustment saved successfully" Then
				UtilFunction.WriteLog strValmsg
				'UtilFunction.WriteStatus "pass", "TC009", "TSA Online", strValmsg
				TSAonlineTable = "Pass - TSAonline is successful"
				Reporter.ReportEvent micPass, "TSA Offline", strValmsg
				UtilFunction.WriteLog "Closing validation popup"
				Browser("Single Sign-On").Page("US Regulatory Reporting").Image("AMDAwAAAACH5BAEAAAAALAAAAAABAA_12").Click
				UtilFunction.WriteLog "PreTSAs: "&arr(0,0)&", "&arr(1,0)&", "&arr(2,0)&", "&arr(3,0)
			ElseIf strValmsg = "Adjustment is in pending state for same combination" Then
				UtilFunction.WriteLog strValmsg
				UtilFunction.WriteLog "FormName: "&formName&" Period: "&accountingPeriod
				TSAonlineTable = strValmsg
				UtilFunction.WriteLog "Closing validation popup"
				Browser("Single Sign-On").Page("US Regulatory Reporting").Image("AMDAwAAAACH5BAEAAAAALAAAAAABAA_12").Click
				UtilFunction.WriteLog "PreTSAs: "&arr(0,0)&", "&arr(1,0)&", "&arr(2,0)&", "&arr(3,0)
				Reporter.ReportEvent micDone, "TSA Offline", strValmsg
			Else
				Desktop.CaptureBitmap UtilFunction.ErrSreenShots&"/TSAonline-"&Replace(Replace(Replace(now(),"/","-"),":","-")," ","-")&".png", true
				UtilFunction.WriteLog strValmsg
				'UtilFunction.WriteStatus "fail", "TC009", "TSA Online", strValmsg
				Browser("Single Sign-On").Page("US Regulatory Reporting").Image("AMDAwAAAACH5BAEAAAAALAAAAAABAA_14").Click
				Reporter.ReportEvent micFail, "TSA Oline", strValmsg
				TSAonlineTable = strValmsg
			End If
		If Err <> 0 Then
			UtilFunction.WriteLog "TSAonlineTable - "&Err.description
			Reporter.ReportEvent micFail, "TSA Approvals Online", Err.description
			'TSAonlineTable = "TSAonlineTable - "&Err.description
		End If
End Function

Function TSAresVerifyonline(ByRef preTSA,ByRef postTSA,intTSA1,intTSA2,intTSA3,intTSA4)
	Dim FailFlag: FailFlag = 0
	UtilFunction.WriteLog "Started verifying results"
	If preTSA(0,0)+intTSA1 = postTSA(0,0) Then
		UtilFunction.WriteLog "1st TSA passed - Expected: "&preTSA(0,0)&" + "&intTSA1&" Actual: "&postTSA(0,0)
		Reporter.ReportEvent micPass, "TSAonline", "1st TSA failed - Expected: "&preTSA(0,0)&" + "&intTSA1&" Actual: "&postTSA(0,0)
	Else
		FailFlag = 1
		UtilFunction.WriteLog "1st TSA failed - Expected: "&preTSA(0,0)&" + "&intTSA1&" Actual: "&postTSA(0,0)
		Reporter.ReportEvent micFail, "TSAonline", "1st TSA failed - Expected: "&preTSA(0,0)&" + "&intTSA1&" Actual: "&postTSA(0,0)
	End If
	If preTSA(1,0)+intTSA2 = postTSA(1,0) Then
		UtilFunction.WriteLog "2nd TSA passed - Expected: "&preTSA(1,0)&" + "&intTSA2&" Actual: "&postTSA(1,0)
		Reporter.ReportEvent micPass, "TSAonline", "2nd TSA failed - Expected: "&preTSA(1,0)&" + "&intTSA2&" Actual: "&postTSA(1,0)
	Else
		FailFlag = 1
		UtilFunction.WriteLog "2nd TSA failed - Expected: "&preTSA(1,0)&" + "&intTSA2&" Actual: "&postTSA(1,0)
		Reporter.ReportEvent micFail, "TSAonline", "2nd TSA failed - Expected: "&preTSA(1,0)&" + "&intTSA2&" Actual: "&postTSA(1,0)
	End If
	If preTSA(2,0)+intTSA3 = postTSA(2,0) Then
		UtilFunction.WriteLog "3rd TSA passed - Expected: "&preTSA(2,0)&" + "&intTSA3&" Actual: "&postTSA(2,0)
		Reporter.ReportEvent micPass, "TSAonline", "3rd TSA failed - Expected: "&preTSA(2,0)&" + "&intTSA3&" Actual: "&postTSA(2,0)
	Else
		FailFlag = 1
		UtilFunction.WriteLog "3rd TSA failed - Expected: "&preTSA(2,0)&" + "&intTSA3&" Actual: "&postTSA(2,0)
		Reporter.ReportEvent micFail, "TSAonline", "3rd TSA failed - Expected: "&preTSA(2,0)&" + "&intTSA3&" Actual: "&postTSA(2,0)
	End If
	If preTSA(3,0)+intTSA4 = postTSA(3,0) Then
		UtilFunction.WriteLog "4th TSA passed - Expected: "&preTSA(3,0)&" + "&intTSA4&" Actual: "&postTSA(3,0)
		Reporter.ReportEvent micPass, "TSAonline", "4th TSA failed - Expected: "&preTSA(3,0)&" + "&intTSA4&" Actual: "&postTSA(3,0)
	Else
		FailFlag = 1
		UtilFunction.WriteLog "4th TSA failed - Expected: "&preTSA(3,0)&" + "&intTSA4&" Actual: "&postTSA(3,0)
		Reporter.ReportEvent micFail, "TSAonline", "4th TSA failed - Expected: "&preTSA(3,0)&" + "&intTSA4&" Actual: "&postTSA(3,0)
	End If
	If FailFlag = 1 Then
		TSAresVerifyonline = "TSA online is failed"
		UtilFunction.WriteStatus "Fail", "TC009", "One/All of TSA values are not matching, check for logs for more info"
	Else
		TSAresVerifyonline = "Pass - TSAonline is successful"
		UtilFunction.WriteStatus "Pass", "TC009", "TSAonline", "All TSA values are successful"
	End If
End Function

'############################ End of TSA online ####################################################################################
'#############################################################################################################
' Function/sub name	 : SupplementaryDataload(Supplementory data load)
' Description		 : System would provide the user with capability to manually upload files for report processing. The user would be provided with 
'						a simple screen UI for uploading of files. Supplementary data load is used when we want to insert any new records, update 
'						the existing records or delete the records of the table.
' Input arguments	 : functionalArea,formName,bussdate,reasoncode,strRootFolder,filename,intCalCounter,adminissueFlag,strUserName
' Output/return value: -
' Date of creation	 : 8/3/2018
' Developed by		 : Saurabh Sharma
'#############################################################################################################
Function SupplementaryDataload(functionalArea,formName,bussdate,reasoncode,strRootFolder,filename,intCalCounter,adminissueFlag,strUserName)
On Error Resume Next
'Setting("SnapshotReportMode") = 1
	Dim objWT, objWTName, defaultselect
	defaultselect = "0"
	Set objMClick = CreateObject("Wscript.Shell")
	Dim objFSO, objFileStream
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	'Set objFileStream = objFSO.OpenTextFile(FileLocation&"\SupplementaryDataloadStatus.txt", 8, True)
	Set objFileStream = objFSO.OpenTextFile(UtilFunction.detailedResults, 8, True)
	UtilFunction.WriteLog "**********************************************************************************************"
	UtilFunction.WriteLog "Executing the supplementarydataload for "&intCalCounter&" iteration"
	If intCalCounter = 1 Then
		objFileStream.WriteLine "S.No.	Form	Reasoncode	Filename	Bussiness Date	Status	Comments"
		UtilFunction.WriteLog "Opening left navigation pane"
'		Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("west-region-container-splitter").Click
		Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").Image("Navigation").Click
'		Browser("Single Sign-On").Page("US Regulatory Reporting").Image("AMDAwAAAACH5BAEAAAAALAAAAAABAA_2").Click
		UtilFunction.WriteLog "Clicking Supplementary Data Load"
		Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("Supplementary Data Load").Click
	End If
	If adminissueFlag = 1 Then
		UtilFunction.WriteLog "Opening left navigation pane"
'		Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("west-region-container-splitter").Click
		Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").Image("Navigation").Click
'		Browser("Single Sign-On").Page("US Regulatory Reporting").Image("AMDAwAAAACH5BAEAAAAALAAAAAABAA_2").Click
		UtilFunction.WriteLog "Clicking Supplementary Data Load"
		Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("Supplementary Data Load").Click
	End If

	UtilFunction.WriteLog "Closing left navigation page"
	Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").Image("navigationclose").Click

	UtilFunction.WriteLog "Selecting Functional area"
	Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("suppLoadfunctionalArea-trigger-pick").Click
	Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebList("boundlist-2114-listEl").Select functionalArea  '"CREDIT-RSK"
	wait(1)
	UtilFunction.WriteLog "Selected Functional area: "&Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebEdit("suppLoadfunctionalArea").GetROProperty("value")
	Dim selectedFArea
	selectedFArea = Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebEdit("suppLoadfunctionalArea").GetROProperty("value")
	
	If selectedFArea <> functionalArea Then
		objFileStream.WriteLine "S.No.	Form	Reasoncode	Filename	Bussiness Date	Status	Comments"
		objFileStream.WriteLine intCalCounter&"	"&formName&"	"&reasoncode&"	"&filename&"	"&bussdate&"	Fail	Functional Area is not present"
		Desktop.CaptureBitmap UtilFunction.ErrSreenShots&"/"&intCalCounter&"-Supplementary Dataload-"&Replace(Replace(Replace(now(),"/","-"),":","-")," ","-")&".png", true
		UtilFunction.WriteStatus "fail", "TC006", "Supplementary Dataload", "Functional Area is not present"
		SupplementaryDataload = "Failed - Supplementary dataload is not successful"
		Reporter.ReportEvent micFail, "Supplementary dataload", strValmsg		
		Exit Function	
	End If

	UtilFunction.WriteLog "Selecting Form/Source"
	Select Case functionalArea
		Case "CREDIT-RSK"
			Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("formNameLrr-trigger-picker").Click
			Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebList("boundlist-3817-CR").Select formName '"CGME_WTDA"
			wait(1)
			UtilFunction.WriteLog "Selected Form/Source: "&Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebEdit("formName").GetROProperty("value")
		Case "MARKET-RSK"
			Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("formNameLrr-trigger-picker").Click
			Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebList("boundlist-3817-MR").Select formName '"CGME_CRMR_SA"
			wait(1)
			UtilFunction.WriteLog "Selected Form/Source: "&Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebEdit("formName").GetROProperty("value")
		Case "OWN-FUNDS"
			Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("formNameLrr-trigger-picker").Click
			Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebList("boundlist-3135-OF").Select formName '"COREP_YTD_PNL"
			wait(1)
			UtilFunction.WriteLog "Selected Form/Source: "&Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebEdit("formName").GetROProperty("value")
		Case "LRG-EXPOS"
			Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("formNameLrr-trigger-picker").Click
			Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebList("boundlist-4499-LRG").Select formName '"CGME_CCB_RATES"
			wait(1)
			UtilFunction.WriteLog "Selected Form/Source: "&Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebEdit("formName").GetROProperty("value")
		Case else
			objFileStream.WriteLine "S.No.	Form	Reasoncode	Filename	Bussiness Date	Status	Comments"
			objFileStream.WriteLine intCalCounter&"	"&formName&"	"&reasoncode&"	"&filename&"	"&bussdate&"	Fail	FormName is not present"
			Desktop.CaptureBitmap UtilFunction.ErrSreenShots&"/"&intCalCounter&"-Supplementary Dataload-"&Replace(Replace(Replace(now(),"/","-"),":","-")," ","-")&".png", true
			UtilFunction.WriteStatus "fail", "TC006", "Supplementary Dataload", "Formname is not present"
			SupplementaryDataload = "Failed - Supplementary dataload is not successful"
			Reporter.ReportEvent micFail, "Supplementary dataload", strValmsg		
			Exit Function
	End Select
	
	Dim selectedform
	selectedform = Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebEdit("formName").GetROProperty("value")
	If selectedform <> formName Then
		objFileStream.WriteLine "S.No.	Form	Reasoncode	Filename	Bussiness Date	Status	Comments"
		objFileStream.WriteLine intCalCounter&"	"&formName&"	"&reasoncode&"	"&filename&"	"&bussdate&"	Fail	Form name is not present"
		Desktop.CaptureBitmap UtilFunction.ErrSreenShots&"/"&intCalCounter&"-Supplementary Dataload-"&Replace(Replace(Replace(now(),"/","-"),":","-")," ","-")&".png", true
		UtilFunction.WriteStatus "fail", "TC006", "Supplementary Dataload", "Form name is not present"
		SupplementaryDataload = "Failed - Supplementary dataload is not successful"
		Reporter.ReportEvent micFail, "Supplementary dataload", strValmsg		
		Exit Function
	End If

	UtilFunction.WriteLog "Selecting Reason Code"
	Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("suppDataLoaReasonCodeComboLrr-trigg").Click
	Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebList("boundlist-1439-ReasonCode").Select reasoncode '"Not Applicable"
	UtilFunction.WriteLog "Selected Reason code: "&Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebEdit("reasonCode").GetROProperty("value")
	wait(1)
	Dim selectedRcode
	selectedRcode = Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebEdit("reasonCode").GetROProperty("value")
	If selectedRcode <> reasoncode Then
		objFileStream.WriteLine "S.No.	Form	Reasoncode	Filename	Bussiness Date	Status	Comments"
		objFileStream.WriteLine intCalCounter&"	"&formName&"	"&reasoncode&"	"&filename&"	"&bussdate&"	Fail	Reason Code is not present"
		Desktop.CaptureBitmap UtilFunction.ErrSreenShots&"/"&intCalCounter&"-Supplementary Dataload-"&Replace(Replace(Replace(now(),"/","-"),":","-")," ","-")&".png", true
		UtilFunction.WriteStatus "fail", "TC006", "Supplementary Dataload", "Reason Code is not present"
		SupplementaryDataload = "Failed - Supplementary dataload is not successful"
		Reporter.ReportEvent micFail, "Supplementary dataload", strValmsg		
		Exit Function
	End If

	UtilFunction.WriteLog "Selecting Period"
	Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebEdit("period").Set bussdate '"10/31/2017"
	UtilFunction.WriteLog "Selected Bussiness Date: "&Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebEdit("period").GetROProperty("value")
	wait(1)

	UtilFunction.WriteLog "Clicking Select button"
	Dim objMClick
	Set objMClick = CreateObject("Wscript.Shell")
	objMClick.SendKeys"{TAB 3}",true
	objMClick.SendKeys"{ENTER}",true
	Set objMClick = Nothing
	wait(1)
	UtilFunction.WriteLog "Select button Clicked"
	
	Dim tempfpath
	tempfpath = strRootFolder&"\SupplementaryDataLoad\"&filename
	UtilFunction.WriteLog "Selecting File for Supplementary dataload"	
	Window("Google Chrome").Dialog("Open").Activate
	Window("Google Chrome").Dialog("Open").WinEdit("File name").Set tempfpath '"I:\Brexit\Automation\SupplementaryDataLoad\TRG_13_CGME_CCB_RATES_20171031_6774_VK16303.xlsx"
	wait(5)
	Window("Google Chrome").Dialog("Open").WinObject("Open").Click
	wait(10)
	UtilFunction.WriteLog "File is Selected for Supplementary dataload"
	'Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").Sync()

	UtilFunction.WriteLog "Clicking on Upload Button"		
	Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("suppUploadbuttonIdLrr").Click
	wait(5)
	UtilFunction.WriteLog "Upload Button Clicked"

	UtilFunction.WriteLog "Clicking on Cancel Button"
	'If Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("title-1097-textEl").Exist(5) Then
	If Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("messagebox-1001-msg_3").Exist(5) Then
		Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").Image("successclose").Click
		wait(5)
		
		UtilFunction.WriteLog "Selecting Uploaded User"
		Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebEdit("textfield-UploadedBy").Set strUserName '"SS16890"
		UtilFunction.WriteLog "Uploaded User is Selected"
	
		UtilFunction.WriteLog "Sorting reports based on Uploaded At Column"	
		Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("gridcolumn-UploadedAt").Click
		wait(1)
		Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("gridcolumn-UploadedAt").Click
		wait(1)
		UtilFunction.WriteLog "Reports sorted based on Uploaded At Column"	
	
		UtilFunction.WriteLog "Selecting the Report"		
		If Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("WebElement").Exist(5) Then
			wait(1)
			UtilFunction.WriteLog "Report is Selected"
			Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("WebElement").Click
			UtilFunction.WriteLog "Supplementary File is loaded: "&strExcelName
			UtilFunction.WriteStatus "pass", "TC006", "Supplementary Dataload", "Supplementary Dataload is successful"
			objFileStream.WriteLine intCalCounter&"	"&selectedform&"	"&selectedRcode&"	"&filename&"	"&bussdate&"	Pass	Supplementary Dataload is successful"
			SupplementaryDataload = "Pass - Supplementary Dataload is successful"
		Else
			Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").Image("successclose").Click
			UtilFunction.WriteLog "Cancel Button Clicked"
			objFileStream.WriteLine "S.No.	Form	Reasoncode	Filename	Bussiness Date	Status	Comments"
			objFileStream.WriteLine intCalCounter&"	"&formName&"	"&reasoncode&"	"&filename&"	"&bussdate&"	Fail	File upload success popup is not present"
			Desktop.CaptureBitmap UtilFunction.ErrSreenShots&"/"&intCalCounter&"-Supplementary Dataload-"&Replace(Replace(Replace(now(),"/","-"),":","-")," ","-")&".png", true
			UtilFunction.WriteStatus "fail", "TC006", "Supplementary Dataload", "File upload success popup is not present"
			SupplementaryDataload = "Failed - Supplementary dataload is not successful"
			Reporter.ReportEvent micFail, "Supplementary dataload", strValmsg		
			Exit Function
		End If
	Else
		Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").Image("successclose").Click
		UtilFunction.WriteLog "Cancel Button Clicked"
		objFileStream.WriteLine "S.No.	Form	Reasoncode	Filename	Bussiness Date	Status	Comments"
		objFileStream.WriteLine intCalCounter&"	"&formName&"	"&reasoncode&"	"&filename&"	"&bussdate&"	Fail	File upload success popup is not present"
		Desktop.CaptureBitmap UtilFunction.ErrSreenShots&"/"&intCalCounter&"-Supplementary Dataload-"&Replace(Replace(Replace(now(),"/","-"),":","-")," ","-")&".png", true
		UtilFunction.WriteStatus "fail", "TC006", "Supplementary Dataload", "File upload success popup is not present"
		SupplementaryDataload = "Failed - Supplementary dataload is not successful"
		Reporter.ReportEvent micFail, "Supplementary dataload", strValmsg		
		Exit Function
	End If
	Set objFileStream = Nothing
	Set objFSO = Nothing
End Function
'#############################################################################################################
'#############################################################################################################
' Function/sub name	 : FileApproveReject(Supplementory data load)
' Description		 : Function used to Approve or Reject the updated files.
' Input arguments	 : functionalArea,formName,bussdate,reasoncode,filename,approverflag,approvercomments,intCalCounter,adminissueFlag,strUserName(2) (Approver Name)
' Output/return value: -
' Date of creation	 : 8/5/2018
' Developed by		 : Saurabh Sharma
'#############################################################################################################
	Function FileApproveReject(functionalArea,formName,bussdate,reasoncode,filename,approverflag,approvercomments,intCalCounter,adminissueFlag,strUserName)
On Error Resume Next
'Setting("SnapshotReportMode") = 1
	Dim objWT, objWTName, defaultselect
	defaultselect = "0"
	Set objMClick = CreateObject("Wscript.Shell")
	Dim objFSO, objFileStream
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	'Set objFileStream = objFSO.OpenTextFile(FileLocation&"\FileApproveRejectStatus.txt", 8, True)
	Set objFileStream = objFSO.OpenTextFile(UtilFunction.detailedResults, 8, True)
	UtilFunction.WriteLog "**********************************************************************************************"
	UtilFunction.WriteLog "Executing the FileApproveReject for "&intCalCounter&" iteration"
	If intCalCounter = 1 Then
		'objFileStream.WriteLine "S.No.	Form	Reasoncode	Filename	Bussiness Date	Status	Comments"
		UtilFunction.WriteLog "Opening left navigation pane"
		Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("west-region-container-splitter").Click
		UtilFunction.WriteLog "Clicking Supplementary Data Load"
		Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("Supplementary Data Load").Click
	End If
	If adminissueFlag = 1 Then
		UtilFunction.WriteLog "Opening left navigation pane"
		Browser("Single Sign-On").Page("US Regulatory Reporting").WebElement("west-region-container-splitter").Click
		UtilFunction.WriteLog "Clicking Supplementary Data Load"
		Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("Supplementary Data Load").Click
	End If

	UtilFunction.WriteLog "Closing left navigation page"
	Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").Image("navigationclose").Click

	UtilFunction.WriteLog "Selecting Functional area"
	Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("suppLoadfunctionalArea-trigger-pick").Click
	Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebList("boundlist-2114-listEl").Select functionalArea  '"CREDIT-RSK"
	wait(1)
	UtilFunction.WriteLog "Selected Functional area: "&Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebEdit("suppLoadfunctionalArea").GetROProperty("value")
	Dim selectedFArea
	selectedFArea = Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebEdit("suppLoadfunctionalArea").GetROProperty("value")
	
	If selectedFArea <> functionalArea Then
		'objFileStream.WriteLine "S.No.	Form	Reasoncode	Filename	Bussiness Date	Status	Comments"
		objFileStream.WriteLine intCalCounter&"	"&formName&"	"&reasoncode&"	"&filename&"	"&bussdate&"	Fail	n/a	Functional Area is not present"
		Desktop.CaptureBitmap UtilFunction.ErrSreenShots&"/"&intCalCounter&"-Supplementary Dataload-"&Replace(Replace(Replace(now(),"/","-"),":","-")," ","-")&".png", true
		UtilFunction.WriteStatus "fail", "TC006", "Supplementary Dataload", "Functional Area is not present"
		FileApproveReject = "Failed - File Approval is not successful"
		Reporter.ReportEvent micFail, "Supplementary dataload", strValmsg		
		Exit Function	
	End If

	UtilFunction.WriteLog "Selecting Form/Source"
	Select Case functionalArea
		Case "CREDIT-RSK"
			Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("formNameLrr-trigger-picker").Click
			Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebList("boundlist-3817-CR").Select formName '"CGME_WTDA"
			wait(1)
			UtilFunction.WriteLog "Selected Form/Source: "&Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebEdit("formName").GetROProperty("value")
		Case "MARKET-RSK"
			Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("formNameLrr-trigger-picker").Click
			Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebList("boundlist-3817-MR").Select formName '"CGME_CRMR_SA"
			wait(1)
			UtilFunction.WriteLog "Selected Form/Source: "&Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebEdit("formName").GetROProperty("value")
		Case "OWN-FUNDS"
			Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("formNameLrr-trigger-picker").Click
			Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebList("boundlist-3135-OF").Select formName '"COREP_YTD_PNL"
			wait(1)
			UtilFunction.WriteLog "Selected Form/Source: "&Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebEdit("formName").GetROProperty("value")
		Case "LRG-EXPOS"
			Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("formNameLrr-trigger-picker").Click
			Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebList("boundlist-4499-LRG").Select formName '"CGME_CCB_RATES"
			wait(1)
			UtilFunction.WriteLog "Selected Form/Source: "&Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebEdit("formName").GetROProperty("value")
		Case else
			'objFileStream.WriteLine "S.No.	Form	Reasoncode	Filename	Bussiness Date	Status	Comments"
			objFileStream.WriteLine intCalCounter&"	"&formName&"	"&reasoncode&"	"&filename&"	"&bussdate&"	Fail	n/a	FormName is not present"
			Desktop.CaptureBitmap UtilFunction.ErrSreenShots&"/"&intCalCounter&"-Supplementary Dataload-"&Replace(Replace(Replace(now(),"/","-"),":","-")," ","-")&".png", true
			UtilFunction.WriteStatus "fail", "TC006", "Supplementary Dataload", "Formname is not present"
			FileApproveReject = "Failed - File Approval is not successful"
			Reporter.ReportEvent micFail, "Supplementary dataload", strValmsg		
			Exit Function
	End Select
	
	Dim selectedform
	selectedform = Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebEdit("formName").GetROProperty("value")
	If selectedform <> formName Then
		objFileStream.WriteLine "S.No.	Form	Reasoncode	Filename	Bussiness Date	Status	Comments"
		objFileStream.WriteLine intCalCounter&"	"&formName&"	"&reasoncode&"	"&filename&"	"&bussdate&"	Fail	n/a	Form name is not present"
		Desktop.CaptureBitmap UtilFunction.ErrSreenShots&"/"&intCalCounter&"-Supplementary Dataload-"&Replace(Replace(Replace(now(),"/","-"),":","-")," ","-")&".png", true
		UtilFunction.WriteStatus "fail", "TC006", "Supplementary Dataload", "Form name is not present"
		FileApproveReject = "Failed - File Approval is not successful"
		Reporter.ReportEvent micFail, "Supplementary dataload", strValmsg		
		Exit Function
	End If

	UtilFunction.WriteLog "Selecting Uploaded User"
	Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebEdit("textfield-UploadedBy").Set strUserName '"SS16890"
	Dim selecteduploadeduser
	selecteduploadeduser = Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebEdit("textfield-UploadedBy").GetROProperty("value")
	If selecteduploadeduser <> strUserName Then
		'objFileStream.WriteLine "S.No.	Form	Reasoncode	Filename	Bussiness Date	Status	Comments"
		objFileStream.WriteLine intCalCounter&"	"&formName&"	"&reasoncode&"	"&filename&"	"&bussdate&"	Fail	n/a	Uploaded user is not present"
		Desktop.CaptureBitmap UtilFunction.ErrSreenShots&"/"&intCalCounter&"-Supplementary Dataload-"&Replace(Replace(Replace(now(),"/","-"),":","-")," ","-")&".png", true
		UtilFunction.WriteStatus "fail", "TC006", "Supplementary Dataload", "Uploaded user is not present"
		FileApproveReject = "Failed - File Approval is not successful"
		Reporter.ReportEvent micFail, "Supplementary dataload", strValmsg		
		Exit Function
	End If
	UtilFunction.WriteLog "Uploaded User is Selected"

	UtilFunction.WriteLog "Sorting reports based on Uploaded At Column"	
	Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("gridcolumn-UploadedAt").Click
	wait(1)
	Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("gridcolumn-UploadedAt").Click
	wait(1)
	UtilFunction.WriteLog "Reports sorted based on Uploaded At Column"	

	UtilFunction.WriteLog "Selecting the Report"		
	Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("WebElement").Click
	wait(1)
	UtilFunction.WriteLog "Report is Selected"	
	Dim enteredcomments	
	Dim flag
	Dim fstatus
	flag = 0
	
	If approverflag = "Y" Then
		UtilFunction.WriteLog "Clicking on Approve Image"
		'Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").Image("img_trans").Click
		Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").Image("Approve").Click
		wait(1)
		UtilFunction.WriteLog "Approve Image is clicked"

		UtilFunction.WriteLog "Entering Approver Comments"
		Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebEdit("remPopUpTxtArea-Approve").Set approvercomments '"QA Testing"
		wait(1)
		'Dim enteredcomments
		enteredcomments = Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebEdit("remPopUpTxtArea-Approve").GetROProperty("value")
		If enteredcomments <> approvercomments Then
			'objFileStream.WriteLine "S.No.	Form	Reasoncode	Filename	Bussiness Date	Status	Comments"
			objFileStream.WriteLine intCalCounter&"	"&formName&"	"&reasoncode&"	"&filename&"	"&bussdate&"	Fail	n/a	Approver Comments not present"
			Desktop.CaptureBitmap UtilFunction.ErrSreenShots&"/"&intCalCounter&"-Supplementary Dataload-"&Replace(Replace(Replace(now(),"/","-"),":","-")," ","-")&".png", true
			UtilFunction.WriteStatus "fail", "TC006", "Supplementary Dataload", "Approver Comments not present"
			FileApproveReject = "Failed - File Approval is not successful"
			Reporter.ReportEvent micFail, "Supplementary dataload", strValmsg		
			Exit Function
		End If
		UtilFunction.WriteLog "Approver Comments Entered"

		UtilFunction.WriteLog "Click Submit Button"
		Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("btnApproveWindowSubmit").Click
		UtilFunction.WriteLog "Submit Button Clicked"
		
		UtilFunction.WriteLog "Checking Approval process initiated"
		If Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("messagebox-1001-msg").Exist(5) Then
			UtilFunction.WriteLog "Clicking Ok Button"
			Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("button-1005-btnEl").Click
			UtilFunction.WriteLog "Ok Button Clicked"
				flag = 0
'				Set odesc = Description.Create()
'				odesc("micclass").value="Image"
'				Set r_image = Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebTable("PR").ChildObjects(odesc)
'					For i = 0 to r_image.count-1
'						r_class = r_image(i).GetROProperty("class")
'						If r_class ="imgacceptnoaction" Then
'							flag = 1
'						End If
'					Next
'				Dim fstatus
				fstatus = "Approved"
				'fstatus = "Pending Processing"
				'fstatus = "Rejected"
				UtilFunction.WriteLog "Selecting Status"
				Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("combobox-1404-trigger-picker").Click
				Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebList("boundlist-1437-listEl").Select fstatus
				wait(2)
				UtilFunction.WriteLog fstatus&" Status Selected"
				If Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("WebElement").Exist(5) Then
					wait(1)
					UtilFunction.WriteLog "Report is Selected"
					Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("WebElement").Click
					flag = 1
				End If
				
				If flag = 1 Then
					UtilFunction.WriteLog "File Approval is successful: "&filename
					UtilFunction.WriteStatus "pass", "TC006", "Supplementary Dataload", "File is Approved"
					objFileStream.WriteLine intCalCounter&"	"&selectedform&"	"&selectedRcode&"	"&filename&"	"&bussdate&"	Pass	File Approval is successful"
					FileApproveReject = "Pass - File Approval is successful"
				Else
					'objFileStream.WriteLine "S.No.	Form	Reasoncode	Filename	Bussiness Date	Status	Comments"
					objFileStream.WriteLine intCalCounter&"	"&formName&"	"&reasoncode&"	"&filename&"	"&bussdate&"	Fail	n/a	Approved Element is not present"
					Desktop.CaptureBitmap UtilFunction.ErrSreenShots&"/"&intCalCounter&"-Supplementary Dataload-"&Replace(Replace(Replace(now(),"/","-"),":","-")," ","-")&".png", true
					UtilFunction.WriteStatus "fail", "TC006", "Supplementary Dataload", "Approved Element is not present"
					FileApproveReject = "Failed - File Approval is not successful"
					Reporter.ReportEvent micFail, "Supplementary dataload", strValmsg		
					Exit Function	
				End If	
		Else
			'objFileStream.WriteLine "S.No.	Form	Reasoncode	Filename	Bussiness Date	Status	Comments"
			objFileStream.WriteLine intCalCounter&"	"&formName&"	"&reasoncode&"	"&filename&"	"&bussdate&"	Fail	n/a	Approval process initiated popup not present"
			Desktop.CaptureBitmap UtilFunction.ErrSreenShots&"/"&intCalCounter&"-Supplementary Dataload-"&Replace(Replace(Replace(now(),"/","-"),":","-")," ","-")&".png", true
			UtilFunction.WriteStatus "fail", "TC006", "Supplementary Dataload", "Approval process initiated popup not present"
			FileApproveReject = "Failed - File Approval is not successful"
			Reporter.ReportEvent micFail, "Supplementary dataload", strValmsg		
			Exit Function	
		End If
	Else
		UtilFunction.WriteLog "Clicking on Reject Image"
		'Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").Image("img_trans_2").Click
		Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").Image("Reject").Click
		wait(1)
		UtilFunction.WriteLog "Reject Image is clicked"

		UtilFunction.WriteLog "Entering Approver Comments"
		Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebEdit("remPopUpTxtArea-Reject").Set approvercomments '"QA Testing"
		wait(1)
		'Dim enteredcomments
		enteredcomments = Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebEdit("remPopUpTxtArea-Reject").GetROProperty("value")
		If enteredcomments <> approvercomments Then
			'objFileStream.WriteLine "S.No.	Form	Reasoncode	Filename	Bussiness Date	Status	Comments"
			objFileStream.WriteLine intCalCounter&"	"&formName&"	"&reasoncode&"	"&filename&"	"&bussdate&"	Fail	n/a	Approver Comments not present"
			Desktop.CaptureBitmap UtilFunction.ErrSreenShots&"/"&intCalCounter&"-Supplementary Dataload-"&Replace(Replace(Replace(now(),"/","-"),":","-")," ","-")&".png", true
			UtilFunction.WriteStatus "fail", "TC006", "Supplementary Dataload", "Approver Comments not present"
			FileApproveReject = "Failed - File Rejection is not successful"
			Reporter.ReportEvent micFail, "Supplementary dataload", strValmsg		
			Exit Function
		End If
		UtilFunction.WriteLog "Approver Comments Entered"

		UtilFunction.WriteLog "Click Submit Button"
		Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("btnrejectWindowSubmit").Click
		UtilFunction.WriteLog "Submit Button Clicked"
		
		UtilFunction.WriteLog "Checking Rejection process initiated"
		If Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("messagebox-1001-msg_2").Exist(5) Then
			UtilFunction.WriteLog "Clicking Yes Button"
			Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("button-1006-btnEl").Click
			UtilFunction.WriteLog "Yes Button Clicked"
				flag = 0
'				Set odesc = Description.Create()
'				odesc("micclass").value="Image"
'				Set r_image = Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebTable("PR").ChildObjects(odesc)
'					For i = 0 to r_image.count-1
'						r_class = r_image(i).GetROProperty("class")
'						If r_class ="imgrejectnoaction" Then
'							flag = 1
'						End If
'					Next
'				Dim fstatus
				'fstatus = "Approved"
				'fstatus = "Pending Processing"
				fstatus = "Rejected"
				UtilFunction.WriteLog "Selecting Status"
				Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("combobox-1404-trigger-picker").Click
				Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebList("boundlist-1437-listEl").Select fstatus
				wait(2)
				UtilFunction.WriteLog fstatus&" Status Selected"
				If Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("WebElement").Exist(5) Then
					wait(1)
					UtilFunction.WriteLog "Report is Selected"
					Browser("Local Regulatory Reporting").Page("Local Regulatory Reporting").WebElement("WebElement").Click
					flag = 1
				End If
				If flag = 1 Then
					UtilFunction.WriteLog "File Rejection is successful: "&filename
					UtilFunction.WriteStatus "pass", "TC006", "Supplementary Dataload", "File is Rejected"
					objFileStream.WriteLine intCalCounter&"	"&selectedform&"	"&selectedRcode&"	"&filename&"	"&bussdate&"	Pass	File Rejection is successful"
					FileApproveReject = "Pass - File Rejection is successful"
				Else
					'objFileStream.WriteLine "S.No.	Form	Reasoncode	Filename	Bussiness Date	Status	Comments"
					objFileStream.WriteLine intCalCounter&"	"&formName&"	"&reasoncode&"	"&filename&"	"&bussdate&"	Fail	n/a	Rejected Element is not present"
					Desktop.CaptureBitmap UtilFunction.ErrSreenShots&"/"&intCalCounter&"-Supplementary Dataload-"&Replace(Replace(Replace(now(),"/","-"),":","-")," ","-")&".png", true
					UtilFunction.WriteStatus "fail", "TC006", "Supplementary Dataload", "Rejected Element is not present"
					FileApproveReject = "Failed - File rejection is not successful"
					Reporter.ReportEvent micFail, "Supplementary dataload", strValmsg		
					Exit Function	
				End If	
		Else
			'objFileStream.WriteLine "S.No.	Form	Reasoncode	Filename	Bussiness Date	Status	Comments"
			objFileStream.WriteLine intCalCounter&"	"&formName&"	"&reasoncode&"	"&filename&"	"&bussdate&"	Fail	n/a	Rejection process initiated popup not present"
			Desktop.CaptureBitmap UtilFunction.ErrSreenShots&"/"&intCalCounter&"-Supplementary Dataload-"&Replace(Replace(Replace(now(),"/","-"),":","-")," ","-")&".png", true
			UtilFunction.WriteStatus "fail", "TC006", "Supplementary Dataload", "Rejection process initiated popup not present"
			FileApproveReject = "Failed - File Rejection is not successful"
			Reporter.ReportEvent micFail, "Supplementary dataload", strValmsg		
			Exit Function	
		End If		
		
	End If

	Set objFileStream = Nothing
	Set objFSO = Nothing
End Function

'############################### End of SupplementaryDataload ##############################################################################
