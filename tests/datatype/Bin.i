// Code taken from: https://gist.github.com/bojidar-bg/85026fa70e6ba7b1862bf8226ba9feca

type Bin -- @Type end

node bend
  ------------
  Bin :value!
end

node b0
  Bin :higherbits
  ------------
  Bin :value!
end

node b1
  Bin :higherbits
  ------------
  Bin :value!
end

// Utilities

node bin_dup
  Bin :value!
  ------------
  Bin :result1
  Bin :result2
end

rule b1 bin_dup
  (b1)-higherbits bin_dup $d b1 result1-(bin_dup) d b1 result2-(bin_dup)
end

rule b0 bin_dup
  (b0)-higherbits bin_dup $d b0 result1-(bin_dup) d b0 result2-(bin_dup)
end

rule bend bin_dup
  bend result1-(bin_dup) bend result2-(bin_dup)
end

node bin_erase
  Bin :value!
  ------------
end

rule b1 bin_erase
  (b1)-higherbits bin_erase
end

rule b0 bin_erase
  (b0)-higherbits bin_erase
end

rule bend bin_erase
end

// b0q -- b0 when in the middle of a number, replaced by bend elsewhere - used to avoid unnecessary leading zeroes

node b0q
  Bin :higherbits!
  ------------
  Bin :value
end

rule b0 b0q
  (b0)-higherbits b0 b0 value-(b0q)
end

rule b1 b0q
  (b1)-higherbits b1 b0 value-(b0q)
end

rule bend b0q
  bend value-(b0q)
end

// Basic arithmetic - increment

node badd1
  Bin :value!
  ------------
  Bin :result
end

rule b1 badd1
  (b1)-higherbits badd1 b0 result-(badd1)
end

rule b0 badd1
  (b0)-higherbits b1 result-(badd1)
end

rule bend badd1
  bend b1 result-(badd1)
end

// Basic arithmetic - addition built on top of increment

node badd
  Bin :left
  Bin :right!
  ------------
  Bin :result
end

node baddadvance
  Bin :left!
  Bin :right
  ------------
  Bin :result
end

rule b0 badd
  (b0)-higherbits (badd)-left baddadvance result-(badd)
end

rule b1 badd
  (b1)-higherbits (badd)-left baddadvance badd1 result-(badd)
end

rule bend badd
  bend (badd)-left baddadvance result-(badd)
end

rule b0 baddadvance
  (baddadvance)-right (b0)-higherbits badd b0 result-(baddadvance)
end

rule b1 baddadvance
  (baddadvance)-right (b1)-higherbits badd b1 result-(baddadvance)
end

rule bend baddadvance
  (baddadvance)-right b0q result-(baddadvance)
end

// Basic arithmetic - multiplication built on top of addition

node bmul
  Bin :left
  Bin :right!
  ------------
  Bin :result
end

rule b0 bmul
  (b0)-higherbits (bmul)-left bmul b0 result-(bmul)
end

rule b1 bmul
  (b1)-higherbits (bmul)-left bin_dup $d bmul b0q d badd result-(bmul)
end

rule bend bmul
  bend result-(bmul)
  (bmul)-left bin_erase
end

// Conversion to and from Nat

import
  Nat, zero, add1,
  nat_erase, nat_dup
from "./Nat.i"

node nat_double
  Nat :target!
  ------------
  Nat :return
end

rule zero nat_double
  zero return-(nat_double)
end

rule add1 nat_double
  (add1)-prev nat_double add1 add1 return-(nat_double)
end

node ntob
  Nat :nat!
  ------------
  Bin :result
end

rule add1 ntob
  (add1)-prev
  ntob
  badd1 result-(ntob)
end

rule zero ntob
  bend result-(ntob)
end

node bton
  Bin :bin!
  ------------
  Nat :result
end

rule b0 bton
  (b0)-higherbits bton nat_double result-(bton)
end

rule b1 bton
  (b1)-higherbits bton nat_double add1 result-(bton)
end

rule bend bton
  zero result-(bton)
end

// Ideas for future development:
// - Change bend to bend0/bpos and bend1/bneg to support two's complement signed integers
// - Add subtraction
// - Add division and modulo (could be same node doing both?)
