require 'rubygems'
require 'bundler/setup'

require 'kubernetes'
require 'yaml'

# Setup authentication.
# In case you have a local .kube configuration you can also use: Kubernetes.load_kube_config, instead.
Kubernetes.configure do |config|
  
  # Development only - Please unset the following options for productive use
  config.debugging = true
  config.verify_ssl = false # Switch off ssl verfication for self signed certs.
  config.verify_ssl_host = false

  # Set your kubernetes endpoint
  config.host = 'api.your.kubernetes.io'

  # Configure API key authorization: BearerToken by setting the 'k8s' ENV variable.
  config.api_key['authorization'] = ENV['k8s']
  
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  config.api_key_prefix['authorization'] = 'Bearer'
end

api_instance = Kubernetes::CustomObjectsApi.new

group = "argoproj.io" # String | The custom resource's group name

version = "v1alpha1" # String | The custom resource's version

# Set your namespace
namespace = "default"

plural = "workflows" # String | The custom resource's plural name. For TPRs this would be lowercase plural kind.

# Read your workflow definition from file.
workflow_definition = YAML.load_file("hello-world.yml")

# Object | The JSON schema of the Resource to create.
body = workflow_definition

opts = { 
  pretty: "pretty_example" # String | If 'true', then the output is pretty printed.
}

begin
  result = api_instance.create_namespaced_custom_object(group, version, namespace, plural, body, opts)
  p result
rescue Kubernetes::ApiError => e
  puts "\n\nException when calling CustomObjectsApi: #{e.inspect}"
end