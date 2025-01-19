{
  fetchurl,
  stdenv,
  unzip,
  ...
}:
stdenv.mkDerivation rec {
  name = "bluesnooze";
  version = "1.2";
  src = fetchurl {
    url = "https://github.com/odlp/bluesnooze/releases/download/v${version}/Bluesnooze.zip";
    sha256 = "sha256-B1qLfPj2bU9AAsYqGYWl0/sEPj3wnn/UBeiM4kqW/rA=";
  };

  # Needed to avoid the binary becoming corrupted and mac refusing to open it. I
  # don't know why.
  dontFixup = true;

  # there appears to be an undocumented "unpack" phase that does the unzipping
  # automatically
  nativeBuildInputs = [ unzip ];
  sourceRoot = "."; # squash "unpacker produced multiple directories" error

  installPhase = ''
    mkdir -p "$out/Applications"
    cp -r Bluesnooze.app $out/Applications/
  '';
}
