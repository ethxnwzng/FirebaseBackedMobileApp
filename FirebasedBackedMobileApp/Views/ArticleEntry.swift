import SwiftUI
import FirebaseFirestore

struct ArticleEntry: View {
    @EnvironmentObject var articleService: FirebaseBackedMobileAppArticle
    @EnvironmentObject var auth: FirebaseBackedMobileAppAuth
    @Binding var writing: Bool
    
    @State private var title = ""
    @State private var game = ""
    @State private var articleBody = ""
    
    func submitArticle() {
        guard let userID = auth.userID else {
            print("Error: User is not signed in")
            return
        }
        
        let newArticle = Article(
                    title: title,
                    title_lowercase: title.lowercased(),
                    date: Date(),
                    body: articleBody,
                    game: game,
                    userID: userID // Include the userId when creating a new article
                )
        
        _ = articleService.createArticle(article: newArticle)
        writing = false
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Title").foregroundColor(.purple)) {
                    TextField("Title of your post", text: $title)
                }
                
                Section(header: Text("Game").foregroundColor(.purple)) {
                    TextField("Game related to the article", text: $game)
                }
                
                Section(header: Text("Body").foregroundColor(.purple)) {
                    TextEditor(text: $articleBody)
                        .frame(minHeight: 200, maxHeight: .infinity)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("New Article")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        writing = false
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Submit") {
                        submitArticle()
                    }
                    .disabled(title.isEmpty || articleBody.isEmpty)
                }
            }
            .background(Color.purple.edgesIgnoringSafeArea(.all))
        }
    }
}

struct ArticleEntry_Previews: PreviewProvider {
    @State static var writing = true
    
    static var previews: some View {
        ArticleEntry(writing: $writing)
            .environmentObject(FirebaseBackedMobileAppArticle())
            .environmentObject(FirebaseBackedMobileAppAuth())
    }
}
