{
  fetchFromGitHub,
  vimUtils,
  vimPlugins,
}:
vimUtils.buildVimPlugin {
  name = "cmp_kitty";
  src = fetchFromGitHub {
    owner = "garyhurtz";
    repo = "cmp_kitty";
    rev = "f0d7782a525b0445499d3217f820ea43f7459e15";
    hash = "sha256-Z5ajN1cAgsy7GB1xS8Jk/Vo9LjoY7N/JXnzK1bB2cKo=";
  };
  dependencies = [
    vimPlugins.nvim-cmp
  ];
}
