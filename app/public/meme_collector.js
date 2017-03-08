
console.log("Hi");
const validCheckBoxElement = document.getElementById("valid_only");
const toggleInvalidMemes = function () {
  const invalidMemes = document.querySelectorAll("[data-valid='false']");

  for (let i = 0; i < invalidMemes.length; i++) {
    const meme = invalidMemes[i];
    meme.style.display = validCheckBoxElement.checked ? 'none' : 'table-row';
  }
};

validCheckBoxElement.addEventListener("change", toggleInvalidMemes);
toggleInvalidMemes();
