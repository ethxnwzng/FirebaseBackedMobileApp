//
//  ArticleMetaData.swift
//  FirebasedBackedMobileApp
//
//  Created by Ethan Wong on 3/18/24.
//
import SwiftUI

struct ArticleMetadata: View {
    var article: Article

    var body: some View {
        HStack() {
            Text(article.title)
                .font(.headline)

            Spacer()

            VStack(alignment: .trailing) {
                Text(article.date, style: .date)
                    .font(.caption)

                Text(article.date, style: .time)
                    .font(.caption)
            }
        }
    }
}

#Preview {
    ArticleMetadata(article: Article(
        title: "Preview",
        date: Date(),
        body: "Lorem ipsum dolor sit something something amet"
        
    ))
}
