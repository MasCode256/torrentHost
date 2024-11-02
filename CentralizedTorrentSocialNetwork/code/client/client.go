package main

import (
	"bytes"
	"fmt"
	"log"
	"net/http"
	"os/exec"
	"runtime"
)

func queryHandler(w http.ResponseWriter, r *http.Request) {
	// Получаем параметры запроса
	query := r.URL.Query()
	response := ""

	// Перебираем параметры и добавляем их к ответу
	if query.Has("cmd") {
		response += executeCommand(query.Get("cmd"))
	} else if query.Has("test") {
		w.Write([]byte("Before sleep. "))
		response = "After sleep."
	}

	w.Write([]byte(response))
}

// Обработчик для запросов на получение файлов
func fileHandler(w http.ResponseWriter, r *http.Request) {
	// Укажите путь к файлу, который хотите вернуть
	filePath := "./client/html" + r.URL.Path // Например, если запрашивается /example.txt, файл будет в текущей директории

	http.ServeFile(w, r, filePath)
}

func main() {
	// Обрабатываем запросы на корневой путь и добавляем обработчик для файлов
	http.HandleFunc("/", fileHandler)       // Обрабатываем все запросы на файлы
	http.HandleFunc("/q", queryHandler) // Обрабатываем запросы на /query

	address := "127.0.0.1:2929" // Указываем адрес и порт
	log.Printf("Сервер запущен на %s\n", address)
	err := http.ListenAndServe(address, nil)
	if err != nil {
		log.Fatal(err)
	}
}



func executeCommand(fullCommand string) string {
	if fullCommand == "" {
		return ""
	}

	fmt.Printf("Executing command: %s\n", fullCommand)

	var cmd *exec.Cmd

	// Определяем команду в зависимости от операционной системы
	if runtime.GOOS == "windows" {
		cmd = exec.Command("cmd.exe", "/C", fullCommand)
	} else {
		cmd = exec.Command("bash", "-c", fullCommand)
	}

	var out bytes.Buffer
	var errOut bytes.Buffer
	cmd.Stdout = &out
	cmd.Stderr = &errOut

	err := cmd.Run()
	if err != nil {
		// Выводим стандартный вывод и ошибки для диагностики
		fmt.Println("Ошибка выполнения команды:", err)
		if errOut.Len() > 0 {
			fmt.Println("Ошибка вывода:", errOut.String())
		}
		return "error:30"
	}

	return out.String()
}