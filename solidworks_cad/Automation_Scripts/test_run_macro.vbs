Option Explicit
Dim swApp, res, errCode, macroPath

Set swApp = CreateObject("SldWorks.Application")
macroPath = "C:\Program Files\SOLIDWORKS Corp\SOLIDWORKS\sldBenchmarking\Macro\testmacro.swp"
errCode = CLng(0)
res = swApp.RunMacro2(macroPath, "testmacro1", "main", 1, errCode)
WScript.Echo "RunMacro2 res: " & res & ", err: " & errCode
