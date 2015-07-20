shared-fields
---

[view on hackage](https://hackage.haskell.org/package/shared-fields)

A simple single-module library for creating [lens](https://hackage.haskell.org/package/lens) field typeclasses in a way that allows them to be shared between modules.

By default, lens' `makeFields` creates a new class if it can't find a matching one in scope. This means that if you try to `makeFields` records in different modules without importing one module into the other, you'll get conflicting class definitions rather than a single lens which functions with both records.

```haskell
module A where
data A = A { _aThing :: Bool }
  deriving (Show, Read, Eq)
makeFields ''A

module B where
data B = B { _bThing :: String }
   deriving (Show, Read, Eq)
makeFields ''B

module Main where
import A
import B
import Control.Lens

main = print $ A False ^. thing -- fails because there are two HasThing classes
```

If you use `shared-fields`, though:

```haskell
module SharedFields where
generateField "Thing"

-- alternatively:
-- generateFields ["Thing"]

module A where
import SharedFields
data A = A { _aThing :: Bool }
  deriving (Show, Read, Eq)
makeFields ''A

module B where
import SharedFields
data B = B { _bThing :: String }
   deriving (Show, Read, Eq)
makeFields ''B

module Main where
import A
import B
import Control.Lens

main = print $ A False ^. thing -- works now because there's one consistent HasThing class!
```
