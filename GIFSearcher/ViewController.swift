import UIKit
import SDWebImage

class ViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!

    var gifs: [GifData] = []

    var gifDownloader = GifDownloader()

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchGifs), object: nil)
        perform(#selector(searchGifs), with: nil, afterDelay: 0.5)
    }

    @objc private func searchGifs() {
        guard let query = searchBar.text else { return }

        gifDownloader.searchGifs(query: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let gifs):
                    self.gifs = gifs
                    self.collectionView.reloadData()
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GifCell", for: indexPath) as! GifCollectionViewCell
        let gif = gifs[indexPath.item]
        cell.gifImageView.sd_setImage(with: URL(string: gif.images.original.url))

        return cell
    }
}
