package main

import (
	"bytes"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

// ANSI colors
const (
	colorFolder = "\033[90m"
	colorBranch = "\033[34m"
	colorReset  = "\033[0m"
)

func main() {
	home, err := os.UserHomeDir()
	if err != nil {
		fmt.Fprintf(os.Stderr, "cannot get home dir: %v\n", err)
		os.Exit(1)
	}

	entries, err := os.ReadDir(home)
	if err != nil {
		fmt.Fprintf(os.Stderr, "cannot read home dir: %v\n", err)
		os.Exit(1)
	}

	for _, e := range entries {
		if !e.IsDir() {
			continue
		}

		name := e.Name()
		if !strings.HasPrefix(name, "frontend") {
			continue
		}

		path := filepath.Join(home, name)
		branch, ok := gitBranch(path)
		if !ok {
			continue // not a git repo or error
		}

                namePadded := fmt.Sprintf("%10s", name)
		fmt.Printf("%s%s%s: %s%s%s\n",
			colorFolder, namePadded, colorReset,
			colorBranch, branch, colorReset,
		)
	}
}

func gitBranch(dir string) (string, bool) {
	cmd := exec.Command("git", "rev-parse", "--abbrev-ref", "HEAD")
	cmd.Dir = dir

	var out bytes.Buffer
	cmd.Stdout = &out
	cmd.Stderr = &out

	if err := cmd.Run(); err != nil {
		return "", false
	}

	branch := strings.TrimSpace(out.String())
	if branch == "" {
		return "", false
	}
	return branch, true
}
