listener "tcp" {
  address     = "127.0.0.1:8200"
  tls_disable = 1
}

storage "file" {
  path = "./vault/data"
}

api_addr = "http://127.0.0.1:8200"
ui = true