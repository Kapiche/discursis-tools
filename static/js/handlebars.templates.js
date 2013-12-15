(function() {
  var template = Handlebars.template, templates = Handlebars.templates = Handlebars.templates || {};
templates['annotations'] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n        <li class=\"list-group-item\"><label><input type=\"checkbox\" value=\"";
  if (stack1 = helpers.name) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.name); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "\"> ";
  if (stack1 = helpers.name) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.name); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "</label></li>\n        ";
  return buffer;
  }

  buffer += "<div class=\"col-lg-6\">\n    <h2>Step 1 - Select Tiers to include:</h2>\n    <p><em>Only tiers with at least 1 annotation are shown.</em></p>\n    <ul class=\"list-group\">\n        ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.annotations), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </ul>\n</div>\n<div class=\"col-lg-6\">\n    <h2>Step 2 - Download the Discursis CSV file</h2>\n    <button type=\"button\" id=\"elan-save-btn\" class=\"btn btn-primary btn-lg\" disabled><span class=\"glyphicon glyphicon-download-alt\"></span> Download CSV</button>\n    <p><strong>Please Note:</strong> In <strong><a href=\"http://www.google.com/chrome/‎\" target=\"_blank\">Chrome</a></strong> the file will download automatically, in <strong><a href=\"http://www.mozilla.org/en-US/firefox/\" target=\"_blank\">Firefox</a></strong> the download dialogue will pop up and in <strong><a href=\"http://www.apple.com/au/safari/‎\" target=\"_blank\">Safari</a></strong> the content of the CSV will open in a new tab and you will need to save the page manually. God knows what will happen in <strong>IE</strong>, you shouldn't use IE...</p>\n</div>\n\n";
  return buffer;
  });
})();