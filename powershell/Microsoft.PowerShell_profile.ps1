Import-Module -Name Microsoft.PowerShell.Utility

###############
# Git Aliases #
###############

# Prevent conflict with built-in aliases by removing them
$aliases = @(
    "ga",
    "gca",
    "gcm",
    "gco",
    "gfp",
    "gp",
    "gpf",
    "gpl",
    "gpoh",
    "gr",
    "gri",
    "gs"

)

foreach ($alias in $aliases) {
    if (Test-Path Alias:$alias) {
        Remove-Item Alias:$alias -Force
    }
}

function _ga() {
    git add $args
}
New-Alias -Name ga -Value _ga

function _gca() {
    git commit --amend $args
}
New-Alias -Name gca -Value _gca

function _gcm() {
    git commit -m $args
}
New-Alias -Name gcm -Value _gcm

function _gco() {
    git checkout $args
}
New-Alias -Name gco -Value _gco

function _gfp {
    git fetch --prune $args
}
New-Alias -Name gfp -Value _gfp

function _gp {
    git push $args
}
New-Alias -Name gp -Value _gp

function _gpf {
    git push --force $args
}
New-Alias -Name gpf -Value _gpf

function _gpl() {
    git pull $args
}
New-Alias -Name gpl -Value _gpl

function _gpoh() {
    git push origin head
}
New-Alias -Name gpoh -Value _gpoh

function _gr() {
    git rebase $args
}
New-Alias -Name gr -Value _gr

function _gri() {
    git rebase --interactive $args
}
New-Alias -Name gri -Value _gri

function _gs() {
    git status $args
}
New-Alias -Name gs -Value _gs
