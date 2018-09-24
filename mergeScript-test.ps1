#To use this script, use mergescript.ps1 <Projectname> <GitRepoURL> <VersionToTag i.e., v1.2.3> <optional HotfixBranch hot123 if no input provided will take default remote branch> 

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
    Write-Host "No Hotfix branch passed as an argument, Next Action to merge Release branch to Master" -ForegroundColor Blue
} else {
    $branch = $hbranch
    Write-Host "Thanks for providing the Hostfix Branch "$hbranch", Next Action to merge Hostfix branch to Master" -ForegroundColor Blue
}

#--------------------------Main Program begins------------------------------------------------

#Check to see if the Project folder is available on the local machine
If(Test-Path C:\Users\sharan1\$ProjectName) {
    Write-Host "Powerspeak_terraform repo already exists. Pulling latest changes from remote " -ForegroundColor Green
    Set-Location -Path C:\Users\sharan1\$ProjectName
    git pull 2>$null                    #local repository is updated using git Pull

} else {
    Set-Location -Path C:\Users\sharan1\
    Write-Host "Powerspeak_terraform repo doesn't already exists. Cloning it" -ForegroundColor Green
    git clone $RURL 2>$null       #local repository is created using git clone

}

#merge and tag release to master branch
    git checkout master 2>$null                 #checkout to master branch
    git merge $branch 2>$null                   #Merge release/hotfix to master branch
    $commitID = git log --format="%H" -n 1      #get the most-recent/last commit ID as variable for tagging
    git tag -a v$tagv -m "$commitID"           #tagging latest commit in master with version
#   git branch -d $branch                       #delete release/hotfix
    
#merging master branch into develop branch
    git checkout develop 2>$null                #checkout to develop branch
    git merge master                            #merge master to develop branch
    Write-Host('Successfully Merged Master Branch with Developer branch') -ForegroundColor Yellow

#Update the remote repository by git push
#   git push master origin                      #push changes with only master branch to remote repository
    git push origin --all                       #push all branches to remote repository
    git push origin --tags                      #push all tags to remote repository

Write-Host('Remote Repository updated. Task accomplished') -ForegroundColor Green
