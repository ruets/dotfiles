package tui

import (
	"fmt"
	"os"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"

	"github.com/ruets/dotfiles/internal/tui/tabs/dashboard"
	"github.com/ruets/dotfiles/internal/tui/tabs/explorer"
	"github.com/ruets/dotfiles/internal/tui/tabs/manager"
)

var (
  highlightColor    = lipgloss.AdaptiveColor{Light: "#874BFD", Dark: "#7D56F4"}
  tabsStyle        = lipgloss.NewStyle().
    Margin(1, 0).
    Bold(true)
  activeTabStyle = tabsStyle.Copy().
    Underline(true).
    Foreground(highlightColor)
  inactiveTabStyle = tabsStyle.Copy().
    Underline(false)
  contentStyle       = lipgloss.NewStyle().
    BorderForeground(highlightColor).
    Padding(1, 0).
    Border(lipgloss.DoubleBorder()).
    Align(lipgloss.Center)
  tooltipStyle = lipgloss.NewStyle().
    Foreground(lipgloss.Color("#888")).
    MarginTop(1).
    Align(lipgloss.Center)

)

type model struct {
	Tabs      []tab
	activeTab int
	width     int
	height    int
}

type tab struct {
	Name      string
	Model     tea.Model
	Keymap string
}


func (m model) Init() tea.Cmd {
	return m.Tabs[m.activeTab].Model.Init()
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.width = msg.Width
		m.height = msg.Height

	case tea.KeyMsg:
		switch key := msg.String(); key {
		case "ctrl+c", "q":
			return m, tea.Quit
		case "tab":
			m.activeTab = (m.activeTab + 1) % len(m.Tabs)
			return m, m.Tabs[m.activeTab].Model.Init()
		case "shift+tab":
			m.activeTab = (m.activeTab - 1 + len(m.Tabs)) % len(m.Tabs)
			return m, m.Tabs[m.activeTab].Model.Init()
		}
	}

	subModel := m.Tabs[m.activeTab].Model
	updated, cmd := subModel.Update(msg)
	m.Tabs[m.activeTab].Model = updated
	return m, cmd
}

func (m model) View() string {
	var renderedTabs []string
	for i, t := range m.Tabs {
		style := inactiveTabStyle
		if i == m.activeTab {
			style = activeTabStyle
		}
		renderedTabs = append(renderedTabs, style.Render(t.Name), "   ")
	}

	header := lipgloss.JoinHorizontal(lipgloss.Top, renderedTabs...)
	content := contentStyle.
		Width(m.width - contentStyle.GetHorizontalFrameSize()).
		Height(m.height - contentStyle.GetVerticalFrameSize() - 2). // Leave room for tooltip
		Render(m.Tabs[m.activeTab].Model.View())

  tabKeys := m.Tabs[m.activeTab].Keymap
	globalKeys := "[tab] Next   [shift+tab] Prev   [q] Quit" 
  tooltip := tooltipStyle.
    Width(m.width).
    Render(fmt.Sprintf("%s   %s", tabKeys, globalKeys))

	return fmt.Sprintf("%s\n%s\n%s", header, content, tooltip)
}


func Start() {
	m := model{
		Tabs: []tab{
			{Name: dashboard.Name(),  Model: dashboard.New(),   Keymap: dashboard.Keymap()},
			{Name: explorer.Name(),   Model: explorer.New(),    Keymap: explorer.Keymap()},
			{Name: manager.Name(),    Model: manager.New(),     Keymap: manager.Keymap()},
		},
		activeTab: 0,
	}
	if _, err := tea.NewProgram(m, tea.WithAltScreen()).Run(); err != nil {
		fmt.Println("Error running program:", err)
		os.Exit(1)
	}
}

