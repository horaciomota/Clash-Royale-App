//
//  CardListView.swift
//  ClashRoyale
//
//  Created by Horacio Mota on 25/02/24.
//

import SwiftUI

struct CardListView: View {
    @State private var cards: [Card] = []
    @State private var isLoading = false

    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
                List(cards, id: \.id) { card in
                    Text(card.name)
                }
                .refreshable {
                    await fetchCards()
                }
                .onAppear {
                    Task {
                        await fetchCards()
                    }
                }
            }
        }
        .navigationTitle("Cards")
    }

    func fetchCards() async {
        isLoading = true
        do {
            let api = ClashRoyaleAPI()
            self.cards = try await api.fetchAllCards()
        } catch {
            print("Error fetching cards: \(error)")
        }
        isLoading = false
    }
}

struct CardListView_Previews: PreviewProvider {
    static var previews: some View {
        CardListView()
    }
}
