import SwiftUI

struct HomepageView: View {
    @EnvironmentObject var auth: FirebaseBackedMobileAppAuth
    @EnvironmentObject var articleService: FirebaseBackedMobileAppArticle
    
    @State private var searchText = "" //text in search bar
    @State private var writing = false //pull up ArticleEntry sheet
    @State private var showingProfile = false //pull up ProfileView sheet
    @State private var showingSearchModifiers = false //pull up SearchModifersView sheet
    
    @State private var selectedSortOption: ArticleSortOption = .mostRecent //initial sort option for ArticleList
    @State private var numberOfResults: Double = 20 //initial number of results shown for ArticleList
    
    //both @State variables above will be the initla values seen when SearchModifersview Shett is pulled up as well
    
    @State private var isSignedIn = false // to trigger animation when sign-in status changes
    
    //overarching view that handles the animations as well as user sign in and signout logic with auth.user
    var body: some View {
        Group {
            //if there is no user signed in, show sign in screen
            if auth.user == nil {
                SignInView()
                    .scaleEffect(isSignedIn ? 0.9 : 1) // start scaled down if signed in, for animation
                    .opacity(isSignedIn ? 0 : 1) // start transparent if signed in, for animation
                    .onAppear {
                        withAnimation(.easeOut(duration: 0.5)) {
                            isSignedIn = false
                        }
                    }
            } else { //else show the main content of the app
                mainContentView
                    .transition(.asymmetric(insertion: .slide, removal: .opacity))
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isSignedIn = true
                        }
                    }
            }
        }
        .animation(.easeInOut, value: isSignedIn)
    }
    
    //view for the homescreen of the app
    var mainContentView: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        withAnimation {
                            auth.user = nil // Sign out action
                        }
                    }) {
                        Image(systemName: "arrow.backward.square")
                            .foregroundColor(.black)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(5)
                    }
                    
                    Button(action: {
                        writing = true
                    }) {
                        Image(systemName: "pencil")
                            .foregroundColor(.black)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(5)
                    }
                    
                    Spacer()
                    
                    Text("GamerBlog!")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        showingSearchModifiers = true
                    }) {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(.black)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(5)
                    }
                    
                    Button(action: {
                        showingProfile = true
                    }) {
                        Image(systemName: "person.crop.circle")
                            .foregroundColor(.black)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(5)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                .background(LinearGradient(gradient: Gradient(colors: [Color.black, Color.purple]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(5)
                
                //search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                    
                    TextField("Search for articles!", text: $searchText)
                        .textInputAutocapitalization(.none)
                        .padding(7)
                        .padding(.leading, -7) // Adjust according to your UI needs
                }
                .background(Color.white)
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .padding(.top, 10)
                
                Spacer()
                    .frame(height: 20)
                
                ArticleList()
            }
            .background(Color.purple.edgesIgnoringSafeArea(.all))
            .sheet(isPresented: $writing) {
                ArticleEntry(writing: $writing)
                    .environmentObject(articleService)
            }
            .sheet(isPresented: $showingProfile) {
                ProfileView(isPresented: $showingProfile)
                    .environmentObject(auth)
            }
            .sheet(isPresented: $showingSearchModifiers) {
                SearchModifiersView(selectedSortOption: $selectedSortOption, numberOfResults: $numberOfResults)
            }
            .task {
                await fetchArticles()
            }
        }
    }
    
    //calls the article service to fetch articles once user signs in and handles error so it doesn't have to be done within the view and make it messy
    func fetchArticles() async {
        do {
            try await _ = articleService.fetchArticles()
        } catch {
            print("Error fetching articles: \(error)")
        }
    }
    
    //calls the article service to search articles once user searches within the search bar and handles errors so it doesn't have to be done within the view and make it messy
    func searchArticles() async {
        do {
            try await _ = articleService.searchArticles(title: searchText)
        } catch {
            print("Error fetching articles: \(error)")
        }
    }
}

struct HomepageView_Previews: PreviewProvider {
    static var previews: some View {
        HomepageView()
            .environmentObject(FirebaseBackedMobileAppAuth())
            .environmentObject(FirebaseBackedMobileAppArticle())
    }
}
