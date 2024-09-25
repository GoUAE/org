terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }

    sops = {
      source  = "carlpett/sops"
      version = "1.1.1"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }

  required_version = ">= 1.8.0"
}

data "sops_file" "chq" {
  source_file = "secrets.yaml"
}

provider "cloudflare" {
  api_token = data.sops_file.chq.data["cloudflare.apiToken"]
}

provider "random" {}
