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

resource "cloudflare_list" "gouae_social_redirect_list" {
  account_id  = local.account_id
  name        = "gouae_social_redirect_list"
  description = "Social Redirect list for GoUAE"
  kind        = "redirect"

  item {
    value {
      redirect {
        source_url = "golang.ae/discord"
        target_url = "https://discord.gg/FXhjYCkvGg"
      }
    }
  }

  item {
    value {
      redirect {
        source_url = "golang.ae/whatsapp"
        target_url = "https://chat.whatsapp.com/DEmS5AmfJSfBmH40aYLih1"
      }
    }
  }

  item {
    value {
      redirect {
        source_url = "golang.ae/twitter"
        target_url = "https://x.com/uaegophers"
      }
    }
  }

  item {
    value {
      redirect {
        source_url = "golang.ae/linkedin"
        target_url = "https://linkedin.com/company/gouae"
      }
    }
  }

  item {
    value {
      redirect {
        source_url = "golang.ae/github"
        target_url = "https://github.com/gouae"
      }
    }
  }
}

resource "cloudflare_ruleset" "gouae_social_redirect_ruleset" {
  account_id  = local.account_id
  name        = "redirects"
  description = "GoUAE Socials Redirect ruleset"
  kind        = "root"
  phase       = "http_request_redirect"

  rules {
    action = "redirect"
    action_parameters {
      from_list {
        name = "gouae_social_redirect_list"
        key = "http.request.full_uri"
      }
    }

    expression = "http.request.full_uri in $gouae_social_redirect_list"
    description = "Apply redirects from gouae_social_redirect_list"
    enabled = true
  }
}


/* Equivalent to what we're doing on cloudflare, but 
  fails to work with terraform due to
 `There is an internal issue with your Cloudflare Pages Git installation` */

# resource "cloudflare_pages_project" "golang_ae_site" {
#   account_id        = local.account_id
#   name              = "golang-ae"
#   production_branch = "main"

#   source { 
#     type = "github"

#     config {
#       owner = "gouae"
#       repo_name = "golang.ae"
#       production_branch = "main"
#     }    
#   }

#   build_config {
#     build_command   = "go run main.go --static"
#     destination_dir = ""
#     root_dir        = ""
#   }
# }

# resource "cloudflare_record" "golang_pages_cname" {
#   zone_id = local.golang.zone_id
#   name    = "@"
#   content = "golang-ae.pages.dev"
#   type    = "CNAME"
#   proxied = true
# }
