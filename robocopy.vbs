sBatFile = "e:\trashes\robocopy.bat"
 
Set oShell = CreateObject("WScript.Shell")
Set oFSO = CreateObject("Scripting.FileSystemObject")
 
If Not oFSO.FileExists(sBatFile) Then
    MsgBox "Could not find batch file, make sure the path is correct. Closing Script!", _
       vbCritical + vbSystemModal, "Text search"
    WScript.Quit
End If
 
sBatFileShort = oFSO.GetFile(sBatFile).ShortPath
oShell.Run sBatFileShort, 0, True
 
Set oShell = nothing
Set oFSO = nothing
