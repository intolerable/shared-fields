module Control.Lens.TH.SharedFields
  ( generateField
  , generateFields ) where

import Data.Char
import Language.Haskell.TH

-- | Generate classes for a field that will be shared between modules
--     without using 'makeFields' (which would create an extra
--     instance at minimum)
generateField :: String -> Q [Dec]
generateField = return . return . make

-- | Generate classes for multiple fields. Use this if you want to
--     define a bunch of fields.
generateFields :: [String] -> Q [Dec]
generateFields = return . map make

make :: String -> Dec
make name =
  ClassD
    []
    (mkName $ "Has" ++ name)
    [PlainTV s, PlainTV a]
    [FunDep [s] [a]]
    [SigD (mkName $ functionName name) methodType]
  where
    s = mkName "s"
    a = mkName "a"
    f = mkName "f"
    vs = VarT s
    va = VarT a
    vf = VarT f
    methodType =
      ForallT
        [PlainTV f]
        [ClassP ''Functor [vf]]
        ((va `arrow` AppT vf va) `arrow` (vs `arrow` AppT vf vs))

arrow :: Type -> Type -> Type
arrow x y = AppT (AppT ArrowT x) y

functionName :: String -> String
functionName (x:xs) = toLower x : xs
functionName _ = error "invalid class name"
