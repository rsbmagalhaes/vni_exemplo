terraform {
  required_providers {
    ibm = {
      version = "1.59.0-vnip2.1"
      source  = "terraform-stratus.com/ibm-cloud/ibm"
    }
  }
}

provider "ibm" {
}