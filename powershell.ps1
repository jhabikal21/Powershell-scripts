
#Execute if and only if git, posh-git & ssh-Agent are not installed and setup on our production server.  
#If your production server is already installed with these softwares, please remove all the below steps till #Setup Complete
#Mostly installation of any software or application is ideally not recommended using scripts (any script, i.e., bash, batch, shell, powershell)
#the installation and configuration part is always prefered using configuration management tools such as Ansible, Chef, Puppet, Salt
#Confirm with your manager is he actually wants to install git and post-get as well as configure ssh-agent in your production server
#High chances are, subbu recommended you the link just to make you aware of how production server will interect with your Git repository.

#check and confirm above information and update the script accordingly

#making out script Idempotent (validating before installing any application/service)
Set-ExecutionPolicy RemoteSigned
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

#check if git is already installed on this machine
git --help 2>$null
If( $? -eq False ){                                             #check exit status if Flase, no git installed
    choco install -y git -params '"/GitAndUnixToolsOnPath"'     #installing git
}

git --help 2>$null
If( $? -eq False ){                                             #check exit status if Flase, no posh-git installed
    choco install -y poshgit                                    #installing posh-git
}

git --help 2>$null
If( $? -eq False ){                                             #check exit status if Flase, no putty installed
    choco install -y putty                                      #installing putty
}

cd ~
mkdir .ssh

#SSH key setup for your machine
ssh-keygen
Import-Module 'C:\tools\poshgit\dahlbyk-posh-git-a4faccd\src\posh-git.psd1'
Start-SshAgent
Add-SshKey (Resolve-Path ~\.ssh\github_rsa)
# Setup Complete

# Above infomration is not required if your machine already has all those above setup. 
#--------------------------Main Program begins------------------------------------------------

#Check to see if the Project folder is available on the local machine
If(Test-Path C:\terraform\tmp4\powerspeak_terraform) {
    Write-Host "Powerspeak_terraform repo already exists. Pulling latest changes from remote" -ForegroundColor Green
    Set-Location -Path C:\terraform\tmp4\powerspeak_terraform
    git pull 2>$null                                                                #local repository is updated using git clone
} else {
    Set-Location -Path C:\terraform\tmp4\
    Write-Host "Powerspeak_terraform repo doesn't already exists. Cloning it" -ForegroundColor Green
    git clone git@bitbucket.org:amey_globant/powerspeak_terraform.git 2>$null       #local repository is created using git clone
}

# Moving inside powerspeak_terraform Directory
cd C:\terraform\tmp4\powerspeak_terraform

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