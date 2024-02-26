//
//  CardListView.swift
//  ClashRoyale
//
//  Created by Horacio Mota on 25/02/24.
//

import SwiftUI

struct CardListView: View {
    @State private var cards: [Card] = []
    @State private var selectedCard: Card? = nil
    @State private var isLoading = false

    let gridItems = [GridItem(.flexible(), spacing: 6), GridItem(.flexible(), spacing: 6)]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItems, spacing: 6) {
                ForEach(cards) { card in
                    Button(action: {
                        selectedCard = card
                    }) {
                        VStack {
                            // Exibição da imagem da carta
                            AsyncImage(url: URL(string: card.iconUrls.medium)) { phase in
                                switch phase {
                                case let .success(image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 150, height: 200)
                                        .cornerRadius(8)
                                default:
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .frame(width: 50, height: 50)
                                }
                            }

                            // Nome da carta e nível máximo
                            VStack(alignment: .leading) {
                                Text(card.name)
                                    .font(.headline)
                                Text("Nível Máximo: \(card.maxLevel)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
            .navigationTitle("Cartas")
        }
        .onAppear {
            Task {
                await fetchCards()
            }
        }
    }

    //Funcao usada para dar fetch nas cartas na view principal
    func fetchCards() async {
        isLoading = true
        do {
            let api = ClashRoyaleAPI()
            cards = try await api.fetchAllCards()
        } catch {
            print("Erro ao buscar as cartas: \(error)")
        }
        isLoading = false
    }
}

struct CardListView_Previews: PreviewProvider {
    static var previews: some View {
        CardListView()
    }
}
