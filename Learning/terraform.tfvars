#az login
#az account set --subscription "c1612ae2-5f15-487e-b926-fecaf634a54c"
server_location        = "westeurope"
server_rg              = "demo-rg"
server_resource_prefix = "demo-server"
server_address_space   = "1.0.0.0/22"
server_name            = "server"
server_subnet          = "1.0.1.0/24"
server_count           = 1