package manager

import (
	"bytes"
	"os/exec"
	"strings"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

type Script struct {
	Name        string
	Path        string
	Description string
}

type Module struct {
	Name    string
	Scripts []Script
}

type model struct {
	modules       []Module
	currentModule int
	cursor        int
	scriptOutput  []string

	width, height int
}

var (
	headerStyle   = lipgloss.NewStyle().Bold(true).Underline(true)
	selectedStyle = lipgloss.NewStyle().Background(lipgloss.Color("#5FD7FF")).Foreground(lipgloss.Color("#000000"))
	normalStyle   = lipgloss.NewStyle()
	helpStyle     = lipgloss.NewStyle().Padding(0, 1)
	terminalStyle = lipgloss.NewStyle().Border(lipgloss.NormalBorder()).Padding(1, 2)
)

func Name() string {
	return "Manager"
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
	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.width = msg.Width
		m.height = msg.Height

	case tea.KeyMsg:
		switch msg.String() {
		case "q", "ctrl+c":
			return m, tea.Quit

		case "up":
			if len(m.modules) > 0 && m.cursor > 0 {
				m.cursor--
			}
		case "down":
			if len(m.modules) > 0 && m.cursor < len(m.modules[m.currentModule].Scripts)-1 {
				m.cursor++
			}

		case "enter":
			if len(m.modules) == 0 {
				break
			}
			selected := m.modules[m.currentModule].Scripts[m.cursor]
			cmd := exec.Command("sh", selected.Path)
			var out bytes.Buffer
			cmd.Stdout = &out
			cmd.Stderr = &out
			cmd.Run()
			m.scriptOutput = strings.Split(out.String(), "\n")
		}
	}

	return m, nil
}

func (m model) View() string {
	if len(m.modules) == 0 {
		return "No modules loaded."
	}

	// Dimensions
	leftWidth := m.width / 2
	scriptListHeight := m.height / 2
	helpHeight := m.height - scriptListHeight
	rightWidth := m.width - leftWidth

	// Gauche haut : liste des scripts
	var listBuilder strings.Builder
	listBuilder.WriteString(headerStyle.Render("Scripts") + "\n\n")
	for i, script := range m.modules[m.currentModule].Scripts {
		style := normalStyle
		if i == m.cursor {
			style = selectedStyle
		}
		listBuilder.WriteString(style.Render(script.Name) + "\n")
	}
	list := lipgloss.NewStyle().Height(scriptListHeight).Render(listBuilder.String())

	// Gauche bas : aide
	helpText := m.modules[m.currentModule].Scripts[m.cursor].Description
	help := lipgloss.NewStyle().Height(helpHeight).Render(helpStyle.Render(helpText))

	left := lipgloss.JoinVertical(lipgloss.Top, list, help)
	left = lipgloss.NewStyle().Width(leftWidth).Render(left)

	// Droite : terminal
	terminalContent := strings.Join(m.scriptOutput, "\n")
	right := terminalStyle.Width(rightWidth).Height(m.height).Render(terminalContent)

	return lipgloss.JoinHorizontal(lipgloss.Top, left, right)
}
