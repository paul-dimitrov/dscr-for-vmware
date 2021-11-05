<#
Copyright (c) 2018-2021 VMware, Inc.  All rights reserved

The BSD-2 license (the "License") set forth below applies to all parts of the Desired State Configuration Resources for VMware project.  You may not use this file except in compliance with the License.

BSD-2 License

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#>

[DscResource()]
class ResourcePool : BaseDSC {
    <#
    .DESCRIPTION

    Specifies the name of the resource pool.
    #>
    [DscProperty(Key)]
    [string] $ResourcePoolName

    <#
    .DESCRIPTION

    Specifies the location of the resource pool. For nested location as a separator use '/'
    #>
    [DscProperty(Key)]
    [string] $ResourcePoolLocation

    <#
    .DESCRIPTION

    Indicates that CPU expandable reservation is enabled
    #>
    [DscProperty()]
    [bool] $CpuExpandableReservation = $true

    <#
    .DESCRIPTION

    Specifies a configured CPU limit in MHz
    #>
    [DscProperty()]
    [long] $CpuLimitMHz = -1

    <#
    .DESCRIPTION

    Specifies a configured CPU reservation in MHz
    #>
    [DscProperty()]
    [long] $CpuReservationMHz = 0

    <#
    .DESCRIPTION

    Specifies CPU shares level. The valid values are Custom, High, Low, Normal and Unset.
    #>
    [DscProperty()]
    [SharesLevel] $CpuSharesLevel = [SharesLevel]::Normal

    <#
    .DESCRIPTION

    Indicates that Memory expandable reservation is enabled
    #>
    [DscProperty()]
    [bool] $MemExpandableReservation = $true

    <#
    .DESCRIPTION

    Specifies a configured memory limit in GB
    #>
    [DscProperty()]
    [long] $MemLimitGB = -1

    <#
    .DESCRIPTION

    Specifies a configured memory reservation in GB
    #>
    [DscProperty()]
    [long] $MemReservationGB = 0

    <#
    .DESCRIPTION

    Specifies Memory shares level. The valid values are Custom, High, Low, Normal and Unset.
    #>
    [DscProperty()]
    [SharesLevel] $MemSharesLevel = [SharesLevel]::Normal

    <#
    .DESCRIPTION

    Specifies the memory allocation level for the resource pool.
    This parameter is ignored unless MemSharesLevel is set to Custom.
    #>
    [DscProperty()]
    [long] $NumMemShares

    <#
    .DESCRIPTION

    Specifies the CPU allocation level for the resource pool.
    This DSC property is ignored unless CpuSharesLevel is set to Custom.
    #>
    [DscProperty()]
    [long] $NumCpuShares

    <#
    .DESCRIPTION

    Specifies whether the DRS rule should be present or absent.
    #>
    [DscProperty(Mandatory)]
    [Ensure] $Ensure

    <#
    .DESCRIPTION

    Specifies the instance of the 'InventoryUtil' class that is used
    for Inventory operations.
    #>
    hidden [InventoryUtil] $InventoryUtil

    hidden [string] $CpuExpandableReservationParameterName = 'CpuExpandableReservation'
    hidden [string] $CpuLimitMHzParameterName = 'CpuLimitMHz'
    hidden [string] $CpuReservationMHzParameterName = 'CpuReservationMHz'
    hidden [string] $CpuSharesLevelParameterName = 'CpuSharesLevel'
    hidden [string] $MemExpandableReservationParameterName = 'MemExpandableReservation'
    hidden [string] $MemLimitGBParameterName = 'MemLimitGB'
    hidden [string] $MemReservationGBParameterName = 'MemReservationGB'
    hidden [string] $MemSharesLevelParameterName = 'MemSharesLevel'
    hidden [string] $NumCpuSharesParameterName = 'NumCpuShares'
    hidden [string] $NumMemSharesParameterName = 'NumMemShares'
    hidden [hashtable] $CpuSharesMap = @{
       'Low' = 2000
       'Normal' = 4000
       'High' = 8000
    }
    hidden [hashtable] $MemSharesMap = @{
       'Low' = 81920
       'Normal' = 163840
       'High' = 327680
    }

    [void] Set() {
        try {
            $this.ConnectVIServer()
            $this.InitInventoryUtil()
            $resourcePool = $this.InventoryUtil.GetResourcePool($this.ResourcePoolName, $this.ResourcePoolLocation)
            if ($this.Ensure -eq [Ensure]::Present) {
                if ($null -eq $resourcePool) {
                    $resourcePoolParent = $this.InventoryUtil.GetResourcePoolParent($this.ResourcePoolLocation)
                    $this.AddResourcePool($resourcePoolParent)
                }
                else {
                    $this.UpdateResourcePool($resourcePool)
                }
            }
            else {
                if ($null -ne $resourcePool) {
                    $this.RemoveResourcePool($resourcePool)
                }
            }
        }
        finally {
            $this.DisconnectVIServer()
        }
    }

    [bool] Test() {
        try {
            $this.ConnectVIServer()

            $this.InitInventoryUtil()
            $resourcePool = $this.InventoryUtil.GetResourcePool($this.ResourcePoolName, $this.ResourcePoolLocation)
            $result = $null
            if ($this.Ensure -eq [Ensure]::Present) {
                if ($null -eq $resourcePool) {
                    $result = $false
                }
                else {
                    $result = !$this.ShouldUpdateResourcePool($resourcePool)
                }
            }
            else {
                $result = ($null -eq $resourcePool)
            }

            $this.WriteDscResourceState($result)

            return $result
        }
        finally {
            $this.DisconnectVIServer()
        }
    }

    [ResourcePool] Get() {
        try {
            $this.ConnectVIServer()
            $this.InitInventoryUtil()

            $result = [ResourcePool]::new()
            $result.Server = $this.Server
            $result.ResourcePoolLocation = $this.ResourcePoolLocation
            $result.ResourcePoolName = $this.ResourcePoolName

            $resourcePool = $this.InventoryUtil.GetResourcePool($this.ResourcePoolName, $this.ResourcePoolLocation)

            $this.PopulateResult($resourcePool, $result)

            return $result
        }
        finally {
            $this.DisconnectVIServer()
        }
    }

    <#
    .DESCRIPTION

    Initializes an instance of the 'InventoryUtil' class.
    #>
    [void] InitInventoryUtil() {
        if ($null -eq $this.InventoryUtil) {
            $this.InventoryUtil = [InventoryUtil]::new($this.Connection, $this.Ensure)
        }
    }

    <#
    .DESCRIPTION

    Checks if the Resource pool should be updated.
    #>
    [bool] ShouldUpdateResourcePool($resourcePool) {
        if ($this.MemSharesLevel -ne [SharesLevel]::Unset -and $this.MemSharesLevel -ne [SharesLevel]::Custom){
           $memSharesLevelValue = [string]$this.MemSharesLevel
           $this.NumMemShares = $this.MemSharesMap.($memSharesLevelValue)
        }
        if ($this.CpuSharesLevel -ne [SharesLevel]::Unset -and $this.CpuSharesLevel -ne [SharesLevel]::Custom){
           $cpuSharesLevelValue = [string]$this.CpuSharesLevel
           $this.NumCpuShares = $this.CpuSharesMap.($cpuSharesLevelValue)
        }
        $shouldUpdateResourcePool = @(
            $this.ShouldUpdateDscResourceSetting('CpuExpandableReservation', $resourcePool.CpuExpandableReservation, $this.CpuExpandableReservation),
            $this.ShouldUpdateDscResourceSetting('CpuLimitMHz', $resourcePool.CpuLimitMHz, $this.CpuLimitMHz),
            $this.ShouldUpdateDscResourceSetting('CpuReservationMHz', $resourcePool.CpuReservationMHz, $this.CpuReservationMHz),
            $this.ShouldUpdateDscResourceSetting('CpuSharesLevel', [string]$resourcePool.CpuSharesLevel, $this.CpuSharesLevel.ToString()),
            $this.ShouldUpdateDscResourceSetting('MemExpandableReservation', $resourcePool.MemExpandableReservation, $this.MemExpandableReservation),
            $this.ShouldUpdateDscResourceSetting('MemLimitGB', $resourcePool.MemLimitGB, $this.MemLimitGB),
            $this.ShouldUpdateDscResourceSetting('MemReservationGB', $resourcePool.MemReservationGB, $this.MemReservationGB),
            $this.ShouldUpdateDscResourceSetting('MemSharesLevel', [string]$resourcePool.MemSharesLevel, $this.MemSharesLevel.ToString()),
            $this.ShouldUpdateDscResourceSetting('NumCpuShares', $resourcePool.NumCpuShares, $this.NumCpuShares),
            $this.ShouldUpdateDscResourceSetting('NumMemShares', $resourcePool.NumMemShares, $this.NumMemShares)
        )

        return ($shouldUpdateResourcePool -Contains $true)
    }

    <#
    .DESCRIPTION

    Populates the parameters for the New-ResourcePool and Set-ResourcePool cmdlets.
    #>
    [void] PopulateResourcePoolParams($resourcePoolParams, $parameter, $desiredValue) {
        <#
            Special case where the desired value is enum type. These type of properties
            should be added as parameters to the cmdlet only when their value is not equal to Unset.
            Unset means that the property was not specified in the Configuration.
        #>
        if ($desiredValue -is [SharesLevel]) {
            if ($desiredValue -ne 'Unset') {
                $resourcePoolParams.$parameter = $desiredValue.ToString()
            }

            return
        }

        if ($null -ne $desiredValue) {
            $resourcePoolParams.$parameter = $desiredValue
        }
    }

    <#
    .DESCRIPTION

    Returns the populated Resource pool parameters.
    #>
    [hashtable] GetResourcePoolParams() {
        $resourcePoolParams = @{}

        $resourcePoolParams.Server = $this.Connection
        $resourcePoolParams.Confirm = $false
        $resourcePoolParams.ErrorAction = 'Stop'

        $this.PopulateResourcePoolParams($resourcePoolParams, $this.CpuExpandableReservationParameterName, $this.CpuExpandableReservation)
        $this.PopulateResourcePoolParams($resourcePoolParams, $this.CpuLimitMHzParameterName, $this.CpuLimitMHz)
        $this.PopulateResourcePoolParams($resourcePoolParams, $this.CpuReservationMHzParameterName, $this.CpuReservationMHz)
        $this.PopulateResourcePoolParams($resourcePoolParams, $this.CpuSharesLevelParameterName, $this.CpuSharesLevel)
        $this.PopulateResourcePoolParams($resourcePoolParams, $this.MemExpandableReservationParameterName, $this.MemExpandableReservation)
        $this.PopulateResourcePoolParams($resourcePoolParams, $this.MemLimitGBParameterName, $this.MemLimitGB)
        $this.PopulateResourcePoolParams($resourcePoolParams, $this.MemReservationGBParameterName, $this.MemReservationGB)
        $this.PopulateResourcePoolParams($resourcePoolParams, $this.MemSharesLevelParameterName, $this.MemSharesLevel)

        if ($this.CpuSharesLevel -eq [SharesLevel]::Custom) {
           $this.PopulateResourcePoolParams($resourcePoolParams, $this.NumCpuSharesParameterName, $this.NumCpuShares)
        }
        if ($this.MemSharesLevel -eq [SharesLevel]::Custom) {
           $this.PopulateResourcePoolParams($resourcePoolParams, $this.NumMemSharesParameterName, $this.NumMemShares)
        }

        return $resourcePoolParams
    }

    <#
    .DESCRIPTION

    Creates a new Resource pool with the specified properties at the specified parent.
    #>
    [void] AddResourcePool($parent) {
        $resourcePoolParams = $this.GetResourcePoolParams()
        $resourcePoolParams.Name = $this.ResourcePoolName
        $resourcePoolParams.Location = $parent

        try {
            New-ResourcePool @resourcePoolParams
        }
        catch {
            throw "Cannot create Resource pool $($this.Name). For more information: $($_.Exception.Message)"
        }
    }

    <#
    .DESCRIPTION

    Updates the Resource pool with the specified properties.
    #>
    [void] UpdateResourcePool($resourcePool) {
        $resourcePoolParams = $this.GetResourcePoolParams()

        try {
            $resourcePool | Set-ResourcePool @resourcePoolParams
        }
        catch {
            throw "Cannot update Resource pool $($this.Name). For more information: $($_.Exception.Message)"
        }
    }

    <#
    .DESCRIPTION

    Removes the Resource pool.
    #>
    [void] RemoveResourcePool($resourcePool) {
        try {
            $resourcePool | Remove-ResourcePool -Server $this.Connection -Confirm:$false -ErrorAction Stop
        }
        catch {
            throw "Cannot remove Resource pool $($this.Name). For more information: $($_.Exception.Message)"
        }
    }

    <#
    .DESCRIPTION

    Populates the result returned from the Get() method with the values of the Resource pool from the server.
    #>

    [void] PopulateResult($resourcePool, $result) {
        if ($null -ne $resourcePool) {
            $result.ResourcePoolName = $resourcePool.Name
            $result.Ensure = [Ensure]::Present
            $result.CpuExpandableReservation = $resourcePool.CpuExpandableReservation
            $result.CpuLimitMHz = $resourcePool.CpuLimitMHz
            $result.CpuReservationMHz = $resourcePool.CpuReservationMHz
            $result.CpuSharesLevel = $resourcePool.CpuSharesLevel.ToString()
            $result.MemExpandableReservation = $resourcePool.MemExpandableReservation
            $result.MemLimitGB = $resourcePool.MemLimitGB
            $result.MemReservationGB = $resourcePool.MemReservationGB
            $result.MemSharesLevel = $resourcePool.MemSharesLevel.ToString()
            $result.NumCpuShares = $resourcePool.NumCpuShares
            $result.NumMemShares = $resourcePool.NumMemShares
        }
        else {
            $result.ResourcePoolName = $this.ResourcePoolName
            $result.Ensure = [Ensure]::Absent
            $result.CpuExpandableReservation = $this.CpuExpandableReservation
            $result.CpuLimitMHz = $this.CpuLimitMHz
            $result.CpuReservationMHz = $this.CpuReservationMHz
            $result.CpuSharesLevel = $this.CpuSharesLevel
            $result.MemExpandableReservation = $this.MemExpandableReservation
            $result.MemLimitGB = $this.MemLimitGB
            $result.MemReservationGB = $this.MemReservationGB
            $result.MemSharesLevel = $this.MemSharesLevel
            $result.NumCpuShares = $this.NumCpuShares
            $result.NumMemShares = $this.NumMemShares
        }
    }
}
