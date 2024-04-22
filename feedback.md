

## Firebase 30

##### https://github.com/lmu-cmsi2022-spring2024/firebase-backed-team-ethan

| Category | Feedback | Points |
| --- | --- | ---: |
| **Baseline functionality** | | |
| • Authentication | Firebase authentication meets criteria. | 4/4 |
| • Firestore | Firestore reading and writing meets criteria. | 4/4 |
| • Security | Firebase security is not properly set up—although the actual security policy is not provided (see below for why), testing has shown that it is possible to write to the database without being logged in. This implies that guard code for preventing unauthorized writes to the blog is front-end only, and not enforced on the back end (–4) | 0/4 |
| **Three features** | | |
| • Feature 1 | Custom sign up/sign in/sign out implementation nearly meets criteria, except for sign out: the “logout” button on upper-left merely sets the front-end user object to `nil` but does not actually invoke the `Auth.auth().signOut()` function, meaning that the user is “silently” still signed in from the perspective of the back end (–2) | 10/12 |
| • Feature 2 | Article link implementation meets criteria | 12/12 |
| • Feature 3 | User profile with profile name meets criteria; UI is provided for custom limits and article sorting but the feature is unfinished (+3) | 15/12 |
| **Baseline code quality** | | |
| • Abstraction of Firebase functionality | `SignInView` invokes the Firebase `Auth` functions directly—these should have been abstracted into `FirebaseBackedMobileAppAuth` (–2) | 6/8 |
| • Feedback for operations-in-progress | No aynchronous progress feedback is seen (–6) | 0/6 |  
| • Error handling and messaging | Authentication error-handling meets criteria, but all other errors are relegated to `print` statements which the user will not see (–1). | 5/6 |
| **Baseline design/layout** | | |
| • Layout and composition | Layout/composition meets criteria. | 5/5 |
| • Colors and other visuals | Colors/visuals meets criteria. | 4/4 |
| • Proper choice of input views and controls | Input views are generally straightforward although there is some potential for confusion between the secondary Back button when viewing an article and the overall icon “back” button at the top left—the blue-on-purple color scheme of the former can make it easy to miss and result in inadvertent logout when the user actually just wants to go back to the blog list (–1) | 4/5 |
| **Implementation specifications** | | |
| • Model objects | Model objects meet criteria—`fetchUserData` borderline misses this but is OK for all-or-nothing purposes | ✅ |
| • Interaction with Firebase | Firebase interactions meet criteria. | ✅ |
| • Coded-in animations or transitions | Meets criteria with animation and transition | ✅ |
| • Programmed graphics | Meets criteria with gradient and other custom visual elements | ✅ |
| • Custom app icon | Custom app icon meets criteria. | ✅ |
| | _All or nothing_ | 10/10 |
| **Blog app description** | | |
| • About the added features | About 3 features meet criteria. | 6/6 |
| • Production security policy | What is represented in the _about.md_ file as the production security policy is actually the Firebase configuration file. The security policy was pointed out and discussed in class and can be reviewed in the screen recordings on Brightspace if needed (–2) | 0/2 |
| **Other categories** | | |
| • Credits where appropriate | Meets criteria with credits. |  |
| Code maintainability | Maintainability meets criteria. |  |
| Code readability | Code readability meets criteria. |  |
| Version control | Commit granularity could be better (–1); messages can be more descriptive overall too (–1)<br><br>The Xcode project file was not committed properly—although the files themselves were in GitHub, the committed project file did not list them, requiring a manual add of the files to the project after cloning. Correct usage of version control would have made this unnecessary (–2)<br><br>In addition, the project was not committed with package dependency settings saved; this should have been done for a better turnkey experience (–2), to avoid package guesswork (i.e., “which packages are needed’) (–2), and to ensure that the correct package versions are installed (–2) | -10 |
| Punctuality | Last commit 3/25 8:13pm |  |
| | **Total** | **75/100** |

