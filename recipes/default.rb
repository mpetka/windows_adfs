

# Pre-requisite features for.Net 4.0 that need to be installed first

include_recipe "ms_dotnet4"



case node['adfs']['type']
when "primary"
  include_recipe "adfs::primary"
when "secondary"
  include_recipe "adfs::secondary"
when "not_specified"
  puts 'ADFS type not specified. Exiting'
else
  puts "invalid attribute specified"
end