#az login
#az account set --subscription "c1612ae2-5f15-487e-b926-fecaf634a54c"
web_server_location        = "westeurope"
web_server_rg              = "demo-rg"
web_server_resource_prefix = "demo-server"
web_server_address_space   = "1.0.0.0/22"
web_server_name            = "web"
web_server_subnet          = "1.0.1.0/24"
web_server_count           = 2