#
# Cookbook Name:: adfs
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# node.default['afds']['primary'] = true


windows_package "KB974408" do
    logtime = Time.now.getutc.strftime("%Y_%m_%d_%H-%M-%S")
    #http://www.microsoft.com/en-us/download/confirmation.aspx?id=10909
    #AdfsSetup.exe /quiet /logfile ADFS_Setup_Primary_installtime.log
    source "http://download.microsoft.com/download/F/3/D/F3D66A7E-C974-4A60-B7A5-382A61EB7BC6/RTW/W2K8R2/amd64/AdfsSetup.exe"
    options "/quiet /logfile c:\\ADFS_Setup_Primary_#{logtime}.log"
    installer_type :custom
    # idempotence - if get-hotfix xxx -eq true adfs aleady installed
    # action :nothing
    # if(get-hotfix | ? {$_.hotfixid -like 'KB974408'}){"bla"}
    action :nothing
end


windows_features "IIS-ManagementScriptingTools" 
# do
    # PKGMGR.EXE /l:log.etw /iu:IIS-ManagementScriptingTools
# end


# .net 4.0 comes from include recipe
# powershell_script "dot net 4.0" do
    # code "add-windowsfeature dotnet 4.0"
    # or dotNetFx40_Full_x86_x64.exe /q /norestart /log '+$dotNetlogfile
    # source2 "http://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe"  
# end


# is there something for certificates in windows cookbook?
powershell_script "install IIS cert" do
    # code "install certificate #{node['iis']['ssl_certificate']}"
end


powershell_script "install ADFS signing cert" do
    # code "install certificate #{node['adfs']['signing_cert']}"
end


powershell_script"install ADFS decrypting cert" do
    # code "install certificate #{node['adfs']['decrypting_cert']}"
end


powershell_script "assing SSL cert to IIS" do
	code <<-EOH 
    # step 5 - Remove / Recreate SSL binding on default web site.
	Remove-WebBinding  -Name "Default Web Site" -IP "*" -Port 443 -Protocol https

    #   step 5a - Create a binding on 443 with cert from above
    New-WebBinding -Name "Default Web Site" -IP "*" -Port 443 -Protocol https
    EOH
    action :nothing
end


powershell_script "configure primary ADFS" do
    #run the ADFS config wizard.
    # pushd "C:\Program Files\Active Directory Federation Services 2.0"
    # try{
    # 	.\FSConfig.exe CreateFarm /ServiceAccount $adfsacctname /ServiceAccountPassword $adfsacctpass /CertThumbprint $a.thumbprint /SigningCertThumbPrint $b.thumbprint /DecryptCertThumbPrint $c.thumbprint /FederationServiceName $federationservicename /CleanConfig 
    # 	If ($? -eq $true){Write-Host -ForegroundColor Green ("SUCCESS: ADFS Configured")}
    # }
    # catch{
    # 	break
    # }
end


powershell_script "add adfs relying party" do
    #or  add_adfs_relying_party do // aka do via lwrp
    # Add-ADFSRelyingPartyTrust -Name "Hat" -Notes "Hat is a relying party to CCT ADFS" -Identifier "https://us.expediaairagenttool.com","https://ca.expediaairagenttool.com", "https://uk.expediaairagenttool.com" , "https://de.expediaairagenttool.com" -IssuanceAuthorizationRules '@RuleName = "Query CCTAuthorization for HAT Authorization and add allowed claim" c:[Type == "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"]=>issue(store = "CCTAuthorization", types = ("http://schemas.microsoft.com/authorization/claims/permit"), query = "EXEC dbo.HatAuthorizeUser @pLogin = {0}", param = c.Value);' -IssuanceTransformRules '@RuleName = "Issue Hat claims from CCTAuthorization store" c:[Type == "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"]  => issue(store = "CCTAuthorization", types = ("http://contactcentertokenprovider.expedia.com/claims/firstname", "http://contactcentertokenprovider.expedia.com/claims/middlename", "http://contactcentertokenprovider.expedia.com/claims/lastname", "http://contactcentertokenprovider.expedia.com/claims/knownas", "http://contactcentertokenprovider.expedia.com/claims/email", "http://contactcentertokenprovider.expedia.com/claims/primarylanguage","http://contactcentertokenprovider.expedia.com/claims/secondarylanguage", "http://contactcentertokenprovider.expedia.com/claims/thirdlanguage", "http://contactcentertokenprovider.expedia.com/claims/locationname", "http://contactcentertokenprovider.expedia.com/claims/vendorname", "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name", "http://schemas.microsoft.com/ws/2008/06/identity/claims/role"), query = "EXEC dbo.HatGetUserAttributes @pLogin = {0}", param = c.Value);'

end