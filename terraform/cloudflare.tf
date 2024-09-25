locals {
  account_id = "5dd366da8efa3edd54b306fad16911b6"

  codershq-ae_zone_id = "8ac9c1caeb68da365765acef4de02ddd"
  golang-ae_zone_id   = "d74bb219f0939f2f509ff3c61d2fe8bd"

  # Alias
  uaq_tunnel = cloudflare_zero_trust_tunnel_cloudflared.uaq_tunnel
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "uaq_tunnel" {
  account_id = local.account_id
  name       = "UAQ Instance Tunnel. Managed by Nix"
  secret     = data.sops_file.chq.data["cloudflare.tunnels.uaqSecret"]
}

resource "cloudflare_record" "codershq_tunnel_cname" {
  zone_id = local.codershq-ae_zone_id
  name    = "uaq_tunnel"
  content = local.uaq_tunnel.cname
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "golang_tunnel_cname" {
  zone_id = local.golang-ae_zone_id
  name    = "uaq_tunnel"
  content = local.uaq_tunnel.cname
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_email_routing_rule" "cm-golang-ae" {
  zone_id = local.golang-ae_zone_id
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
