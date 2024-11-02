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
