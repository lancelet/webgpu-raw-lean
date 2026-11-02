{
  # Development tools only. Nothing in the build depends on Nix: the Lean
  # toolchain is chosen by `lean-toolchain` files, which elan reads whether or
  # not it comes from Nix.
  #
  # On NixOS, elan patches each toolchain it installs to call this shell's
  # bash and cc by store path. Keep the shell GC-rooted (nix-direnv does this),
  # and after `nix flake update` reinstall toolchains with
  # `elan toolchain uninstall <ver>`, or they break once old paths are collected.
  description = "wgpu-raw-lean development shell";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = [
            pkgs.elan # installs the Lean toolchain named in lean-toolchain
            pkgs.curl # vendor/*/fetch.sh
            pkgs.unzip # vendor/wgpu-native/fetch.sh
            pkgs.shellcheck # checks the shell scripts
            pkgs.git
          ];
        };
      });

      formatter = forAllSystems (pkgs: pkgs.nixfmt);
    };
}
