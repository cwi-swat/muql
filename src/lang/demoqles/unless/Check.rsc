module lang::demoqles::unless::Check

import lang::demoqles::unless::Unless;
extend lang::demoqles::ql::Check;

set[Message] tc((Question)`unless (<Expr c>) <Question q>`, Info i) 
  = tcCond(c, i) + tc(q, i);



