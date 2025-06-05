# Dice Splitter

Dice Splitter is a SwiftUI board game where players claim and grow dice on a grid. Each turn you increment a die to increase its value and spread your influence across neighboring spaces. Dice that exceed the number of adjacent tiles "split" and cause a chain reaction to surrounding dice.

## Features

- Adjustable board size using the settings panel or onboarding flow.
- Supports 2--4 players with either human or AI opponents.
- Cross‑platform target for iPhone, iPad and Mac Catalyst.
- Animated SwiftUI interface with mesh gradients and particle effects.
- Unit and UI tests included under `DiceSplitterTests` and `DiceSplitterUITests`.

## Requirements

- Xcode 15 or later.
- iOS 18, iPadOS 18 or macOS 15 to run on device.
- Swift 6 for the main app (Swift 5 for test targets).

## Building

Open `DiceSplitter.xcodeproj` in Xcode and run the **DiceSplitter** scheme on your chosen simulator or device. The project contains an onboarding flow that lets you select board size, number of players and whether to face an AI opponent.

## Running Tests

Select `Product > Test` in Xcode to run the unit and UI test suites. Tests verify board initialization, move logic and basic game mechanics.

## Privacy

A privacy policy is included in [`Readme.md`](Readme.md).
