let
  users = {
    miyuki = {
      mpointec = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGpLeRUtqU9hvTyN+6z9MEPYYfvZh03gzwjnyd/yHIg9";
    };
    momo = {
      krapaince = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHpf1drzhkDC5UWwX056yAZOOB/8g1k49hzDVqVQVfj8";
    };
    pabu = {
      krapaince = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOIBDlSmlT3y7+8Rm2Wx4Oba4uJh8I60W7lThyZ+KrSo";
    };
  };

  machines = {
    momo_boot = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMEgXfQBRl6Zo4heEVLXIpfXOwNzUFPFM1gUmYKT7ke5";
    momo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICIEv+m1Mldyg23rJTw4bece5/p6wdCZkew6g8mI56PS";
    appa = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINTeo+Mywjhv91A92B6bA2x1O0h3+6oawp8JcGYib4RF";
  };

  publicKeys = { inherit machines users; };
in
{
  perSystem._module.args.keys = publicKeys;

  flake.keys = publicKeys;
}
