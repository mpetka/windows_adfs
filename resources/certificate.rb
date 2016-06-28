actions :add, :remove

attribute :path, :kind_of => String # add contraints - must be present
attribute :password, :kind_of => String  # add contraints - must be present
attribute :thumbprint, :kind_of => String # add contraints - must be present

#add more validation 

default_action :add