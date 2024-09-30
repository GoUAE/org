locals {
  account_id = "5dd366da8efa3edd54b306fad16911b6"

  codershq = {
    zone_id = "8ac9c1caeb68da365765acef4de02ddd"
  }

  golang = {
    zone_id  = "d74bb219f0939f2f509ff3c61d2fe8bd"
  }
  
  # Alias
  uaq_tunnel = cloudflare_zero_trust_tunnel_cloudflared.uaq_tunnel
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "uaq_tunnel" {
  account_id = local.account_id
  name       = "uaq_tunnel"
  secret     = data.sops_file.chq.data["cloudflare.tunnels.uaq"]  
}

resource "cloudflare_record" "codershq_tunnel_cname" {
  zone_id = local.codershq.zone_id
  name    = "@"
  content = local.uaq_tunnel.cname
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "golang_tunnel_cname" {
  zone_id = local.golang.zone_id
  name    = "@"
  content = local.uaq_tunnel.cname
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "golang_github_verification" {
  zone_id = local.golang.zone_id
  name = "_gh-GoUAE-o"
  content = "16511f1c86"
  type = "TXT"
}

resource "cloudflare_record" "golang_mx_1" {
  zone_id = local.golang.zone_id
  name = "@"
  type = "MX"
  content    = "route1.mx.cloudflare.net"
  priority = 7
}

resource "cloudflare_record" "golang_mx_2" {
  zone_id = local.golang.zone_id
  name = "@"
  type = "MX"
  content   = "route2.mx.cloudflare.net"
  priority = 7
}

resource "cloudflare_record" "golang_mx_3" {
  zone_id = local.golang.zone_id
  name = "@"
  type = "MX"
  content    = "route3.mx.cloudflare.net"
  priority = 67
}

resource "cloudflare_record" "golang_spf1" {
  zone_id = local.golang.zone_id
  name = "@"
  type = "TXT"
  content = "\"v=spf1 include:_spf.mx.cloudflare.net ~all\""    
}

resource "cloudflare_email_routing_rule" "cm-golang-ae" {
  zone_id = local.golang.zone_id
  name    = "GoUAE Community Manager Email"
  enabled = true

  matcher {
    type  = "literal"
    field = "to"
    value = "cm@golang.ae"
  }

  # NOTE(2024-09-26): CF's Email Routing limits destination addresses to a single address
  action {
    type  = "forward"
    value = ["r.muhairi@pm.me"]
  }
}

# resource "cloudflare_pages_project" "golang_ae_site" {
#   account_id        = local.account_id
#   name              = "this-is-my-project-01"
#   production_branch = "main"
#   source = [{
#     type = "github"
#     config = {
#       owner = "gouae"
#       repo_name = "golang.ae"
#       production_branch = "main"
#     }    
#   }]
# }
