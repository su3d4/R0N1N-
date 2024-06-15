-- HaskTimeSpace.hs

{-# LANGUAGE GADTs #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE DataKinds #-}

module HaskTimeSpace where

import Data.Kind (Type)
import GHC.TypeLits (Nat)

-- **Temporal Library (HaskTime)**

data Time :: Nat -> Type where
  MkTime :: Integer -> Time n

instance Eq (Time n) where
  (==) = (==) `on` getTime

getTime :: Time n -> Integer
getTime (MkTime t) = t

-- Temporal operations

addTime :: Time n -> Time m -> Time (n + m)
addTime (MkTime t1) (MkTime t2) = MkTime (t1 + t2)

subTime :: Time n -> Time m -> Time (n - m)
subTime (MkTime t1) (MkTime t2) = MkTime (t1 - t2)

-- **Spatial Library (HaskSpace)**

data Point :: Type where
  MkPoint :: Double -> Double -> Point

instance Eq Point where
  (==) = (==) `on` getX &&& (==) `on` getY

getX :: Point -> Double
getX (MkPoint x _) = x

getY :: Point -> Double
getY (MkPoint _ y) = y

-- Spatial operations

distance :: Point -> Point -> Double
distance p1 p2 = sqrt ((getX p1 - getX p2) ^ 2 + (getY p1 - getY p2) ^ 2)

-- **Temporal-Spatial Integration**

data Trajectory :: Nat -> Type where
  MkTrajectory :: [Time n] -> [Point] -> Trajectory n

instance Functor Trajectory where
  fmap f (MkTrajectory ts ps) = MkTrajectory ts (map f ps)

-- Initializers

zeroTime :: Time 0
zeroTime = MkTime 0

origin :: Point
origin = MkPoint 0.0 0.0

exampleTrajectory :: Trajectory 3
exampleTrajectory =
  MkTrajectory [MkTime 1, MkTime 2, MkTime 3]
             [MkPoint 1.0 2.0, MkPoint 3.0 4.0, MkPoint 5.0 6.0]

-- This is just an initial iteration, and there's much more to be added,
-- refined, and optimized.
