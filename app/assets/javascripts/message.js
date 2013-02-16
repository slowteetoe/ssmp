$(document).ready(function(){
  $("#decryptform")
    .bind("ajax:success", function(evt, data, status, xhr){
      $("#contents").val(data["msg"]);
    })
    .bind("ajax:error", function(evt, data, status, xhr){
      alert("Sorry, we're unable to complete your request.  We apologize.");
   });
});
