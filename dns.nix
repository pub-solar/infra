{ ... }: 
{
# https://registry.terraform.io/providers/namecheap/namecheap/latest/docs
  resource."namecheap_domain_records"."pub-solar" = {
    domain = "pub.solar";
    mode = "OVERWRITE";
    email_type = "MX";

    record = [
      {
        hostname = "flora-6";
        type = "CNAME";
        address = "flora-6.svc.e5756d08-36fd-424b-f8bc-acdb92ca7b82.lev-1.greenbaum.zone.";
      }
      {
        hostname = "auth";
        type = "CNAME";
        address = "flora-6.svc.e5756d08-36fd-424b-f8bc-acdb92ca7b82.lev-1.greenbaum.zone.";
      }
      {
        hostname = "ci";
        type = "CNAME";
        address = "flora-6.svc.e5756d08-36fd-424b-f8bc-acdb92ca7b82.lev-1.greenbaum.zone.";
      }
      {
        hostname = "git";
        type = "CNAME";
        address = "flora-6.svc.e5756d08-36fd-424b-f8bc-acdb92ca7b82.lev-1.greenbaum.zone.";
      }
      {
        hostname = "stream";
        type = "CNAME";
        address = "flora-6.svc.e5756d08-36fd-424b-f8bc-acdb92ca7b82.lev-1.greenbaum.zone.";
      }
      {
        hostname = "list";
        type = "A";
        address = "80.71.153.210";
      }
      {
        hostname = "obs-portal";
        type = "CNAME";
        address = "flora-6.svc.e5756d08-36fd-424b-f8bc-acdb92ca7b82.lev-1.greenbaum.zone.";
      }
      {
        hostname = "vpn";
        type = "CNAME";
        address = "flora-6.svc.e5756d08-36fd-424b-f8bc-acdb92ca7b82.lev-1.greenbaum.zone.";
      }
      {
        hostname = "cache";
        type = "A";
        address = "95.217.225.160";
      }
      {
        hostname = "factorio";
        type = "A";
        address = "80.244.242.2";
      }
      {
        hostname = "collabora";
        type = "A";
        address = "95.217.225.160";
      }
      {
        hostname = "@";
        type = "ALIAS";
        address = "flora-6.svc.e5756d08-36fd-424b-f8bc-acdb92ca7b82.lev-1.greenbaum.zone.";
        ttl = 300;
      }
      {
        hostname = "chat";
        type = "CNAME";
        address = "matrix.svc.e5756d08-36fd-424b-f8bc-acdb92ca7b82.cgn-1.greenbaum.zone.";
      }
      {
        hostname = "cloud";
        type = "CNAME";
        address = "nc-web.svc.e5756d08-36fd-424b-f8bc-acdb92ca7b82.lev-1.greenbaum.zone.";
      }
      {
        hostname = "coturn";
        type = "CNAME";
        address = "nc-hpb.svc.e5756d08-36fd-424b-f8bc-acdb92ca7b82.lev-1.greenbaum.zone.";
      }
      {
        hostname = "hpb";
        type = "CNAME";
        address = "nc-hpb.svc.e5756d08-36fd-424b-f8bc-acdb92ca7b82.lev-1.greenbaum.zone.";
      }
      {
        hostname = "dimension";
        type = "CNAME";
        address = "matrix.svc.e5756d08-36fd-424b-f8bc-acdb92ca7b82.cgn-1.greenbaum.zone.";
      }
      {
        hostname = "element";
        type = "CNAME";
        address = "matrix.svc.e5756d08-36fd-424b-f8bc-acdb92ca7b82.cgn-1.greenbaum.zone.";
      }
      {
        hostname = "files";
        type = "CNAME";
        address = "mastodon-proxy.svc.e5756d08-36fd-424b-f8bc-acdb92ca7b82.cgn-1.greenbaum.zone.";
      }
      {
        hostname = "mastodon";
        type = "CNAME";
        address = "mastodon-proxy.svc.e5756d08-36fd-424b-f8bc-acdb92ca7b82.cgn-1.greenbaum.zone.";
      }
      {
        hostname = "matrix";
        type = "CNAME";
        address = "matrix.svc.e5756d08-36fd-424b-f8bc-acdb92ca7b82.cgn-1.greenbaum.zone.";
      }
      {
        hostname = "www";
        type = "CNAME";
        address = "flora-6.svc.e5756d08-36fd-424b-f8bc-acdb92ca7b82.lev-1.greenbaum.zone.";
      }
      {
        hostname = "@";
        type = "TXT";
        address = "v=spf1 include:spf.greenbaum.cloud a:list.pub.solar ~all";
      }
      {
        hostname = "list";
        type = "TXT";
        address = "v=spf1 a:list.pub.solar ?all";
      }
      {
        hostname = "_dmarc";
        type = "TXT";
        address = "v=DMARC1; p=reject;";
      }
      {
        hostname = "_dmarc.list";
        type = "TXT";
        address = "v=DMARC1; p=reject;";
      }
      {
        hostname = "@";
        type = "MX";
        address = "mx2.greenbaum.cloud.";
        mx_pref = "0";
      }
      {
        hostname = "list";
        type = "MX";
        address = "list.pub.solar";
        mx_pref = "0";
      }
      {
        hostname = "nachtigall";
        type = "A";
        address = "138.201.80.102";
      }
      {
        hostname = "nachtigall";
        type = "AAAA";
        address = "2a01:4f8:172:1c25::1";
      }
      # SRV records can only be changed via NameCheap Web UI
      # add comment
    ];
  };
}
