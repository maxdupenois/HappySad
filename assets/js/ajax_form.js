$("#frm_happysad").submit(function(event){
    $('div#sentiment').detach()
    jQuery.ajax("/asynch",{
                  type : 'post',
                  data : {'website':$("#frm_happysad input:text[name=website]").val()},
                  dataType : 'html',
                  success : sentiment_returned
              });
    $("#frm_happysad input").attr("disabled", "disabled");
    
    $('#frm_happysad').after('<img src="/img/ajax-loader.gif" alt="Processing" id="img_processing"/>')
    $('#frm_happysad').css("display", "none")
    event.preventDefault();
});


function sentiment_returned(data, textStatus, jqXHR){
    $("#frm_happysad input").removeAttr("disabled")
    $("#img_processing").detach()
    $('#frm_happysad').css("display", "block")
    $('#frm_happysad').after(data)
    jQuery.getScript( "/js/show_hide_tbl.js" );
}