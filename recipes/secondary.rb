## ADFS secondary

# search always returns an array of Node objects
adfs_search_results = search(:nodes, "adfs_primary:true")


if ! adfs_search_results.empty? then
	adfs_primary = results[0]
end	

# template "foo" do
# 	source "whatever"
# 	variables(
# 		:something => adfs_primary['ipaddress'],
# 		:something_else => adfs_primary['fqdn']
# 		:something_cpu => adfs_primary['cpu']
# 		)





windows_package "adfs" do
    # AdfsSetup.exe /quiet /logfile ADFS_Setup_Primary_installtime.log
    # idempotence - if get-hotfix xxx -eq true adfs aleady installed
end


powershell_script "IIS-ManagementScriptingTools" do
    # PKGMGR.EXE /l:log.etw /iu:IIS-ManagementScriptingTools
end



powershell_script "dot net 4.0" do
    # code "add-windowsfeature dotnet 4.0"
    # or dotNetFx40_Full_x86_x64.exe /q /norestart /log '+$dotNetlogfile
end


powershell_script"install IIS cert" do
    # code "install certificate #{node['iis']['ssl_certificate']}"
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




powershell_script "configure secondary adfs" do
	code <<-EOH 
    pushd "C:\Program Files\Active Directory Federation Services 2.0"
    .\FSConfig.exe JoinFarm /PrimaryComputerName "#{adfs_primary['fqdn']}" /ServiceAccount "#{node['adfs']['service_acct']}" /ServiceAccountPassword "#{node['adfs']['service_acct_pwd']}" /CertThumbprint $a.thumbprint /cleanconfig
    If ($? -eq $true){Write-Host -ForegroundColor Green ("SUCCESS: ADFS Configured")}}
    catch{;break}
    popd
    EOH
    action :nothing
end