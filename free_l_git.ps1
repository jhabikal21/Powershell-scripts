If(Test-Path C:\terraform\tmp4\powerspeak_terraform) {
    Write-Host "Powerspeak_terraform repo already exists. Pulling latest changes from remote" -ForegroundColor Green
    Set-Location -Path C:\terraform\tmp4\powerspeak_terraform
    git pull 2>$null
} else {
    Set-Location -Path C:\terraform\tmp4\
    Write-Host "Powerspeak_terraform repo doesn't already exists. Cloning it" -ForegroundColor Green
    git clone git@bitbucket.org:amey_globant/powerspeak_terraform.git 2>$null
}
# Moving inside powerspeak_terraform Directory
cd C:\terraform\tmp4\powerspeak_terraform

$branch= [release, hotfix]

#Listing All the branches available
function PullAllBranches() {
$branches = git branch
If($branch in $branches) {

    git checkout master 2>$null
    git merge $branch 2>$null
    git log #check the commit ID to tag
    git tag -a <v1.2> <commit ID> -m "Message here"
    git checkout develop 2>$null
    git merge master
    git branch -d $branch
    Write-Host('Master Branch Merged with Developer branch. Task accomplished')

} else {

    Write-Host('No Release or Hosfix Branch available. Task Aborted')
}