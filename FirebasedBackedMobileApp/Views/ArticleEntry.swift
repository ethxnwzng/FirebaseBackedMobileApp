import SwiftUI

struct ArticleEntry: View {
    @EnvironmentObject var articleService: FirebaseBackedMobileAppArticle
    @EnvironmentObject var auth: FirebaseBackedMobileAppAuth
    @Binding var writing: Bool
    
    @State private var title = ""
    @State private var game = ""
    @State private var articleBody = ""
    @State private var links = [String]()

    func submitArticle() {
        guard let userID = auth.userID else {
            print("User is not signed in")
            return
        }
        
        // Process links: Replace empty strings with "None", or if all are empty, use ["None"]
        let processedLinks = links.isEmpty ? ["None"] : links.map { $0.isEmpty ? "None" : $0 }

        let newArticle = Article(
            title: title,
            title_lowercase: title.lowercased(),
            date: Date(),
            body: articleBody,
            game: game,
            userID: userID,
            links: processedLinks
        )
        
        articleService.createArticle(article: newArticle)
        writing = false // Close the ArticleEntry view
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Title of your post", text: $title)
                }
                
                Section(header: Text("Game")) {
                    TextField("Game related to the article", text: $game)
                }
                
                Section(header: Text("Links")) {
                    ForEach($links.indices, id: \.self) { index in
                        TextField("Link \(index + 1)", text: $links[index])
                    }
                    Button(action: {
                        links.append("") // Add a new empty link field
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                    }
                }
                
                Section(header: Text("Body")) {
                    TextEditor(text: $articleBody)
                }
            }
            .navigationBarTitle("New Article", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { writing = false }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Submit") { submitArticle() }
                        .disabled(title.isEmpty || articleBody.isEmpty)
                }
            }
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
