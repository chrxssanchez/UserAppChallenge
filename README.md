
## My changes

**Bugs:**
- `User` wasn't `Identifiable`, so `List(users)` didn't compile. 
- The client decoded a `{ "users": [...] }` wrapper, but the API returns a plain array, so every load failed. 
- The view used `@ObservedObject` for a view model it created itself, so it could be recreated and lose its data. 
- Refresh could start overlapping requests, and on a fast network the spinner only flashed.

**Fixes:** 
- Decode `[User]` directly and treat non-2xxs responses as errors. 
- The view model is `@MainActor` and `@Observable`, owned by the view with `@State`.
- `load()` ignores calls while already loading, and Refresh is disabled meanwhile. 
- Every state sits in one `List`, so pull to refresh works from any screen, including errors.
- The loading indicator shows for at least 500 ms so refreshes are visible.

**Testing:** 
- The view model depends on a `UsersFetch` protocol, so tests use a mock with no network.
- `UsersState` is `Equatable` (errors become a message), so tests compare whole states. 
- Swift Testing covers decoding a real API sample, success, failure, the loading state, refresh, double taps and the minimum loading time.

**Trade-offs / Design decisions:**
- Refresh reuses the same loading state as the first load, rather than keeping the old list visible, to match the brief and keep state simple. Because the API responds so quickly, I added a 500 ms minimum loading time so users can see a refresh actually happened.
- I wrapped `content` in a single `List` with `.refreshable`, so pull to refresh works from any state, including errors.
- I used the `@Observable` macro with `@State`, since the minimum target is iOS 26. It needs less boilerplate and only redraws views that read the changed property. If the app had to support iOS 16 or earlier, I'd have used `ObservableObject` with `@StateObject`.
