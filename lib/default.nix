{ lib, ... }:
{
  neovim =
    let
      formatAutocmd =
        event: fileExtensions: command:
        let
          globs = map (fileExtension: "*.${fileExtension}") fileExtensions;
          targets = lib.strings.concatStringsSep "," globs;
        in
        "autocmd ${event} ${targets} ${command}";
    in
    {
      fileOpenCommand = formatAutocmd "BufEnter";
      preSaveCommand = formatAutocmd "BufWritePre";
    };

  mkEnvrc =
    vars:
    let
      keysToEnvVarStrings = builtins.mapAttrs (key: value: "export ${key}=\"${value}\"") vars;
      envVarStrings = lib.attrsets.attrValues (keysToEnvVarStrings);
    in
    (lib.strings.concatStringsSep "\n" envVarStrings) + "\n";
}
