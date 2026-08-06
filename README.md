# SwiftUI Snippets Library

A personal, reusable collection of **SwiftUI code snippets, patterns, and documentation** for everyday iOS development. Every file is heavily commented and self-contained so you can read it directly on GitHub and copy what you need.

> Target: iOS 16+ (notes call out iOS 17 `@Observable` where relevant). Language: Swift 5.9+.

## 📚 Contents

| Topic | What's inside |
|-------|---------------|
| [Models](./01-Models) | `Codable` model classes/structs, nested JSON, decoding strategies |
| [Networking](./02-Networking) | `async/await` network layer, `URLSession`, error handling, generic API client |
| [Dependency Injection](./03-DependencyInjection) | `@EnvironmentObject`, protocol-based DI, custom `EnvironmentKey` |
| [Lists](./04-Lists) | Basic `List`, sections, navigation, swipe actions, pull-to-refresh |
| [Search](./05-Search) | `.searchable`, live filtering, search scopes, debounced search |
| [Images](./06-Images) | `AsyncImage`, custom async image loader with in-memory + disk cache |
| [State Management](./07-StateManagement) | `@State`, `@Binding`, `@StateObject`, `@ObservedObject`, `@Observable` |
| [Navigation](./08-Navigation) | `NavigationStack`, programmatic navigation, sheets, deep-linking |
| [Forms & Input](./09-FormsAndInput) | `Form`, `TextField`, `Picker`, `Toggle`, validation |
| [Persistence](./10-Persistence) | `@AppStorage`, `UserDefaults`, `FileManager` JSON store |
| [Layout](./11-Layout) | Stacks, `LazyVGrid`, `Grid`, `GeometryReader`, adaptive layouts |
| [Alerts & Sheets](./12-AlertsAndSheets) | `alert`, `confirmationDialog`, `sheet`, `fullScreenCover` |
| [Animations](./13-Animations) | Implicit/explicit animations, transitions, `matchedGeometryEffect` |
| [Extensions & Modifiers](./14-ExtensionsAndModifiers) | Reusable `ViewModifier`, `View` extensions, `Color` hex init |
| [SwiftData & Core Data](./15-SwiftData-CoreData) | `@Model`/`@Query` CRUD, Core Data step-by-step guide |
| [Combine](./16-Combine) | Publishers/operators, debounced search, Combine networking |
| [Testing](./17-Testing) | Unit-testing the network layer (mock service, `URLProtocol` stub, Swift Testing) |
| [Charts](./18-Charts) | Swift Charts — bar/line/multi-series, interactive selection |
| [Accessibility](./19-Accessibility) | VoiceOver labels/traits, Dynamic Type, semantic fonts |
| [Dark / Light Mode](./20-DarkLightMode) | Semantic colors, asset color sets, persisted theme switcher |
| [Image Picking & Display](./21-ImagePicker) | `PhotosPicker` (single/multi), camera via `UIImagePickerController` |
| [SSL / Certificate Pinning](./22-SSLPinning) | Certificate pinning & public-key pinning via `URLSessionDelegate` |

> 🔐 **Secrets** (auth tokens, passwords) go in the [Keychain](./10-Persistence/Keychain.swift), not UserDefaults.

## 🧭 How to use this repo

1. Browse the folder for the feature you need.
2. Each folder has a `README.md` explaining the concept and when to use it.
3. **Read files in order — simplest first.** Where a topic has both, files are ordered `*-Simple` → `*-FullCRUD`/`*-Advanced`, and each README has a simple→advanced table. Start at the top; only go deeper if you need to.
4. Copy the `.swift` file (or the relevant snippet) into your project.
5. Comments explain **why**, not just **what** — read them before adapting.

## 🗂 Folder convention

```
NN-Topic/
├── README.md          # concept explanation + when to use
└── *.swift            # ready-to-copy, heavily-commented snippets
```

## ✅ Conventions used in the snippets

- **MARK comments** (`// MARK: -`) to make files navigable in Xcode.
- **DocC-style doc comments** (`///`) on public types and functions.
- **Preview providers** (`#Preview`) so every view can be dropped into Xcode and run.
- Networking uses **`async/await`** (not completion handlers) as the default.

---

_Maintained as a personal reference. PRs to myself welcome._
