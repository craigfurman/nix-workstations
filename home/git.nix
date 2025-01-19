{ pkgs, secrets, ... }:
{
  home.packages = with pkgs; [ git-crypt ];

  programs.git = {
    enable = true;

    aliases = {
      amend = "ci --amend";
      br = "branch";
      ci = "commit -v";
      co = "checkout";
      dci = "duet-commit";
      di = "diff";
      ds = "diff --staged";
      flog = "log --pretty=fuller --decorate";
      fpush = "push --force-with-lease";
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
      mrnotes = "log --reverse --format='%n%n**%s**%n%n%b' origin/HEAD..HEAD";
      prnotes = "mrnotes";
      pullsubs = "submodule update --init --recursive";
      rom = "rebase origin/main";
      st = "status";

      # Not a hater, only trolling a little, I promise...
      #
      # graphite.dev is a promising product that does a lot more than this
      # alias, but a gitconfig comment really isn't the place for me to expand
      # further on that.
      graphene = "rebase --onto origin/HEAD HEAD^";
    };

    delta = {
      enable = true;
      options = {
        light = false;
        navigate = true;
        side-by-side = true;
      };
    };

    extraConfig = {
      diff = {
        colorMoved = true;
      };
      init = {
        defaultBranch = "main";
      };
      log = {
        # Greater precision for nearer dates, but only if the pager is in use
        date = "auto:human";
      };
      merge = {
        conflictstyle = "zdiff3";
      };
      pull = {
        ff = "only";
      };
      push = {
        autoSetupRemote = true;
      };
      user = {
        name = "Craig Furman";
        email = secrets.git.email;
      };
    };
  };

  programs.zsh.shellAliases = {
    g = "git";
  };
}
