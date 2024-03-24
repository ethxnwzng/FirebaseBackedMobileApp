import SwiftUI
import FirebaseFirestore

struct ArticleView: View {
    @EnvironmentObject var auth: FirebaseBackedMobileAppAuth
    var article: Article
    @State private var username: String = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(article.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding([.leading, .trailing])
            
            Text("Author: \(username.isEmpty ? "Loading..." : username)")
                .font(.caption)
                .foregroundColor(.white)
                .padding(.top, 5)

            
            HStack {
            
                Text("Game: \(article.game),")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.top, 2)
                
                Text("Posted: \(article.date, style: .date)")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.top, 2)
            }
            .padding([.top, .trailing])
            
            ScrollView(.vertical) {
                Text(article.body)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(15)
                    .padding()
                    .shadow(radius: 3)
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.purple.edgesIgnoringSafeArea(.all))
        .onAppear {
            // Assuming article.userID contains the ID of the user who wrote the article
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
            userID: "nc703rlLNVfJnsyEcMTk5J5le522"
        )).environmentObject(FirebaseBackedMobileAppAuth())
    }
}
