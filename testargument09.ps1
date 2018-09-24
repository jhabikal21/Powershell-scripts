Param(
	[Parameter(Position = 0, Mandatory = $true)]
	[String]
	$ProjectName,

    [Parameter(Position = 1, Mandatory = $true)]
	[String]
	$RURL,

    [Parameter(Position = 2, Mandatory = $true)]
	[String]
	$tagv,

    [Parameter(Position = 3, Mandatory = $false)]
	[String]
	$hbranch
)

If (!$hbranch) {
    $branch = 'release'
    Write-Host "No Hotfix branch passed as an argument, Next Action to merge Release branch to Master"    
} else {
    $branch = $hbranch
    Write-Host "Thanks for providing the Hostfix Branch "$hbranch", Next Action to merge Hostfix branch to Master"    
}

#--------------------------Main Program begins------------------------------------------------

#Check to see if the Project folder is available on the local machine
If(Test-Path C:\Users\bjha\$ProjectName) {
    Write-Host "Powerspeak_terraform repo already exists. Pulling latest changes from remote " -ForegroundColor Green
    Set-Location -Path C:\Users\bjha\$ProjectName
    git pull 2>$null                                                                #local repository is updated using git pull

} else {
    Set-Location -Path C:\Users\bjha\
    Write-Host "Powerspeak_terraform repo doesn't already exists. Cloning it" -ForegroundColor Green
    git clone $RURL 2>$null       #local repository is created using git clone

}

# Moving inside powerspeak_terraform Directory
cd C:\Users\bjha\$ProjectName

#merge and tag release to master branch
git checkout master 2>$null                 #checkout to master branch
git merge $branch 2>$null                   #Merge release/hotfix to master branch
$commitID = git log --format="%H" -n 1      #get the most-recent/last commit ID as variable for tagging
git tag -a v$tagv -m "$commitID"           #tagging latest commit in master with version

#merging master branch into develop branch
git checkout develop 2>$null                #checkout to develop branch
git merge master                            #merge master to develop branch

#Update the remote repository by git push
#   git push master origin                      #push changes with only master branch to remote repository
git push origin --all                       #push all branches to remote repository
git push origin --tags                      #push all tags to remote repository

Write-Host('Master Branch Merged with Developer branch. Remote Repository updated. Task accomplished')


