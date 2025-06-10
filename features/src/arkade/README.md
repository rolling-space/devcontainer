# Arkade CLI Devcontainer Feature

This devcontainer feature installs the Arkade CLI, a tool for managing Kubernetes applications. It simplifies the installation of various applications and tools in a Kubernetes environment.

## Installation

To use this feature, include it in your devcontainer configuration. The feature will automatically install the Arkade CLI and its dependencies.

### Options

- **installZsh**: (boolean) Install ZSH? Default is true.
- **configureZshAsDefaultShell**: (boolean) Change default shell to ZSH? Default is false.
- **installOhMyZsh**: (boolean) Install Oh My Zsh!? Default is true.
- **installOhMyZshConfig**: (boolean) Allow installing the default dev container .zshrc templates? Default is true.
- **upgradePackages**: (boolean) Upgrade OS packages? Default is true.
- **username**: (string) Enter name of a non-root user to configure or none to skip. Default is "automatic".
- **userUid**: (string) Enter UID for non-root user. Default is "automatic".
- **userGid**: (string) Enter GID for non-root user. Default is "automatic".
- **nonFreePackages**: (boolean) Add packages from non-free Debian repository? (Debian only). Default is false.

## Usage

After adding the feature to your devcontainer, rebuild your container. The Arkade CLI will be installed and ready for use. You can verify the installation by running:

```bash
arkade version
```

## Troubleshooting

If you encounter any issues during installation, ensure that you have the necessary permissions and that your environment meets the requirements for running the Arkade CLI.