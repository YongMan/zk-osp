package main

import (
	"flag"
	"fmt"
	"os"
)

var key string
var value string
var file string

func init() {
	flag.StringVar(&file, "f", "", "config file")
	flag.StringVar(&key, "k", "", "key to update")
	flag.StringVar(&value, "v", "", "value to set")
}

func main() {
	flag.Parse()
	if file == "" || key == "" || value == "" {
		os.Exit(-1)
	}

	config, err := Read(file)
	if err != nil {
		fmt.Println(err)
		os.Exit(-1)
	}
	fmt.Println(config)
	sec, err := config.Section("global")
	if err != nil {
		fmt.Println(err)
		os.Exit(-1)
	}
	sec.Add(key, value)
	fmt.Println(sec)
	err = Save(config, file)
	if err != nil {
		fmt.Println(err)
	}
}
