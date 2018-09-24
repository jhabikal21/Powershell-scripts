


#Check to see if the Project folder is available on the local machine
If(Test-Path C:\terraform\tmp4\sss) {
    Write-Host "Powerspeak_terraform repo already exists. Pulling latest changes from remote" -ForegroundColor Green
    Set-Location -Path C:\terraform\tmp4\sss
    git pull 2>$null                                                                #local repository is updated using git clone
} else {
    Set-Location -Path C:\terraform\tmp4\
    Write-Host "Powerspeak_terraform repo doesn't already exists. Cloning it" -ForegroundColor Green
    git clone git@bitbucket.org:fff/sss.git 2>$null       #local repository is created using git clone
}

# Moving inside powerspeak_terraform Directory
cd C:\terraform\tmp4\sss

#branches to be merged in "master branch"
$branch= [release, hotfix]

#Listing All the branches available
function PullAllBranches() {
$branches = git branch  #List all the banch in $branches variable
If($branch in $branches) { #checked if $branches contain any release/hotfix branch

    #merge and tag release to master branch
    git checkout master 2>$null                 #checkout to master branch
    git merge $branch 2>$null                   #Merge release/hotfix to master branch
    $commitID = git log --format="%H" -n 1      #get the most-recent/last commit ID as variable for tagging
    git tag -a v5.2.16 -m "$commitID"           #tagging latest commit in master with version
    git branch -d $branch                       #delete release/hotfix
    
    #merging master branch into develop branch
    git checkout develop 2>$null                #checkout to develop branch
    git merge master                            #merge master to develop branch

    #Update the remote repository by git push
#   git push master origin                      #push changes with only master branch to remote repository
    git push origin --all                       #push all branches to remote repository
    git push origin --tags                      #push all tags to remote repository

    Write-Host('Master Branch Merged with Developer branch. Remote Repository updated. Task accomplished')

} else {

    Write-Host('No Release or Hotfix Branch available. Task Aborted')
}
