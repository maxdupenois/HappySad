function tbl_switch(){
    var tbl = document.getElementById('tbl_why');
    var swtch = document.getElementById('swtch_why');
    if(tbl.style.display=="none"){
        tbl.style.display = "table"
        tbl.style.visibility = "visible"
        swtch.innerHTML = "Hide"
        swtch.title = "Hide why"
    }else{
        tbl.style.display = "none"
        tbl.style.visibility = "hidden"
        swtch.innerHTML = "Why?"
        swtch.title = "Show why"
    }
}