module lang::muql::ql::Form2HTML

import lang::muql::ql::Types;
import lang::muql::ql::QL;
import lang::muql::ql::Expr2JS;
import lang::muql::ql::Form2Model;
import lang::muql::ql::Bind;
import IO;
import ParseTree;

void testGen() {
  pt = parse(#start[Form], |project://muql/input/tax.mql|);
  <f, defs> = definitions(pt.top);
  f = bind(f, defs);
  g = form2html(f);
  println(g);
}  

loc TEMPLATE = |project://muql/src/lang/muql/template.html|;

str qName(Question q) = "<q.var>_<q@\loc.offset>";
str qLabel(Question q) = "<q.label>";

str form2html(Form f) {
  name = "<f.name>";
  t = readFile(TEMPLATE);
  return top-down-break visit (t) {
    case /TITLE/ => name
    case /CONTENT/ => form2items(f)
    case /INIT/ => "<form2model(f, name)>
                   '$(document).ready(function() {
                   '   ko.applyBindings(new <name>Model());
                   '});"
  }
}

str form2items(Form f) = 
  "\<ul\>
  '  <( "\n" | it + question2item(q) + "\n" | /Question q := f, q has var)>
  '\</ul\>"; 

str expr2js(Expr e) = expr2js(e, str(str x) { return x; });

str question2item(Question q) 
  = "\<li data-bind=\"visible: <qName(q)>_visible\"\>
    '  <question2html(q)>
    '\</li\>";

str question2html(Question q) 
  = labeledWidget(q, inputWidget(qName(q), "checkbox", "checked: <qName(q)>"))
  when (Type)`boolean` := q.\type;  

default str question2html(Question q) = // ignore type for now 
  labeledWidget(q, inputWidget(qName(q), "text", "value: <qName(q)>"));

str inputWidget(str name, str tipe, str bind) 
  = "\<input name=\"<name>\" id=\"<name>\" type=\"<tipe>\" data-bind=\"<bind>\" /\>";

str labeledWidget(Question q, str w) 
  = "\<label for=\"<qName(q)>\"\><qLabel(q)>\</label\>\n<w>";


