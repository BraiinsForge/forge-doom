{
  description = "fbDOOM for Braiins devices (Deck and MiniMiner)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    fbdoom-deck = {
      url = "github:BraiinsForge/fbDOOM-fork/doom-deck-mp";
      flake = false;
    };
    fbdoom-miniminer = {
      url = "github:BraiinsForge/fbDOOM-fork/doom-miniminer";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, fbdoom-deck, fbdoom-miniminer }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgsCross = pkgs.pkgsCross.armv7l-hf-multiplatform;

      # Helper function to build fbDOOM
      mkDoom = { src, name }: pkgsCross.stdenv.mkDerivation {
        pname = "fbdoom-${name}";
        version = "0.1";

        src = src;
        sourceRoot = "source/fbdoom";

        nativeBuildInputs = [ pkgs.gnumake ];
        buildInputs = [ pkgsCross.glibc.static ];

        makeFlags = [
          "CROSS_COMPILE=${pkgsCross.stdenv.cc.targetPrefix}"
          "CC=${pkgsCross.stdenv.cc.targetPrefix}gcc"
        ];

        NIX_CFLAGS_COMPILE = "-static -std=gnu99";
        NIX_LDFLAGS = "-static";
        NOSDL = "1";

        buildPhase = ''
          runHook preBuild
          make $makeFlags
          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall
          mkdir -p $out/bin
          cp fbdoom $out/bin/
          runHook postInstall
        '';

        meta = {
          description = "DOOM port for framebuffer - ${name} variant";
          homepage = "https://github.com/BraiinsForge/fbDOOM-fork";
          platforms = [ "armv7l-linux" ];
        };
      };
    in
    {
      packages.${system} = {
        doom-deck = mkDoom {
          src = fbdoom-deck;
          name = "deck";
        };

        doom-bmm = mkDoom {
          src = fbdoom-miniminer;
          name = "miniminer";
        };

        default = self.packages.${system}.doom-deck;
      };

      devShells.${system}.default = pkgs.mkShell {
        nativeBuildInputs = [
          pkgsCross.stdenv.cc
          pkgs.gnumake
        ];

        buildInputs = [
          pkgsCross.glibc.static
        ];

        shellHook = ''
          export CROSS_COMPILE="${pkgsCross.stdenv.cc.targetPrefix}"
          export CC="${pkgsCross.stdenv.cc}/bin/${pkgsCross.stdenv.cc.targetPrefix}gcc"
          export CFLAGS="-static -std=gnu99 $CFLAGS"
          export LDFLAGS="-static $LDFLAGS"
          export NOSDL="1"

          echo "fbDOOM cross-compile environment for Braiins Forge Deck"
          echo ""
          echo "Environment configured:"
          echo "  CROSS_COMPILE=$CROSS_COMPILE"
          echo "  CC=$CC"
          echo "  Target: armv7l-hf"
          echo ""
          echo "To build:"
          echo "  cd fbdoom"
          echo "  make"
          echo ""
          echo "Binary will be: ./fbdoom/fbdoom"
          echo ""
        '';
      };
    };
}
