# windows-devbox
Boxstarter scripts to setup windows


From a Admin powershell:

```powershell
. { iwr -useb http://boxstarter.org/bootstrapper.ps1 } | iex; get-boxstarter -Force
Install-BoxstarterPackage -PackageName https://raw.githubusercontent.com/bltavares/windows-devbox/master/install.ps1 -DisableReboots
```
