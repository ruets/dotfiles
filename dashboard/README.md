# Dotfiles Dashboard

Simple TUI en Go avec Bubbletea pour gérer les dotfiles.

## Stack

- bubbletea pour le TUI
- bubbles pour les composants (liste, spinner, etc.)
- lipgloss pour le style

- cobra pour les permettre une installation, des updates ou encore une désinstallation par cli
- viper pour sauvegarder les paramètres des dotfiles, comme des applis préférées par exemple
- glamour pour le rendu de Markdown dans le terminal

- go-task pour le build et le run
