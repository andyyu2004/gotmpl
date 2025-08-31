package main

import (
	"flag"
	"io"
	"os"
	"strings"
	"text/template"

	"github.com/Masterminds/sprig/v3"
	"go.yaml.in/yaml/v3"
)

func main() {
	flag.Parse()
	args := flag.Args()

	data := map[string]any{}
	for _, arg := range args {
		xs := strings.SplitN(arg, "=", 2)
		if len(xs) != 2 {
			panic("arguments must be in the form key=value")
		}

		var value any
		if err := yaml.Unmarshal([]byte(xs[1]), &value); err != nil {
			panic("failed to parse value: " + err.Error())
		}

		data[xs[0]] = value
	}

	if err := run(os.Stdin, os.Stdout, data); err != nil {
		panic(err)
	}

}

func run(input io.Reader, output io.Writer, data map[string]any) error {
	s, err := io.ReadAll(input)
	if err != nil {
		return err
	}

	tpl, err := template.New("base").Funcs(sprig.FuncMap()).Parse(string(s))
	if err != nil {
		return err
	}

	return tpl.Execute(output, data)
}
