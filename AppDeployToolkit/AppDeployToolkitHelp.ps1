<#
.SYNOPSIS
	Displays a graphical console to browse the help for the App Deployment Toolkit functions
    # LICENSE #
    PowerShell App Deployment Toolkit - Provides a set of functions to perform common application deployment tasks on Windows.
    Copyright (C) 2017 - Sean Lillis, Dan Cunningham, Muhammad Mashwani, Aman Motazedian.
    This program is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation, either version 3 of the License, or any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
    You should have received a copy of the GNU Lesser General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
.DESCRIPTION
	Displays a graphical console to browse the help for the App Deployment Toolkit functions
.EXAMPLE
	AppDeployToolkitHelp.ps1
.NOTES
.LINK
	http://psappdeploytoolkit.com
#>

##*===============================================
##* VARIABLE DECLARATION
##*===============================================

## Variables: Script
[string]$appDeployToolkitHelpName = 'PSAppDeployToolkitHelp'
[string]$appDeployHelpScriptFriendlyName = 'App Deploy Toolkit Help'
[version]$appDeployHelpScriptVersion = [version]'3.8.0'
[string]$appDeployHelpScriptDate = '23/09/2019'

## Variables: Environment
[string]$scriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
#  Dot source the App Deploy Toolkit Functions
. "$scriptDirectory\AppDeployToolkitMain.ps1" -DisableLogging

##*===============================================
##* END VARIABLE DECLARATION
##*===============================================

##*===============================================
##* FUNCTION LISTINGS
##*===============================================

Function Show-HelpConsole {
	## Import the Assemblies
	Add-Type -AssemblyName 'System.Windows.Forms' -ErrorAction 'Stop'
	Add-Type -AssemblyName System.Drawing -ErrorAction 'Stop'

	## Form Objects
	$HelpForm = New-Object -TypeName 'System.Windows.Forms.Form'
	$HelpListBox = New-Object -TypeName 'System.Windows.Forms.ListBox'
	$HelpTextBox = New-Object -TypeName 'System.Windows.Forms.RichTextBox'
	$InitialFormWindowState = New-Object -TypeName 'System.Windows.Forms.FormWindowState'

	## Form Code
	$System_Drawing_Size = New-Object -TypeName 'System.Drawing.Size'
	$System_Drawing_Size.Height = 665
	$System_Drawing_Size.Width = 957
	$HelpForm.ClientSize = $System_Drawing_Size
	$HelpForm.DataBindings.DefaultDataSourceUpdateMode = 0
	$HelpForm.Name = 'HelpForm'
	$HelpForm.Text = 'PowerShell App Deployment Toolkit Help Console'
	$HelpForm.WindowState = 'Normal'
	$HelpForm.ShowInTaskbar = $true
	$HelpForm.FormBorderStyle = 'Fixed3D'
	$HelpForm.MaximizeBox = $false
	$HelpForm.Icon = New-Object -TypeName 'System.Drawing.Icon' -ArgumentList $AppDeployLogoIcon
	$HelpListBox.Anchor = 7
	$HelpListBox.BorderStyle = 1
	$HelpListBox.DataBindings.DefaultDataSourceUpdateMode = 0
	$HelpListBox.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList ('Microsoft Sans Serif', 9.75, 1, 3, 1)
	$HelpListBox.FormattingEnabled = $true
	$HelpListBox.ItemHeight = 16
	$System_Drawing_Point = New-Object -TypeName 'System.Drawing.Point'
	$System_Drawing_Point.X = 0
	$System_Drawing_Point.Y = 0
	$HelpListBox.Location = $System_Drawing_Point
	$HelpListBox.Name = 'HelpListBox'
	$System_Drawing_Size = New-Object -TypeName 'System.Drawing.Size'
	$System_Drawing_Size.Height = 658
	$System_Drawing_Size.Width = 271
	$HelpListBox.Size = $System_Drawing_Size
	$HelpListBox.Sorted = $true
	$HelpListBox.TabIndex = 2
	$HelpListBox.add_SelectedIndexChanged({ $HelpTextBox.Text = Get-Help -Name $HelpListBox.SelectedItem -Full | Out-String })
	$helpFunctions = Get-Command -CommandType 'Function' | Where-Object { ($_.HelpUri -match 'psappdeploytoolkit') -and ($_.Definition -notmatch 'internal script function') } | Select-Object -ExpandProperty Name
	ForEach ($helpFunction in $helpFunctions) {
		$null = $HelpListBox.Items.Add($helpFunction)
	}
	$HelpForm.Controls.Add($HelpListBox)
	$HelpTextBox.Anchor = 11
	$HelpTextBox.BorderStyle = 1
	$HelpTextBox.DataBindings.DefaultDataSourceUpdateMode = 0
	$HelpTextBox.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList ('Microsoft Sans Serif', 8.5, 0, 3, 1)
	$HelpTextBox.ForeColor = [System.Drawing.Color]::FromArgb(255, 0, 0, 0)
	$System_Drawing_Point = New-Object -TypeName System.Drawing.Point
	$System_Drawing_Point.X = 277
	$System_Drawing_Point.Y = 0
	$HelpTextBox.Location = $System_Drawing_Point
	$HelpTextBox.Name = 'HelpTextBox'
	$HelpTextBox.ReadOnly = $True
	$System_Drawing_Size = New-Object -TypeName 'System.Drawing.Size'
	$System_Drawing_Size.Height = 658
	$System_Drawing_Size.Width = 680
	$HelpTextBox.Size = $System_Drawing_Size
	$HelpTextBox.TabIndex = 1
	$HelpTextBox.Text = ''
	$HelpForm.Controls.Add($HelpTextBox)

	## Save the initial state of the form
	$InitialFormWindowState = $HelpForm.WindowState
	## Init the OnLoad event to correct the initial state of the form
	$HelpForm.add_Load($OnLoadForm_StateCorrection)
	## Show the Form
	$null = $HelpForm.ShowDialog()
}

##*===============================================
##* END FUNCTION LISTINGS
##*===============================================

##*===============================================
##* SCRIPT BODY
##*===============================================

Write-Log -Message "Load [$appDeployHelpScriptFriendlyName] console..." -Source $appDeployToolkitHelpName

## Show the help console
Show-HelpConsole

Write-Log -Message "[$appDeployHelpScriptFriendlyName] console closed." -Source $appDeployToolkitHelpName

##*===============================================
##* END SCRIPT BODY
##*===============================================
# SIG # Begin signature block
# MIIZ7wYJKoZIhvcNAQcCoIIZ4DCCGdwCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAsQJM4ezULzhDh
# 5p/8Jo1d+ifDf+746xKNf2wq3+otOaCCFFwwggQUMIIC/KADAgECAgsEAAAAAAEv
# TuFS1zANBgkqhkiG9w0BAQUFADBXMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xv
# YmFsU2lnbiBudi1zYTEQMA4GA1UECxMHUm9vdCBDQTEbMBkGA1UEAxMSR2xvYmFs
# U2lnbiBSb290IENBMB4XDTExMDQxMzEwMDAwMFoXDTI4MDEyODEyMDAwMFowUjEL
# MAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExKDAmBgNVBAMT
# H0dsb2JhbFNpZ24gVGltZXN0YW1waW5nIENBIC0gRzIwggEiMA0GCSqGSIb3DQEB
# AQUAA4IBDwAwggEKAoIBAQCU72X4tVefoFMNNAbrCR+3Rxhqy/Bb5P8npTTR94ka
# v56xzRJBbmbUgaCFi2RaRi+ZoI13seK8XN0i12pn0LvoynTei08NsFLlkFvrRw7x
# 55+cC5BlPheWMEVybTmhFzbKuaCMG08IGfaBMa1hFqRi5rRAnsP8+5X2+7UulYGY
# 4O/F69gCWXh396rjUmtQkSnF/PfNk2XSYGEi8gb7Mt0WUfoO/Yow8BcJp7vzBK6r
# kOds33qp9O/EYidfb5ltOHSqEYva38cUTOmFsuzCfUomj+dWuqbgz5JTgHT0A+xo
# smC8hCAAgxuh7rR0BcEpjmLQR7H68FPMGPkuO/lwfrQlAgMBAAGjgeUwgeIwDgYD
# VR0PAQH/BAQDAgEGMBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFEbYPv/c
# 477/g+b0hZuw3WrWFKnBMEcGA1UdIARAMD4wPAYEVR0gADA0MDIGCCsGAQUFBwIB
# FiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAzBgNVHR8E
# LDAqMCigJqAkhiJodHRwOi8vY3JsLmdsb2JhbHNpZ24ubmV0L3Jvb3QuY3JsMB8G
# A1UdIwQYMBaAFGB7ZhpFDZfKiVAvfQTNNKj//P1LMA0GCSqGSIb3DQEBBQUAA4IB
# AQBOXlaQHka02Ukx87sXOSgbwhbd/UHcCQUEm2+yoprWmS5AmQBVteo/pSB204Y0
# 1BfMVTrHgu7vqLq82AafFVDfzRZ7UjoC1xka/a/weFzgS8UY3zokHtqsuKlYBAIH
# MNuwEl7+Mb7wBEj08HD4Ol5Wg889+w289MXtl5251NulJ4TjOJuLpzWGRCCkO22k
# aguhg/0o69rvKPbMiF37CjsAq+Ah6+IvNWwPjjRFl+ui95kzNX7Lmoq7RU3nP5/C
# 2Yr6ZbJux35l/+iS4SwxovewJzZIjyZvO+5Ndh95w+V/ljW8LQ7MAbCOf/9RgICn
# ktSzREZkjIdPFmMHMUtjsN/zMIIEnzCCA4egAwIBAgISESHWmadklz7x+EJ+6RnM
# U0EUMA0GCSqGSIb3DQEBBQUAMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9i
# YWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIFRpbWVzdGFtcGluZyBD
# QSAtIEcyMB4XDTE2MDUyNDAwMDAwMFoXDTI3MDYyNDAwMDAwMFowYDELMAkGA1UE
# BhMCU0cxHzAdBgNVBAoTFkdNTyBHbG9iYWxTaWduIFB0ZSBMdGQxMDAuBgNVBAMT
# J0dsb2JhbFNpZ24gVFNBIGZvciBNUyBBdXRoZW50aWNvZGUgLSBHMjCCASIwDQYJ
# KoZIhvcNAQEBBQADggEPADCCAQoCggEBALAXrqLTtgQwVh5YD7HtVaTWVMvY9nM6
# 7F1eqyX9NqX6hMNhQMVGtVlSO0KiLl8TYhCpW+Zz1pIlsX0j4wazhzoOQ/DXAIlT
# ohExUihuXUByPPIJd6dJkpfUbJCgdqf9uNyznfIHYCxPWJgAa9MVVOD63f+ALF8Y
# ppj/1KvsoUVZsi5vYl3g2Rmsi1ecqCYr2RelENJHCBpwLDOLf2iAKrWhXWvdjQIC
# KQOqfDe7uylOPVOTs6b6j9JYkxVMuS2rgKOjJfuv9whksHpED1wQ119hN6pOa9PS
# UyWdgnP6LPlysKkZOSpQ+qnQPDrK6Fvv9V9R9PkK2Zc13mqF5iMEQq8CAwEAAaOC
# AV8wggFbMA4GA1UdDwEB/wQEAwIHgDBMBgNVHSAERTBDMEEGCSsGAQQBoDIBHjA0
# MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0
# b3J5LzAJBgNVHRMEAjAAMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMIMEIGA1UdHwQ7
# MDkwN6A1oDOGMWh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3MvZ3N0aW1lc3Rh
# bXBpbmdnMi5jcmwwVAYIKwYBBQUHAQEESDBGMEQGCCsGAQUFBzAChjhodHRwOi8v
# c2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc3RpbWVzdGFtcGluZ2cyLmNy
# dDAdBgNVHQ4EFgQU1KKESjhaGH+6TzBQvZ3VeofWCfcwHwYDVR0jBBgwFoAURtg+
# /9zjvv+D5vSFm7DdatYUqcEwDQYJKoZIhvcNAQEFBQADggEBAI+pGpFtBKY3IA6D
# lt4j02tuH27dZD1oISK1+Ec2aY7hpUXHJKIitykJzFRarsa8zWOOsz1QSOW0zK7N
# ko2eKIsTShGqvaPv07I2/LShcr9tl2N5jES8cC9+87zdglOrGvbr+hyXvLY3nKQc
# MLyrvC1HNt+SIAPoccZY9nUFmjTwC1lagkQ0qoDkL4T2R12WybbKyp23prrkUNPU
# N7i6IA7Q05IqW8RZu6Ft2zzORJ3BOCqt4429zQl3GhC+ZwoCNmSIubMbJu7nnmDE
# Rqi8YTNsz065nLlq8J83/rU9T5rTTf/eII5Ol6b9nwm8TcoYdsmwTYVQ8oDSHQb1
# WAQHsRgwggWuMIIElqADAgECAhAHA3HRD3laQHGZK5QHYpviMA0GCSqGSIb3DQEB
# CwUAMHwxCzAJBgNVBAYTAlVTMQswCQYDVQQIEwJNSTESMBAGA1UEBxMJQW5uIEFy
# Ym9yMRIwEAYDVQQKEwlJbnRlcm5ldDIxETAPBgNVBAsTCEluQ29tbW9uMSUwIwYD
# VQQDExxJbkNvbW1vbiBSU0EgQ29kZSBTaWduaW5nIENBMB4XDTE4MDYyMTAwMDAw
# MFoXDTIxMDYyMDIzNTk1OVowgbkxCzAJBgNVBAYTAlVTMQ4wDAYDVQQRDAU4MDIw
# NDELMAkGA1UECAwCQ08xDzANBgNVBAcMBkRlbnZlcjEYMBYGA1UECQwPMTIwMSA1
# dGggU3RyZWV0MTAwLgYDVQQKDCdNZXRyb3BvbGl0YW4gU3RhdGUgVW5pdmVyc2l0
# eSBvZiBEZW52ZXIxMDAuBgNVBAMMJ01ldHJvcG9saXRhbiBTdGF0ZSBVbml2ZXJz
# aXR5IG9mIERlbnZlcjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMtX
# iSjEDjYNBIYXsPnFGHwZqvS5lgRNSaQjsyxgLsGI6yLLDCpaYy3CBwN1on4QnYzE
# QpsHV+TJ/3K61ZvqAxhR6Anw8TjVjaB3kPdtKJjEUlgiXNK0nDRyMVasZyeXALR5
# STSf1SxoMt8HIDd0KTB8yhME6ezFdFzwB5He2/jyOswfYsN+n4k2Q9UcaVtWgCzW
# ua39anwNva7M4GugPO5ZkF6XkrGzRHpXctV/Fk6LmqPY6sRm45nScnC1KQ3NN/t6
# ZBHzmAtgbZa41o5+AvNdkv9TVF6S3ODGpf3qKW8kjFt82LLYdZi0V07ln+S/BtAl
# GUPOvqem4EkbMtZ5M3MCAwEAAaOCAewwggHoMB8GA1UdIwQYMBaAFK41Ixf//wY9
# nFDgjCRlMx5wEIiiMB0GA1UdDgQWBBSl6YhuvPlIpfXzOIq+Y/mkDGObDzAOBgNV
# HQ8BAf8EBAMCB4AwDAYDVR0TAQH/BAIwADATBgNVHSUEDDAKBggrBgEFBQcDAzAR
# BglghkgBhvhCAQEEBAMCBBAwZgYDVR0gBF8wXTBbBgwrBgEEAa4jAQQDAgEwSzBJ
# BggrBgEFBQcCARY9aHR0cHM6Ly93d3cuaW5jb21tb24ub3JnL2NlcnQvcmVwb3Np
# dG9yeS9jcHNfY29kZV9zaWduaW5nLnBkZjBJBgNVHR8EQjBAMD6gPKA6hjhodHRw
# Oi8vY3JsLmluY29tbW9uLXJzYS5vcmcvSW5Db21tb25SU0FDb2RlU2lnbmluZ0NB
# LmNybDB+BggrBgEFBQcBAQRyMHAwRAYIKwYBBQUHMAKGOGh0dHA6Ly9jcnQuaW5j
# b21tb24tcnNhLm9yZy9JbkNvbW1vblJTQUNvZGVTaWduaW5nQ0EuY3J0MCgGCCsG
# AQUFBzABhhxodHRwOi8vb2NzcC5pbmNvbW1vbi1yc2Eub3JnMC0GA1UdEQQmMCSB
# Iml0c3N5c3RlbWVuZ2luZWVyaW5nQG1zdWRlbnZlci5lZHUwDQYJKoZIhvcNAQEL
# BQADggEBAIc2PVq7BamWAujyCQPHsGCDbM3i1OY5nruA/fOtbJ6mJvT9UJY4+61g
# rcHLzV7op1y0nRhV459TrKfHKO42uRyZpdnHaOoC080cfg/0EwFJRy3bYB0vkVP8
# TeUkvUhbtcPVofI1P/wh9ZT2iYVCerOOAqivxWqh8Dt+8oSbjSGhPFWyu04b8Ucz
# bK/97uXdgK0zNcXDJUjMKr6CbevfLQLfQiFPizaej+2fvR/jZHAvxO9W2rhd6Nw6
# gFs2q3P4CFK0+yAkFCLk+9wsp+RsRvRkvdWJp+anNvAKOyVfCj6sz5dQPAIYIyLh
# y9ze3taVKm99DQQZV/wN/ATPDftLGm0wggXrMIID06ADAgECAhBl4eLj1d5QRYXz
# JiSABeLUMA0GCSqGSIb3DQEBDQUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMK
# TmV3IEplcnNleTEUMBIGA1UEBxMLSmVyc2V5IENpdHkxHjAcBgNVBAoTFVRoZSBV
# U0VSVFJVU1QgTmV0d29yazEuMCwGA1UEAxMlVVNFUlRydXN0IFJTQSBDZXJ0aWZp
# Y2F0aW9uIEF1dGhvcml0eTAeFw0xNDA5MTkwMDAwMDBaFw0yNDA5MTgyMzU5NTla
# MHwxCzAJBgNVBAYTAlVTMQswCQYDVQQIEwJNSTESMBAGA1UEBxMJQW5uIEFyYm9y
# MRIwEAYDVQQKEwlJbnRlcm5ldDIxETAPBgNVBAsTCEluQ29tbW9uMSUwIwYDVQQD
# ExxJbkNvbW1vbiBSU0EgQ29kZSBTaWduaW5nIENBMIIBIjANBgkqhkiG9w0BAQEF
# AAOCAQ8AMIIBCgKCAQEAwKAvix56u2p1rPg+3KO6OSLK86N25L99MCfmutOYMlYj
# XAaGlw2A6O2igTXrC/Zefqk+aHP9ndRnec6q6mi3GdscdjpZh11emcehsriphHMM
# zKuHRhxqx+85Jb6n3dosNXA2HSIuIDvd4xwOPzSf5X3+VYBbBnyCV4RV8zj78gw2
# qblessWBRyN9EoGgwAEoPgP5OJejrQLyAmj91QGr9dVRTVDTFyJG5XMY4DrkN3dR
# yJ59UopPgNwmucBMyvxR+hAJEXpXKnPE4CEqbMJUvRw+g/hbqSzx+tt4z9mJmm2j
# /w2nP35MViPWCb7hpR2LB8W/499Yqu+kr4LLBfgKCQIDAQABo4IBWjCCAVYwHwYD
# VR0jBBgwFoAUU3m/WqorSs9UgOHYm8Cd8rIDZsswHQYDVR0OBBYEFK41Ixf//wY9
# nFDgjCRlMx5wEIiiMA4GA1UdDwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEA
# MBMGA1UdJQQMMAoGCCsGAQUFBwMDMBEGA1UdIAQKMAgwBgYEVR0gADBQBgNVHR8E
# STBHMEWgQ6BBhj9odHRwOi8vY3JsLnVzZXJ0cnVzdC5jb20vVVNFUlRydXN0UlNB
# Q2VydGlmaWNhdGlvbkF1dGhvcml0eS5jcmwwdgYIKwYBBQUHAQEEajBoMD8GCCsG
# AQUFBzAChjNodHRwOi8vY3J0LnVzZXJ0cnVzdC5jb20vVVNFUlRydXN0UlNBQWRk
# VHJ1c3RDQS5jcnQwJQYIKwYBBQUHMAGGGWh0dHA6Ly9vY3NwLnVzZXJ0cnVzdC5j
# b20wDQYJKoZIhvcNAQENBQADggIBAEYstn9qTiVmvZxqpqrQnr0Prk41/PA4J8HH
# nQTJgjTbhuET98GWjTBEE9I17Xn3V1yTphJXbat5l8EmZN/JXMvDNqJtkyOh26ow
# AmvquMCF1pKiQWyuDDllxR9MECp6xF4wnH1Mcs4WeLOrQPy+C5kWE5gg/7K6c9G1
# VNwLkl/po9ORPljxKKeFhPg9+Ti3JzHIxW7LdyljffccWiuNFR51/BJHAZIqUDw3
# LsrdYWzgg4x06tgMvOEf0nITelpFTxqVvMtJhnOfZbpdXZQ5o1TspxfTEVOQAsp0
# 5HUNCXyhznlVLr0JaNkM7edgk59zmdTbSGdMq8Ztuu6VyrivOlMSPWmay5MjvwTz
# uNorbwBv0DL+7cyZBp7NYZou+DoGd1lFZN0jU5IsQKgm3+00pnnJ67crdFwfz/8b
# q3MhTiKOWEb04FT3OZVp+jzvaChHWLQ8gbCORgClaZq1H3aqI7JeRkWEEEp6Tv4W
# AVsr/i7LoXU72gOb8CAzPFqwI4Excdrxp0I4OXbECHlDqU4sTInqwlMwofmxeO4u
# 94196qIqJQl+8Sykl06VktqMux84Iw3ZQLH08J8LaJ+WDUycc4OjY61I7FGxCDkb
# SQf3npXeRFm0IBn8GiW+TRDk6J2XJFLWEtVZmhboFlBLoUlqHUCKu0QOhU/+AEOq
# nY98j2zRMYIE6TCCBOUCAQEwgZAwfDELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAk1J
# MRIwEAYDVQQHEwlBbm4gQXJib3IxEjAQBgNVBAoTCUludGVybmV0MjERMA8GA1UE
# CxMISW5Db21tb24xJTAjBgNVBAMTHEluQ29tbW9uIFJTQSBDb2RlIFNpZ25pbmcg
# Q0ECEAcDcdEPeVpAcZkrlAdim+IwDQYJYIZIAWUDBAIBBQCggYQwGAYKKwYBBAGC
# NwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgor
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQg4C1p1k3u
# Ec/MHzMgSrbNDhWYv0Hfa7CgugZHYzRHm1EwDQYJKoZIhvcNAQEBBQAEggEAab1W
# qZ17E9kPegeTbbKC5ckPCA2ii1O20aCBlCAV/RCDKvFj6DMWgSqr9QKX6cgYkwiU
# MyVZSMnzDKH0+7MqWCIfbb/W3AG5qBOTxk+fKri5bR+S/Ld806GrNwZw1mJnkavv
# +tt/u/hZFGmXkjVF/pOWjVgd09Joktq2ONB5I9ugKXIYL/qG7tEkG2hiZoL+X+uO
# RG9pDDA4GBpRtIp/gk6xP8NGvXsNHMvoKd4ZxR3JdUwoUkX8hRlyDFYPND96nDJq
# PKDlAH/zrGe8fGYglX1MR1KIvUrVFo/MOgzl+UVr0/3EQgNwhelWhe2HFY2b5axe
# rWerlD2x4O9md7RKj6GCAqIwggKeBgkqhkiG9w0BCQYxggKPMIICiwIBATBoMFIx
# CzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQD
# Ex9HbG9iYWxTaWduIFRpbWVzdGFtcGluZyBDQSAtIEcyAhIRIdaZp2SXPvH4Qn7p
# GcxTQRQwCQYFKw4DAhoFAKCB/TAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwG
# CSqGSIb3DQEJBTEPFw0yMDA0MTMxNDMwMzdaMCMGCSqGSIb3DQEJBDEWBBR7w9Q1
# mSp9C2TPym/3bNYrg3GH9zCBnQYLKoZIhvcNAQkQAgwxgY0wgYowgYcwgYQEFGO4
# L6th9YOQlpUFCwAknFApM+x5MGwwVqRUMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQK
# ExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIFRpbWVzdGFt
# cGluZyBDQSAtIEcyAhIRIdaZp2SXPvH4Qn7pGcxTQRQwDQYJKoZIhvcNAQEBBQAE
# ggEASyZ7u55hTSniHn0iEaJVb9SsW4vcio8BT7EluJO7JhV1StUhJCuTkm+/6oKG
# cv70E7zNiu5t+7U4EbKrjHFUlveJIKqg7ks+mUojakSYRzqRiiRbb8IIf+RjR7Wt
# /bGAeysvGCkYX3bnoa3DtzvXhdrF4gvss21Uvmtzee6bWfdqZ91gHQWWuCGI/mbg
# 1EE6pa2bfqbMlNCkCgkZGyJVXW3nIJSEjE4lOzK19JVochEq5XImdH4luwBTPRAK
# LL4kD1dN+NSrWA3+Dahb5+u5Lrl2qldD1PSwk6ky1iXXgTvNzJtMWf2sqD6HE0TE
# N1DgRRPwrQLf3mU0yq1gIcmiQA==
# SIG # End signature block
