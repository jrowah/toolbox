Event sourcing: is a way of storing data as a sequence of events rather than just storing the current state. In this pattern, every change to your application's state is captured as an immutable event, and the current state can be derived by replaying those events in order.

Command: a request for something to happen, an instruction, not a fact, and is named with an imperative verb. "I want to deposit $100" is an event, it can be rejected, and can be named imperatively as DepositMoney.
Event: is a record that something already happened. "A deposit of $100 occurred at 2PM", is a fact, immutable, and named in past tense; MoneyDeposited.

Aggregate: is an entity that commands are sent to and events belong to; is a logical boundary around a group of related data that changes together, with single ID. A bank account can be an aggregate; has an identity (account number), receives commands (DepositMoney), enforces rules ("You can't withdraw more than your balance"), and its state is rebuilt by replaying its own events. Aggregate state is not meant to be shared and not meant for external consumption.
Characteristics of an aggregate;
Validates incoming commands and returns at least one event
Applies events to state to produce new state
Application of events and commands is pure and referentially transparent (no side effects)

Event Sourcing Rules:
All events are immutable and Past Tense
Applying a Failure Event Must Always Return the Previous State
