function resetSearchValue(v) {
	if (v == 'a' || elementValue('a') == '') removeElement('a');
	if (v == 'l' || elementValue('l') == '') removeElement('l');
	if (v == 's' || elementValue('s') == '') removeElement('s');
	removeElement('resetsearch');
	document.getElementById("searchform").submit();
}

function removeElement(v) {
	var e = document.getElementById(v);
	if (e) {
		if (v == 's') {
			// it looks ugly if the input disappears so replace it with a dummy
			var r = document.createElement('input');
			r.type = 'text';
			e.replaceWith(r);
		}
		else {
			e.parentNode.removeChild(e);
		}
	}
}

function elementValue(v) {
	var e = document.getElementById(v);
	if (e)
		return e.value;
	else
		return "";
}
