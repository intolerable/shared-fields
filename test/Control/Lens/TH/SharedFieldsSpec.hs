module Control.Lens.TH.SharedFieldsSpec
  ( main
  , spec
  , HasA
  , Test(..)
  , a ) where

import Control.Lens.TH.SharedFields

import Control.Lens
import Test.Hspec

data Test = Test { _testA :: String }
  deriving (Show, Eq)

generateField "A"
makeFields ''Test

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
  describe "Test" $ do
    it "should have a working getter" $ do
      Test "hello" ^. a `shouldBe` "hello"
    it "should have a working setter" $ do
      (Test "hello" & a .~ "goodbye") `shouldBe` Test "goodbye"
