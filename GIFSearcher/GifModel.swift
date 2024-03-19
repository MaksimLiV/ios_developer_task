import Foundation

struct GiphyResponse: Decodable {
    let data: [GifData]
}

struct GifData: Decodable {
    let images: GifImagesOriginal
}

struct GifImagesOriginal: Decodable {
    let original: GifImage
}

struct GifImage: Decodable {
    let url: String
}
