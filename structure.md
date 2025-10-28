# Backend Structure

## Routes (`/src/routes`)

Routes are the entrypoint for the frontend. 

They:
- Should only handle HTTP 
  - Pulling out headers (webhook verification for instance)
  - Pull out params (/:orgId/:accountId)
  - Pull out body
- They feed those things into:
  - Services, only for
    - Header / signature verification
    - Single-line getters like Plaid link_token fetching

## Controllers (`/src/controllers`)

Controllers sanitize and validate inputs from routes, and aggregate work that needs doing. 

They:
- Should take as little time as possible to complete
  - If you need to do something heavy, throw it on a queue to process async
- Should not do anything with databases (prisma) except for create transactions services can use
- Should call services to do the work they need
- Perform business logic

### Accounts Controller

Used for financial accounts (not users). Can add or remove banks, wallets, and exchanges from here. 

### Auth Controller

User for registering new users (and creating orgs for org-less users), and logging in. 

### Org Controller

Used for any org action like inviting/removing team members, updating settings or billing info, etc.


## Models

These are types that must import non-declared types (can't use the `/types` dir since `.d.ts` files don't support that). They could be things like backend-only enums, or interfaces.

### RawTransaction Model

This is what the `transaction.queue` expects back from financial connection vendors when they give back transactions from fetchers. It's what will be later transformed and inserted into the database.

## Services (`/src/services`)

Services come in two layers: 
- **Abstractions** around concepts (assets, connections, etc)
- **Vendors**: transformers that return uniform data or spawn queues from webhooks


Abstractions handle things like creating or updating types of records (`Org`, `TokenBalance`, etc). Something like the `AssetService.createOrGetToken` handles everything you need to get or insert a token into the database including indices and uniqueness. 

Vendors integrate directly with some third party like CoinMarketCap, the Vaulta blockchain, Moralis, etc and return data in a way that consumers expect all similarly grouped service to.

The preference should always be to use non-vendor services for interacting with the database as they handle special cases like never pulling soft deleted records, or validating inputs to prevent catastrophe. 

### FinancialConnectionService (`services/connection.service`)

Is used for both `FinancialConnection` and `FinancialAccount` models.

## Queues (`/src/queues`)

Queues come in three parts:
- `/models/queues.model.ts` houses an enum for channels
- `/queues` houses queues for specific actions
- `/services/queue.service` handles queueing up tasks, pubsub (and/or pulling next queue items manually)

The model file is used so that services and vendors aren't importing them from services they aren't supposed to import. It allows you to set up channels as you need them for queue processing, and interfaces for typing the task `payload`.

Queue files inside of `/queues` are similar to controllers. They are business logic containers for specific task processing. No vendors or services will ever call into those files, so they are safe to call any service into them for processing.

Queues can be unique, or multiple.
- `QueueService.queue` is used to queue something that can have multiple payloads (Task{accountId})
- `QueueService.queueUniqueByChannel` is used for processes that should only run once on a machine (webhook queues work that way right now)

### Assets queue

Handles gathering balances for accounts that are marked as stale

### Email queue

Handles sending emails to users so that we aren't blocking their actions.

### Org queue

Handles adding a user to an org from an invite. This is somewhat of a special case since we can't risk there being an error when they try to login with an existing account if they are joining a new org and are already part of an org. So their new org linking is done async if they login with an invitation token.

### Transaction queue

Handles getting historical transactions, processing incoming transactions from webhooks, syncing plaid transactions.

### Webhooks queue

Handles refreshing webhooks when new financial accounts are added since most of our webhook vendors have some penalty or rate limit for doing so, and also to unblock the user action when linking new accounts.


## Utils (`/src/utils`)

- `cron.util` allows starting and stopping jobs on a millisecond interval
- `logger.util` should be used instead of `console.log` so that we can capture logs in third party services later
- `ngrok.util` is used for testing webhooks locally and sets up an https relay into your localhost
- `router.util` is where you place any routers that you've created in the `/routes` dir. These will be auto-placed under a `/v1/` prefix.
- `startup.util` is a single location that you can services when the backend starts up. 


## Index file (`/src/index.ts`)

Mostly that file doesn't need changing, but there's an `onServerStop` that you might want to place things that need tearing down if the app crashes. 

## Tests  (`/tests`)

We're using two flavors of tests right now:
- Unit tests - anything that doesn't need to tap into a real service, or uses mocks
- Integration tests - anything that needs to test real flows like database, moralis, plaid, etc.

## Types  (`/types`)

Any of these files that uses the `declare` keyword for types will be used at transpile time and don't need to be manually imported into other files to be used as a type. 


