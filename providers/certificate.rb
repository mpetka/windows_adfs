# Roll this into the Windows cookbook when done
use_inline_resources

action :add do
  batch "bla" do
    certutil -importpfx :path -p :password
    not_if "cmd /c powershell -command ^" & {Get-ChildItem Cert:\\LocalMachine\\My | ? {$_.Thumbprint -like  :thumbprint}} ^" "
    # not_if "powershell_script  -command ^" & {Get-ChildItem Cert:\\LocalMachine\\My | ? {$_.Thumbprint -like  :thumbprint}} ^" "
  end
end


 #    function certinstallloop ($certpassin, $certnamein){
 #    $certout=certutil -f -importpfx -p $certpassin $certnamein
	# if($? -eq $false){write-host -f red "There was an error in installation of the cert:";"";$certout;break
	# }else{
	# $certout=($certout | select -first 1).replace('" added to store.',"").replace('Certificate "',"")}
 #    return $certout}

	# default['iis']['pfx_cert_location']        = 'c:\cert\b.pfx'
	# default['iis']['pfx_cert_pwd']             = 'bob123'
	# default['iis']['pfx_cert_thumbprint']      = '3498DKJHEJDFHEREFDFS98324989234'


	# attribute :path, :kind_of => String # add contraints - must be present
	# attribute :password, :kind_of => String  # add contraints - must be present
	# attribute :thumbprint, :kind_of => String # add contraints - must be present


action :remove do
  powershell_script "remove cert" do
      code "get-item cert:\\LocalMachine\\My\\:thumbprint | remove-item"
      only_if "cmd /c powershell -command ^" & {get-item cert:\\LocalMachine\\My\\:thumbprint} ^" "
    end
end


