# windows-devbox
Boxstarter scripts to setup windows


From a Admin powershell:

```powershell
. { iwr -useb http://boxstarter.org/bootstrapper.ps1 } | iex; get-boxstarter -Force
Install-BoxstarterPackage -PackageName https://raw.githubusercontent.com/bltavares/windows-devbox/master/install.ps1 -DisableReboots
```


Powershell setup:


```powershell
cat "Set-PSReadlineOption -EditMode Emacs" > $profile
cat "Set-PSReadlineOption -EditMode Emacs" > "$ENV:CMDER_ROOT\config\profile.d\config.ps1"
```
