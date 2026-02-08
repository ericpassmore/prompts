# iOS Commerce App Structure (iPhone + iPad)

## Metadata
- Name: iOS Commerce App
- Type: Native iOS single app target set
- Language/Runtime: Swift 5+ with SwiftUI
- Platforms: iPhone and iPad (shared app)
- Commerce Model: Server-authoritative cart and checkout

## Objectives
- Build one shared iOS codebase that adapts UX for iPhone and iPad.
- Support core commerce flows: catalog, product detail, cart, checkout, and order history.
- Keep cart state authoritative on server APIs while maintaining responsive local UI state.
- Integrate payments through backend APIs that encapsulate payment rails.
- Maintain reliable build, lint, and test workflows for CI and local development.

## Layout
```text
/
├── iOSCommerceApp.xcodeproj
├── iOSCommerceApp/
│   ├── App/
│   │   ├── iOSCommerceApp.swift
│   │   └── AppEnvironment.swift
│   ├── Core/
│   │   ├── Networking/
│   │   ├── Models/
│   │   ├── State/
│   │   ├── DesignSystem/
│   │   └── Utilities/
│   ├── Features/
│   │   ├── Catalog/
│   │   ├── ProductDetail/
│   │   ├── Cart/
│   │   ├── Checkout/
│   │   ├── Orders/
│   │   └── Account/
│   ├── Services/
│   │   ├── CartService/
│   │   ├── CheckoutService/
│   │   ├── ProductService/
│   │   └── OrderService/
│   ├── Resources/
│   │   ├── Assets.xcassets
│   │   └── Localizable.strings
│   └── Supporting/
│       ├── Config/
│       └── PreviewData/
├── iOSCommerceAppTests/
│   ├── Unit/
│   └── Integration/
├── iOSCommerceAppUITests/
│   └── Flows/
└── docs/
    ├── architecture.md
    ├── api-contracts.md
    └── commerce-flows.md
```

## Actions
- Implement adaptive SwiftUI layouts with size-class driven presentation for iPhone and iPad.
- Model server API contracts in `Core/Models` and keep transport logic in `Core/Networking`.
- Keep feature modules isolated under `Features/` with dedicated views, view models, and routing.
- Implement server-authoritative cart operations through `Services/CartService` (add, update quantity, remove, refresh).
- Reconcile optimistic local cart UI updates against server responses and error states.
- Route checkout initiation and payment intents through backend APIs only; client does not encode payment-rail specifics.
- Cover cart and checkout flows with unit, integration, and UI tests.

## Verification
- Lint: `swiftlint`
- Build: `xcodebuild -project iOSCommerceApp.xcodeproj -scheme iOSCommerceApp -destination 'platform=iOS Simulator,name=iPhone 16' build`
- Test: `xcodebuild -project iOSCommerceApp.xcodeproj -scheme iOSCommerceApp -destination 'platform=iOS Simulator,name=iPhone 16' test`

## Constraints
- Use one shared app architecture for iPhone and iPad; avoid duplicated feature implementations per device.
- Treat server as the source of truth for cart totals, promotions, taxes, and checkout state.
- Keep payment provider logic behind backend APIs; iOS app consumes normalized checkout endpoints only.
- Keep feature boundaries explicit: UI in `Features/`, domain/integration logic in `Services/` and `Core/`.
- Maintain offline-tolerant UX, but always re-sync cart before checkout confirmation.

## Success Criteria
- App compiles and tests pass via `xcodebuild` commands in Verification.
- Catalog-to-cart-to-checkout flow works on both iPhone and iPad layouts.
- Cart mutations persist through backend APIs and remain consistent after app relaunch and refresh.
- Payment initiation succeeds via backend API flow without client-side payment-rail coupling.
- Architecture and API expectations are documented under `docs/`.

## Non-Goals
- Defining backend service internals or payment-provider account configuration.
- Building Android or web clients.
- Implementing warehouse, fulfillment, or ERP workflows.
- Defining marketing CMS content pipelines.
