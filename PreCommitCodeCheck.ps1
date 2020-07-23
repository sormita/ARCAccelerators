
$folderLocation="C:\Users\SormitaChakraborty\source\repos\arcGitOpsRepo\cluster-apps\"

Get-ChildItem $folderLocation -Filter *.yaml | 
Foreach-Object {
    $content = Get-Content $_.FullName
    $fileLocation=$_.FullName

    if(Get-Content $fileLocation | Where-Object { $_.Contains("image") })
    {
     if(Get-Content $fileLocation | Where-Object { $_.Contains("limits:") })
     {
      #write-host "Limits present in " + $_.FullName      
     }
     else
     {     
      write-host "Limits missing in " + $_.FullName
      exit 1              
     }
    }    
    
}
exit 0




