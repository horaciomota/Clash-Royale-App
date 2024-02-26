import SwiftUI

struct CardListView: View {
    @State private var cards: [Card] = []
    @State private var selectedCard: Card? = nil
    @State private var isLoading = false
    @State private var searchText: String = ""

    let gridItems = [GridItem(.flexible(), spacing: 0), GridItem(.flexible(), spacing: 0)]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItems, spacing: 0) {
                ForEach(filteredCards) { card in
                    Button(action: {
                        selectedCard = card
                    }) {
                        ZStack(alignment: .topTrailing) {
                            // Exibição da imagem da carta
                            AsyncImage(url: URL(string: card.iconUrls.medium)) { phase in
                                switch phase {
                                case let .success(image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 150)
                                        .cornerRadius(1)
                                default:
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .frame(width: 110)
                                }
                            }

                            // Número de mana
                            Circle()
                                .foregroundColor(.purple)
                                .frame(width: 40, height: 30)
                                .overlay(
                                    Text("\(card.elixirCost != nil ? "\(card.elixirCost!)" : "N/A")")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                )
                                .offset(x: -80, y: 0)
                        }
                        .padding()
                        .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("Cartas")
            .padding()
        }
        .searchable(text: $searchText) {
            ForEach(cards) { card in
                Text(card.name).searchCompletion(card.name)
            }
        }
        .onAppear {
            Task {
                await fetchCards()
            }
        }
    }

    // Função para filtrar as cartas com base no texto de pesquisa
    var filteredCards: [Card] {
        if searchText.isEmpty {
            return cards
        } else {
            return cards.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    // Função para buscar as cartas
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
