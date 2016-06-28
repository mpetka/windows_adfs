
#ADFS attributes - for both Primary and Secondary
default['adfs']['type']             = 'primary'
default['adfs']['service_acct']     = 'svc_opscode'
default['adfs']['service_acct_pwd'] = 'Opscode123'
default['adfs']['federation_fqdn']  = 'adfs.opscode.com'

#ADFS attributes - for Primary only
default['adfs']['relying_parties']         = {
    'attribute1' => ['https://localhost'],
    'attribute2' => ['https://localhost:8080']
}

#ADFS attributes - for Secondary only
default['afds']['master_fqdn'] = #this attribute should come from search


# ADFS IIS related Attributes
default['iis']['pfx_cert_location']        = 'c:\cert\b.pfx'
default['iis']['pfx_cert_pwd']             = 'bob123'
default['iis']['pfx_cert_thumbprint']      = '3498DKJHEJDFHEREFDFS98324989234'

# ADFS crypto Certificates info
default['adfs']['pfx_signing_cert_location']      = 'c:\cert\a.pfx'
default['adfs']['pfx_signing_cert_pwd']           = 'bob123'
default['adfs']['pfx_signing_cert_thumbprint']    = '3498DKJHEJDFHEREFDFS98324989235ASDW'
default['adfs']['pfx_decrypting_cert_location']   = 'c:\cert\a.pfx'
default['adfs']['pfx_decrypting_cert_pwd']        = 'bob123'
default['adfs']['pfx_decrypting_cert_thumbprint'] = 'FSE3KJHEJDFHEREFDFS98324989235ASDW'


# Attributes not currently in use
default['adfs']['attribute_store_sql_fqdn']    = 'ec2-aws-bla-14-13-12.aws.com'
default['adfs']['attribute_store_db']          = 'SomeDB_Name'
default['adfs']['attribute_store_db_user']     = 'SomeDB_Name'
default['adfs']['attribute_store_db_pass']     = 'SomeDB_Name'
