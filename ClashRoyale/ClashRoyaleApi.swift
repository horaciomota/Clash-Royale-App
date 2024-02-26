//
//  ClashRoyaleApi.swift
//  ClashRoyale
//
//  Created by Horacio Mota on 25/02/24.
//

import Foundation



class ClashRoyaleAPI {
    // URL base da API do Clash Royale
    let baseURL = URL(string: "https://api.clashroyale.com/v1")!

    // Token de acesso
    let token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6Ijk1ODMzNTk2LTA2NDgtNGRkMS04NTU1LTFmZTU3MzAyZjdmMiIsImlhdCI6MTcwODg5MjE1Mywic3ViIjoiZGV2ZWxvcGVyLzFlYTIzZjU4LWQ4YjMtMDZjNC0yMjlhLTFhZmRmYzkwYWMwOCIsInNjb3BlcyI6WyJyb3lhbGUiXSwibGltaXRzIjpbeyJ0aWVyIjoiZGV2ZWxvcGVyL3NpbHZlciIsInR5cGUiOiJ0aHJvdHRsaW5nIn0seyJjaWRycyI6WyIzNy4yMjguMjQyLjI1NCJdLCJ0eXBlIjoiY2xpZW50In1dfQ.Ki2F5hhtTnWTKhcjD4pVxIVnCvc6JFSpLAytMRVfOIC5QlhX8bFDiP_3yWAoJj56aGWyuYzQxVb-xATxju0rfw"

    // Método para fazer uma chamada para a API e listar todas as cartas e seus nomes
        func fetchAllCards() async throws -> [Card] {
        // Construindo a URL completa
        let url = baseURL.appendingPathComponent("cards")

        // Criando a requisição com o token de autorização
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        // Realizando a chamada assíncrona
        let (data, _) = try await URLSession.shared.data(for: request)

        // Decodificando a resposta
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let response = try decoder.decode([String: [Card]].self, from: data)

        // Obtendo a lista de cartas
        guard let cards = response["items"] else {
            throw NSError(domain: "ClashRoyaleAPI", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse cards"])
        }

        return cards
    }
}
