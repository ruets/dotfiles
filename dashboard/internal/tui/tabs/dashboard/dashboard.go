package dashboard

import (
 
  tea "github.com/charmbracelet/bubbletea"
  "github.com/charmbracelet/lipgloss"
)

type model struct {
	name      string
  keymap    string
}

func Name() string {
  return "Dashboard"
}

func Keymap() string {
  return ""
}

func New() tea.Model {
	return model{}
}

func (m model) Init() tea.Cmd {
	return nil
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	return m, nil
}

func (m model) View() string {
	return lipgloss.NewStyle().
    Align(lipgloss.Center).
    Render("Welcome to the dotfiles dashboard!")
}

