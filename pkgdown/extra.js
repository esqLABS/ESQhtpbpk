$(document).ready(function(){
  $(".toggle-code-block").before('<div class="code-fold-toggle">Show/Hide Code</div>');
  $(".toggle-code-block").find(".sourceCode").hide()
  $(".code-fold-toggle").click(function(){
    $(this).next(".toggle-code-block").find(".sourceCode").toggle();
  });
});
