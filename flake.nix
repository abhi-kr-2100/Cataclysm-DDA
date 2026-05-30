{
  description = "Cataclysm-DDA development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-astyle31.url = "github:NixOS/nixpkgs/a71323f68d4377d12c04a5410e214495ec598d4c";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-astyle31,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      pkgs-astyle31 = import nixpkgs-astyle31 { inherit system; };
      commonInputs =
        with pkgs;
        [
          ccache
          cmake
          freetype
          gcc
          gettext
          glib
          glslang
          gnumake
          libx11
          ncurses
          pkg-config
          python3
          llvmPackages.clang-tools
          mold
        ]
        ++ ([ pkgs-astyle31.astyle ]);
    in
    {
      devShells.${system} = {
        default = pkgs.mkShell {
          buildInputs =
            commonInputs
            ++ (with pkgs; [
              sdl3
              sdl3-image
              sdl3-mixer
              sdl3-ttf
            ]);

          shellHook = ''
            echo "Cataclysm-DDA build environment ready (SDL3)"
          '';
        };

        sdl2 = pkgs.mkShell {
          buildInputs =
            commonInputs
            ++ (with pkgs; [
              SDL2
              SDL2_image
              SDL2_mixer
              SDL2_ttf
            ]);

          shellHook = ''
            echo "Cataclysm-DDA build environment ready (SDL2)"
          '';
        };
      };
    };
}
