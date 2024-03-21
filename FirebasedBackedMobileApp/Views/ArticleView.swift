import SwiftUI

struct ArticleView: View {
    var article: Article

    var body: some View {
        VStack {
            HStack {
                Text(article.title)
                    .font(.largeTitle) // Make the title prominent
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding([.top, .leading, .trailing])
                
                Spacer() // This will push the title to the left and the date to the right
                
                Text(article.date, style: .date) // Displaying the date
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding([.top, .trailing])
            }
            .frame(maxWidth: .infinity) // Ensure the HStack takes the full width

            ScrollView {
                Text(article.body)
                    .padding()
                    .background(Color.white) // Text bubble background color
                    .foregroundColor(.black) // Text color
                    .cornerRadius(15)
                    .padding([.leading, .bottom, .trailing])
                    .shadow(radius: 3) // Adds depth
            }
        }
        .background(Color.purple.edgesIgnoringSafeArea(.all)) // Set the background color
    }
}

// Preview provider with a sample article
struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(article: Article(
            title: "Preview Title",
            date: Date(),
            body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        ))
    }
}
