async function fetchTextFromUrl(url) {
  try {
    const response = await fetch(url);
    if (!response.ok) {
      throw new Error(`HTTP error! Status: ${response.status}`);
    }
    const text = await response.text();
    return text;
  } catch (error) {
    console.error("Ошибка при получении данных:", error);
    throw error; // Проброс ошибки, чтобы она могла быть обработана вызывающим кодом
  }
}

async function switch_page(page) {
  const elements = document.querySelectorAll(".left-btn");

  // Преобразуем NodeList в массив и используем forEach для перебора элементов
  elements.forEach(function (element) {
    element.classList.remove("active");
  });

  document.getElementById("page:" + page).classList.add("active");
  document.getElementById("page").src = "pages/" + page + ".html";
}
