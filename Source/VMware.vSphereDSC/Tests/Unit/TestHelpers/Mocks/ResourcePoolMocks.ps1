<#
Copyright (c) 2018-2021 VMware, Inc.  All rights reserved

The BSD-2 license (the "License") set forth below applies to all parts of the Desired State Configuration Resources for VMware project.  You may not use this file except in compliance with the License.

BSD-2 License

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#>

function New-ResourcePoolProperties {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]

    $resourcePoolProperties = @{
        Server = $script:constants.VIServerName
        Credential = $script:credential
        ResourcePoolName = $script:constants.ResourcePoolName
        Ensure = 'Present'
        ResourcePoolLocation = "$($script:constants.InventoryItemLocationItemOne)/$($script:constants.InventoryItemLocationItemTwo)"
    }

    $resourcePoolProperties
}

function New-MocksForResourcePool {
    [CmdletBinding()]

    $viServerMock = $script:viServer

    Mock -CommandName Connect-VIServer -MockWith { return $viServerMock }.GetNewClosure() -Verifiable
}

function New-MocksWhenEnsurePresentNonExistingResourcePoolParentIsResourcePool {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]

    $resourcePoolProperties = New-ResourcePoolProperties

    $resourcePoolMock = $script:resourcePool

    Mock `
      -CommandName Get-Inventory -MockWith {return $resourcePoolMock }.GetNewClosure() `
      -ParameterFilter {
         $Server -eq $script:viServer -and $Name -eq $script:constants.InventoryItemLocationItemOne
      } `
      -Verifiable

    Mock `
      -CommandName Get-Inventory -MockWith { return $resourcePoolMock }.GetNewClosure() `
      -ParameterFilter {
         $Name -eq $script:constants.InventoryItemLocationItemTwo -and $Location -eq $script:resourcePool
      } `
      -Verifiable

    Mock `
      -CommandName Get-ResourcePool -MockWith { return $null }.GetNewClosure() `
      -ParameterFilter {
         $Name -eq $script:constants.ResourcePoolName -and $Location -eq $script:resourcePool
      } `
      -Verifiable

    Mock `
      -CommandName New-ResourcePool -MockWith { return $resourcePoolMock }.GetNewClosure() `
      -ParameterFilter {
         $Name -eq $script:constants.ResourcePoolName -and $Location -eq $script:resourcePool
      } `
      -Verifiable

    $resourcePoolProperties
}

function New-MocksWhenEnsurePresentNonExistingResourcePoolandAllSettingsSpecified {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]

    $resourcePoolProperties = New-ResourcePoolProperties

    $resourcePoolMock = $script:resourcePool

    $resourcePoolProperties.CpuExpandableReservation = $script:constants.CpuExpandableReservation
    $resourcePoolProperties.CpuLimitMHz = $script:constants.CpuLimitMHz
    $resourcePoolProperties.CpuReservationMHz = $script:constants.CpuReservationMHz
    $resourcePoolProperties.CpuSharesLevel = $script:constants.CpuSharesLevelCustom
    $resourcePoolProperties.NumCpuShares = $script:constants.NumCpuShares
    $resourcePoolProperties.MemExpandableReservation = $script:constants.MemExpandableReservation
    $resourcePoolProperties.MemLimitGB = $script:constants.MemLimitGB
    $resourcePoolProperties.MemReservationGB = $script:constants.MemReservationGB
    $resourcePoolProperties.MemSharesLevel = $script:constants.MemSharesLevelCustom
    $resourcePoolProperties.NumMemShares = $script:constants.NumMemShares

    Mock `
      -CommandName Get-Inventory -MockWith { return $resourcePoolMock }.GetNewClosure() `
      -ParameterFilter {
         $Server -eq $script:viServer -and $Name -eq $script:constants.InventoryItemLocationItemOne
      } `
      -Verifiable

    Mock `
      -CommandName Get-Inventory -MockWith { return $resourcePoolMock }.GetNewClosure() `
      -ParameterFilter {
         $Name -eq $script:constants.InventoryItemLocationItemTwo -and $Location -eq $script:resourcePool
      } `
      -Verifiable

    Mock `
      -CommandName Get-ResourcePool -MockWith { return $null }.GetNewClosure() `
      -ParameterFilter {
         $Name -eq $script:constants.ResourcePoolName -and $Location -eq $script:resourcePool
      } `
      -Verifiable

    Mock `
      -CommandName New-ResourcePool -MockWith { return $resourcePoolMock }.GetNewClosure() `
      -ParameterFilter {
         $Name -eq $script:constants.ResourcePoolName -and `
         $Location -eq $script:resourcePool -and `
         $CpuExpandableReservation -eq $script:constants.CpuExpandableReservation -and `
         $CpuLimitMHz -eq $script:constants.CpuLimitMHz -and `
         $CpuReservationMHz -eq $script:constants.CpuReservationMHz -and `
         $CpuSharesLevel -eq $script:constants.CpuSharesLevelCustom -and `
         $NumCpuShares -eq $script:constants.NumCpuShares -and `
         $MemExpandableReservation -eq $script:constants.MemExpandableReservation -and `
         $MemLimitGB -eq $script:constants.MemLimitGB -and `
         $MemReservationGB -eq $script:constants.MemReservationGB -and `
         $MemSharesLevel -eq $script:constants.MemSharesLevelCustom -and `
         $NumMemShares -eq $script:constants.NumMemShares
      } `
      -Verifiable

    $resourcePoolProperties
}

function New-MocksWhenEnsurePresentExistingResourcePoolOnlyNameAndLocationSpecified {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]

    $resourcePoolProperties = New-ResourcePoolProperties

    $resourcePoolMock = $script:resourcePool

    Mock `
      -CommandName Get-Inventory -MockWith { return $resourcePoolMock }.GetNewClosure() `
      -ParameterFilter {
         $Server -eq $script:viServer -and $Name -eq $script:constants.InventoryItemLocationItemOne
      } `
      -Verifiable

    Mock `
      -CommandName Get-Inventory -MockWith { return $resourcePoolMock }.GetNewClosure() `
      -ParameterFilter {
         $Name -eq $script:constants.InventoryItemLocationItemTwo -and $Location -eq $script:resourcePool
      } `
      -Verifiable

    Mock `
      -CommandName Get-ResourcePool -MockWith { return $resourcePoolMock }.GetNewClosure() `
      -ParameterFilter {
         $Name -eq $script:constants.ResourcePoolName -and $Location -eq $script:resourcePool
      } `
      -Verifiable

    Mock -CommandName Set-ResourcePool -MockWith { return $null }.GetNewClosure() -Verifiable

    $resourcePoolProperties
}

function New-MocksWhenEnsurePresentExistingResourcePoolAndAllSettingsSpecified {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]

    $resourcePoolProperties = New-ResourcePoolProperties

    $resourcePoolMock = $script:resourcePool

    $resourcePoolProperties.CpuExpandableReservation = $script:constants.CpuExpandableReservation
    $resourcePoolProperties.CpuLimitMHz = $script:constants.CpuLimitMHz
    $resourcePoolProperties.CpuReservationMHz = $script:constants.CpuReservationMHz
    $resourcePoolProperties.CpuSharesLevel = $script:constants.CpuSharesLevelCustom
    $resourcePoolProperties.NumCpuShares = $script:constants.NumCpuShares
    $resourcePoolProperties.MemExpandableReservation = $script:constants.MemExpandableReservation
    $resourcePoolProperties.MemLimitGB = $script:constants.MemLimitGB
    $resourcePoolProperties.MemReservationGB = $script:constants.MemReservationGB
    $resourcePoolProperties.MemSharesLevel = $script:constants.MemSharesLevelCustom
    $resourcePoolProperties.NumMemShares = $script:constants.NumMemShares

    Mock `
      -CommandName Get-Inventory -MockWith {return $resourcePoolMock }.GetNewClosure() `
      -ParameterFilter {
         $Server -eq $script:viServer -and $Name -eq $script:constants.InventoryItemLocationItemOne
      } `
      -Verifiable

    Mock `
      -CommandName Get-Inventory -MockWith {return $resourcePoolMock }.GetNewClosure() `
      -ParameterFilter {
         $Name -eq $script:constants.InventoryItemLocationItemTwo -and $Location -eq $script:resourcePool
      } `
      -Verifiable

    Mock `
      -CommandName Get-ResourcePool -MockWith { return $resourcePoolMock }.GetNewClosure() `
      -ParameterFilter {
         $Name -eq $script:constants.ResourcePoolName -and $Location -eq $script:resourcePool
      } `
      -Verifiable

    Mock `
      -CommandName Set-ResourcePool -MockWith { return $resourcePoolMock }.GetNewClosure() `
      -ParameterFilter {
         $ResourcePool -eq $script:resourcePool -and `
         $CpuExpandableReservation -eq $script:constants.CpuExpandableReservation -and `
         $CpuLimitMHz -eq $script:constants.CpuLimitMHz -and `
         $CpuReservationMHz -eq $script:constants.CpuReservationMHz -and `
         $CpuSharesLevel -eq $script:constants.CpuSharesLevelCustom -and `
         $NumCpuShares -eq $script:constants.NumCpuShares -and `
         $MemExpandableReservation -eq $script:constants.MemExpandableReservation -and `
         $MemLimitGB -eq $script:constants.MemLimitGB -and `
         $MemReservationGB -eq $script:constants.MemReservationGB -and `
         $MemSharesLevel -eq $script:constants.MemSharesLevelCustom -and `
         $NumMemShares -eq $script:constants.NumMemShares
      } `
      -Verifiable

    $resourcePoolProperties
}

function New-MocksWhenEnsureAbsentAndExistingResourcePool {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]

    $resourcePoolProperties = New-ResourcePoolProperties
    $resourcePoolProperties.Ensure = 'Absent'

    $resourcePoolMock = $script:resourcePool

    Mock `
      -CommandName Get-Inventory -MockWith {return $resourcePoolMock }.GetNewClosure() `
      -ParameterFilter {
         $Server -eq $script:viServer -and $Name -eq $script:constants.InventoryItemLocationItemOne
      } `
      -Verifiable

    Mock `
      -CommandName Get-Inventory -MockWith {return $resourcePoolMock }.GetNewClosure() `
      -ParameterFilter {
         $Name -eq $script:constants.InventoryItemLocationItemTwo -and $Location -eq $script:resourcePool
      } `
      -Verifiable

    Mock `
      -CommandName Get-ResourcePool -MockWith { return $resourcePoolMock }.GetNewClosure() `
      -ParameterFilter {
         $Name -eq $script:constants.ResourcePoolName -and $Location -eq $script:resourcePool
      } `
      -Verifiable

    Mock -CommandName Remove-ResourcePool -MockWith { return $null }.GetNewClosure() -Verifiable

    $resourcePoolProperties
}

function New-MocksWhenEnsureAbsentAndNonExistingResourcePool {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]

    $resourcePoolProperties = New-ResourcePoolProperties
    $resourcePoolProperties.Ensure = 'Absent'

    $resourcePoolMock = $script:resourcePool

    Mock `
      -CommandName Get-Inventory -MockWith { return $resourcePoolMock }.GetNewClosure() `
      -ParameterFilter {
         $Server -eq $script:viServer -and $Name -eq $script:constants.InventoryItemLocationItemOne
      } `
      -Verifiable

    Mock `
      -CommandName Get-Inventory -MockWith { return $resourcePoolMock }.GetNewClosure() `
      -ParameterFilter {
         $Name -eq $script:constants.InventoryItemLocationItemTwo -and $Location -eq $script:resourcePool
      } `
      -Verifiable

    Mock `
      -CommandName Get-ResourcePool -MockWith { return $null }.GetNewClosure() `
      -ParameterFilter {
         $Name -eq $script:constants.ResourcePoolName -and $Location -eq $script:resourcePool
      } `
      -Verifiable

    Mock -CommandName Remove-ResourcePool -MockWith { return $null }.GetNewClosure()

    $resourcePoolProperties
}

function New-MocksWhenEnsurePresentAndNonExistingResourcePool {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]

    $resourcePoolProperties = New-ResourcePoolProperties

    $resourcePoolMock = $script:resourcePool

    Mock `
      -CommandName Get-Inventory -MockWith { return $resourcePoolMock }.GetNewClosure() `
      -ParameterFilter {
         $Server -eq $script:viServer -and $Name -eq $script:constants.InventoryItemLocationItemOne
      } `
      -Verifiable

    Mock `
      -CommandName Get-Inventory -MockWith { return $resourcePoolMock }.GetNewClosure() `
      -ParameterFilter {
         $Name -eq $script:constants.InventoryItemLocationItemTwo -and $Location -eq $script:resourcePool
      } `
      -Verifiable

    Mock `
      -CommandName Get-ResourcePool -MockWith { return $null }.GetNewClosure() `
      -ParameterFilter {
         $Name -eq $script:constants.ResourcePoolName -and $Location -eq $script:resourcePool
      } `
      -Verifiable

    $resourcePoolProperties
}

function New-MocksWhenEnsurePresentExistingResourcePoolAndMatchingSettings {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]

    $resourcePoolProperties = New-ResourcePoolProperties

    $resourcePoolMock = $script:resourcePool

    $resourcePoolProperties.CpuExpandableReservation = $script:constants.CpuExpandableReservation
    $resourcePoolProperties.CpuLimitMHz = $script:constants.CpuLimitMHz
    $resourcePoolProperties.CpuReservationMHz = $script:constants.CpuReservationMHz
    $resourcePoolProperties.CpuSharesLevel = $script:constants.CpuSharesLevelCustom
    $resourcePoolProperties.NumCpuShares = $script:constants.NumCpuShares
    $resourcePoolProperties.MemExpandableReservation = $script:constants.MemExpandableReservation
    $resourcePoolProperties.MemLimitGB = $script:constants.MemLimitGB
    $resourcePoolProperties.MemReservationGB = $script:constants.MemReservationGB
    $resourcePoolProperties.MemSharesLevel = $script:constants.MemSharesLevelCustom
    $resourcePoolProperties.NumMemShares = $script:constants.NumMemShares

    Mock `
      -CommandName Get-Inventory -MockWith { return $resourcePoolMock }.GetNewClosure() `
      -ParameterFilter {
         $Server -eq $script:viServer -and $Name -eq $script:constants.InventoryItemLocationItemOne
      } `
      -Verifiable


    Mock `
      -CommandName Get-Inventory -MockWith { return $resourcePoolMock }.GetNewClosure() `
      -ParameterFilter {
         $Name -eq $script:constants.InventoryItemLocationItemTwo -and $Location -eq $script:resourcePool
      } `
      -Verifiable

    Mock `
      -CommandName Get-ResourcePool -MockWith { return $resourcePoolMock }.GetNewClosure() `
      -ParameterFilter {
         $Name -eq $script:constants.ResourcePoolName -and $Location -eq $script:resourcePool
      } `
      -Verifiable

    $resourcePoolProperties
}

function New-MocksWhenEnsurePresentExistingResourcePoolAndNonMatchingSetting {
param(
   $ParameterName
)
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]

    $resourcePoolProperties = New-ResourcePoolProperties

    $resourcePoolMock = $script:resourcePool

    $resourcePoolProperties.CpuExpandableReservation = $script:constants.CpuExpandableReservation
    if ($ParameterName -eq 'CpuExpandableReservation') {
       $resourcePoolProperties.CpuExpandableReservation = $script:constants.CpuExpandableReservation2
    }
    $resourcePoolProperties.CpuLimitMHz = $script:constants.CpuLimitMHz
    if ($ParameterName -eq 'CpuLimitMHz') {
       $resourcePoolProperties.CpuLimitMHz = $script:constants.CpuLimitMHz2
    }
    $resourcePoolProperties.CpuReservationMHz = $script:constants.CpuReservationMHz
    if ($ParameterName -eq 'CpuReservationMHz') {
       $resourcePoolProperties.CpuReservationMHz = $script:constants.CpuReservationMHz2
    }
    $resourcePoolProperties.CpuSharesLevel = $script:constants.CpuSharesLevelCustom
    if ($ParameterName -eq 'CpuSharesLevel') {
       $resourcePoolProperties.CpuSharesLevel = $script:constants.CpuSharesLevelLow
    }
    $resourcePoolProperties.NumCpuShares = $script:constants.NumCpuShares
    if ($ParameterName -eq 'NumCpuShares') {
       $resourcePoolProperties.NumCpuShares = $script:constants.NumCpuShares2
    }
    $resourcePoolProperties.MemExpandableReservation = $script:constants.MemExpandableReservation
    if ($ParameterName -eq 'MemExpandableReservation') {
       $resourcePoolProperties.MemExpandableReservation = $script:constants.MemExpandableReservation2
    }
    $resourcePoolProperties.MemLimitGB = $script:constants.MemLimitGB
    if ($ParameterName -eq 'MemLimitGB') {
       $resourcePoolProperties.MemLimitGB = $script:constants.MemLimitGB2
    }
    $resourcePoolProperties.MemReservationGB = $script:constants.MemReservationGB
    if ($ParameterName -eq 'MemReservationGB') {
       $resourcePoolProperties.MemReservationGB = $script:constants.MemReservationGB2
    }
    $resourcePoolProperties.MemSharesLevel = $script:constants.MemSharesLevelCustom
    if ($ParameterName -eq 'MemSharesLevel') {
       $resourcePoolProperties.MemSharesLevel = $script:constants.MemSharesLevelLow
    }
    $resourcePoolProperties.NumMemShares = $script:constants.NumMemShares
    if ($ParameterName -eq 'NumMemShares') {
       $resourcePoolProperties.NumMemShares = $script:constants.NumMemShares2
    }

    Mock `
      -CommandName Get-Inventory -MockWith { return $resourcePoolMock }.GetNewClosure() `
      -ParameterFilter {
         $Server -eq $script:viServer -and $Name -eq $script:constants.InventoryItemLocationItemOne
      } `
      -Verifiable

    Mock `
      -CommandName Get-Inventory -MockWith { return $resourcePoolMock }.GetNewClosure() `
      -ParameterFilter {
         $Name -eq $script:constants.InventoryItemLocationItemTwo -and $Location -eq $script:resourcePool
      } `
      -Verifiable

    Mock `
      -CommandName Get-ResourcePool -MockWith { return $resourcePoolMock }.GetNewClosure() `
      -ParameterFilter {
         $Name -eq $script:constants.ResourcePoolName -and $Location -eq $script:resourcePool
      } `
      -Verifiable

    $resourcePoolProperties
}

function New-MocksInTestWhenEnsureAbsentAndExistingResourcePool {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]

    $resourcePoolProperties = New-ResourcePoolProperties
    $resourcePoolProperties.Ensure = 'Absent'

    $resourcePoolMock = $script:resourcePool

    Mock `
      -CommandName Get-Inventory -MockWith { return $resourcePoolMock }.GetNewClosure() `
      -ParameterFilter {
         $Server -eq $script:viServer -and $Name -eq $script:constants.InventoryItemLocationItemOne
      } `
      -Verifiable

    Mock `
      -CommandName Get-Inventory -MockWith { return $resourcePoolMock }.GetNewClosure() `
      -ParameterFilter {
         $Name -eq $script:constants.InventoryItemLocationItemTwo -and $Location -eq $script:resourcePool
      } `
      -Verifiable

    Mock `
      -CommandName Get-ResourcePool -MockWith { return $resourcePoolMock }.GetNewClosure() `
      -ParameterFilter {
         $Name -eq $script:constants.ResourcePoolName -and $Location -eq $script:resourcePool
      } `
      -Verifiable

    $resourcePoolProperties
}

function New-MocksInGetWhenEnsurePresentAndNonExistingResourcePool {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]

    $resourcePoolProperties = New-ResourcePoolProperties

    $resourcePoolProperties.CpuExpandableReservation = $script:constants.CpuExpandableReservation
    $resourcePoolProperties.CpuLimitMHz = $script:constants.CpuLimitMHz
    $resourcePoolProperties.CpuReservationMHz = $script:constants.CpuReservationMHz
    $resourcePoolProperties.CpuSharesLevel = $script:constants.CpuSharesLevelCustom
    $resourcePoolProperties.NumCpuShares = $script:constants.NumCpuShares
    $resourcePoolProperties.MemExpandableReservation = $script:constants.MemExpandableReservation
    $resourcePoolProperties.MemLimitGB = $script:constants.MemLimitGB
    $resourcePoolProperties.MemReservationGB = $script:constants.MemReservationGB
    $resourcePoolProperties.MemSharesLevel = $script:constants.MemSharesLevelCustom
    $resourcePoolProperties.NumMemShares = $script:constants.NumMemShares

    $resourcePoolMock = $script:resourcePool

    Mock `
      -CommandName Get-Inventory -MockWith { return $resourcePoolMock }.GetNewClosure() `
      -ParameterFilter {
         $Server -eq $script:viServer -and $Name -eq $script:constants.InventoryItemLocationItemOne
      } `
      -Verifiable

    Mock `
      -CommandName Get-Inventory -MockWith { return $resourcePoolMock }.GetNewClosure() `
      -ParameterFilter {
         $Name -eq $script:constants.InventoryItemLocationItemTwo -and $Location -eq $script:resourcePool
      } `
      -Verifiable

    Mock `
      -CommandName Get-ResourcePool -MockWith { return $null }.GetNewClosure() `
      -ParameterFilter {
         $Name -eq $script:constants.ResourcePoolName -and $Location -eq $script:resourcePool
      } `
      -Verifiable

    $resourcePoolProperties
}
