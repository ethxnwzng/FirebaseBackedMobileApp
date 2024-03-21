import SwiftUI

struct ArticleList: View {
    @EnvironmentObject var articleService: FirebaseBackedMobileAppArticle
    
    var body: some View {
        NavigationView {
            if articleService.articles.isEmpty {
                VStack {
                    Spacer()
                    Text("There are no articles.")
                        .foregroundColor(.black)
                    Spacer()
                }
                .background(Color.white)
            } else {
                List(articleService.articles) { article in
                    NavigationLink(destination: ArticleView(article: article)) {
                        ArticleMetadata(article: article)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 1)
                            .foregroundColor(.black)
                    }
                    .listRowBackground(Color.purple)
                }
                .listStyle(PlainListStyle())
                .background(Color.purple.edgesIgnoringSafeArea(.all))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ArticleList_Previews: PreviewProvider {
    static var previews: some View {
        ArticleList()
            .environmentObject(FirebaseBackedMobileAppArticle())
    }
}
