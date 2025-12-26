{ secrets, ... }:
{
  users.users.craig = {
    openssh.authorizedKeys.keys = secrets.authorizedKeys;
  };

  services.openssh = {
    enable = true;

    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  security.pam.sshAgentAuth.enable = true;
}
