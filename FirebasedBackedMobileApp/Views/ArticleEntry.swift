import SwiftUI

struct ArticleEntry: View {
    @EnvironmentObject var articleService: FirebaseBackedMobileAppArticle
    @Binding var writing: Bool
    
    @State private var title = ""
    @State private var articleBody = ""

    func submitArticle() {
        let newArticle = Article(
            title: title,
            date: Date(),
            body: articleBody
        )
        
        // Call createArticle function to send the article to Firestore.
        // The articleService is responsible for updating the articles list.
        articleService.createArticle(article: newArticle)

        // Reset the writing flag to dismiss the ArticleEntry view
        writing = false
    }

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Title")) {
                    TextField("", text: $title)
                }
                
                Section(header: Text("Body")) {
                    TextEditor(text: $articleBody)
                        .frame(minHeight: 256, maxHeight: .infinity)
                }
            }
            .navigationTitle("New Article")
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
        }
    }
}

struct ArticleEntry_Previews: PreviewProvider {
    @State static var writing = true
    
    static var previews: some View {
        ArticleEntry(writing: $writing)
            .environmentObject(FirebaseBackedMobileAppArticle())
    }
}
