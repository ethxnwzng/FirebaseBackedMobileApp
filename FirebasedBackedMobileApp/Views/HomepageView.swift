import SwiftUI

struct HomepageView: View {
    @EnvironmentObject var auth: FirebaseBackedMobileAppAuth
    @EnvironmentObject var articleService: FirebaseBackedMobileAppArticle
    
    @State private var searchText = ""
    @State private var writing = false
    
    var body: some View {
        if auth.user == nil {
            SignInView()
        } else {
            NavigationView {
                VStack(spacing: 0) {
                    // GamerBlog Banner with Write and Filter Texts
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
                        
                        Button("Filter") {
                            // Action for "Filter"
                        }
                        .font(.footnote)
                        .foregroundColor(.black)
                        .padding(5)
                        .background(Color.white)
                        .cornerRadius(5)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(5)
                    
                    // Search Bar
                    TextField("Search for articles!", text: $searchText)
                        .padding(7)
                        .padding(.horizontal, 25)
                        .background(Color.white)
                        .cornerRadius(8)
                        .padding(.horizontal, 10)
                        .overlay(
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 15)
                            }
                        )
                        .padding(.top, 10)
                    
                    Spacer()
                        .frame(height:20)
                    
                    ArticleList()
                }
                .background(Color.purple.edgesIgnoringSafeArea(.all))
                .sheet(isPresented: $writing) {
                    ArticleEntry(writing: $writing)
                        .environmentObject(articleService)
                }
                .task {
                    await fetchArticles()
                }
            }
        }
    }
    
    func fetchArticles() async {
        do {
            // This function updates the shared articles in `articleService`
            try await _ = articleService.fetchArticles()
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


