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
    Write-Host "Powerspeak_terraform repo already exists. Pulling latest changes from remote" -ForegroundColor Green
    Set-Location -Path C:\Users\bjha\$ProjectName
    git pull 2>$null                                                                #local repository is updated using git clone
} else {
    Set-Location -Path C:\Users\bjha\
    Write-Host "Powerspeak_terraform repo doesn't already exists. Cloning it" -ForegroundColor Green
    git clone $RURL 2>$null       #local repository is created using git clone
}

# Moving inside powerspeak_terraform Directory
cd C:\Users\bjha\$ProjectName

git checkout -b testautomate

#Listing All the branches available
function PullAllBranches() {
$branches = git branch  #Lists all the branches in $branches variable
$branches = -split $branches


for ($i=0; $i -lt $branches.Length; $i++){
    if ($branches[i] -eq $hbranch) {
        #merge and tag release to master branch
        git checkout master 2>$null                 #checkout to master branch
        git merge $branch 2>$null                   #Merge release/hotfix to master branch
        $commitID = git log --format="%H" -n 1      #get the most-recent/last commit ID as variable for tagging
        git tag -a v$tagv -m "$commitID"            #tagging latest commit in master with version
        #git branch -d $branch                      #delete release/hotfix
    
        #merging master branch into develop branch
        git checkout develop 2>$null                #checkout to develop branch
        git merge master                            #merge master to develop branch

        Write-Host('Master Branch Merged with Developer branch. Remote Repository updated. Task accomplished')

    } else {
    git checkout -b elsehu
    Write-Host('No Release or Hotfix Branch available. Task Aborted')
}
}

    
}
