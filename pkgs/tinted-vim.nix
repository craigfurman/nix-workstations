{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  name = "tinted-vim";
  src = fetchFromGitHub {
    owner = "tinted-theming";
    repo = "tinted-vim";
    rev = "c2a1232aa2c0ed27dcbf005779bcfe0e0ab5e85d";
    hash = "sha256-YbQwaApLFJobn/0lbpMKcJ8N5axKlW2QIGkDS5+xoSU=";
  };
}
