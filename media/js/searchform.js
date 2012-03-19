document.onkeydown=handleKeyEvent;

function resetSearchForm() {
  document.getElementById("sbox").innerHTML += '<form><input type="text" /> <input type="submit" value="&#9747;" /></form>';
  document.getElementById("searchform").style.display = 'none';;
  sfield = document.getElementById("s");
  sfield.parentNode.removeChild(sfield);
  document.getElementById("searchform").submit();
}

function handleKeyEvent (e) {
  if (!e) e=window.event;
  if (e.keyCode==88 && e.ctrlKey) {
    resetSearchForm();
  }
}
