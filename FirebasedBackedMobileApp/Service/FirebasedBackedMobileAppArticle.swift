//
//  FirebasedBackedMobileAppArticle.swift
//  FirebasedBackedMobileApp
//
//  Created by Ethan Wong on 3/18/24.
//
import Foundation

import Firebase
import FirebaseFirestore


let COLLECTION_NAME = "articles"
let PAGE_LIMIT = 20

enum ArticleServiceError: Error {
    case mismatchedDocumentError
    case unexpectedError
}

class FirebaseBackedMobileAppArticle: ObservableObject {
    private let db = Firestore.firestore()

    @Published var articles: [Article] = []
    // Some of the iOS Firebase library’s methods are currently a little…odd.
    // They execute synchronously to return an initial result, but will then
    // attempt to write to the database across the network asynchronously but
    // not in a way that can be checked via try async/await. Instead, a
    // callback function is invoked containing an error _if it happened_.
    // They are almost like functions that return two results, one synchronously
    // and another asynchronously.
    //
    // To deal with this, we have a published variable called `error` which gets
    // set if a callback function comes back with an error. SwiftUI views can
    // access this error and it will update if things change.
    @Published var error: Error?

    func createArticle(article: Article) {
        var ref: DocumentReference? = nil
        // Now including links in the document data
        ref = db.collection(COLLECTION_NAME).addDocument(data: [
            "title": article.title,
            "title_lowercase": article.title.lowercased(),
            "date": Timestamp(date: article.date),
            "body": article.body,
            "game": article.game,
            "userID": article.userID,
            "links": article.links // Include links
        ]) { error in
            if let error = error {
                self.error = error
                print("Error adding document: \(error.localizedDescription)")
            } else {
                print("Document added with ID: \(ref?.documentID ?? "")")
            }
        }
    }

    // Note: This is quite unsophisticated! It only gets the first PAGE_LIMIT articles.
    // In a real app, you implement pagination.
    func fetchArticles() async throws -> [Article] {
        articles = []
        let articleQuery = db.collection(COLLECTION_NAME)
            .order(by: "date", descending: true)
            .limit(to: PAGE_LIMIT)

        // Fortunately, getDocuments does have an async version.
        //
        // Firestore calls query results “snapshots” because they represent a…wait for it…
        // _snapshot_ of the data at the time that the query was made. (i.e., the content
        // of the database may change after the query but you won’t see those changes here)
        let querySnapshot = try await articleQuery.getDocuments()

        return try querySnapshot.documents.map {
            //added initilization statements for the additional fields I included within my articles collection in Firestore
            guard let title = $0.get("title") as? String,
                let title_lowercase = $0.get("title_lowercase") as? String,
                let dateAsTimestamp = $0.get("date") as? Timestamp,
                let body = $0.get("body") as? String,
                let game = $0.get("game") as? String,
                let userID = $0.get("userID") as? String,
                let links = $0.get("links") as? [String] else { // Ensure userId is retrieved
                throw ArticleServiceError.mismatchedDocumentError
            }

            let addArticle = Article(
                title: title,
                title_lowercase: title_lowercase,
                date: dateAsTimestamp.dateValue(),
                body: body,
                game: game,
                userID: userID,
                links: links 
            )
            articles.append(addArticle)
            return addArticle
        }

    }
    
    //searches article based on query that matches article title
    //code referencing db (Firestore) taken from Firebase Firestore usage documentation
    func searchArticles(title: String) async throws -> [Article] {
        articles = []
        print(title.lowercased())
        let articleQuery = db.collection(COLLECTION_NAME)
            .whereField("title_lowercase", isEqualTo: title.lowercased())
            .limit(to: PAGE_LIMIT)

        // Fortunately, getDocuments does have an async version.
        //
        // Firestore calls query results “snapshots” because they represent a…wait for it…
        // _snapshot_ of the data at the time that the query was made. (i.e., the content
        // of the database may change after the query but you won’t see those changes here)
        let querySnapshot = try await articleQuery.getDocuments()

        return try querySnapshot.documents.map {
            //added initilization statements for the additional fields I included within my articles collection in Firestore
            guard let title = $0.get("title") as? String,
                let title_lowercase = $0.get("title_lowercase") as? String,
                let dateAsTimestamp = $0.get("date") as? Timestamp,
                let body = $0.get("body") as? String,
                let game = $0.get("game") as? String,
                let userID = $0.get("userID") as? String,
                let links = $0.get("links") as? [String] else {
                throw ArticleServiceError.mismatchedDocumentError
            }
            
            let addArticle = Article(
                title: title,
                title_lowercase: title_lowercase,
                date: dateAsTimestamp.dateValue(),
                body: body,
                game: game,
                userID: userID,
                links: links
            )
            articles.append(addArticle)
            return addArticle
        }
    }
}
