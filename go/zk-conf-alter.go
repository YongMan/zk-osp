package main

import (
	"flag"
	"fmt"
	"os"
)

var key string
var value string
var file string
var del bool

func init() {
	flag.StringVar(&file, "f", "", "config file")
	flag.StringVar(&key, "k", "", "key to update")
	flag.StringVar(&value, "v", "", "value to set")
	flag.BoolVar(&del, "d", false, "flag delete operation")
}

func main() {
	flag.Parse()
	if (!del && (file == "" || key == "" || value == "")) || (del && key == "") {
		os.Exit(-1)
	}

	config, err := Read(file)
	if err != nil {
		fmt.Println(err)
		os.Exit(-1)
	}
	sec, err := config.Section("global")
	if err != nil {
		fmt.Println(err)
		os.Exit(-1)
	}
	if !del {
		//add or update
		sec.Add(key, value)
	} else {
		//delete key
		sec.DelRegex(key)
	}
	err = Save(config, file)
	if err != nil {
		fmt.Println(err)
	}
}
