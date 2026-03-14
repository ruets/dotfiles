package cli

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"

  "github.com/ruets/dotfiles/internal/tui"
)

// RootCmd est la commande racine
var rootCmd = &cobra.Command{
	Use:   "dotfiles",
	Short: "Gestionnaire de dotfiles en Go",
	Run: func(cmd *cobra.Command, args []string) {
		// Si aucune commande n’est fournie → lancer le TUI
		if len(os.Args) == 1 {
			tui.Start()
			return
		}

		// Sinon, afficher l’aide
		_ = cmd.Help()
	},
}

func init() {
	// Ajoute les sous-commandes à la racine
	rootCmd.AddCommand(installCmd)
	rootCmd.AddCommand(updateCmd)
	rootCmd.AddCommand(uninstallCmd)
}

// Sous-commande : install
var installCmd = &cobra.Command{
	Use:   "install",
	Short: "Installe les dotfiles",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("📦 Installation des dotfiles…")
		// ici tu peux appeler internal/installers/nix.go
	},
}

// Sous-commande : update
var updateCmd = &cobra.Command{
	Use:   "update",
	Short: "Met à jour les dotfiles",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("⬆️  Mise à jour des dotfiles…")
	},
}

// Sous-commande : uninstall
var uninstallCmd = &cobra.Command{
	Use:   "uninstall",
	Short: "Supprime les dotfiles installés",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("🗑️  Suppression des dotfiles…")
	},
}

// Fonction à appeler depuis main.go
func Execute() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Println("Erreur : ", err)
		os.Exit(1)
	}
}
