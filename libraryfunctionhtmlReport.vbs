'##############################################################################################
' File name			: Class object to handle HTML reports
' Description			: It handles html reports
' Functions it contains		: 
' Date of creation		: 30th May 2017
' Developed by			: Santhosh Reddy
'##############################################################################################
Option Explicit

Dim htmlreport
	Dim objFSO, objHD, objDts
	
	Function htmlReport1(htmlfilepath, ReportName, ChartImgpath)'it should be called once test is done
		Set objFSO = CreateObject("Scripting.FilesystemObject")
		Set objHD = objFSO.OpenTextFile(htmlfilepath,8,true)
		objHD.WriteLine "<html><title>Test Report "&ReportName&"</title><body><h3>Test Results for "&ReportName&" run</h3><table><tr><td>"&_
						"<img src="""&ChartImgpath&""" width=550, height=350></td><td><table border=2><tr>"&_
						"<th>Country</th><th>Passed</th><th>Failed</th><th>Skipped</th><th>Total</th></tr>"
		objHD.Close
		Set objFSO = Nothing
	End Function

	Function htmlReport2(htmlfilepath,Country,Passed,Failed,skipped,total)'It should be called for every country once module loop is done
		Set objFSO = CreateObject("Scripting.FilesystemObject")
		Set objHD = objFSO.OpenTextFile(htmlfilepath,8,true)
		objHD.WriteLine "<tr><td><a href=""#"&Country&"Pass"">"&Country&"</a></td>"&_
						"<td><a href=""#"&Country&"Pass"">"&Passed&"</a></td>"&_
						"<td><a href=""#"&Country&"Fail"">"&Failed&"</a></td>"&_
						"<td><a href=""#"&Country&"Skip"">"&Skipped&"</a></td>"&_
						"<td>"&Total&"</td></tr>"
		objHD.Close
		Set objFSO = Nothing
	End Function

	Function htmlReport3(htmlfilepath,Country,statusflag)'It should be called for every country before module loop
		Set objFSO = CreateObject("Scripting.FilesystemObject")
		If statusflag = "Pass" Then
			Set objHD = objFSO.OpenTextFile(htmlfilepath,8,true)
			objHD.WriteLine "<table border=1><tr><h4 id="""&Country&"Pass"">&nbsp&nbsp&nbsp "&Country&" - Passed Test cases</h4></tr>"&_
							"<tr><th>Test case ID#</th>"&_
							"<th>Test case Name</th>"&_
							"<th>Results</th>"&_
							"<th>Remarks</th></tr>"
		Else
			
			Set objHD = objFSO.OpenTextFile(htmlfilepath,8,true)
			objHD.WriteLine "</table><br><table border=1><tr><h4 id="""&Country&"Fail"">&nbsp&nbsp&nbsp "&Country&" - Failed Test cases</h4></tr>"&_
							"<tr><th>Test case ID#</th>"&_
							"<th>Test case Name</th>"&_
							"<th>Results</th>"&_
							"<th>Remarks</th></tr>"
			
		End If
		
		objHD.Close
		Set objFSO = Nothing
	End Function

	Function htmlReport4(htmlfilepath,TestCaseid,TestcaseName,Results,Remarks)'it should be called for every test case results
		Set objFSO = CreateObject("Scripting.FilesystemObject")
		
		If Results = "Pass" Then
			Set objHD = objFSO.OpenTextFile(htmlfilepath,8,true)
			objHD.WriteLine "<tr><td>"&TestCaseid&"</td><td>"&TestcaseName&"</td><td bgcolor=""green"">Pass</td><td>"&Remarks&"</td></tr>"
		Else
			Set objHD = objFSO.OpenTextFile(htmlfilepath,8,true)
			objHD.WriteLine "<tr><td>"&TestCaseid&"</td><td>"&TestcaseName&"</td><td bgcolor=""red"">Fail</td><td>"&Remarks&"</td></tr>"
			
		End If
		objHD.Close
		Set objFSO = Nothing
	End Function

	Function ConsolidateDetailReport(htmlfilea, htmlfileb)
		Dim objhtmlfilea, objhtmlfileb
		Set objFSO = CreateObject("Scripting.FilesystemObject")
		Set objhtmlfilea = objFSO.OpenTextFile(htmlfilea,8,true)
		Set objhtmlfileb = objFSO.OpenTextFile(htmlfileb)
		If Not objhtmlfileb.AtEndOfStream Then
			objhtmlfilea.Write objhtmlfileb.ReadAll
		End If
		objhtmlfilea.Close
		objhtmlfileb.Close
		Set objFSO = Nothing
	End Function

	Function htmlConsolidate(htmlfile,html1,html2,html3)
		Dim objhtmlfile, objhtmlfile1,objhtmlfile2,objhtmlfile3a
		Set objFSO = CreateObject("Scripting.FilesystemObject")
		Set objhtmlfile = objFSO.OpenTextFile(htmlfile,8,true)
		Set objhtmlfile1 = objFSO.OpenTextFile(html1,1)
		Set objhtmlfile2 = objFSO.OpenTextFile(html2,1)
		Set objhtmlfile3a = objFSO.OpenTextFile(html3,1)
			
		'If Not objhtmlfile1.AtEndOfStream Then
			objhtmlfile.Write objhtmlfile1.ReadAll
		'End If
		
		'If Not objhtmlfile2.AtEndOfStream Then
			objhtmlfile.Write objhtmlfile2.ReadAll
		'End If
		
		objhtmlfile.WriteLine "</table></td></tr></table><br><br><div><h3> Detailed Test status</h3></div>"
		'If objhtmlfile3a.AtEndOfStream Then
			objhtmlfile.Write objhtmlfile3a.ReadAll
		'End If
		
		objhtmlfile.WriteLine "</table></body><html>"
		
		objhtmlfile.Close
		objhtmlfile1.Close
		objhtmlfile3a.Close
	
		Set objFSO = Nothing
	End Function

	Function CreateExcelChart(intpass,intfail,intskip,strexcelpath, strsaveaspath)
		On Error Resume Next
		Dim objExl, objWrBk, objWrkSt
		Set objExl = CreateObject("Excel.Application")
		Set objWrBk = objExl.Workbooks.Open(strexcelpath)
		Set objWrkSt = objWrBk.Worksheets("Sheet1")
		objWrkSt.Cells(3,2) = intpass
		objWrkSt.Cells(4,2) = intfail
		objWrkSt.Cells(5,2) = intskip
		objWrBk.SaveAs strsaveaspath
		objWrBk.Close
		objExl.Quit
		Set objWrkSt = Nothing
		Set objWrBk = Nothing
		Set objExl = Nothing
	End Function

	Function RunMacro(strResExcel, strMacroname)
		On Error Resume Next
		Dim objExl, objWrBk, objWrkSt
		Set objExl = CreateObject("Excel.Application")
		Set objWrBk = objExl.Workbooks.Open(strResExcel)
		objExl.Run strMacroname
		objWrBk.Close
		objExl.Quit
		Set objWrBk = Nothing
		Set objExl = Nothing
	End Function
