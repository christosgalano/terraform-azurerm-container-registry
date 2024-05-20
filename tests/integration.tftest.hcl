provider "azurerm" {
  features {}
}

run "setup" {
  module {
    source = "./tests/setup"
  }

  variables {
    location              = "northeurope"
    resource_group_prefix = "rg-cr-tftest"
    vnet_prefix           = "vnet-cr-tftest"
    subnet_prefix         = "subnet-cr-tftest"
  }
}

run "create_public_container_registry" {
  command = apply

  variables {
    name                          = "crpublictftest${run.setup.random_name}"
    location                      = "northeurope"
    resource_group_name           = run.setup.resource_group_name
    admin_enabled                 = true
    public_network_access_enabled = true
  }
}

run "public_container_registry_unauthorized_without_credentials" {
  command = plan

  module {
    source = "./tests/requests"
  }

  variables {
    endpoints = ["https://${run.create_public_container_registry.login_server}/v2/"]
  }

  assert {
    condition     = data.http.requests[0].status_code == 401
    error_message = "Container registry responded with HTTP status ${data.http.requests[0].status_code}"
  }
}

run "public_container_registry_authorized_with_credentials" {
  command = plan

  module {
    source = "./tests/requests"
  }

  variables {
    endpoints = ["https://${run.create_public_container_registry.login_server}/v2/"]
    headers = {
      authorization = "Basic ${base64encode("${run.create_public_container_registry.admin.username}:${run.create_public_container_registry.admin.password}")}"
    }
  }

  assert {
    condition     = data.http.requests[0].status_code == 200
    error_message = "Container registry responded with HTTP status ${data.http.requests[0].status_code}"
  }

  assert {
    condition     = data.http.requests[0].response_body == "{}"
    error_message = "Container registry responded with unexpected content."
  }
}

run "create_private_container_registry" {
  command = apply

  variables {
    name                = "crprivatetftest${run.setup.random_name}"
    location            = "northeurope"
    resource_group_name = run.setup.resource_group_name
    admin_enabled       = true
    private_endpoint = {
      name      = "pep-tftest-${run.setup.random_name}"
      subnet_id = run.setup.subnet_id
    }
  }
}

run "private_container_registry_unauthorized_without_credentials" {
  command = plan

  module {
    source = "./tests/requests"
  }

  variables {
    endpoints = ["https://${run.create_private_container_registry.login_server}/v2/"]
  }

  assert {
    condition     = data.http.requests[0].status_code == 403
    error_message = "Container registry responded with HTTP status ${data.http.requests[0].status_code}"
  }
}

run "private_container_registry_unauthorized_with_credentials" {
  command = plan

  module {
    source = "./tests/requests"
  }

  variables {
    endpoints = ["https://${run.create_private_container_registry.login_server}/v2/"]
    headers = {
      authorization = "Basic ${base64encode("${run.create_private_container_registry.admin.username}:${run.create_private_container_registry.admin.password}")}"
    }
  }

  assert {
    condition     = data.http.requests[0].status_code == 403
    error_message = "Container registry responded with HTTP status ${data.http.requests[0].status_code}"
  }
}
