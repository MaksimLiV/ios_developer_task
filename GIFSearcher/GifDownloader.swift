import Foundation

enum APIError: Error {
    case invalidURL
    case noData
    case decodingError
}

class GifDownloader {
    let apiKey = "DgvlIXvH8wLy4TRCky7JabOEHB0sDT1A"
    let baseURL = "https://api.giphy.com/v1/gifs/search"

    func searchGifs(query: String, completion: @escaping (Result<[GifData], APIError>) -> Void) {
        guard var components = URLComponents(string: baseURL) else {
            completion(.failure(.invalidURL))
            return
        }

        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "q", value: query)
        ]

        guard let url = components.url else {
            completion(.failure(.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.noData))
                return
            }

            do {
                let gifs = try JSONDecoder().decode(GiphyResponse.self, from: data)
                completion(.success(gifs.data))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
