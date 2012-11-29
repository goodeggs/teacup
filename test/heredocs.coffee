expect = require 'expect.js'
{render, script} = require '../tags'

describe 'HereDocs', ->
  it 'preserves line breaks', ->
    template = -> script """
      $(document).ready(function(){
        alert('test');
      });
    """
    expect(render template).to.equal '<script>$(document).ready(function(){\n  alert(\'test\');\n});</script>'
