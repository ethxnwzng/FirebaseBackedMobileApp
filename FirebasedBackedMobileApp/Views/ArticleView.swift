import SwiftUI
import FirebaseFirestore

struct ArticleView: View {
    @EnvironmentObject var auth: FirebaseBackedMobileAppAuth
    @EnvironmentObject var articleService: FirebaseBackedMobileAppArticle
    var article: Article
    @State private var username: String = ""
    
    var body: some View {
        ZStack { // ZStack because ScrollView makes applying background color work weirdly without wrapper
            Color.purple.edgesIgnoringSafeArea(.all) // Apply background color to the whole screen

            ScrollView {
                VStack(alignment: .center, spacing: 10) {
                    Text(article.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding([.leading, .trailing])
                    
                    Text("Author: \(username.isEmpty ? "Loading..." : username)")
                        .font(.caption)
                        .foregroundColor(.black)
                        .padding(.top, 5)
                    
                    HStack {
                        Spacer()
                        Text("Game: \(article.game), ")
                            .font(.caption)
                            .foregroundColor(.white)
                        
                        Text("Posted: \(article.date, style: .date)")
                            .font(.caption)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.top, 2)
                    
                    Spacer()
                        .frame(height:5)
                    
                    Text(article.body)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(15)
                        .shadow(radius: 3)
                        .padding(.bottom, 10)
                    
                    if !article.links.isEmpty && article.links[0] != "None" {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Links: ")
                                    .font(.footnote)
                                Spacer()
                            }
                            ForEach(article.links, id: \.self) { link in
                                if link != "None" {
                                    Link(destination: URL(string: link)!) {
                                        Text(link)
                                            .foregroundColor(.white)
                                            .font(.footnote)
                                            .underline()
                                            .lineLimit(1)
                                    }
                                    .padding(.vertical, 2)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            guard !article.userID.isEmpty else {
                print("Error: userID is empty")
                return
            }

            auth.fetchUsernameFromID(userId: article.userID) { fetchedUsername in
                self.username = fetchedUsername
            }
        }
    }
}

// Preview provider with a sample article
struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(article: Article(
            title: "Preview Title",
            title_lowercase: "preview title",
            date: Date(),
            body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
            game: "Something",
            userID: "nc703rlLNVfJnsyEcMTk5J5le522",
            links: ["https://www.example.com", "www.hello.com"]
        )).environmentObject(FirebaseBackedMobileAppAuth())
    }
}
