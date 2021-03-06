import showdown from "showdown";

// tab support for all textaread on page (4 spaces)
var textareas = document.getElementsByTagName("textarea");
var count = textareas.length;
for (var i = 0; i < count; i++) {
  textareas[i].onkeydown = function(e) {
    if(e.keyCode == 9 || e.which == 9){
      e.preventDefault();
      var s = this.selectionStart;
      this.value = this.value.substring(0, this.selectionStart) + "    " + this.value.substring(this.selectionEnd);
      this.selectionEnd = s + "    ".length;
    }
  }
}

// show markdown preview
var converter = new showdown.Converter({
  "tables": true, 
  "disableForced4SpacesIndentedSublists": true
});
var preview = document.getElementById("preview");
document.getElementById("post_body").addEventListener("input", function() {
  var md = this.value;
  var html = converter.makeHtml(md).replace("<table>", "<table class=\"pure-table\">");
  preview.innerHTML = html;
});