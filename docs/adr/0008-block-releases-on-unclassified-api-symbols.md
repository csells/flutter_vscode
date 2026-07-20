---
status: accepted
---

# Block Releases on Unclassified API Symbols

An API Parity Baseline update will fail when the Binding Pipeline encounters an
unclassified or ambiguous symbol. A maintainer must add an explicit Semantic
Override or extend a general translation rule before the new baseline can ship;
the generator will never silently drop the symbol, infer a likely meaning, or
replace it with `dynamic` unless `dynamic` is the faithful upstream type.

The previous baseline remains supported while the update is resolved. This
trades automatic release speed for compile-time accuracy and prevents
plausible-but-wrong bindings from becoming failures for Extension Users.
