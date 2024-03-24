import SwiftUI

struct HomepageView: View {
    @EnvironmentObject var auth: FirebaseBackedMobileAppAuth
    @EnvironmentObject var articleService: FirebaseBackedMobileAppArticle
    
    @State private var searchText = ""
    @State private var writing = false
    @State private var showingProfile = false
    @State private var showingSearchModifiers = false // State for showing search modifiers
    
    @State private var selectedSortOption: ArticleSortOption = .mostRecent
    @State private var numberOfResults: Double = 20
    
    var body: some View {
        if auth.user == nil {
            SignInView()
        } else {
            NavigationView {
                VStack(spacing: 0) {
                    // GamerBlog Banner with Write and Profile Texts
                    HStack {
                        Button("Write") {
                            writing = true
                        }
                        .font(.footnote)
                        .foregroundColor(.black)
                        .padding(5)
                        .background(Color.white)
                        .cornerRadius(5)
                        
                        Spacer()
                        
                        Text("GamerBlog!")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: {
                            //to show modifiers sheet
                            showingSearchModifiers = true
                        }) {
                            Image(systemName: "slider.horizontal.3")
                                .foregroundColor(.black)
                                .padding(5)
                                .background(Color.white)
                                .cornerRadius(5)
                        }
                        
                        Button("Profile") {
                            //to show profile sheet
                            showingProfile = true
                        }
                        .font(.footnote)
                        .foregroundColor(.black)
                        .padding(5)
                        .background(Color.white)
                        .cornerRadius(5)
                    }
                    //gradient taken from:
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.black, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(5)
                    
                    // Search Bar
                    TextField("Search for articles!", text: $searchText)
                        .textInputAutocapitalization(.none)
                        .padding(7)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 15)
                            }
                        )
                        .onChange(of: searchText) { newValue in
                            Task {
                                if newValue.isEmpty {
                                    // If the search text is cleared, fetch all articles again
                                    await fetchArticles()
                                } else {
                                    // Search for articles that match the search text
                                    await searchArticles()
                                }
                            }
                        }
                        .padding(.top, 10)
                    
                    Spacer().frame(height: 20)
                    
                    // Article List that updates based on search
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
                        .environmentObject(articleService)
                }
                .task {
                    // Initial load of articles
                    await fetchArticles()
                }
            }
        }
    }
    
    func fetchArticles() async {
            do {
                // Fetches all articles and updates the shared articles in `articleService`
                try await _ = articleService.fetchArticles()
            } catch {
                // Handle error if necessary
                print("Error fetching articles: \(error)")
            }
    }
    
    func searchArticles() async {
        do {
            // Fetches all articles and updates the shared articles in `articleService`
            try await _ = articleService.searchArticles(title: searchText)
        } catch {
            // Handle error if necessary
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
