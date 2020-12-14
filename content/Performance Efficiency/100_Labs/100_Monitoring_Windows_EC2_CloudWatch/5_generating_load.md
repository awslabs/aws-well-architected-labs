---
title: "Generate CPU and Memory load"
menutitle: "Generate load"
date: 2020-11-19T12:00:00-04:00
chapter: false
weight: 5
pre: "<b>5. </b>"
tags:
 - Windows Server
 - Windows
 - EC2
 - CloudWatch
 - CloudWatch Dashboard
---

We have a CloudWatch dashboard to show us CPU and Memory statistics for the deployed EC2 instance. In order to showcase the dashboards, lets add a synthetic load to the machine.  We have 2 PowerShell scripts that have already been deployed to the instance to facilitate this.

## cpu_stress.ps1

This script will start multiple threads (one per CPU in the machine) to keep the processor busy doing a simple math computation. We set the thread priority to "Lowest" so it should still allow system processes to continue.

{{%expand " View cpu_stress.ps1 Code" %}}
```
<#
.EXAMPLE
.\cpu_stress.ps1

This will execute the script against all cores

.DESCRIPTION
#>

# CPUs in the machine
$cpus=$env:NUMBER_OF_PROCESSORS
# Lower the thread so it won't overwhelm the system for other things
[System.Threading.Thread]::CurrentThread.Priority = 'Lowest'

#####################
# perfmon counters for CPU
$Global:psPerfCPU = new-object System.Diagnostics.PerformanceCounter("Processor","% Processor Time","_Total")
$psPerfCPU.NextValue() | Out-Null


$StartDate = Get-Date
Write-Output "=-=-=-=-=-=-=-=-=-=  Stress Machine Started: $StartDate =-=-=-=-=-=-=-=-=-="
Write-Warning "This script will saturate all available CPUs in the machine"
Write-Warning "To cancel execution of all jobs, close the PowerShell Host Window (or terminate the remote session)"
Write-Output "=-=-=-=-=-=-=-=-=-=  CPUs in box: $cpus =-=-=-=-=-=-=-=-=-= "



# This will stress the CPU
foreach ($loopnumber in 1..$cpus){
  Start-Job -ScriptBlock{
  $result = 1
      foreach ($number in 1..0x7FFFFFFF){
          $result = $result * $number
      }# end foreach
  }# end Start-Job
}# end foreach

Write-Output "Created sub-jobs to consume the CPU"
# Ask the user if they want to clear out RAM, if so we will continue
Read-Host -Prompt "Press any key to stop the JOBs CTRL+C to quit"

Write-Output "Clearing CPU Jobs"
Receive-Job *
Stop-Job *
Remove-Job *

$EndDate = Get-Date
Write-Output "=-=-=-=-=-=-=-=-=-= Stress Machine Complete: $EndDate =-=-=-=-=-=-=-=-=-="

```
{{% /expand%}}


## mem_stress.ps1

This script will create an ever expanding array in RAM to attempt to consume as much as possible. We do reserve 512Mb of ram for the OS to continue to operate.

{{%expand " View mem_stress.ps1 Code" %}}
```
<#
.EXAMPLE
.\mem_stress.ps1

This will execute the script to consume all of the memory (less 512 for the OS to survive)

.DESCRIPTION
#>

# RAM in box
$box=get-WMIobject Win32_ComputerSystem
$Global:physMB=$box.TotalPhysicalMemory / 1024 /1024

# Create object to get current memory available
$Global:psPerfMEM = new-object System.Diagnostics.PerformanceCounter("Memory","Available Mbytes")
$psPerfMEM.NextValue() | Out-Null

# leave 512Mb for the OS to survive.
$HEADROOM=512

$ram = $physMB - $psPerfMEM.NextValue()
$maxRAM=$physMB - $HEADROOM

$progress = ($ram / $maxRAM) * 100
$completed  = [int]$progress
$StartDate = Get-Date

Write-Output "=-=-=-=-=-=-=-=-=-=  Memory Stress Started: $StartDate =-=-=-=-=-=-=-=-=-="
Write-Output "mem_stress - This script will consume all but 512MB of RAM available on the machine"
Write-Output "Starting consumed RAM: $ram out of $maxRAM ($completed% Full)"
Write-Output "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
# If you increase the size of the array the GC seems to do quicker cleanups
# Not sure why, but 200MB seems to be the suite spot
$a = "a" * 200MB

# These are the arrays we will create to consume all of the RAM
$growArray = @()
$growArray += $a
$bigArray = @()
$k=0
$lastCompleted = 900

# This loop will continue until we have consumed all of the RAM minus the headroom
while ($ram -lt $maxRAM) {
 $bigArray += ,@($k,$growArray)
 $k += 1
 $growArray += $a
 # Find out how much RAM we are now consuming
 $ram = $physMB - $psPerfMEM.NextValue()
 $progress = ($ram / $maxRAM) * 100
 $completed  = [int]$progress
 $status_string = -join([int]$ram," of ",[int]$maxRAM, "MB ($completed% Complete)")
 # Only show the message when we have a change in percentage
 if ($completed -ne $lastCompleted) {
    Write-Output "$status_string"
    $lastCompleted = $completed
    }
}
Write-Output "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
# Do a final check of RAM after consuming it all
$ram = $physMB - $psPerfMEM.NextValue()
Write-Output "FINAL $ram / $maxRAM"

# Ask the user if they want to clear out RAM, if so we will continue
Read-Host -Prompt "Press any key to clear out RAM or CTRL+C to quit"

Write-Output "Clearing RAM"
#####################
# and now release it all.
$bigArray.clear()
#remove-variable bigArray
$growArray.clear()
#remove-variable growArray
[System.GC]::Collect()
#####################

$ram = $physMB - $psPerfMEM.NextValue()
Write-Output "RAM HAS BEEN CLEARED: $ram / $maxRAM"

```
{{% /expand%}}

## Generate Load

1. Open a new tab for the AWS console with this link:
https://console.aws.amazon.com/ec2/v2/home?r#Instances:instanceState=running;tag:Name=WindowsMachineDeploy
1. You should see the EC2 instance we have deployed.
    * _Troubleshooting_: If you do not see the instance, and you changed the CloudFormation stack name when deploying, then delete the **Name: WindowsMachineDeploy** filter and search for the instance with the same name as you used for your stack
![GenerateLoad1](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/4/GenerateLoad1.png?classes=lab_picture_small)
1. Click the checkbox next to the machine, and then click "Connect"
![GenerateLoad2](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/4/GenerateLoad2.png?classes=lab_picture_small)
1. Select "Session Manager" and then click Connect. This will open a new tab with a PowerShell console for the instance.
![GenerateLoad3](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/4/GenerateLoad3.png?classes=lab_picture_small)
![GenerateLoad4](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/4/GenerateLoad4.png?classes=lab_picture_small)

1. Type C:\mem_stress.ps1 at the console and it will start to consume memory resources
![GenerateLoad5](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/4/GenerateLoad5.png?classes=lab_picture_small)
![GenerateLoad6](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/4/GenerateLoad6.png?classes=lab_picture_small)
1. Go back to the previous broswer tab that has the EC2 console connect screen and click Connect again. This will open another PowerShell console.
![GenerateLoad4](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/4/GenerateLoad4.png?classes=lab_picture_small)
1. Type C:\cpu_stress.ps1 at the console and it will start to consume CPU resources
![GenerateLoad7](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/4/GenerateLoad7.png?classes=lab_picture_small)
1. Go back to your browser tab that contains the CloudWatch Dashboard. You should see the CPU and Memory graphs change within 10-15 seconds.
    * **Processor % User Time** goes up as the test script consumes CPU
    * **Memory Available** goes down, as the script consumes all of it except for a small reserve
![GenerateLoad8](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/4/GenerateLoad8.png?classes=lab_picture_small)
1. As time goes on, it will continue to update the graph. In order to remove the load, go back to each of the console windows and simply press any key.  This will cause the script to reclaim all resources it has consumed.
1. Go back to your browser tab that contains the CloudWatch Dashboard to watch as the CPU load goes down and the amount of free RAM increases.
![GenerateLoad9](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/4/GenerateLoad9.png?classes=lab_picture_small)




{{< prev_next_button link_prev_url="../4_adding_metrics_to_dashboard/" link_next_url="../6_cleanup/" />}}
