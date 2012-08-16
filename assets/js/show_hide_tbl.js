
$("#swtch_why").click(function(event){
    if($("#tbl_why").css("display")=="none"){
        $("#tbl_why").css("display", "table")
        $("#tbl_why").css("visibility", "visible")
        $("#swtch_why").text("Hide")
        $("#swtch_why").attr("title", "Hide why")
    }else{
        $("#tbl_why").css("display", "none")
        $("#tbl_why").css("visibility", "hidden")
        $("#swtch_why").text("Why?")
        $("#swtch_why").attr("title", "Show why")
    }
    event.preventDefault();  
});
// function tbl_switch(){
//     var tbl = document.getElementById('tbl_why');
//     var swtch = document.getElementById('swtch_why');
//     if(tbl.style.display=="none"){
//         tbl.style.display = "table"
//         tbl.style.visibility = "visible"
//         swtch.innerHTML = "Hide"
//         swtch.title = "Hide why"
//     }else{
//         tbl.style.display = "none"
//         tbl.style.visibility = "hidden"
//         swtch.innerHTML = "Why?"
//         swtch.title = "Show why"
//     }
// }