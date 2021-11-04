<#
Copyright (c) 2018-2021 VMware, Inc.  All rights reserved

The BSD-2 license (the "License") set forth below applies to all parts of the Desired State Configuration Resources for VMware project.  You may not use this file except in compliance with the License.

BSD-2 License

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#>

Using module '..\..\VMware.vSphereDSC.psm1'

$script:moduleName = 'VMware.vSphereDSC'

InModuleScope -ModuleName $script:moduleName {
    try {
        $unitTestsFolder = Join-Path (Join-Path (Get-Module VMware.vSphereDSC -ListAvailable).ModuleBase 'Tests') 'Unit'
        $modulePath = $env:PSModulePath
        $resourceName = 'ResourcePool'

        . "$unitTestsFolder\TestHelpers\TestUtils.ps1"

        # Calls the function to Import the mocked VMware.VimAutomation.Core module before all tests.
        Invoke-TestSetup

        . "$unitTestsFolder\TestHelpers\Mocks\MockData.ps1"
        . "$unitTestsFolder\TestHelpers\Mocks\ResourcePoolMocks.ps1"


        Describe 'ResourcePool\Set' -Tag 'Set' {
            BeforeAll {
                # Arrange
                New-MocksForResourcePool
            }

            Context 'Invoking with Ensure Present, non existing ResourcePool and no other settings specified' {
                BeforeAll {
                    # Arrange
                    $resourceProperties = New-MocksWhenEnsurePresentNonExistingResourcePoolParentIsResourcePool
                    $resource = New-Object -TypeName $resourceName -Property $resourceProperties
                }

                It 'Should call all defined mocks' {
                    # Act
                    $resource.Set()

                    # Assert
                    Assert-VerifiableMock
                }

                It 'Should call the New-ResourcePool mock' {
                    # Act
                    $resource.Set()

                    # Assert
                    $assertMockCalledParams = @{
                        CommandName = 'New-ResourcePool'
                        ParameterFilter = { $Server -eq $script:viServer -and $Name -eq $resourceProperties.ResourcePoolName -and $Location -eq $script:resourcePool -and !$Confirm }
                        Exactly = $true
                        Times = 1
                        Scope = 'It'
                    }

                    Assert-MockCalled @assertMockCalledParams
                }
            }

            Context 'Invoking with Ensure Present, non existing ResourcePool and all settings specified' {
                BeforeAll {
                    # Arrange
                    $resourceProperties = New-MocksWhenEnsurePresentNonExistingResourcePoolandAllSettingsSpecified
                    $resource = New-Object -TypeName $resourceName -Property $resourceProperties
                }

                It 'Should call all defined mocks' {
                    # Act
                    $resource.Set()

                    # Assert
                    Assert-VerifiableMock
                }

                
                It 'Should call the New-ResourcePool mock with all settings specified once' {
                    # Act
                    $resource.Set()

                    # Assert
                    $assertMockCalledParams = @{

                        CommandName = 'New-ResourcePool'
                        ParameterFilter = { 
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
                        }
                        Exactly = $true
                        Times = 1
                        Scope = 'It'
                    }

                    Assert-MockCalled @assertMockCalledParams
                }
            }

            Context 'Invoking with Ensure Present, existing ResourcePool, only Name and Location specified' {
                BeforeAll {
                    # Arrange
                    $resourceProperties = New-MocksWhenEnsurePresentExistingResourcePoolOnlyNameAndLocationSpecified
                    $resource = New-Object -TypeName $resourceName -Property $resourceProperties
                }

                It 'Should call all defined mocks' {
                    # Act
                    $resource.Set()

                    # Assert
                    Assert-VerifiableMock
                }

                
                It 'Should call the Set-ResourcePool mock specified once' {
                    # Act
                    $resource.Set()

                    # Assert
                    
                    $assertMockCalledParams = @{
                        CommandName = 'Set-ResourcePool'
                        ParameterFilter = { 
                           $ResourcePool -eq $script:resourcePool
                        }
                        Exactly = $true
                        Times = 1
                        Scope = 'It'
                    }

                    Assert-MockCalled @assertMockCalledParams
                }
            }

            Context 'Invoking with Ensure Present, existing ResourcePool and all specified' {
                BeforeAll {
                    # Arrange
                    $resourceProperties = New-MocksWhenEnsurePresentExistingResourcePoolAndAllSettingsSpecified
                    $resource = New-Object -TypeName $resourceName -Property $resourceProperties
                }

                It 'Should call all defined mocks' {
                    # Act
                    $resource.Set()

                    # Assert
                    Assert-VerifiableMock
                }

                It 'Should call the Set-ResourcePool mock with all settings specified once' {
                    # Act
                    $resource.Set()

                    # Assert
                    $assertMockCalledParams = @{
                        CommandName = 'Set-ResourcePool'
                        ParameterFilter = { 
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
                        }
                        Exactly = $true
                        Times = 1
                        Scope = 'It'
                    }

                    Assert-MockCalled @assertMockCalledParams
                }
            }

            Context 'Invoking with Ensure Absent and existing ResourcePool' {
                BeforeAll {
                    # Arrange
                    $resourceProperties = New-MocksWhenEnsureAbsentAndExistingResourcePool
                    $resource = New-Object -TypeName $resourceName -Property $resourceProperties
                }

                It 'Should call all defined mocks' {
                    # Act
                    $resource.Set()

                    # Assert
                    Assert-VerifiableMock
                }

                It 'Should call the Remove-ResourcePool mock once' {
                    # Act
                    $resource.Set()

                    # Assert
                    $assertMockCalledParams = @{
                        CommandName = 'Remove-ResourcePool'
                        ParameterFilter = { $ResourcePool -eq $script:resourcePool -and $Server -eq $script:viServer -and !$Confirm }
                        Exactly = $true
                        Times = 1
                        Scope = 'It'
                    }

                    Assert-MockCalled @assertMockCalledParams
                }
            }

            Context 'Invoking with Ensure Absent and non existing ResourcePool' {
                BeforeAll {
                    # Arrange
                    $resourceProperties = New-MocksWhenEnsureAbsentAndNonExistingResourcePool
                    $resource = New-Object -TypeName $resourceName -Property $resourceProperties
                }

                It 'Should call all defined mocks' {
                    # Act
                    $resource.Set()

                    # Assert
                    Assert-VerifiableMock
                }

                It 'Should not call the Remove-ResourcePool mock' {
                    # Act
                    $resource.Set()

                    # Assert
                    $assertMockCalledParams = @{
                        CommandName = 'Remove-ResourcePool'
                        ParameterFilter = { $ResourcePool -eq $script:resourcePool -and $Server -eq $script:viServer -and !$Confirm }
                        Exactly = $true
                        Times = 0
                        Scope = 'It'
                    }

                    Assert-MockCalled @assertMockCalledParams
                }
            }
        }

        Describe 'ResourcePool\Test' -Tag 'Test' {
            BeforeAll {
                # Arrange
                New-MocksForResourcePool
            }

            Context 'Invoking with Ensure Present and non existing ResourcePool' {
                BeforeAll {
                    # Arrange
                    $resourceProperties = New-MocksWhenEnsurePresentAndNonExistingResourcePool
                    $resource = New-Object -TypeName $resourceName -Property $resourceProperties
                }

                It 'Should call all defined mocks' {
                    # Act
                    $resource.Test()

                    # Assert
                    Assert-VerifiableMock
                }

                It 'Should return $false when the ResourcePool does not exist' {
                    # Act
                    $result = $resource.Test()

                    # Assert
                    $result | Should -Be $false
                }
            }

            Context 'Invoking with Ensure Present, existing ResourcePool and matching settings' {
                BeforeAll {
                    # Arrange
                    $resourceProperties = New-MocksWhenEnsurePresentExistingResourcePoolAndMatchingSettings
                    $resource = New-Object -TypeName $resourceName -Property $resourceProperties
                }

                It 'Should call all defined mocks' {
                    # Act
                    $resource.Test()

                    # Assert
                    Assert-VerifiableMock
                }

                It 'Should return $true when the ResourcePool exists and all settings are equal' {
                    # Act
                    $result = $resource.Test()

                    # Assert
                    $result | Should -Be $true
                }
            }

            Context 'Invoking with Ensure Present, existing ResourcePool and non matching CpuExpandableReservation' {
                BeforeAll {
                    # Arrange
                    $resourceProperties = New-MocksWhenEnsurePresentExistingResourcePoolAndNonMatchingSetting 'CpuExpandableReservation'
                    $resource = New-Object -TypeName $resourceName -Property $resourceProperties
                }

                It 'Should call all defined mocks' {
                    # Act
                    $resource.Test()

                    # Assert
                    Assert-VerifiableMock
                }

                It 'Should return $false when the ResourcePool exists and CpuExpandableReservation setting is not equal' {
                    # Act
                    $result = $resource.Test()

                    # Assert
                    $result | Should -Be $false
                }
            }
            
            Context 'Invoking with Ensure Present, existing ResourcePool and non matching CpuLimitMHz' {
                BeforeAll {
                    # Arrange
                    $resourceProperties = New-MocksWhenEnsurePresentExistingResourcePoolAndNonMatchingSetting 'CpuLimitMHz'
                    $resource = New-Object -TypeName $resourceName -Property $resourceProperties
                }

                It 'Should call all defined mocks' {
                    # Act
                    $resource.Test()

                    # Assert
                    Assert-VerifiableMock
                }

                It 'Should return $false when the ResourcePool exists and CpuLimitMHz setting is not equal' {
                    # Act
                    $result = $resource.Test()

                    # Assert
                    $result | Should -Be $false
                }
            }
            
            Context 'Invoking with Ensure Present, existing ResourcePool and non matching CpuReservationMHz' {
                BeforeAll {
                    # Arrange
                    $resourceProperties = New-MocksWhenEnsurePresentExistingResourcePoolAndNonMatchingSetting 'CpuReservationMHz'
                    $resource = New-Object -TypeName $resourceName -Property $resourceProperties
                }

                It 'Should call all defined mocks' {
                    # Act
                    $resource.Test()

                    # Assert
                    Assert-VerifiableMock
                }

                It 'Should return $false when the ResourcePool exists and CpuReservationMHz setting is not equal' {
                    # Act
                    $result = $resource.Test()

                    # Assert
                    $result | Should -Be $false
                }
            }
            
            Context 'Invoking with Ensure Present, existing ResourcePool and non matching CpuSharesLevel' {
                BeforeAll {
                    # Arrange
                    $resourceProperties = New-MocksWhenEnsurePresentExistingResourcePoolAndNonMatchingSetting 'CpuSharesLevel'
                    $resource = New-Object -TypeName $resourceName -Property $resourceProperties
                }

                It 'Should call all defined mocks' {
                    # Act
                    $resource.Test()

                    # Assert
                    Assert-VerifiableMock
                }

                It 'Should return $false when the ResourcePool exists and CpuSharesLevel setting is not equal' {
                    # Act
                    $result = $resource.Test()

                    # Assert
                    $result | Should -Be $false
                }
            }
            
            Context 'Invoking with Ensure Present, existing ResourcePool and non matching NumCpuShares' {
                BeforeAll {
                    # Arrange
                    $resourceProperties = New-MocksWhenEnsurePresentExistingResourcePoolAndNonMatchingSetting 'NumCpuShares'
                    $resource = New-Object -TypeName $resourceName -Property $resourceProperties
                }

                It 'Should call all defined mocks' {
                    # Act
                    $resource.Test()

                    # Assert
                    Assert-VerifiableMock
                }

                It 'Should return $false when the ResourcePool exists and NumCpuShares setting is not equal' {
                    # Act
                    $result = $resource.Test()

                    # Assert
                    $result | Should -Be $false
                }
            }
            
            Context 'Invoking with Ensure Present, existing ResourcePool and non matching MemExpandableReservation' {
                BeforeAll {
                    # Arrange
                    $resourceProperties = New-MocksWhenEnsurePresentExistingResourcePoolAndNonMatchingSetting 'MemExpandableReservation'
                    $resource = New-Object -TypeName $resourceName -Property $resourceProperties
                }

                It 'Should call all defined mocks' {
                    # Act
                    $resource.Test()

                    # Assert
                    Assert-VerifiableMock
                }

                It 'Should return $false when the ResourcePool exists and MemExpandableReservation setting is not equal' {
                    # Act
                    $result = $resource.Test()

                    # Assert
                    $result | Should -Be $false
                }
            }

            Context 'Invoking with Ensure Present, existing ResourcePool and non matching MemLimitGB' {
                BeforeAll {
                    # Arrange
                    $resourceProperties = New-MocksWhenEnsurePresentExistingResourcePoolAndNonMatchingSetting 'MemLimitGB'
                    $resource = New-Object -TypeName $resourceName -Property $resourceProperties
                }

                It 'Should call all defined mocks' {
                    # Act
                    $resource.Test()

                    # Assert
                    Assert-VerifiableMock
                }

                It 'Should return $false when the ResourcePool exists and MemLimitGB setting is not equal' {
                    # Act
                    $result = $resource.Test()

                    # Assert
                    $result | Should -Be $false
                }
            }            

            Context 'Invoking with Ensure Present, existing ResourcePool and non matching MemReservationGB' {
                BeforeAll {
                    # Arrange
                    $resourceProperties = New-MocksWhenEnsurePresentExistingResourcePoolAndNonMatchingSetting 'MemReservationGB'
                    $resource = New-Object -TypeName $resourceName -Property $resourceProperties
                }

                It 'Should call all defined mocks' {
                    # Act
                    $resource.Test()

                    # Assert
                    Assert-VerifiableMock
                }

                It 'Should return $false when the ResourcePool exists and MemReservationGB setting is not equal' {
                    # Act
                    $result = $resource.Test()

                    # Assert
                    $result | Should -Be $false
                }
            }

            Context 'Invoking with Ensure Present, existing ResourcePool and non matching MemSharesLevel' {
                BeforeAll {
                    # Arrange
                    $resourceProperties = New-MocksWhenEnsurePresentExistingResourcePoolAndNonMatchingSetting 'MemSharesLevel'
                    $resource = New-Object -TypeName $resourceName -Property $resourceProperties
                }

                It 'Should call all defined mocks' {
                    # Act
                    $resource.Test()

                    # Assert
                    Assert-VerifiableMock
                }

                It 'Should return $false when the ResourcePool exists and MemSharesLevel setting is not equal' {
                    # Act
                    $result = $resource.Test()

                    # Assert
                    $result | Should -Be $false
                }
            }
            
            Context 'Invoking with Ensure Present, existing ResourcePool and non matching NumMemShares' {
                BeforeAll {
                    # Arrange
                    $resourceProperties = New-MocksWhenEnsurePresentExistingResourcePoolAndNonMatchingSetting 'NumMemShares'
                    $resource = New-Object -TypeName $resourceName -Property $resourceProperties
                }

                It 'Should call all defined mocks' {
                    # Act
                    $resource.Test()

                    # Assert
                    Assert-VerifiableMock
                }

                It 'Should return $false when the ResourcePool exists and NumMemShares setting is not equal' {
                    # Act
                    $result = $resource.Test()

                    # Assert
                    $result | Should -Be $false
                }
            }
            
            Context 'Invoking with Ensure Absent and non existing ResourcePool' {
                BeforeAll {
                    # Arrange
                    $resourceProperties = New-MocksWhenEnsureAbsentAndNonExistingResourcePool
                    $resource = New-Object -TypeName $resourceName -Property $resourceProperties
                }

                It 'Should call all defined mocks' {
                    # Act
                    $resource.Test()

                    # Assert
                    Assert-VerifiableMock
                }

                It 'Should return $true when the Cluster does not exist' {
                    # Act
                    $result = $resource.Test()

                    # Assert
                    $result | Should -Be $true
                }
            }

            
            Context 'Invoking with Ensure Absent and existing ResourcePool' {
                BeforeAll {
                    # Arrange
                    $resourceProperties = New-MocksInTestWhenEnsureAbsentAndExistingResourcePool
                    $resource = New-Object -TypeName $resourceName -Property $resourceProperties
                }

                It 'Should call all defined mocks' {
                    # Act
                    $resource.Test()

                    # Assert
                    Assert-VerifiableMock
                }

                It 'Should return $false when the Cluster exists' {
                    # Act
                    $result = $resource.Test()

                    # Assert
                    $result | Should -Be $false
                }
            }
        }

        Describe 'ResourcePool\Get' -Tag 'Get' {
            BeforeAll {
                # Arrange
                New-MocksForResourcePool
            }

            Context 'Invoking with Ensure Present and non existing ResourcePool' {
                BeforeAll {
                    # Arrange
                    $resourceProperties = New-MocksInGetWhenEnsurePresentAndNonExistingResourcePool
                    $resource = New-Object -TypeName $resourceName -Property $resourceProperties
                }

                It 'Should call all defined mocks' {
                    # Act
                    $resource.Get()

                    # Assert
                    Assert-VerifiableMock
                }

                It 'Should retrieve the correct settings from the Resource properties and Ensure should be set to Absent' {
                    # Act
                    $result = $resource.Get()

                    # Assert
                    $result.Ensure | Should -Be 'Absent'
                    $result.Server | Should -Be $resourceProperties.Server
                    $result.ResourcePoolName | Should -Be $resourceProperties.ResourcePoolName
                    $result.ResourcePoolLocation | Should -Be $resourceProperties.ResourcePoolLocation
                    $result.CpuExpandableReservation | Should -Be $resourceProperties.CpuExpandableReservation
                    $result.CpuLimitMHz | Should -Be $resourceProperties.CpuLimitMHz
                    $result.CpuReservationMHz | Should -Be $resourceProperties.CpuReservationMHz
                    $result.CpuSharesLevel | Should -Be $resourceProperties.CpuSharesLevel
                    $result.NumCpuShares | Should -Be $resourceProperties.NumCpuShares
                    $result.MemExpandableReservation | Should -Be $resourceProperties.MemExpandableReservation
                    $result.MemLimitGB | Should -Be $resourceProperties.MemLimitGB
                    $result.MemReservationGB | Should -Be $resourceProperties.MemReservationGB
                    $result.MemSharesLevel | Should -Be $resourceProperties.MemSharesLevel
                    $result.NumMemShares | Should -Be $resourceProperties.NumMemShares
                }
            }

            Context 'Invoking with Ensure Present and existing ResourcePool' {
                BeforeAll {
                    # Arrange
                    $resourceProperties = New-MocksWhenEnsurePresentExistingResourcePoolAndMatchingSettings
                    $resource = New-Object -TypeName $resourceName -Property $resourceProperties
                }

                It 'Should call all defined mocks' {
                    # Act
                    $resource.Get()

                    # Assert
                    Assert-VerifiableMock
                }

                It 'Should retrieve the correct settings from the Server and Ensure should be set to Present' {
                    # Act
                    $result = $resource.Get()

                    # Assert
                    $result.Server | Should -Be $resourceProperties.Server
                    $result.ResourcePoolName | Should -Be $resourceProperties.ResourcePoolName
                    $result.ResourcePoolLocation | Should -Be $resourceProperties.ResourcePoolLocation
                    $result.CpuExpandableReservation | Should -Be $resourceProperties.CpuExpandableReservation
                    $result.CpuLimitMHz | Should -Be $resourceProperties.CpuLimitMHz
                    $result.CpuReservationMHz | Should -Be $resourceProperties.CpuReservationMHz
                    $result.CpuSharesLevel | Should -Be $resourceProperties.CpuSharesLevel
                    $result.NumCpuShares | Should -Be $resourceProperties.NumCpuShares
                    $result.MemExpandableReservation | Should -Be $resourceProperties.MemExpandableReservation
                    $result.MemLimitGB | Should -Be $resourceProperties.MemLimitGB
                    $result.MemReservationGB | Should -Be $resourceProperties.MemReservationGB
                    $result.MemSharesLevel | Should -Be $resourceProperties.MemSharesLevel
                    $result.NumMemShares | Should -Be $resourceProperties.NumMemShares
                }
            }

            Context 'Invoking with Ensure Absent and non existing ResourcePool' {
                BeforeAll {
                    # Arrange
                    $resourceProperties = New-MocksInGetWhenEnsurePresentAndNonExistingResourcePool
                    $resourceProperties.Ensure = 'Absent'
                    $resource = New-Object -TypeName $resourceName -Property $resourceProperties
                }

                It 'Should call all defined mocks' {
                    # Act
                    $resource.Get()

                    # Assert
                    Assert-VerifiableMock
                }

                It 'Should retrieve the correct settings from the Resource properties and Ensure should be set to Absent' {
                    # Act
                    $result = $resource.Get()

                    # Assert
                    $result.Server | Should -Be $resourceProperties.Server
                    $result.ResourcePoolName | Should -Be $resourceProperties.ResourcePoolName
                    $result.ResourcePoolLocation | Should -Be $resourceProperties.ResourcePoolLocation
                    $result.CpuExpandableReservation | Should -Be $resourceProperties.CpuExpandableReservation
                    $result.CpuLimitMHz | Should -Be $resourceProperties.CpuLimitMHz
                    $result.CpuReservationMHz | Should -Be $resourceProperties.CpuReservationMHz
                    $result.CpuSharesLevel | Should -Be $resourceProperties.CpuSharesLevel
                    $result.NumCpuShares | Should -Be $resourceProperties.NumCpuShares
                    $result.MemExpandableReservation | Should -Be $resourceProperties.MemExpandableReservation
                    $result.MemLimitGB | Should -Be $resourceProperties.MemLimitGB
                    $result.MemReservationGB | Should -Be $resourceProperties.MemReservationGB
                    $result.MemSharesLevel | Should -Be $resourceProperties.MemSharesLevel
                    $result.NumMemShares | Should -Be $resourceProperties.NumMemShares
                }
            }

            Context 'Invoking with Ensure Absent and existing ResourcePool' {
                BeforeAll {
                    # Arrange
                    $resourceProperties = New-MocksWhenEnsurePresentExistingResourcePoolAndMatchingSettings
                    $resourceProperties.Ensure = 'Absent'
                    $resource = New-Object -TypeName $resourceName -Property $resourceProperties
                }

                It 'Should call all defined mocks' {
                    # Act
                    $resource.Get()

                    # Assert
                    Assert-VerifiableMock
                }

                It 'Should retrieve the correct settings from the Server and Ensure should be set to Present' {
                    # Act
                    $result = $resource.Get()

                    # Assert
                    $result.Server | Should -Be $resourceProperties.Server
                    $result.ResourcePoolName | Should -Be $resourceProperties.ResourcePoolName
                    $result.ResourcePoolLocation | Should -Be $resourceProperties.ResourcePoolLocation
                    $result.CpuExpandableReservation | Should -Be $resourceProperties.CpuExpandableReservation
                    $result.CpuLimitMHz | Should -Be $resourceProperties.CpuLimitMHz
                    $result.CpuReservationMHz | Should -Be $resourceProperties.CpuReservationMHz
                    $result.CpuSharesLevel | Should -Be $resourceProperties.CpuSharesLevel
                    $result.NumCpuShares | Should -Be $resourceProperties.NumCpuShares
                    $result.MemExpandableReservation | Should -Be $resourceProperties.MemExpandableReservation
                    $result.MemLimitGB | Should -Be $resourceProperties.MemLimitGB
                    $result.MemReservationGB | Should -Be $resourceProperties.MemReservationGB
                    $result.MemSharesLevel | Should -Be $resourceProperties.MemSharesLevel
                    $result.NumMemShares | Should -Be $resourceProperties.NumMemShares
                }
            }
        }
    }
    finally {
        # Calls the function to Remove the mocked VMware.VimAutomation.Core module after all tests.
        Invoke-TestCleanup -ModulePath $modulePath
    }
}
