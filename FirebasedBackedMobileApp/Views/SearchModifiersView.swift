import SwiftUI

struct SearchModifiersView: View {
    @Binding var selectedSortOption: ArticleSortOption
    @Binding var numberOfResults: Double
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Number of Results")) {
                    Slider(value: $numberOfResults, in: 1...100, step: 1)
                    Text("Show \(Int(numberOfResults)) Results")
                }
                
                Section(header: Text("Sort Articles")) {
                    Button("Most Recent") {
                        selectedSortOption = .mostRecent
                    }
                    
                    Button("Oldest") {
                        selectedSortOption = .oldest
                    }
                    
                    Button("Most Words") {
                        selectedSortOption = .mostWords
                    }
                    
                    Button("Least Words") {
                        selectedSortOption = .leastWords
                    }
                }
            }
            .navigationTitle("Search Modifiers")
        }
    }
}

enum ArticleSortOption {
    case mostRecent, oldest, mostWords, leastWords
}

struct SearchModifiersView_Previews: PreviewProvider {
    static var previews: some View {
        SearchModifiersView(selectedSortOption: .constant(.mostRecent), numberOfResults: .constant(20))
    }
}
