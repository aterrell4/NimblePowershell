# Nimble Powershell
Powershell based scripts for performing basic admin tasks on HPE/Nimble Storage Arrays. 

These powershell scripts are written to interface directly with HPE/Nimble Storage Arrays to perform basic tasks. 

## Use At Your Own Risk ## 
We are directly interfacing with base data storage and you should always take into account what can happen if it goes wrong. 

**Keep good backups.**

### Usage

This version of the script is rudimentary and designed to be run interactively. With some additional work it can be fully automated or chained to another script to trigger without user interaction. 

1. Ensure you change the performance policy according to your needs. This is hardcoded in this version but could be made to receive a variable or pipe from another location. 
2. Ensure your volume name does not contain illegal characters. This could be altered using regex to clean up input before processing but for now this will have to work. 
