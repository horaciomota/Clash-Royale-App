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

                    // Exibição da imagem da carta
                    AsyncImage(url: URL(string: card.iconUrls.medium)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 250, height: 250)
                                .cornerRadius(8)
                        default:
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .frame(width: 50, height: 50)
                        }
                    }
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
