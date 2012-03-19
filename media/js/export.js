var exportfl;

function im_done(originalRequest) {
  document.getElementById("statusimg").src="media/images/done2.png";
  document.getElementById("result").innerHTML="Click <a href='exp/"+exportfl+".tar'>here</a> to Download.";
}

function do_aj_req(exportfile) {
  exportfl = exportfile;
  var myAjax = new Ajax.Request(
    "doexport.php?action=export&filename="+exportfile,
    { method: 'get', onComplete: im_done }
  );
}
