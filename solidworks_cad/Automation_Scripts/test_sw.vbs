Dim swApp, model, sel
Set swApp = CreateObject("SldWorks.Application")
swApp.Visible = True

Set model = swApp.NewDocument("C:\ProgramData\SOLIDWORKS\SOLIDWORKS 2026\templates\Part.PRTDOT", 0, 0, 0)
If Not model Is Nothing Then
    sel = model.Extension.SelectByID2("Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0)
    WScript.Echo "Front Plane selection status: " & sel
    swApp.CloseDoc ""
End If
