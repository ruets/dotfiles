package explorer

import (
	"os"
	"os/user"
	"path/filepath"
	"strings"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

type Entry struct {
	Name  string
	Path  string
	IsDir bool
}

type model struct {
	path        string
  root        string
	entries     []Entry
	cursor      int
	preview     string
	width       int
	height      int
	showHidden  bool
  scrollOffset int
}

var (
	dirStyle     = lipgloss.NewStyle().Foreground(lipgloss.Color("#5FD7FF"))
	fileStyle    = lipgloss.NewStyle()
	previewStyle = lipgloss.NewStyle().Padding(1, 2)
)

func Name() string {
  return "Explorer"
}

func Keymap() string {
  return "[↑ / ↓] Navigate   [↩ / →] Open   [← / backspace] Back   [h/space] Toggle hidden   [pgup/pgdown] Scroll"
}

func New() tea.Model {
	usr, _ := user.Current()
	startPath := filepath.Join(usr.HomeDir, ".config", "home-manager")
  rootPath := filepath.Join(usr.HomeDir, ".config", "home-manager")
	entries := listDir(startPath, false)
	preview := "Preview"

	return model{
		path:       startPath,
    root:       rootPath,
		entries:    entries,
		cursor:     0,
		preview:    preview,
		showHidden: false,
	}
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
        case "up":
          if m.cursor > 0 {
            m.cursor--
            m.scrollOffset = 0
          }
        case "down":
          if m.cursor < len(m.entries)-1 {
            m.cursor++
            m.scrollOffset = 0
          }
        case "enter", "right":
          if len(m.entries) == 0 {
            break
          }
          selected := m.entries[m.cursor]
          if selected.IsDir {
            m.path = selected.Path
            m.entries = listDir(m.path, m.showHidden)
            m.cursor = 0
          }
        case "left", "backspace":
          if !m.isAtRoot() {
            m.path = filepath.Dir(m.path)
            m.entries = listDir(m.path, m.showHidden)
            m.cursor = 0
            m.scrollOffset = 0
          }
        case "h", " ":
          m.showHidden = !m.showHidden
          m.entries = listDir(m.path, m.showHidden)
          m.cursor = 0
        case "pgdown":
          m.scrollOffset += 1
        case "pgup":
          if m.scrollOffset > 0 {
            m.scrollOffset -= 1
          }
      }
	}
	return m, nil
}

func (m model) View() string {
	var b strings.Builder
	leftColWidth := m.width / 2
	rightColWidth := m.width - leftColWidth

  pathStyle := lipgloss.NewStyle().Bold(true).Underline(true)
  rootStyle := lipgloss.NewStyle().Foreground(lipgloss.Color("#FF5F5F")).Bold(true)

  b.WriteString(pathStyle.Render(m.path))
  if m.isAtRoot() {
    b.WriteString(" " + rootStyle.Render("[ROOT]"))
  }
  b.WriteString("\n\n")

	if len(m.entries) == 0 {
		b.WriteString("(Dossier vide)")
	} else {
		for i, entry := range m.entries {
			var style lipgloss.Style
			if entry.IsDir {
				style = dirStyle
			} else {
				style = fileStyle
			}

			if i == m.cursor {
				style = style.Copy().Reverse(true)
			}

			name := entry.Name
			if entry.IsDir {
				name += "/"
			}

			b.WriteString(style.Render(name) + "\n")
		}
	}

	leftCol := lipgloss.NewStyle().Width(leftColWidth).Height(m.height).Render(b.String())
	rightCol := previewStyle.Width(rightColWidth).Height(m.height).Render(m.preview)

	return lipgloss.JoinHorizontal(lipgloss.Top, leftCol, rightCol)
}

func listDir(path string, showHidden bool) []Entry {
	files, err := os.ReadDir(path)
	if err != nil {
		return []Entry{}
	}

	var dirs, others []Entry
	for _, f := range files {
		name := f.Name()
		if !showHidden && strings.HasPrefix(name, ".") {
			continue
		}
		entry := Entry{
			Name:  name,
			Path:  filepath.Join(path, name),
			IsDir: f.IsDir(),
		}
		if f.IsDir() {
			dirs = append(dirs, entry)
		} else {
			others = append(others, entry)
		}
	}

	return append(dirs, others...)
}

func (m model) isAtRoot() bool {
	absPath, _ := filepath.Abs(m.path)
	absRoot, _ := filepath.Abs(m.root)
	return absPath == absRoot
}
